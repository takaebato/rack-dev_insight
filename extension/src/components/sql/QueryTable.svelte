<script lang='ts'>
  import { Table, TableBody, TableBodyCell, TableBodyRow, TableHead, TableHeadCell } from 'flowbite-svelte';

  export let setSort;
  export let queries;
</script>
<Table class='table-fixed  min-w-[50em]'>
  <TableHead>
    <TableHeadCell class='w-5/12' on:click={() => setSort('statement')}>Statement</TableHeadCell>
    <TableHeadCell class='w-6/12' on:click={() => setSort('backtrace')}>Backtrace</TableHeadCell>
    <TableHeadCell class='w-1/12' on:click={() => setSort('duration')}>Dur.</TableHeadCell>
  </TableHead>
  <TableBody>
    {#each queries as query}
      <TableBodyRow>
        <TableBodyCell class='whitespace-normal break-words'>{query.statement}</TableBodyCell>
        <TableBodyCell class='whitespace-normal break-words'>
          {#each query.backtrace as line}
            <a href={line} target='_blank' class='hover:text-gray-500'>{line}</a><br />
          {/each}
        </TableBodyCell>
        <TableBodyCell class='whitespace-normal break-words'>{query.duration}</TableBodyCell>
      </TableBodyRow>
    {/each}
  </TableBody>
</Table>

