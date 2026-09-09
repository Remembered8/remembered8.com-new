import { expect, test } from '@playwright/test';

/**
 * The public site, in a real browser, rendering from the real registry.
 *
 * The link-preview assertions are the point of the whole split: the single-app
 * version rendered every memorial client-side, so a dossier shared in a family
 * WhatsApp group previewed as the generic site card and a crawler saw nothing.
 */
test.describe('public site', () => {
  test('the landing page renders the archive', async ({ page }) => {
    await page.goto('/');

    await expect(page).toHaveTitle(/Remembered/);
    await expect(page.locator('body')).toContainText('REMEMBERED');
  });

  test('a dossier is server rendered, before any JavaScript runs', async ({ browser }) => {
    // JavaScript off: whatever is asserted here came from the server.
    const context = await browser.newContext({ javaScriptEnabled: false });
    const page = await context.newPage();

    await page.goto('/anma/baris-manco');
    await expect(page.locator('body')).toContainText('Barış Manço');

    await context.close();
  });

  test('link previews carry the person, not the site', async ({ request, baseURL }) => {
    const html = await (await request.get(`${baseURL}/anma/baris-manco`)).text();

    expect(html).toContain('<title>Barış Manço | Remembered</title>');
    expect(html).toMatch(/property="og:title"[^>]*Barış Manço/);
    expect(html).toMatch(/property="og:type"[^>]*profile/);
    // The portrait, so the card in a chat window shows the person.
    expect(html).toMatch(/property="og:image"/);
  });

  test('each dossier gets its own preview rather than a shared one', async ({ request, baseURL }) => {
    const first = await (await request.get(`${baseURL}/anma/albert-einstein`)).text();
    const second = await (await request.get(`${baseURL}/anma/nikola-tesla`)).text();

    const titleOf = (html: string) => /<title>([^<]*)<\/title>/.exec(html)?.[1];

    expect(titleOf(first)).toContain('Albert Einstein');
    expect(titleOf(second)).toContain('Nikola Tesla');
    expect(titleOf(first)).not.toBe(titleOf(second));
  });

  test('a canonical URL is declared, and it is the dossier route', async ({ request, baseURL }) => {
    const html = await (await request.get(`${baseURL}/anma/albert-einstein`)).text();

    expect(html).toMatch(/rel="canonical"[^>]*\/anma\/albert-einstein/);
  });

  test('an unknown dossier is a 404, not a silent fallback', async ({ page }) => {
    const response = await page.goto('/anma/nobody-at-all');

    expect(response?.status()).toBe(404);
  });

  test('the interface can be read in Turkish', async ({ page }) => {
    await page.goto('/');

    // The switcher is a client control, so it only exists once the tree has
    // hydrated. Wait for that rather than racing it: asserting earlier tests
    // the harness's timing, not the product.
    const switcher = page.locator('#navbar-lang-switcher-btn');
    await switcher.waitFor({ state: 'visible', timeout: 20_000 });

    // The consent banner is deliberately left alone. It sits at the bottom and
    // does not cover the header, and it re-mounts once the language settles
    // after hydration, so clicking it here was racing a detaching element.
    const before = (await page.locator('html').getAttribute('lang')) ?? 'en';

    // Dispatched rather than clicked. Switching language re-renders the whole
    // shell with a new dictionary, and Playwright's actionability check keeps
    // re-resolving the button mid-update. The handler is the same either way.
    await switcher.dispatchEvent('click');

    // Asserted on <html>, which never unmounts, rather than on the button,
    // which is replaced as part of the very re-render being tested.
    await expect(page.locator('html')).toHaveAttribute(
      'lang',
      before === 'tr' ? 'en' : 'tr'
    );

    // And the dictionary really did change, not just the attribute.
    await expect(page.locator('body')).toContainText(
      before === 'tr' ? 'Create Memorial' : 'Kütük Oluştur'
    );
  });

  test('no third-party script loads before consent is given', async ({ page }) => {
    const thirdParty: string[] = [];
    page.on('request', (request) => {
      const url = request.url();
      if (/googletagmanager|clarity\.ms|connect\.facebook\.net/.test(url)) {
        thirdParty.push(url);
      }
    });

    await page.goto('/');
    await page.waitForTimeout(1500);

    expect(thirdParty).toEqual([]);
  });
});
