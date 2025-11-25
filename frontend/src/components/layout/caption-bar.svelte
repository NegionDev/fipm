<script lang="ts">
  import { onMount } from "svelte";

  import { cn } from "@app/lib/utils";
  import Minus from "../icon/lucide/minus.svelte";
  import Minimize from "../icon/lucide/minimize.svelte";
  import Maximize from "../icon/lucide/maximize.svelte";
  import X from "../icon/lucide/x.svelte";

  let appTitle = $state("Fish It! 🐟 Perfect Macro");
  let isMaximized = $state(getMaximizeStatus());

  onMount(async () => {
    appTitle = await window.ahk.global.APP_TITLE;

    const maximizeObserver = new MutationObserver(
      () => (isMaximized = getMaximizeStatus()),
    );

    maximizeObserver.observe(document.body, {
      attributes: true,
      attributeFilter: ["class"],
    });
  });

  const AppControls = [
    {
      id: "minimize",
      icon: () => Minus,
      fn: () => window.ahk.gui.Minimize(),
    },
    {
      id: "maximize-restore",
      icon: () => (isMaximized ? Minimize : Maximize),
      fn: () =>
        isMaximized ? window.ahk.gui.Restore() : window.ahk.gui.Maximize(),
    },
    {
      id: "close",
      icon: () => X,
      fn: async () => await window.ahk.global.ExitApp(),
    },
  ];

  function getMaximizeStatus() {
    return document.body.classList.contains("ahk-maximized");
  }
</script>

<!-- Caption / Title Bar -->
<header
  class="fixed inset-x-0 top-0 border-b border-zinc-900 bg-zinc-950 pl-6 select-none"
  style="-webkit-app-region: drag;"
>
  <div class="flex items-center justify-between gap-1">
    <div id="app-title">
      <h1 class="pointer-events-none text-xs font-light text-blue-300">
        {appTitle}
      </h1>
    </div>
    <div id="app-controls" class="flex items-center">
      {#each AppControls as ctrl (ctrl.id)}
        {@const IconComponent = ctrl.icon()}
        <button
          id={ctrl.id}
          class={cn(
            "transition-colors duration-150 ease-linear",
            "px-4 py-2.5 text-slate-400 hover:text-slate-50",
            ctrl.id === "close" ? "hover:bg-red-500" : "hover:bg-zinc-800",
          )}
          onclick={() => ctrl.fn()}
        >
          <span>
            <IconComponent className="size-3" />
          </span>
        </button>
      {/each}
    </div>
  </div>
</header>
