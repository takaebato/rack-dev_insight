<script lang="ts">
  import { TabItem, Table, TableBody, TableBodyCell, TableBodyRow, TableHead, TableHeadCell } from 'flowbite-svelte';
  import type { CrudAggregationSchema, QuerySchema, SqlSchema } from 'src/api/Api';
  import type { OpenRowsType, SortType } from 'src/types';
  import { compFunc } from '../../utils/sort';
  import QueryTable from './QueryTable.svelte';

  export let queries: QuerySchema[];
  export let crudAggregations: CrudAggregationSchema[];
  export let sqlSubPanesHeight: string;
  export let openCrudRows: OpenRowsType;
  export let setOpenCrudRows: (id: number) => (key?: string) => void;
  export let crudSort: SortType;
  export let setCrudSort: (key: string) => void;
  $: crudAggregations = crudAggregations.sort(compFunc(crudSort));

  const extractQueries = (crud: CrudAggregationSchema, sortKey: string, sortDirection: number) =>
    queries
      .filter((query) => crud.queryIds.includes(query.id))
      .sort((a, b) => (a[sortKey] > b[sortKey] ? sortDirection : -sortDirection));
</script>

<TabItem open title="CRUD" class="[&>button]:!p-3">
  <div class="overflow-auto" style="height: {sqlSubPanesHeight}">
    <Table hoverable class="min-w-[50em]  table-fixed">
      <TableHead>
        <TableHeadCell class="w-3/12" on:click={() => setCrudSort('type')}>Type</TableHeadCell>
        <TableHeadCell class="w-5/12" on:click={() => setCrudSort('table')}>Table</TableHeadCell>
        <TableHeadCell class="w-2/12" on:click={() => setCrudSort('count')}>Count</TableHeadCell>
        <TableHeadCell class="w-2/12" on:click={() => setCrudSort('duration')}>Duration</TableHeadCell>
      </TableHead>
      <TableBody>
        {#each crudAggregations as crud}
          <TableBodyRow
            on:click={() => setOpenCrudRows(crud.id)()}
            class={openCrudRows.hasOwnProperty(crud.id) ? 'bg-primary-100 hover:bg-primary-100' : ''}
          >
            <TableBodyCell class="whitespace-normal break-words">{crud.type}</TableBodyCell>
            <TableBodyCell class="whitespace-normal break-words">{crud.table}</TableBodyCell>
            <TableBodyCell class="whitespace-normal break-words">{crud.count}</TableBodyCell>
            <TableBodyCell class="whitespace-normal break-words">{crud.duration}</TableBodyCell>
          </TableBodyRow>
          <!--eslint-disable-next-line no-prototype-builtins-->
          {#if openCrudRows.hasOwnProperty(crud.id)}
            <TableBodyRow>
              <TableBodyCell colspan="4" class="p-2">
                <QueryTable
                  setSort={setOpenCrudRows(crud.id)}
                  queries={extractQueries(crud, openCrudRows[crud.id].key, openCrudRows[crud.id].direction)}
                />
              </TableBodyCell>
            </TableBodyRow>
          {/if}
        {/each}
      </TableBody>
    </Table>
  </div>
</TabItem>
