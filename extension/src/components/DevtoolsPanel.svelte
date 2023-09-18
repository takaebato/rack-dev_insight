<script lang='ts'>
  import { Table, TableBody, TableBodyCell, TableBodyRow, TableHead, TableHeadCell, Tabs } from 'flowbite-svelte';
  import { onMount } from 'svelte';
  import { Pane, Splitpanes } from 'svelte-splitpanes';
  import type { RackAnalyzerResultSchema } from '../api/Api';
  import ApiTabItem from './ApiTabItem.svelte';
  import SqlTabItem from './SqlTabItem.svelte';
  import { fetchResult, fetchResultDebug } from '../api/fetch';

  const DEFAULT_REQUEST_PANE_SIZE = 40;
  let detailPaneSize = 100 - DEFAULT_REQUEST_PANE_SIZE;
  const LAYOUT_SWITCH_PIXEL = 1000;
  let isNarrowViewport = window.innerWidth <= LAYOUT_SWITCH_PIXEL;
  let apiPanesHeight;
  let sqlSubPanesHeight;
  $: {
    if (isNarrowViewport) {
      apiPanesHeight = `calc(${detailPaneSize}vh - 3.2rem - 8px)`;
      sqlSubPanesHeight = `calc(${detailPaneSize}vh - 6.4rem - 8px)`;
    } else {
      apiPanesHeight = 'calc(100vh - 3.2rem)';
      sqlSubPanesHeight = 'calc(100vh - 6.4rem)';
    }
  }
  const handleWindowResize = () => (isNarrowViewport = window.innerWidth <= LAYOUT_SWITCH_PIXEL);
  const DETAIL_PANE_NUMBER = 1;
  const handlePanesResize = event => (detailPaneSize = event.detail[DETAIL_PANE_NUMBER].size);

  let results: RackAnalyzerResultSchema[] = [];

  let openRequestRow;
  const selectRequestRow = (idx) => {
    if (openRequestRow === idx) return;
    openCrudRows = new Set();
    openNormalizedRows = new Set();
    openApiRow = undefined;
    openRequestRow = idx;
  };
  let openCrudRows = new Set();
  const toggleCrudRow = (idx) => {
    openCrudRows.has(idx) ? openCrudRows.delete(idx) : openCrudRows.add(idx);
    openCrudRows = new Set(openCrudRows);
  };
  let openNormalizedRows = new Set();
  const toggleNormalizedRow = (idx) => {
    openNormalizedRows.has(idx) ? openNormalizedRows.delete(idx) : openNormalizedRows.add(idx);
    openNormalizedRows = new Set(openNormalizedRows);
  };
  let openApiRow;
  const API_DETAILS_COUNT = 4;
  let openApiDetails = new Array(API_DETAILS_COUNT).fill(true);
  const selectApiRow = (idx) => openApiRow = idx;

  onMount(() => {
    chrome.devtools.network.onRequestFinished.addListener(async (request) => {
      const { skip, response } = await fetchResultDebug(request);
      if (!skip) {
        if (response.ok) {
          results = [...results, response.data];
        } else {
          console.error(response.error);
        }
      }
    });
    window.addEventListener('resize', handleWindowResize);
    return () => {
      window.removeEventListener('resize', handleWindowResize);
    };
  });
</script>

<div class='[&_td]:border [&_td]:text-xs [&_td]:p-2 [&_th]:border [&_th]:normal-case [&_th]:text-sm [&_th]:p-3'>
  <Splitpanes horizontal={isNarrowViewport} class='!h-screen !bg-white' on:resize={handlePanesResize}>
    <Pane size={DEFAULT_REQUEST_PANE_SIZE} class='!overflow-auto !bg-white'>
      <Table hoverable>
        <TableHead>
          <TableHeadCell>Status</TableHeadCell>
          <TableHeadCell>Method</TableHeadCell>
          <TableHeadCell>Path</TableHeadCell>
          <TableHeadCell>Duration(ms)</TableHeadCell>
        </TableHead>
        <TableBody>
          {#each results as result, idx}
            <TableBodyRow on:click={() => selectRequestRow(idx)}>
              <TableBodyCell>{result.status}</TableBodyCell>
              <TableBodyCell>{result.method}</TableBodyCell>
              <TableBodyCell>{result.path}</TableBodyCell>
              <TableBodyCell>{result.duration}</TableBodyCell>
            </TableBodyRow>
          {/each}
        </TableBody>
      </Table>
    </Pane>
    <Pane class='!overflow-hidden !bg-white'>
      <Tabs style='underline' contentClass='p-2 bg-white rounded-lg dark:bg-gray-800'>
        <SqlTabItem
          sql={results?.[openRequestRow]?.sql}
          {sqlSubPanesHeight}
          {openCrudRows}
          {toggleCrudRow}
          {openNormalizedRows}
          {toggleNormalizedRow}
        />
        <ApiTabItem
          apis={results?.[openRequestRow]?.apis}
          {apiPanesHeight}
          {openApiRow}
          {openApiDetails}
          {selectApiRow}
        />
      </Tabs>
    </Pane>
  </Splitpanes>
</div>
