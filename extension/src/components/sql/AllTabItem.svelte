<script>
  import { TabItem } from 'flowbite-svelte';
  import QueryTable from './QueryTable.svelte';

  export let sql;
  export let sqlSubPanesHeight;
  export let allSort;

  const setAllSort = (key) => {
    if (key === allSort.key) {
      if (allSort.direction === 1) {
        allSort.direction = -1;
      } else {
        allSort.key = 'id';
        allSort.direction = 1;
      }
    } else {
      allSort.key = key;
      allSort.direction = 1;
    }
    allSort = allSort;
  };
</script>
<TabItem title='ALL' class='[&>button]:!p-3'>
  <div class='overflow-auto' style='height: {sqlSubPanesHeight}'>
    <QueryTable
      setSort={setAllSort}
      queries={sql ? sql.queries.sort((a, b) => a[allSort.key] > b[allSort.key] ? allSort.direction : -allSort.direction) : []}
    />
  </div>
</TabItem>
