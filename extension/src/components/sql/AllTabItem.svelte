<script>
  import { TabItem, Table, TableBody, TableBodyCell, TableBodyRow, TableHead, TableHeadCell } from 'flowbite-svelte';

  export let sql;
  export let sqlSubPanesHeight;
</script>
<TabItem title='ALL' class='[&>button]:!p-3'>
  <div class='overflow-auto' style='height: {sqlSubPanesHeight}'>
    <Table>
      <TableHead>
        <TableHeadCell>Statement</TableHeadCell>
        <TableHeadCell>Backtrace</TableHeadCell>
        <TableHeadCell>Duration(ms)</TableHeadCell>
      </TableHead>
      <TableBody>
        {#if sql !== undefined}
          {#each sql.queries as query}
            <TableBodyRow>
              <TableBodyCell>{query.statement}</TableBodyCell>
              <TableBodyCell>{query.backtrace}</TableBodyCell>
              <TableBodyCell>{query.duration}</TableBodyCell>
            </TableBodyRow>
          {/each}
        {/if}
      </TableBody>
    </Table>
  </div>
</TabItem>
