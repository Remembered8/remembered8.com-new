# remembered8.com

Remembered is a living digital memory archive: a dignified place to preserve a
person's story, timeline, voice, photographs, family tree and the memories other
people carry of them.

This is the split rebuild of the single-app version that lives beside it in
`../remembered8.com`. Four applications, one registry.

```
remembered8.com-new/
├── api/          Laravel 13 — the registry, REST, no UI
├── admin/        Laravel 13 + Filament 5 — curation and moderation
├── frontend/     Next.js 16 — the public site, server rendered
└── mobile-app/   SwiftUI sources and the iOS handoff spec
```

| Part | Stack | Local address |
| --- | --- | --- |
| api | Laravel 13.31, PHP 8.4 | `http://api.remembered8.test` |
| admin | Laravel 13.31, Filament 5.8 | `http://admin.remembered8.test/admin` |
| frontend | Next.js 16.3, React 19.2, Tailwind 4 | `http://remembered8.test` |
| mobile-app | SwiftUI | Xcode |

## Why it was split

Two reasons, both concrete.

**Link previews.** The single-app version rendered every memorial client-side at
`/?id=x`. A family sharing a memorial in a WhatsApp group got the generic site
card, not the person. Search engines saw the same empty shell. The Next.js
frontend renders each dossier on the server, so the title, description and
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

# frontend
cd frontend && npm install && npm run dev
```

The Laravel apps are served by Laragon vhosts, not `php artisan serve`. The
`.conf` files are already written into `C:\laragon\etc\apache2\sites-enabled`;
they need two things done by hand, because both require rights this setup does
not have:

1. Add to `C:\Windows\System32\drivers\etc\hosts` as administrator:
   ```
   127.0.0.1 api.remembered8.test
   127.0.0.1 admin.remembered8.test
   ```
2. Restart Apache from Laragon.

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

## What is not carried over yet

The single-app version is still the one deployed at remembered8.com. This split
has the registry, the admin panel and the server-rendered memorial pages; the
rest of the public interface (the landing broadsheet, the profile sections, the
modals, the consent banner) still needs porting from `../remembered8.com/src`.
The shared modules that made it across untouched are the type definitions, the
TR/EN dictionary, and the consent, analytics, storage and controller modules.
