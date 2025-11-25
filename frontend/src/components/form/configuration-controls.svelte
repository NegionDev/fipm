<script lang="ts">
  import DEFAULT_CONFIG from "@shared/schema/config.json";
  import { configState } from "@app/stores/config.svelte";
  import { cn } from "@app/lib/utils";

  const MessageStatus = {
    idle: "Waiting...",
    save: "Changes Saved!",
    reset: "Configuration Reset!",
  };

  let { keys }: { keys: (keyof typeof DEFAULT_CONFIG)[] } = $props();
  let status = $state<keyof typeof MessageStatus>("idle");

  function setStatus(value: keyof typeof MessageStatus, timeout = 1000) {
    status = value;
    setTimeout(() => (status = "idle"), timeout);
  }

  async function saveConfig() {
    const filePath = await window.ahk.global.CONFIG_FILE_PATH;
    const fileContent = await window.ahk.global.FileRead(filePath);
    const jsonParsed = JSON.parse(fileContent);

    for (const key of keys) {
      jsonParsed[key] = configState.config[key];
    }

    await window.ahk.global.FileWrite(
      filePath,
      JSON.stringify(jsonParsed, null, 4),
    );
  }

  async function resetConfig() {
    for (const key of keys) {
      (configState.config as any)[key] = DEFAULT_CONFIG[key];
    }

    await saveConfig();
  }
</script>

<!-- Configuration Controls -->
<div class="border-t border-slate-700/50 pt-5">
  <div class="flex items-center justify-between gap-4">
    <div class="flex-1 text-sm font-medium">
      <span
        class={cn(
          status === "idle" && "hidden",
          status === "save" && "text-green-600",
          status === "reset" && "text-red-600",
        )}
      >
        {MessageStatus[status]}
      </span>
    </div>
    <div class="flex gap-3">
      <button
        class="cursor-pointer rounded-xl bg-green-600 px-6 py-3 text-xs font-bold shadow-lg transition-all hover:bg-green-500 hover:shadow-green-400/30"
        onclick={() => saveConfig().then(() => setStatus("save"))}
      >
        Save Config
      </button>
      <button
        class="cursor-pointer rounded-xl bg-red-600 px-6 py-3 text-xs font-bold shadow-lg transition-all hover:bg-red-500 hover:shadow-red-400/30"
        onclick={() => resetConfig().then(() => setStatus("reset"))}
      >
        Reset to Default
      </button>
    </div>
  </div>
</div>
