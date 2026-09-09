# remembered8.com

Remembered is a living digital memory archive: a dignified place to preserve a
person's story, timeline, voice, photographs, family tree and the memories other
people carry of them.

This is the split rebuild of the single-app version that lives beside it in
`../remembered8.com`. Four applications, one registry.

Each app is its own repository, wired in here as a submodule. This umbrella
holds the cross-cutting pieces: the end-to-end suite that drives several apps at
once, and this document.

```
remembered8.com-new/
├── api/          submodule -> Remembered8/api.remembered8.com
├── admin/        submodule -> Remembered8/admin.remembered8.com
├── app/          submodule -> Remembered8/app.remembered8.com
├── mobile/       submodule -> Remembered8/mobile.remembered8.com
└── e2e/          Playwright, lives here because it spans api and app
```

Clone it with the submodules, or fetch them afterwards:

```bash
git clone --recurse-submodules git@github.com:Remembered8/remembered8.com-new.git
# or, in an existing clone
git submodule update --init --recursive
```

A submodule is pinned to one commit. After pulling changes inside an app,
commit the new pointer here so the umbrella records which versions belong
together:

```bash
git add api && git commit -m "Bump api"
```

| Part | Repository | Stack | Local address |
| --- | --- | --- | --- |
| api | `api.remembered8.com` | Laravel 13.31, PHP 8.4 | `http://api.remembered8.localhost` |
| admin | `admin.remembered8.com` | Laravel 13.31, Filament 5.8 | `http://admin.remembered8.localhost/admin` |
| app | `app.remembered8.com` | Next.js 16.3, React 19.2, Tailwind 4 | `http://app.remembered8.localhost` |
| mobile | `mobile.remembered8.com` | React 19 + Vite + Capacitor 7 | `npm run dev`, then `npx cap run` |

## Why it was split

Two reasons, both concrete.

**Link previews.** The single-app version rendered every memorial client-side at
`/?id=x`. A family sharing a memorial in a WhatsApp group got the generic site
card, not the person. Search engines saw the same empty shell. The Next.js
app renders each dossier on the server, so the title, description and
portrait in the page source belong to the person being remembered.

**Accounts and moderation.** The old admin panel was a modal inside the public
SPA with no authentication at all. Filament brings a real panel with login, and
a moderation queue for the letters visitors leave.

## Running it

Prerequisites: PHP 8.4, Composer, Node 22.

```bash
# api
cd api && composer install && php artisan migrate --seed

# admin (reads the same database as the api)
cd admin && composer install

# app
cd app && npm install && npm run dev

# mobile (same shell, packaged for devices)
cd mobile && npm install && npm run dev
```

The Laravel apps are served by Laragon vhosts, not `php artisan serve`. The
`.conf` files live in `C:\laragon\etcpache2\sites-enabled` and use
`*.localhost`, matching the convention the other projects on this machine
follow. Restart Apache from Laragon after adding or renaming one.

`app.remembered8.localhost` proxies to a Next server on port 3000. Point it at a
production server, not the dev server:

```bash
cd app && npm run build && npm run start -- --port 3000
```

`next dev` behind that proxy loads its JavaScript but never finishes hydrating.
Apache does not forward the HMR WebSocket, and the Turbopack dev runtime keeps
retrying it instead of handing over, so the page renders and then ignores every
click. `next start` has no HMR socket and behaves through the proxy exactly as
it does directly.

While actually developing, skip Apache and use `http://localhost:3000`.

## The registry

A dossier is a deeply nested document and every client consumes it whole, so it
is stored whole, as JSON, with the fields the registry queries lifted into
columns beside it. Normalising it would mean rewriting every editing surface for
no near-term gain.

| Endpoint | Method | Who may call it |
| --- | --- | --- |
| `/api/memorials` | GET | anyone; public dossiers only |
| `/api/memorials` | POST | anyone; mints an edit token, returned once |
| `/api/memorials/{idOrSlug}` | GET | anyone who has the id |
| `/api/memorials/{idOrSlug}` | PUT | holder of that dossier's edit token |
| `/api/memorials/{idOrSlug}/contributions` | GET | anyone; approved entries only |
| `/api/memorials/{idOrSlug}/contributions` | POST | anyone |

There are no accounts on the public side yet, so authorship is proved by a token
minted at creation and hashed before storage. Seeded historical figures are
marked `is_seed` and refuse rewrites outright, so nobody edits Einstein.

Tributes are rows, not edits. That is what lets a stranger pay their respects
without being able to rewrite someone's memorial. A candle counts immediately; a
memory letter arrives unapproved and appears in the admin panel's queue.

`api/tests/Feature/RegistryTest.php` covers that contract, including the refusals.

## Seed data

`api/database/seeds/memorials.json` is exported from the original app rather than
transcribed, so the registry and the apps cannot drift:

```bash
cd ../remembered8.com
node scripts/export-seed-dossiers.mjs ../remembered8.com-new/api/database/seeds/memorials.json
```

## End to end

`e2e/` drives the real thing: Playwright starts the Laravel registry and the
Next.js site, against a throwaway SQLite database rebuilt per run, and exercises
them together. Seventeen tests: the registry contract including its refusals,
and the site including the link previews the split exists for.

```bash
cd e2e && npm install && npx playwright test
```

The API runs under `artisan serve` there rather than its Laragon vhost, because
the harness has to be self-contained and runnable in CI.

## Deployment

The single-app version is still what serves remembered8.com. This split is not
deployed yet.
