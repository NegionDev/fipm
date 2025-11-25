<script lang="ts">
  import HeaderCard from "@app/components/card/header-card.svelte";
  import ContentCard from "@app/components/card/content-card.svelte";
  import StepCard from "@app/components/card/step-card.svelte";
  import Waves from "@app/components/animation/waves.svelte";

  const GettingStarted = [
    "Open Roblox, then play Fish It!",
    "Go to your favorite fishing spot",
    "Equip your rod (make sure the rod indicator appears on the screen)",
    "Enable macros in the General tab or press the hotkey",
  ];

  const FAQnTroubleshooting = [
    ["I need an explanation", "tell me more"],
    ["How can I live forever?", "I don't know"],
    ["Where can I find a Heaven?", "I don't know"],
    ["What is going to happen?", "I don't know"],
    ["Why I'm in love now?", "I don't know"],
  ];
</script>

<div id="tab-guide" class="space-y-10 pb-12">
  <!-- Header -->
  <HeaderCard
    className="flex flex-col items-center text-center gap-5 px-0 py-0 overflow-hidden"
  >
    <div class="px-6 py-7">
      <div class="animate-bounce text-7xl">🐟</div>
      <div class="flex flex-col items-center gap-1">
        <h1 class="text-xl font-black md:text-2xl lg:text-3xl">
          Fish It! Perfect Macro
        </h1>
        <p class="text-xs font-light text-blue-400">v1.0.0 — 17 Nov 2025</p>
      </div>
    </div>
    <Waves />
  </HeaderCard>

  <div class="flex flex-col gap-5">
    <!-- Getting Started -->
    <StepCard label="Getting Started" steps={GettingStarted} />

    <!-- FAQ & Troubleshooting -->
    <ContentCard label="FAQ & Troubleshooting">
      <div class="space-y-4 text-sm">
        {#each FAQnTroubleshooting as [q, a]}
          <details class="cursor-pointer rounded-lg bg-slate-800/50 p-4">
            <summary class="font-semibold">{q}</summary>
            <p class="mt-6">
              {a}
            </p>
          </details>
        {/each}
      </div>
    </ContentCard>

    <!-- Links -->
    <div class="space-y-3">
      <a
        href="https://discord.gg/"
        target="_blank"
        class="block w-full rounded-xl bg-indigo-600/90 py-3.5 text-center text-sm font-bold shadow-lg hover:bg-indigo-500"
      >
        Community
      </a>
      <a
        href="https://www.youtube.com/watch?v=UIp6_0kct_U"
        target="_blank"
        class="block w-full rounded-xl bg-red-600/90 py-3.5 text-center text-sm font-bold shadow-lg hover:bg-red-500"
      >
        Tutorial
      </a>
      <a
        href="https://github.com/NegionDev/fipm"
        target="_blank"
        class="block w-full rounded-xl bg-zinc-800/90 py-3.5 text-center text-sm font-bold shadow-lg hover:bg-zinc-700"
      >
        Repository
      </a>
    </div>
  </div>

  <!-- Footer -->
  <div
    class="border-t border-slate-700/30 pt-5 text-center text-xs text-slate-500"
  >
    <p>
      Made with 🔥 & ❤️ by <span class="font-bold text-blue-400">romen</span>
    </p>
    <p>AutoHotkey v2 • WebView2</p>
  </div>
</div>
