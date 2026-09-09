/// <reference types="vite/client" />

interface ImportMetaEnv {
  /** The Laravel registry this app talks to. */
  readonly VITE_API_URL?: string;
  /** The public site links and QR plaques point at. */
  readonly VITE_SITE_URL?: string;
  readonly VITE_GA4_ID?: string;
  readonly VITE_CLARITY_ID?: string;
  readonly VITE_META_PIXEL_ID?: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
