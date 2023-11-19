<script lang="ts">
  import { TabItem } from 'flowbite-svelte';
  import QueryTable from './QueryTable.svelte';
  import { compFunc } from '../../utils/sort';
  import type { SqlSchema } from '../../api/Api';
  import type { SortType } from '../../types';

  export let sql: SqlSchema | undefined;
  export let sqlSubPanesHeight: string;
  export let allSort: SortType;
  export let setAllSort: (key: string) => void;
</script>

<TabItem title="ALL" class="[&>button]:!p-3">
  <div class="overflow-auto" style="height: {sqlSubPanesHeight}">
    <QueryTable setSort={setAllSort} queries={sql ? sql.queries.sort(compFunc(allSort)) : []} />
  </div>
</TabItem>
