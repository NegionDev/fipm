<script lang="ts">
  import { cn } from "@app/lib/utils";

  let {
    tabs,
    currentTab,
    onNavigate,
  }: {
    tabs: string[];
    currentTab: string;
    onNavigate: (tab: string) => unknown;
  } = $props();
</script>

<!-- Sidebar Navigations -->
<aside class="sticky top-0 w-52">
  <nav id="tab-navigations" class="flex h-full flex-col gap-2.5">
    {#each tabs as tab}
      <button
        title={tab}
        class={cn(
          "flex items-center rounded-lg px-4 py-3 text-sm",
          tab === currentTab
            ? "bg-blue-600/30 font-bold text-blue-400"
            : "cursor-pointer bg-zinc-600/30 font-semibold hover:bg-blue-600/30",
        )}
        onclick={() => onNavigate(tab)}
      >
        {tab}
      </button>
    {/each}
  </nav>
</aside>
