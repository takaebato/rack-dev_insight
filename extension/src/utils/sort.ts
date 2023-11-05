import type { OpenRowsType, SortType } from '../types';

export const buildRows = (originalRows: OpenRowsType, id: number, key?: string): OpenRowsType => {
  const rows = { ...originalRows };
  if (key) {
    if (key === rows[id].key) {
      if (rows[id].direction === 1) {
        rows[id].direction = -1;
      } else {
        rows[id].key = 'id';
        rows[id].direction = 1;
      }
    } else {
      rows[id].key = key;
      rows[id].direction = 1;
    }
  } else {
    rows.hasOwnProperty(id)
      ? delete rows[id]
      : (rows[id] = {
          key: 'id',
          direction: 1,
        });
  }
  return rows;
};

export const buildSort = (originalSort: SortType, key: string): SortType => {
  const sort = { ...originalSort };
  if (key === sort.key) {
    if (sort.direction === 1) {
      sort.direction = -1;
    } else {
      sort.key = 'id';
      sort.direction = 1;
    }
  } else {
    sort.key = key;
    sort.direction = 1;
  }
  return sort;
};

export const compFunc =
  (sort: SortType) =>
  (a, b): number =>
    a[sort.key] > b[sort.key] ? sort.direction : -sort.direction;
