<script lang="ts">
  import DEFAULT_CONFIG from "@shared/schema/config.json";
  import { configState } from "@app/stores/config.svelte";
  import { cn } from "@app/lib/utils";
  import HeaderCard from "@app/components/card/header-card.svelte";
  import ContentCard from "@app/components/card/content-card.svelte";
  import ConfigurationControls from "@app/components/form/configuration-controls.svelte";

  const fnIndicator = {
    ROD_INDICATOR: "GetRodIndicator",
    LUCK_INDICATOR: "GetLuckIndicator",
    REEL_INDICATOR: "GetReelIndicator",
  };

  type IndicatorId = keyof typeof fnIndicator;
  async function testIndicator(id: IndicatorId, label: string) {
    const processTitle = `ahk_exe ${configState.config.GENERAL.PROCESS_NAME}`;
    const appTitle = await window.ahk.global.APP_TITLE;
    const isProcessExist = await window.ahk.global.WinExist(processTitle);

    if (!isProcessExist) {
      return await window.ahk.global.MsgBox(
        `Process "${configState.config.GENERAL.PROCESS_NAME}" not found, it's either the process is not opened or does not exist.`,
        appTitle,
      );
    }

    await window.ahk.global.WinActivate(processTitle);
    const indicator = await window.ahk.global[fnIndicator[id]]();
    const detected = await window.ahk.global.IndicatorSearch(indicator);
    await window.ahk.global.MsgBox(
      `${label} is ${detected ? "" : "not "}detected!`,
      appTitle,
    );
  }

  async function captureRegion(id: IndicatorId) {
    const fnRect = {
      ROD_INDICATOR: "GetRodRect",
      LUCK_INDICATOR: "GetLuckRect",
      REEL_INDICATOR: "GetReelRect",
    };

    const processTitle = `ahk_exe ${configState.config.GENERAL.PROCESS_NAME}`;
    const appTitle = await window.ahk.global.APP_TITLE;
    const isProcessExist = await window.ahk.global.WinExist(processTitle);

    if (!isProcessExist) {
      return await window.ahk.global.MsgBox(
        `Process "${configState.config.GENERAL.PROCESS_NAME}" not found, it's either the process is not opened or does not exist.`,
        appTitle,
      );
    }

    await window.ahk.global.WinActivate(processTitle);
    const anchorRect = await window.ahk.global[fnRect[id]]();
    const indicator = await window.ahk.global[fnIndicator[id]]();
    const delta = await window.ahk.global.CaptureRegion(
      anchorRect,
      indicator.rect,
    );

    const dx = await delta.x;
    const dy = await delta.y;
    const dw = await delta.w;
    const dh = await delta.h;

    configState.config[id].X = dx;
    configState.config[id].Y = dy;
    configState.config[id].W = dw;
    configState.config[id].H = dh;
  }
</script>

{#snippet IndicatorCard({ id, label }: { id: IndicatorId; label: string })}
  <ContentCard {label} className="group relative">
    <button
      class={cn(
        "absolute top-3 right-3 flex size-8 cursor-pointer items-center justify-center rounded-lg text-sm transition-all",
        "bg-slate-800/70 text-slate-400 opacity-0 group-hover:opacity-100 hover:bg-slate-700 hover:text-slate-200",
      )}
      onclick={() => (configState.config[id] = DEFAULT_CONFIG[id])}
    >
      ↻
    </button>
    <div class="grid grid-cols-4 gap-3">
      <input
        type="number"
        placeholder="X"
        class="rounded-lg border border-slate-700 bg-slate-800/70 px-3 py-2 text-sm"
        readonly
        bind:value={configState.config[id].X}
      />
      <input
        type="number"
        placeholder="Y"
        class="rounded-lg border border-slate-700 bg-slate-800/70 px-3 py-2 text-sm"
        readonly
        bind:value={configState.config[id].Y}
      />
      <input
        type="number"
        placeholder="W"
        class="rounded-lg border border-slate-700 bg-slate-800/70 px-3 py-2 text-sm"
        readonly
        bind:value={configState.config[id].W}
      />
      <input
        type="number"
        placeholder="H"
        class="rounded-lg border border-slate-700 bg-slate-800/70 px-3 py-2 text-sm"
        readonly
        bind:value={configState.config[id].H}
      />
    </div>
    <div class="flex gap-3">
      <button
        class={cn(
          "flex-1 cursor-pointer rounded-xl py-3 text-sm transition-colors duration-150 ease-linear",
          "border border-slate-700 bg-slate-800/50 hover:border-blue-500/60 hover:bg-blue-900/20",
        )}
        onclick={() => captureRegion(id)}
      >
        Capture Region
      </button>
      <input
        type="color"
        class="h-12 w-16 cursor-pointer rounded-lg"
        bind:value={configState.config[id].COLOR_ID}
      />
    </div>
    <div class="space-y-3">
      <div class="flex items-center justify-between text-sm">
        <span class="text-slate-400">Tolerance</span>
        <span class="font-mono text-blue-400"
          >{configState.config[id].TOLERANCE}</span
        >
      </div>
      <input
        type="range"
        min="0"
        max="50"
        class="h-3.5 w-full rounded-full bg-slate-700/60 [&::-webkit-slider-thumb]:h-7 [&::-webkit-slider-thumb]:w-7 [&::-webkit-slider-thumb]:bg-blue-500"
        bind:value={configState.config[id].TOLERANCE}
      />
      <button
        class="w-full cursor-pointer rounded-xl bg-blue-600 py-3.5 font-bold text-white shadow-lg transition-all hover:bg-blue-500"
        onclick={() => testIndicator(id, label)}
      >
        Test
      </button>
    </div>
  </ContentCard>
{/snippet}

<div id="tab-calibrate" class="space-y-10 pb-12">
  <!-- Header -->
  <HeaderCard>
    <div class="flex items-center gap-5">
      <div class="text-5xl">
        <!-- Lucide Icon - Crosshair -->
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
          class="lucide lucide-crosshair-icon lucide-crosshair"
          ><circle cx="12" cy="12" r="10" /><line
            x1="22"
            x2="18"
            y1="12"
            y2="12"
          /><line x1="6" x2="2" y1="12" y2="12" /><line
            x1="12"
            x2="12"
            y1="6"
            y2="2"
          /><line x1="12" x2="12" y1="22" y2="18" /></svg
        >
      </div>
      <div>
        <h2 class="text-xl font-bold">Calibrate Detection</h2>
        <p class="text-xs text-slate-500">
          Calibrate indicator for visual scanning!
        </p>
      </div>
    </div>
  </HeaderCard>

  <div class="flex flex-col gap-5">
    {#each Object.keys(fnIndicator) as indicatorId}
      {@render IndicatorCard({
        id: indicatorId as IndicatorId,
        label: indicatorId
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
  <ConfigurationControls keys={Object.keys(fnIndicator) as IndicatorId[]} />
</div>
