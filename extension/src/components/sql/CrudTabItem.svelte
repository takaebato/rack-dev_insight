<script>
  import { TabItem, Table, TableBody, TableBodyCell, TableBodyRow, TableHead, TableHeadCell } from 'flowbite-svelte';
  import QueryTable from './QueryTable.svelte';

  export let sql;
  export let sqlSubPanesHeight;
  export let openCrudRows;
  export let crudSort;

  const setOpenCrudRows = (id) => (key) => {
    if (key) {
      if (key === openCrudRows[id].sortKey) {
        if (openCrudRows[id].sortDirection === 1) {
          openCrudRows[id].sortDirection = -1;
        } else {
          openCrudRows[id].sortKey = 'id';
          openCrudRows[id].sortDirection = 1;
        }
      } else {
        openCrudRows[id].sortKey = key;
        openCrudRows[id].sortDirection = 1;
      }
    } else {
      openCrudRows.hasOwnProperty(id) ? delete openCrudRows[id] : openCrudRows[id] = { sortKey: 'id', sortDirection: 1 };
    }
    openCrudRows = openCrudRows;
  };

  const setCrudSort = (key) => {
    if (key === crudSort.key) {
      if (crudSort.direction === 1) {
        crudSort.direction = -1;
      } else {
        crudSort.key = 'id';
        crudSort.direction = 1;
      }
    } else {
      crudSort.key = key;
      crudSort.direction = 1;
    }
    crudSort = crudSort;
  };

  const extractQueries = (sql, crud, sortKey, sortDirection) =>
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
          {#each sql.crudAggregations.sort((a, b) => a[crudSort.key] > b[crudSort.key] ? crudSort.direction : -crudSort.direction) as crud}
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
                    queries={extractQueries(sql, crud, openCrudRows[crud.id].sortKey, openCrudRows[crud.id].sortDirection)}
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
