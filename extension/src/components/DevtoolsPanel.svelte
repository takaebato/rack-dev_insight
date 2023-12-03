<script lang="ts">
  import { Table, TableBody, TableBodyCell, TableBodyRow, TableHead, TableHeadCell, Tabs } from 'flowbite-svelte';
  import { onMount, tick } from 'svelte';
  import { Pane, Splitpanes } from 'svelte-splitpanes';
  import type { RackDevInsightResultSchema } from '../api/Api';
  import ApiTabItem from './ApiTabItem.svelte';
  import SqlTabItem from './SqlTabItem.svelte';
  import { fetchResult } from '../api/fetch';
  import type { OpenRowsType } from '../types';
  import Pausing from './svgs/Pausing.svelte';
  import Recording from './svgs/Recording.svelte';
  import Sweep from './svgs/Sweep.svelte';
  import SettingWithModal from './SettingWithModal.svelte';

  const DEFAULT_REQUEST_PANE_SIZE = 35;
  let detailPanePercent = 100 - DEFAULT_REQUEST_PANE_SIZE;
  const RECORDING_BAR_HEIGHT = '(1.55rem + 1px)';
  const PANE_HEIGHT = `calc(100vh - ${RECORDING_BAR_HEIGHT})`;
  const LAYOUT_SWITCH_PIXEL = 1000;
  let isNarrowViewport = window.innerWidth <= LAYOUT_SWITCH_PIXEL;
  const TAB_ITEM_HEIGHT = '3.2rem';
  const TAB_ITEM_WITH_SUB_HEIGHT = '5.9rem';
  const PANE_SPLITTER_HEIGHT = '8px';
  let detailPaneHeight = `calc(${PANE_HEIGHT} * ${detailPanePercent} * 0.01)`;
  $: detailPaneHeight = `calc(${PANE_HEIGHT} * ${detailPanePercent} * 0.01)`;
  let apiPanesHeight = `calc(${detailPaneHeight} - ${TAB_ITEM_HEIGHT} - ${PANE_SPLITTER_HEIGHT})`;
  let sqlSubPanesHeight = `calc(${detailPaneHeight} - ${TAB_ITEM_WITH_SUB_HEIGHT} - ${PANE_SPLITTER_HEIGHT})`;
  $: {
    if (isNarrowViewport) {
      apiPanesHeight = `calc(${detailPaneHeight} - ${TAB_ITEM_HEIGHT} - ${PANE_SPLITTER_HEIGHT})`;
      sqlSubPanesHeight = `calc(${detailPaneHeight} - ${TAB_ITEM_WITH_SUB_HEIGHT} - ${PANE_SPLITTER_HEIGHT})`;
    } else {
      apiPanesHeight = `calc(${PANE_HEIGHT} - ${TAB_ITEM_HEIGHT})`;
      sqlSubPanesHeight = `calc(${PANE_HEIGHT} - ${TAB_ITEM_WITH_SUB_HEIGHT})`;
    }
  }
  const handleWindowResize = () => (isNarrowViewport = window.innerWidth <= LAYOUT_SWITCH_PIXEL);
  const DETAIL_PANE_NUMBER = 1;
  const handlePanesResize = (event: CustomEvent) => (detailPanePercent = event.detail[DETAIL_PANE_NUMBER].size);

  let results: RackDevInsightResultSchema[] = [];

  let openRequestRow: number = -1;
  let openCrudRows: OpenRowsType = {};
  let openNormalizedRows: OpenRowsType = {};
  let openApiRow: number = -1;

  const selectRequestRow = (idx: number) => {
    if (openRequestRow === idx) return;
    openRequestRow = idx;
    openCrudRows = {};
    openNormalizedRows = {};
    openApiRow = -1;
  };

  const API_DETAILS_COUNT = 5;
  const openApiDetails: boolean[] = new Array(API_DETAILS_COUNT).fill(true);
  const selectApiRow = (idx: number) => (openApiRow = idx);

  let isRecording = true;
  const handleToggleRecording = () => (isRecording = !isRecording);

  const handleSweep = () => {
    results = [];
    openRequestRow = -1;
    openCrudRows = {};
    openNormalizedRows = {};
    openApiRow = -1;
  };

  let scrollContainer;
  let atBottomOnRequestPane = true;
  const checkScrollOnRequestPane = () => {
    atBottomOnRequestPane =
      Math.abs(scrollContainer.scrollHeight - scrollContainer.scrollTop - scrollContainer.clientHeight) < 1;
  };
  const scrollToBottomOnRequestPane = () => {
    scrollContainer.scrollTop = scrollContainer.scrollHeight;
  };

  onMount(() => {
    // eslint-disable-next-line no-undef
    chrome.devtools.network.onRequestFinished.addListener(async (request: chrome.devtools.network.Request) => {
      if (!isRecording) return;

      const { skip, response } = await fetchResult(request);
      if (skip) return;

      if (response.ok) {
        results = [...results, response.data];
      } else {
        // eslint-disable-next-line no-console
        console.error(response.error);
      }

      await tick(); // wait for DOM update
      if (atBottomOnRequestPane) scrollToBottomOnRequestPane();
    });

    window.addEventListener('resize', handleWindowResize);
    checkScrollOnRequestPane();
    scrollContainer.addEventListener('scroll', checkScrollOnRequestPane);

    return () => {
      window.removeEventListener('resize', handleWindowResize);
      window.removeEventListener('scroll', checkScrollOnRequestPane);
    };
  });
