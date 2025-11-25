<script lang="ts">
  import { cn } from "@app/lib/utils";
  import ContentCard from "./content-card.svelte";

  let {
    steps,
    label = undefined,
    className = "",
  }: { steps: string[]; label?: string; className?: string } = $props();
</script>

<ContentCard {label} className={cn("text-sm space-y-4", className)}>
  {#each steps as step, index}
    <div class="flex gap-3">
      <span class="font-bold text-blue-400">{index + 1}</span>
      {step}
    </div>
  {/each}
</ContentCard>
