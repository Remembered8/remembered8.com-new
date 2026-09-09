import { expect, test } from '@playwright/test';

const API = 'http://127.0.0.1:8877';

/**
 * The registry contract, exercised over real HTTP against the running Laravel
 * app rather than through its own test harness. The refusals matter as much as
 * the successes: an open door for tributes must not be an open door for
 * rewriting someone's memorial.
 */
test.describe('registry API', () => {
  test('reports itself healthy and bound to a database', async ({ request }) => {
    const response = await request.get(`${API}/api/health`);

    expect(response.ok()).toBeTruthy();
    expect(await response.json()).toMatchObject({
      status: 'ok',
      runtime: 'laravel',
      registryBound: true,
    });
  });

  test('lists the seeded dossiers', async ({ request }) => {
    const response = await request.get(`${API}/api/memorials`);
    const { memorials } = await response.json();

    expect(memorials.length).toBeGreaterThan(20);
    expect(memorials.map((m: { id: string }) => m.id)).toContain('albert-einstein');
  });

  test('serves one dossier with its whole document', async ({ request }) => {
    const response = await request.get(`${API}/api/memorials/baris-manco`);
    const { memorial } = await response.json();

    expect(memorial.fullName).toBe('Barış Manço');
    expect(memorial.document.timelineEvents.length).toBeGreaterThan(0);
  });

  test('answers 404 for a dossier that does not exist', async ({ request }) => {
    expect((await request.get(`${API}/api/memorials/nobody-at-all`)).status()).toBe(404);
  });

  test('a candle may be lit by anyone and it counts', async ({ request }) => {
    const before = await (await request.get(`${API}/api/memorials/nikola-tesla`)).json();

    const lit = await request.post(`${API}/api/memorials/nikola-tesla/contributions`, {
      data: { kind: 'candle' },
    });
    expect(lit.status()).toBe(201);

    const after = await (await request.get(`${API}/api/memorials/nikola-tesla`)).json();
    expect(after.memorial.candleCount).toBe(before.memorial.candleCount + 1);
  });

  test('a memory letter is held back until a guardian publishes it', async ({ request }) => {
    const left = await request.post(`${API}/api/memorials/nikola-tesla/contributions`, {
      data: { kind: 'memory', authorName: 'Bir Ziyaretçi', body: 'Onu hiç unutmadım.' },
    });
    expect(left.status()).toBe(201);
    expect((await left.json()).contribution.isApproved).toBe(false);

    const published = await request.get(`${API}/api/memorials/nikola-tesla/contributions`);
    const bodies = (await published.json()).contributions.map((c: { body: string }) => c.body);
    expect(bodies).not.toContain('Onu hiç unutmadım.');
  });

  test('a seeded dossier cannot be rewritten', async ({ request }) => {
    const attempt = await request.put(`${API}/api/memorials/albert-einstein`, {
      data: { document: { id: 'albert-einstein', slug: 'albert-einstein', fullName: 'Vandalised' } },
    });
    expect(attempt.status()).toBe(403);

    const after = await (await request.get(`${API}/api/memorials/albert-einstein`)).json();
    expect(after.memorial.fullName).toBe('Albert Einstein');
  });

  test('a new dossier belongs to whoever holds its edit token', async ({ request }) => {
    const id = `e2e-${Date.now()}`;
    const document = {
      id,
      slug: id,
      fullName: 'Zeynep Şahinoğlu',
      profession: 'Öğretmen',
      privacy: 'public',
      candleCount: 0,
    };

    const created = await request.post(`${API}/api/memorials`, { data: { document } });
    expect(created.status()).toBe(201);

    const { editToken } = await created.json();
    expect(editToken).toBeTruthy();

    // Turkish characters must survive the whole round trip.
    const fetched = await (await request.get(`${API}/api/memorials/${id}`)).json();
    expect(fetched.memorial.fullName).toBe('Zeynep Şahinoğlu');

    // Without the token, no.
    const anonymous = await request.put(`${API}/api/memorials/${id}`, {
      data: { document: { ...document, fullName: 'Vandalised' } },
    });
    expect(anonymous.status()).toBe(403);

    // With it, yes.
    const owner = await request.put(`${API}/api/memorials/${id}`, {
      headers: { authorization: `Bearer ${editToken}` },
      data: { document: { ...document, fullName: 'Sahibi Güncelledi' } },
    });
    expect(owner.status()).toBe(200);

    const final = await (await request.get(`${API}/api/memorials/${id}`)).json();
    expect(final.memorial.fullName).toBe('Sahibi Güncelledi');
  });

  test('an unlisted dossier is reachable by id but not by listing', async ({ request }) => {
    const id = `e2e-unlisted-${Date.now()}`;
    await request.post(`${API}/api/memorials`, {
      data: {
        document: { id, slug: id, fullName: 'Gizli Kayıt', privacy: 'private_link', candleCount: 0 },
      },
    });

    expect((await request.get(`${API}/api/memorials/${id}`)).status()).toBe(200);

    const { memorials } = await (await request.get(`${API}/api/memorials`)).json();
    expect(memorials.map((m: { id: string }) => m.id)).not.toContain(id);
  });
});
