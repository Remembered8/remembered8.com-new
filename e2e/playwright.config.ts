import { defineConfig, devices } from '@playwright/test';
import { existsSync, mkdirSync, writeFileSync } from 'node:fs';
import { resolve } from 'node:path';

/**
 * End-to-end tests across the split.
 *
 * Playwright starts both halves itself: the Laravel registry and the Next.js
 * site that renders from it. Most of what is worth testing here only exists
 * when the two are talking, and a suite that quietly passed against a dead API
 * would be worse than no suite.
 *
 * The API runs under `artisan serve` rather than the Laragon vhost it uses in
 * development. That is on purpose: the harness has to be self-contained and
 * runnable in CI, where there is no Apache and no hosts file to edit.
 *
 * Ports are unusual so the suite does not fight the developer's own dev servers
 * or the other projects on this machine.
 */
const API_PORT = 8877;
const APP_PORT = 3477;

// A throwaway database, rebuilt per run by `migrate:fresh`, so the suite never
// depends on whatever state the developer's own registry happens to be in.
//
// Only created when missing. Truncating it here instead cost an hour: Playwright
// re-imports this config in each worker, so the file was being emptied after the
// migration had already run and every query then hit a missing table.
const E2E_DB = resolve(__dirname, '../api/database/e2e.sqlite');
mkdirSync(resolve(__dirname, '../api/database'), { recursive: true });
if (!existsSync(E2E_DB)) writeFileSync(E2E_DB, '');

export default defineConfig({
  testDir: './tests',
  fullyParallel: false,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: 1,
  reporter: [['list']],

  use: {
    baseURL: `http://127.0.0.1:${APP_PORT}`,
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
  },

  projects: [{ name: 'chromium', use: { ...devices['Desktop Chrome'] } }],

  webServer: [
    {
      command: `php artisan migrate:fresh --seed --no-interaction && php artisan serve --port=${API_PORT} --no-reload`,
      cwd: '../api',
      url: `http://127.0.0.1:${API_PORT}/api/health`,
      reuseExistingServer: false,
      timeout: 180_000,
      env: {
        APP_ENV: 'testing',
        DB_CONNECTION: 'sqlite',
        DB_DATABASE: E2E_DB,
      },
    },
    {
      // Built inside the harness: generateStaticParams prerenders dossiers, so
      // the pages have to be produced against the registry the tests will use.
      command: `npm run build && npm run start -- --port ${APP_PORT}`,
      cwd: '../app',
      url: `http://127.0.0.1:${APP_PORT}`,
      reuseExistingServer: false,
      timeout: 180_000,
      env: {
        API_URL: `http://127.0.0.1:${API_PORT}`,
        NEXT_PUBLIC_API_URL: `http://127.0.0.1:${API_PORT}`,
        NEXT_PUBLIC_SITE_URL: `http://127.0.0.1:${APP_PORT}`,
      },
    },
  ],
});
