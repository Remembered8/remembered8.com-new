/**
 * Deep links inside the app shell.
 *
 * On the web these drive the address bar. Inside Capacitor there is no address
 * bar to drive, so the history calls are no-ops and only the URL builder is
 * meaningful: it is what the share sheet and the QR plaque hand out, and it has
 * to point at the public site rather than at the app bundle.
 */

const SITE_URL = import.meta.env.VITE_SITE_URL ?? 'https://remembered8.com';

export function memorialPath(idOrSlug: string): string {
  return `/anma/${encodeURIComponent(idOrSlug)}`;
}

export function memorialUrl(idOrSlug: string): string {
  return `${SITE_URL}${memorialPath(idOrSlug)}`;
}

/** No address bar on a device: nothing to read. */
export function readMemorialIdFromUrl(): string | null {
  return null;
}

/** No address bar on a device: nothing to sync. */
export function syncUrlToMemorial(): void {}
