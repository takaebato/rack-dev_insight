export type SortType = {
  key: string;
  direction: 1 | -1;
};

export type OpenRowsType = {
  [key: number]: SortType;
};
