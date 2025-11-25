<script lang="ts">
  import { type Snippet } from "svelte";

  import { cn } from "@app/lib/utils";

  let {
    children,
    label = undefined,
    className = "",
  }: { children: Snippet; label?: string; className?: string } = $props();
</script>

<div
  class={cn(
    "space-y-6 rounded-3xl p-6 transition-all duration-150",
    "bg-linear-to-br from-slate-900/50 to-slate-800/50 backdrop-blur-md",
    "border border-slate-700/50 hover:border-blue-500/50",
    className,
  )}
>
  {#if label}
    <h3 class="text-xl font-bold">{label}</h3>
  {/if}
  {@render children()}
</div>