</script>

<div class="flex border-b">
  {#if isRecording}
    <Recording on:click={handleToggleRecording} />
  {:else}
    <Pausing on:click={handleToggleRecording} />
  {/if}
  <Sweep on:click={handleSweep} />
  <div class="my-1 border-l" />
  <SettingWithModal />
</div>
<div class="[&_td]:border [&_td]:p-2 [&_td]:text-xs [&_th]:border [&_th]:p-3 [&_th]:text-sm [&_th]:normal-case">
  <Splitpanes
    horizontal={isNarrowViewport}
    style="height: {PANE_HEIGHT}"
    class="!bg-white"
    on:resize={handlePanesResize}
  >
    <Pane size={DEFAULT_REQUEST_PANE_SIZE} class="relative !bg-white">
      <div bind:this={scrollContainer} class="absolute bottom-0 left-0 right-0 top-0 !overflow-auto">
        <Table hoverable class="min-w-[40em] table-fixed">
          <TableHead>
            <TableHeadCell class="w-2/12">Status</TableHeadCell>
            <TableHeadCell class="w-2/12">Method</TableHeadCell>
            <TableHeadCell class="w-6/12">Path</TableHeadCell>
            <TableHeadCell class="w-2/12">Duration</TableHeadCell>
          </TableHead>
          <TableBody>
            {#each results as result, idx}
              <TableBodyRow
                on:click={() => selectRequestRow(idx)}
                class={idx === openRequestRow ? 'bg-primary-100 hover:bg-primary-100' : ''}
              >
                <TableBodyCell class="whitespace-normal break-words">{result.status}</TableBodyCell>
                <TableBodyCell class="whitespace-normal break-words">{result.method}</TableBodyCell>
                <TableBodyCell class="whitespace-normal break-words">{result.path}</TableBodyCell>
                <TableBodyCell class="whitespace-normal break-words">{result.duration}</TableBodyCell>
              </TableBodyRow>
            {/each}
          </TableBody>
        </Table>
      </div>
    </Pane>
    <Pane class="!overflow-hidden !bg-white">
      <Tabs
        style="underline"
        contentClass={`p-2 bg-white rounded-lg dark:bg-gray-800 ${isNarrowViewport ? 'pl-2' : 'pl-1'}`}
      >
        <SqlTabItem sql={results[openRequestRow]?.sql} {sqlSubPanesHeight} {openCrudRows} {openNormalizedRows} />
        <ApiTabItem
          apis={results[openRequestRow]?.apis || []}
          {apiPanesHeight}
          {openApiRow}
          {openApiDetails}
          {selectApiRow}
        />
      </Tabs>
    </Pane>
  </Splitpanes>
</div>
