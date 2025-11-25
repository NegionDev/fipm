<script lang="ts">
  import { onMount } from "svelte";

  import { configState } from "./stores/config.svelte";
  import CaptionBar from "./components/layout/caption-bar.svelte";
  import Sidebar from "./components/layout/sidebar.svelte";
  import General from "./tabs/general.svelte";
  import Hotkeys from "./tabs/hotkeys.svelte";
  import Calibrate from "./tabs/calibrate.svelte";
  import About from "./tabs/about.svelte";

  const tabs = {
    General,
    Hotkeys,
    Calibrate,
    About,
  };

  type Tab = keyof typeof tabs;
  let currentTab = $state<Tab>(Object.keys(tabs).at(-1) as Tab);

  onMount(async () => {
    const filePath = await window.ahk.global.CONFIG_FILE_PATH;
    const isFileExist = await window.ahk.global.FileExist(filePath);
    if (!isFileExist) {
      return; // file is automatically generated on ahk side with default value
    }

    const fileContent = await window.ahk.global.FileRead(filePath);
    configState.config = JSON.parse(fileContent);
  });
</script>

<CaptionBar />

<!-- App Contents -->
<main
  class="relative mt-[33px] flex max-h-[calc(100vh-33px)] flex-1 overflow-y-auto px-6 py-12"
>
  <Sidebar
    {currentTab}
    tabs={Object.keys(tabs)}
    onNavigate={(tab) => (currentTab = tab as Tab)}
  />

  <!-- Page Contents -->
  <div id="page-content" class="mx-auto max-w-3xl flex-1 pl-12">
    {#if Object.keys(tabs).includes(currentTab)}
      {@const TabComponent = tabs[currentTab]}
      <TabComponent />
    {/if}
  </div>
</main>
