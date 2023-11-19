<script lang="ts">
  import {
    Accordion,
    AccordionItem,
    TabItem,
    Table,
    TableBody,
    TableBodyCell,
    TableBodyRow,
    TableHead,
    TableHeadCell,
  } from 'flowbite-svelte';
  import { Pane, Splitpanes } from 'svelte-splitpanes';
  import JsonViewer from './JsonViewer.svelte';
  import TraceInfo from './TraceInfo.svelte';
  import type { ApiSchema } from '../api/Api';

  export let apis: ApiSchema[];
  export let apiPanesHeight: string;
  export let openApiRow: number;
  export let openApiDetails: boolean[];
  export let selectApiRow: (idx: number) => void;
</script>

<TabItem title="API" class="overflow-hidden [&>button]:!p-3">
  <Splitpanes style="height: {apiPanesHeight}">
    <Pane class="!overflow-auto !bg-white">
      <Table hoverable class="min-w-[30em]  table-fixed">
        <TableHead>
          <TableHeadCell class="w-3/12">Status</TableHeadCell>
          <TableHeadCell class="w-3/12">Method</TableHeadCell>
          <TableHeadCell class="w-6/12">Url</TableHeadCell>
        </TableHead>
        <TableBody>
          {#each apis as api, idx}
            <TableBodyRow
              on:click={() => selectApiRow(idx)}
              class={idx === openApiRow ? 'bg-primary-100 hover:bg-primary-100' : ''}
            >
              <TableBodyCell class="whitespace-normal break-words">{api.status}</TableBodyCell>
              <TableBodyCell class="whitespace-normal break-words">{api.method}</TableBodyCell>
              <TableBodyCell class="whitespace-normal break-words">{api.url}</TableBodyCell>
            </TableBodyRow>
          {/each}
        </TableBody>
      </Table>
    </Pane>
    <Pane class="!overflow-auto !bg-white">
      <Accordion
        multiple
        class="min-w-[20em] text-sm text-gray-900"
        classActive="bg-gray-50 focus:ring-0"
        inactiveClass="bg-gray-50 text-gray-900"
      >
        <AccordionItem
          bind:open={openApiDetails[0]}
          transitionParams={{ duration: 0 }}
          paddingDefault="p-2"
          class="group-first:rounded-none"
        >
          <span slot="header">Request Headers</span>
          {#if openApiRow >= 0}
            {#each apis[openApiRow].requestHeaders as header}
              <p class="p-0.5">{header.field}: {header.value}</p>
            {/each}
          {/if}
        </AccordionItem>
        <AccordionItem
          bind:open={openApiDetails[1]}
          transitionParams={{ duration: 0 }}
          paddingDefault="p-2"
          class="group-first:rounded-none"
        >
          <span slot="header">Request Body</span>
          {#if openApiRow >= 0}
            <JsonViewer data={apis[openApiRow].requestBody || ''} />
          {/if}
        </AccordionItem>
        <AccordionItem
          bind:open={openApiDetails[2]}
          transitionParams={{ duration: 0 }}
          paddingDefault="p-2"
          class="group-first:rounded-none"
        >
          <span slot="header">Response Headers</span>
          {#if openApiRow >= 0}
            {#each apis[openApiRow].responseHeaders as header}
              <p class="p-0.5">{header.field}: {header.value}</p>
            {/each}
          {/if}
        </AccordionItem>
        <AccordionItem
          class="group-first:rounded-none"
          transitionParams={{ duration: 0 }}
          paddingDefault="p-2"
          bind:open={openApiDetails[3]}
        >
          <span slot="header">Response Body</span>
          {#if openApiRow >= 0}
            <JsonViewer data={apis[openApiRow].responseBody || ''} />
          {/if}
        </AccordionItem>
        <AccordionItem
          class="group-first:rounded-none"
          transitionParams={{ duration: 0 }}
          paddingDefault="p-2"
          bind:open={openApiDetails[4]}
        >
          <span slot="header">Backtrace</span>
          {#if openApiRow >= 0}
            {#each apis[openApiRow].backtrace as traceInfo}
              <TraceInfo {traceInfo} />
            {/each}
          {/if}
        </AccordionItem>
      </Accordion>
    </Pane>
  </Splitpanes>
</TabItem>
