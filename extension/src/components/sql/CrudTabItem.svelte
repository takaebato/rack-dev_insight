<script lang='ts'>
  import { TabItem, Table, TableBody, TableBodyCell, TableBodyRow, TableHead, TableHeadCell } from 'flowbite-svelte';
  import QueryTable from './QueryTable.svelte';
  import type { CrudAggregationSchema, SqlSchema } from '../../api/Api';
  import type { OpenRowsType, SortType } from '../../types';
  import { compFunc } from '../../utils/sort';

  export let sql: SqlSchema | undefined;
  export let sqlSubPanesHeight: string;
  export let openCrudRows: OpenRowsType;
  export let setOpenCrudRows: (id: number) => (key?: string) => void;
  export let crudSort: SortType;
  export let setCrudSort: (key: string) => void;

  const extractQueries = (sql: SqlSchema, crud: CrudAggregationSchema, sortKey: string, sortDirection: number) =>
    sql.queries
      .filter((query) => crud.queryIds.includes(query.id))
      .sort((a, b) => a[sortKey] > b[sortKey] ? sortDirection : -sortDirection);
</script>

<TabItem open title='CRUD' class='[&>button]:!p-3'>
  <div class='overflow-auto' style='height: {sqlSubPanesHeight}'>
    <Table hoverable class='table-fixed  min-w-[50em]'>
      <TableHead>
        <TableHeadCell class='w-3/12' on:click={() => setCrudSort('type')}>Type</TableHeadCell>
        <TableHeadCell class='w-5/12' on:click={() => setCrudSort('table')}>Table</TableHeadCell>
        <TableHeadCell class='w-2/12' on:click={() => setCrudSort('count')}>Count</TableHeadCell>
        <TableHeadCell class='w-2/12' on:click={() => setCrudSort('duration')}>Duration</TableHeadCell>
      </TableHead>
      <TableBody>
        {#if sql !== undefined}
          {#each sql.crudAggregations.sort(compFunc(crudSort)) as crud}
            <TableBodyRow on:click={() => setOpenCrudRows(crud.id)()}>
              <TableBodyCell class='whitespace-normal break-words'>{crud.type}</TableBodyCell>
              <TableBodyCell class='whitespace-normal break-words'>{crud.table}</TableBodyCell>
              <TableBodyCell class='whitespace-normal break-words'>{crud.count}</TableBodyCell>
              <TableBodyCell class='whitespace-normal break-words'>{crud.duration}</TableBodyCell>
            </TableBodyRow>
            {#if openCrudRows.hasOwnProperty(crud.id)}
              <TableBodyRow>
                <TableBodyCell colspan='4' class='p-2'>
                  <QueryTable
                    setSort={setOpenCrudRows(crud.id)}
                    queries={extractQueries(sql, crud, openCrudRows[crud.id].key, openCrudRows[crud.id].direction)}
                  />
                </TableBodyCell>
              </TableBodyRow>
            {/if}
          {/each}
        {/if}
      </TableBody>
    </Table>
  </div>
</TabItem>
