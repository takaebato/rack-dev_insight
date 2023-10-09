<script>
  import {
    Accordion,
    AccordionItem, TabItem,
    Table,
    TableBody,
    TableBodyCell,
    TableBodyRow,
    TableHead,
    TableHeadCell,
  } from 'flowbite-svelte';
  import { Pane, Splitpanes } from 'svelte-splitpanes';
  import JsonViewer from './JsonViewer.svelte';

  export let apis;
  export let apiPanesHeight;
  export let openApiRow;
  export let openApiDetails;
  export let selectApiRow;
</script>

<TabItem title='API' class='[&>button]:!p-3 overflow-hidden'>
  <Splitpanes style='height: {apiPanesHeight}'>
    <Pane class='!overflow-auto !bg-white'>
      <Table hoverable class='table-fixed  min-w-[30em]'>
        <TableHead>
          <TableHeadCell class='w-3/12'>Status</TableHeadCell>
          <TableHeadCell class='w-3/12'>Method</TableHeadCell>
          <TableHeadCell class='w-6/12'>Url</TableHeadCell>
        </TableHead>
        <TableBody>
          {#if apis !== undefined}
            {#each apis as api, idx}
              <TableBodyRow on:click={() => selectApiRow(idx)}>
                  <TableBodyCell class='whitespace-normal break-words'>{api.status}</TableBodyCell>
                  <TableBodyCell class='whitespace-normal break-words'>{api.method}</TableBodyCell>
                  <TableBodyCell class='whitespace-normal break-words'>{api.url}</TableBodyCell>
              </TableBodyRow>
            {/each}
          {/if}
        </TableBody>
      </Table>
    </Pane>
    <Pane class='!overflow-auto !bg-white'>
      <Accordion
        multiple
        class='text-gray-900 text-sm min-w-[20em]'
        classActive='bg-gray-50 focus:ring-0'
        inactiveClass='bg-gray-50 text-gray-900'
      >
        <AccordionItem
          bind:open={openApiDetails[0]}
          transitionParams={{ duration: 0 }}
          paddingDefault='p-2'
          class='group-first:rounded-none'
        >
          <span slot='header'>Request Headers</span>
          {#if apis !== undefined && openApiRow !== undefined}
            {#each apis[openApiRow].requestHeaders as header}
              <p class='p-0.5'>{header.field}: {header.value}</p>
            {/each}
          {/if}
        </AccordionItem>
        <AccordionItem
          bind:open={openApiDetails[1]}
          transitionParams={{ duration: 0 }}
          paddingDefault='p-2'
          class='group-first:rounded-none'
        >
          <span slot='header'>Request Body</span>
          {#if apis !== undefined && openApiRow !== undefined}
            <JsonViewer data={apis[openApiRow].requestBody} />
          {/if}
        </AccordionItem>
        <AccordionItem
          bind:open={openApiDetails[2]}
          transitionParams={{ duration: 0 }}
          paddingDefault='p-2'
          class='group-first:rounded-none'
        >
          <span slot='header'>Response Headers</span>
          {#if apis !== undefined && openApiRow !== undefined}
            {#each apis[openApiRow].responseHeaders as header}
              <p class='p-0.5'>{header.field}: {header.value}</p>
            {/each}
          {/if}
        </AccordionItem>
        <AccordionItem
          class='group-first:rounded-none'
          transitionParams={{ duration: 0 }}
          paddingDefault='p-2'
          bind:open={openApiDetails[3]}
        >
          <span slot='header'>Response Body</span>
          {#if apis !== undefined && openApiRow !== undefined}
            <JsonViewer data={apis[openApiRow].responseBody} />
          {/if}
        </AccordionItem>
      </Accordion>
    </Pane>
  </Splitpanes>
</TabItem>
