<script lang="ts">
  import { configState } from "@app/stores/config.svelte";
  import { cn } from "@app/lib/utils";
  import HeaderCard from "@app/components/card/header-card.svelte";
  import ContentCard from "@app/components/card/content-card.svelte";
  import ConfigurationControls from "@app/components/form/configuration-controls.svelte";
  import TimingSlider from "@app/components/form/timing-slider.svelte";

  async function detectProcess() {
    const appTitle = await window.ahk.global.APP_TITLE;
    const isProcessExist = await window.ahk.global.WinExist(
      `ahk_exe ${configState.config.GENERAL.PROCESS_NAME}`,
    );

    await window.ahk.global.MsgBox(
      isProcessExist
        ? `Process "${configState.config.GENERAL.PROCESS_NAME}" detected.`
        : `Process "${configState.config.GENERAL.PROCESS_NAME}" not found, it's either the process is not opened or does not exist.`,
      appTitle,
    );
  }

  async function toggleFishing(e: MouseEvent) {
    e.preventDefault();

    await window.ahk.global.ToggleFishing();
  }
</script>

<div id="tab-general" class="space-y-10 pb-12">
  <!-- Macro Status + Toggle -->
  <HeaderCard>
    <div class="flex flex-col items-center justify-between gap-5 sm:flex-row">
      <div class="flex items-center gap-4">
        <div id="circle-icon-status" class="text-5xl">🔴</div>
        <div>
          <h2 id="toggle-status" class="text-xl font-bold">Disabled</h2>
          <p id="step-status" class="text-xs text-slate-500">Disabled</p>
        </div>
      </div>
      <label
        for="toggle-macro"
        class="group relative inline-flex cursor-pointer items-center"
      >
        <input
          type="checkbox"
          id="toggle-macro"
          class="peer sr-only"
          onclick={toggleFishing}
        />
        <div
          class={cn(
            "h-11 w-22 rounded-full bg-slate-700 transition-all duration-150",
            "peer peer-checked:bg-linear-to-r peer-checked:from-blue-600 peer-checked:to-blue-500 peer-focus:ring-4 peer-focus:ring-blue-500/25 peer-checked:after:translate-x-11",
            "after:absolute after:top-1 after:left-1 after:size-9 after:rounded-full after:bg-white after:transition-all after:duration-300 after:content-['']",
          )}
        ></div>
      </label>
    </div>
  </HeaderCard>

  <div class="flex flex-col gap-5">
    <!-- Process Title Input -->
    <ContentCard label="Process Title">
      <div class="flex gap-3">
        <input
          id="process-title"
          type="text"
          placeholder="Roblox process title"
          class={cn(
            "flex-1 rounded-xl px-5 py-3.5 text-sm transition-all",
            "border border-slate-600 bg-slate-800/70",
            "focus:border-blue-500 focus:ring-2 focus:ring-blue-500 focus:outline-none",
          )}
          bind:value={configState.config.GENERAL.PROCESS_NAME}
        />
        <button
          class={cn(
            "cursor-pointer rounded-xl px-7 py-3.5 text-sm font-medium shadow-lg transition-colors duration-150",
            "bg-linear-to-r from-blue-600 to-blue-500 hover:from-blue-500 hover:to-blue-400",
          )}
          onclick={() => detectProcess()}
        >
          Detect
        </button>
      </div>
    </ContentCard>

    <!-- Timing -->
    <ContentCard label="Timing">
      <div class="space-y-5">
        <TimingSlider
          id="loop-interval"
          label="Loop Interval"
          bind:value={configState.config.GENERAL.LOOP_INTERVAL}
        />
        <TimingSlider
          id="reel-tap-interval"
          label="Reel Tap Interval"
          bind:value={configState.config.GENERAL.REEL_TAP_INTERVAL}
        />
        <TimingSlider
          id="randomize-tap-interval"
          label="Randomize Tap Interval"
          bind:value={configState.config.GENERAL.RANDOMIZE_TAP_INTERVAL}
        />
        <TimingSlider
          id="minimum-charge-hold"
          label="Minimum Charge Hold"
          bind:value={configState.config.GENERAL.MINIMUM_CHARGE_HOLD}
        />
        <TimingSlider
          id="pre-idle-delay"
          label="Pre-Idle Delay"
          bind:value={configState.config.GENERAL.PRE_IDLE_DELAY}
        />
        <TimingSlider
          id="pre-reel-delay"
          label="Pre-Reel Delay"
          bind:value={configState.config.GENERAL.PRE_REEL_DELAY}
        />
        <TimingSlider
          id="step-timeout"
          label="Step Timeout"
          minimum={10_000}
          maximum={60_000}
          bind:value={configState.config.GENERAL.STEP_TIMEOUT}
        />
      </div>
    </ContentCard>

    <!-- Miscellaneous -->
    <ContentCard label="Miscellaneous">
      <div class="space-y-5">
        <label
          for="debug-mode"
          class="flex cursor-pointer items-center justify-between"
        >
          <span class="text-sm">Debug Mode (show tooltip)</span>
          <input
            id="debug-mode"
            type="checkbox"
            class="size-5 rounded text-blue-600"
            bind:checked={configState.config.GENERAL.DEBUG_MODE}
          />
        </label>
        <label
          for="hide-gui"
          class="flex cursor-pointer items-center justify-between"
        >
          <span class="text-sm">Hide GUI when macro active</span>
          <input
            id="hide-gui"
            type="checkbox"
            class="size-5 rounded text-blue-600"
            bind:checked={configState.config.GENERAL.HIDE_GUI_WHEN_ENABLED}
          />
        </label>
      </div>
    </ContentCard>
  </div>
  <ConfigurationControls keys={["GENERAL"]} />
</div>
