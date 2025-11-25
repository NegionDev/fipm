<script lang="ts">
  import { onDestroy } from "svelte";
  import hotkeys from "hotkeys-js";
  import { partition } from "es-toolkit";

  import DEFAULT_CONFIG from "@shared/schema/config.json";
  import { configState } from "@app/stores/config.svelte";
  import { cn, escapeRegExp } from "@app/lib/utils";
  import HeaderCard from "@app/components/card/header-card.svelte";
  import ContentCard from "@app/components/card/content-card.svelte";
  import ConfigurationControls from "@app/components/form/configuration-controls.svelte";

  const MODIFIER_KEYS: Record<string, string> = {
    LWin: "<#",
    RWin: ">#",
    Control: "^",
    Ctrl: "^",
    Alt: "!",
    Shift: "+",
    LControl: "<^",
    LCtrl: ">^",
    LShift: "<+",
    RShift: ">+",
    LAlt: "<!",
    RAlt: ">!",
  };

  type HotkeyId = "RELOAD_MACRO" | "EXIT_MACRO" | "TOGGLE_FISHING";
  let currentRecording = $state<HotkeyId | null>(null);

  function startRecordHotkey(id: HotkeyId) {
    currentRecording = id;

    // @ts-ignore
    hotkeys("*", id, async function (ev) {
      ev.preventDefault();

      const codes = hotkeys.getPressedKeyCodes();
      const promisedConvertedKeys = Promise.all(
        codes.map(async (code) => {
          const vk = code.toString(16).toUpperCase();
          const convertedKey = await window.ahk.global.GetKeyName(`vk${vk}`);
          return convertedKey as string;
        }),
      );

      const convertedKeys = (await promisedConvertedKeys).map((key, _, arr) => {
        const isModifierOnly = arr.every((k) =>
          Object.keys(MODIFIER_KEYS).includes(k),
        );

        return !isModifierOnly && key in MODIFIER_KEYS
          ? MODIFIER_KEYS[key]
          : key;
      });

      const [modifiers, keys] = partition(convertedKeys, (key) =>
        Object.values(MODIFIER_KEYS).includes(key),
      );

      configState.config.HOTKEYS[id] = [
        ...modifiers,
        ...keys.slice(0, modifiers.length ? 1 : 2),
      ].join(modifiers.length ? "" : " & ");
    });

    hotkeys.setScope(id);
  }

  function stopRecordHotkey(id: HotkeyId) {
    currentRecording = null;

    return hotkeys.deleteScope(id);
  }

  function rebindHotkey(id: HotkeyId) {
    if (currentRecording === id) {
      return stopRecordHotkey(id);
    }

    if (currentRecording) {
      stopRecordHotkey(currentRecording);
    }

    return startRecordHotkey(id);
  }

  function formatHotkey(hotkey: string) {
    const modifierPattern = Object.entries(MODIFIER_KEYS)
      .flat()
      .map(escapeRegExp)
      .join("|");

    const generalPattern = [
      "CapsLock",
      "Space",
      "Tab",
      "Enter",
      "Esc(?:ape)?",
      "Backspace",
      "BS",
    ].join("|");

    const cursorControlPattern = [
      "ScrollLock",
      "Del(?:ete)?",
      "Ins(?:ert)?",
      "Home",
      "End",
      "Pg(?:Up|Dn)",
      "Up",
      "Down",
      "Left",
      "Right",
    ].join("|");

    const numpadPattern = [
      "Numpad(?:Ins|End|Down|Pg(?:Up|Dn)|Left|Clear|Right|Home|Up|Del|Div|Mult|Add|Sub|Enter|Dot|[0-9])",
      "NumLock",
    ].join("|");

    const functionPattern = "F(?:[1-9]|1[0-9]|2[0-4])";
    const multimediaPattern = [
      "Browser_(?:Back|Forward|Refresh|Stop|Search|Favorites|Home)",
      "Volume_(?:Mute|Down|Up)",
      "Media_(?:Next|Prev|Stop|Play_Pause)",
      "Launch_(?:Mail|Media|App1|App2)",
    ].join("|");

    const otherPattern = [
      "AppsKey",
      "PrintScreen",
      "CtrlBreak",
      "Pause",
      "Help",
      "Sleep",
    ].join("|");

    const symbolPattern = [
      "`",
      "-",
      "=",
      "[",
      "]",
      "\\",
      ";",
      "'",
      ",",
      ".",
      "/",
      "Slash",
      "Backslash",
      "Semicolon",
      "Apostrophe",
      "Grave",
      "Minus",
      "Equal",
      "LBracket",
      "RBracket",
      "Comma",
      "Dot",
      "Period",
    ]
      .map(escapeRegExp)
      .join("|");

    const singleAlphanumericPattern = "[a-z0-9]";
    const keysPattern = [
      modifierPattern,
      generalPattern,
      cursorControlPattern,
      numpadPattern,
      functionPattern,
      multimediaPattern,
      otherPattern,
      symbolPattern,
      singleAlphanumericPattern,
    ].join("|");

    const regex = new RegExp(keysPattern, "gi");
    return (hotkey.match(regex) ?? [])
      .map((v) => {
        const modifierKey = Object.entries(MODIFIER_KEYS).find(
          ([, mod]) => mod === v,
        );

        return modifierKey
          ? modifierKey[0]
          : v.length === 1
            ? v.toUpperCase()
            : v;
      })
      .join(" + ");
  }

  onDestroy(() => {
    if (currentRecording) {
      stopRecordHotkey(currentRecording);
    }
  });
