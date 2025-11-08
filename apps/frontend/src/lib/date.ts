const dateFormatter = new Intl.DateTimeFormat('fr-FR', {
  day: '2-digit',
  month: 'long',
  year: 'numeric',
});

export function formatDate(dateString: string) {
  return dateFormatter.format(new Date(dateString));
}
