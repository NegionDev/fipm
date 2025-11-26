<script lang="ts">
  import { cn, formatMs } from "@app/lib/utils";

  let {
    id,
    label,
    value = $bindable(),
    minimum = 10,
    maximum = 1000,
    className = "",
  }: {
    id: string;
    label: string;
    value: number;
    minimum?: number;
    maximum?: number;
    className?: string;
  } = $props();
</script>

<div class={cn(className)}>
  <label for={id} class="mb-2 flex justify-between">
    <p class="text-sm font-light text-slate-400">{label}</p>
    <span class="font-mono text-xs text-blue-300">{formatMs(value)}</span>
  </label>
  <input
    {id}
    type="range"
    min={minimum}
    max={maximum}
    class={cn(
      "h-3.5 w-full cursor-grab appearance-none rounded-full bg-slate-700/60 active:cursor-grabbing",
      "[&::-webkit-slider-thumb]:size-7 [&::-webkit-slider-thumb]:rounded-full [&::-webkit-slider-thumb]:bg-blue-500 [&::-webkit-slider-thumb]:shadow-lg",
    )}
    bind:value
  />
</div>
