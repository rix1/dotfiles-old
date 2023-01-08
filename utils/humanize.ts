export function humanize(num: number) {
  const inMinutes = num / 60;
  if (inMinutes < 1) {
    return `~${num} seconds`;
  }
  return `~${inMinutes} minute${inMinutes > 1 ? "s" : ""}`;
}