</script>

{#snippet HotkeyCard({ id, label }: { id: HotkeyId; label: string })}
  <ContentCard className="group relative">
    <button
      class={cn(
        "absolute top-3 right-3 flex size-8 cursor-pointer items-center justify-center rounded-lg text-sm transition-all",
        "bg-slate-800/70 text-slate-400 opacity-0 group-hover:opacity-100 hover:bg-slate-700 hover:text-slate-200",
      )}
      onclick={() =>
        (configState.config.HOTKEYS[id] = DEFAULT_CONFIG.HOTKEYS[id])}
    >
      ↻
    </button>
    <div class="flex items-start justify-between gap-1">
      <h1 class="text-xl font-bold">{label}</h1>
      <kbd
        class="rounded-lg border border-blue-800/50 bg-blue-900/30 px-5 py-2.5 font-mono text-lg text-blue-400"
      >
        {formatHotkey(configState.config.HOTKEYS[id])}
      </kbd>
    </div>
    <button
      {id}
      class={cn(
        "w-full cursor-pointer rounded-xl py-3.5 text-sm font-medium transition-colors duration-150 ease-linear",
        currentRecording === id
          ? "border border-red-500/60 bg-red-800/50 text-red-200 hover:bg-red-900/20"
          : "border border-slate-600 bg-slate-800/50 hover:border-blue-500/60 hover:bg-blue-900/20",
      )}
      onclick={rebindHotkey.bind(null, id)}
    >
      {currentRecording === id ? "Stop Recording" : "Rebind Hotkey"}
    </button>
  </ContentCard>
{/snippet}

<div id="tab-hotkeys" class="space-y-10 pb-12">
  <!-- Header -->
  <HeaderCard>
    <div class="flex items-center gap-5">
      <div class="text-5xl">
        <!-- Lucide Icon - Keyboard -->
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="24"
          height="24"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
          class="lucide lucide-keyboard-icon lucide-keyboard"
          ><path d="M10 8h.01" /><path d="M12 12h.01" /><path
            d="M14 8h.01"
          /><path d="M16 12h.01" /><path d="M18 8h.01" /><path
            d="M6 8h.01"
          /><path d="M7 16h10" /><path d="M8 12h.01" /><rect
            width="20"
            height="16"
            x="2"
            y="4"
            rx="2"
          /></svg
        >
      </div>
      <div>
        <h2 class="text-xl font-bold">Hotkeys Configuration</h2>
        <p class="text-xs text-slate-500">Rebind hotkeys as needed!</p>
      </div>
    </div>
  </HeaderCard>

  <div class="flex flex-col gap-5">
    {#each Object.keys(configState.config.HOTKEYS) as hotkeyId}
      {@render HotkeyCard({
        id: hotkeyId as HotkeyId,
        label: hotkeyId
          .split("_")
          .map(
            (str) => str.charAt(0).toUpperCase() + str.slice(1).toLowerCase(),
          )
          .join(" "),
      })}
    {/each}
  </div>

  <!-- Footnote -->
  <div
    class="rounded-2xl border border-slate-700/30 bg-slate-900/40 py-4 text-center text-xs text-slate-500 backdrop-blur-sm"
  >
    Hover card → Click ↻ to reset
  </div>
  <ConfigurationControls keys={["HOTKEYS"]} />
</div>
