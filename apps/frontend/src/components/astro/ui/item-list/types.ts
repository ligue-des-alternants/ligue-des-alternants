export interface Item {
  title?: string;
  description: string;
  Icon?: (props: { class?: string }) => unknown;
}
