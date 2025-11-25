<script lang="ts">
  import { type Snippet } from "svelte";

  import { cn } from "@app/lib/utils";

  let { children, className = "" }: { children: Snippet; className?: string } =
    $props();
</script>

<div
  class={cn(
    "rounded-2xl px-6 py-7 transition-all duration-150",
    "bg-linear-to-br from-slate-900/70 to-slate-800/70 backdrop-blur-md",
    "border border-slate-700/50 hover:border-blue-500/50",
    "shadow-2xl hover:shadow-blue-500/50",
    className,
  )}
>
  {@render children()}
</div>
