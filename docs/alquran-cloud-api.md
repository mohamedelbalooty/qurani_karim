# alquran.cloud — API and CDN reference for this app

Agent-facing reference for integrating [alquran.cloud](https://alquran.cloud/) into
`qurany_karim`. Read this before adding, changing, or debugging any network call to
`api.alquran.cloud` or `cdn.islamic.network`.

Companion to [`AGENTS.md`](../AGENTS.md), which documents the repo's architecture and
conventions. That file is authoritative for layering, state enums, providers, routes and
cache keys; this one is authoritative for the API.

**Sources.** Every endpoint list here comes from the canonical OpenAPI spec the site's
`/api` page renders from, fetched at `https://api.alquran.cloud/v1/documentation/openapi/yaml`
(1,982 lines, `openapi: 3.1.0`, 35 paths). Every response shape, field list, byte size and
error string was additionally verified against **live responses** from 20 endpoints and
**8 CDN URLs** on 28 September 2026. Where the spec and the live API disagree, the live
behaviour wins and is called out.

---

## TL;DR

- The app uses **2 of 35** available endpoints, through `DioHelper`'s `baseUrl`.
- The app **already downloads and discards** 7 of the 9 fields the API returns per ayah
  (`juz`, `manzil`, `page`, `ruku`, `hizbQuarter`, `sajda`, `number`) and 3 of 6 per surah
  (`englishName`, `englishNameTranslation`, `numberOfAyahs`). Several "new features"
  therefore need **no new download** — only model changes. See
  [The discarded-fields problem](#the-discarded-fields-problem).
- An **invalid edition identifier returns HTTP 200** with fallback text and **no `audio`
  key**. It does not 404. This is a live trap on the app's audio path. See
  [Gotchas](#gotchas-read-before-you-ship).
- The reciter table on the site's `/cdn` page is **partly wrong**. Trust
  `GET /edition/format/audio`, not the docs.

---

## Quick start

| Thing | Value |
| --- | --- |
| REST base URL | `https://api.alquran.cloud/v1/` |
| Media CDN | `https://cdn.islamic.network` |
| CDN (Russia) | `https://cdn.alislam.ru` |
| Auth | **None.** Free and key-less. No API key exists. |
| Rate limit | Soft, per-second, per-IP. Details: <https://community.islamic.network/knowledgebase/2-is-there-a-rate-limit-on-the-apis-cdn> |
| CDN throttling | None per client, but "cache aggressively at your own edge" is asked for explicitly |
| Terms | <https://alquran.cloud/terms-and-conditions> (last updated 14 June 2026) |

Terms worth knowing before shipping:

- The **text** may be reproduced/embedded/stored/displayed freely for non-commercial use.
  Preserve Uthmani diacritics; do not alter or commingle with non-Quranic material.
  Commercial use needs no permission but a source acknowledgement is asked for.
- **Recitations** are licensed for free non-commercial redistribution at the published
  bitrates. You may bundle them in a commercial product, but copyright stays with the
  reciters and they may ask for removal. Attribute translators by name.
- No warranties of any kind. It is a free, volunteer-run service.

### Response envelope

Every endpoint returns the same top-level shape:

```json
{ "code": 200, "status": "OK", "data": { } }
```

- `data` is **an object for most endpoints and an array for list endpoints** —
  `/surah`, `/ayah/random/editions/{editions}`, `/ayah/{number}/editions/{editions}`,
  `/edition*`, `/search` (`data` is an object with `count`/`matches`).
- `status` is `"OK"` on success and `"NOT FOUND"` on 404.
- The app's convention is that `data` exists on 200. **It does not exist on 404**, and the
  404 body has `data` as a *string*, not an object. See [Gotchas](#gotchas-read-before-you-ship).

### Compression

Every endpoint accepts an `Accept-Encoding` header; supported values are `gzip` and `zstd`.
`Dio` sends an `Accept-Encoding` automatically, so nothing to configure — but note the app
sets no explicit value.

---

## All 35 REST endpoints

Base: `https://api.alquran.cloud/v1/`. All are `GET`. "JSON path" is how you reach the
useful data from the envelope.

### Quran (2)

| Endpoint | Params | JSON path | Notes / candidate use |
| --- | --- | --- | --- |
| `/quran` | — | `data.surahs[]` | Full Quran, default edition. |
| `/quran/{edition}` | `edition` | `data.surahs[]` | Full Quran, named edition. **The app uses `quran-uthmani`.** 2,109,200 bytes. Works for translations and tafsirs too — `en.sahih` is 1,614,163 bytes. |

### Surah (4)

| Endpoint | Params | JSON path | Notes / candidate use |
| --- | --- | --- | --- |
| `/surah` | — | `data[]` (array) | 114 index rows, **19,276 bytes**. Cheap surah list for a dropdown — no text. |
| `/surah/{number}` | `number` 1–114, `?offset`, `?limit` | `data` | One surah with all ayahs. Default edition. |
| `/surah/{number}/{edition}` | `number`, `edition`, `?offset`, `?limit` | `data` | **The app uses this for audio** (`surah_audio/remote_service.dart:16`). `?offset`/`?limit` verified working → lazy per-ayah paging. |
| `/surah/{number}/editions/{editions}` | `number`, comma-separated `editions`, `?offset`, `?limit` | `data[]` (array) | Arabic + translation side by side, one request. Not in any current app flow. |

### Ayah (6)

| Endpoint | Params | JSON path | Notes / candidate use |
| --- | --- | --- | --- |
| `/ayah/random` | — | `data` | Random ayah. `data.surah` carries the surah metadata. |
| `/ayah/random/{edition}` | `edition` | `data` | "Verse of the day" per language. |
| `/ayah/random/editions/{editions}` | comma-separated `editions` | `data[]` (array) | Same word in several languages. |
| `/ayah/{number}` | `number` 1–6236 | `data` | Global ayah number, not ayah-within-surah. |
| `/ayah/{number}/{edition}` | `number`, `edition` | `data` | |
| `/ayah/{number}/editions/{editions}` | `number`, comma-separated `editions` | `data[]` (array) | |

### Page / Juz / HizbQuarter / Ruku / Manzil (10)

All five grouping schemes have the **same two-endpoint pattern** and the **same response
shape**: `{ number, ayahs[], surahs{}, edition }`, where `surahs` is a **map keyed by surah
number**, not an array. All accept `?offset` and `?limit`.

| Endpoint family | Range | Verified response |
| --- | --- | --- |
| `/page/{number}` · `/page/{number}/{edition}` | 1–**604** | `{number, ayahs, surahs, edition}` |
| `/juz/{number}` · `/juz/{number}/{edition}` | 1–**30** | `{number, ayahs, surahs, edition}` (juz 1 = 148 ayahs) |
| `/hizbQuarter/{number}` · `/hizbQuarter/{number}/{edition}` | 1–**240** | `{number, ayahs, surahs, edition}` |
| `/ruku/{number}` · `/ruku/{number}/{edition}` | 1–**556** | `{number, ayahs, surahs, edition}` |
| `/manzil/{number}` · `/manzil/{number}/{edition}` | 1–**7** | `{number, ayahs, surahs, edition}` |

`/page/1` is the basis for a mushaf (codex page) view. The site's own reader uses it.

### Edition (7)

| Endpoint | Params | JSON path | Notes |
| --- | --- | --- | --- |
| `/edition` | `?type`, `?format`, `?language` | `data[]` (array) | All editions; filters are combinable. |
| `/edition/type` | — | `data[]` (array of strings) | Returns 6: `tafsir`, `translation`, `quran`, `transliteration`, `versebyverse`, `surahbysurah`. |
| `/edition/type/{type}` | enum: `quran`, `versebyverse`, `transliteration`, `translation`, `tafsir` | `data[]` | The spec documents 5 types; the live `/edition/type` returns a 6th, `surahbysurah`. |
| `/edition/format` | — | `data[]` | `text`, `audio`. |
| `/edition/format/{format}` | enum: `text`, `audio` | `data[]` | **`/edition/format/audio` returns 190 editions, 35,008 bytes. This is the authoritative reciter list.** |
| `/edition/language` | — | `data[]` | 40 language codes. |
| `/edition/language/{lang}` | `lang` | `data[]` | |

Edition object shape: `{ identifier, language, name, englishName, format, type, direction }`.
`direction` is present on Uthmani text editions and on all 190 audio editions (both `rtl`),
but is **absent** from text translations such as `en.sahih` — so read it with a null guard
and fall back to deriving direction from `language`.

**Counts verified live:** 124 translations · 6 tafsirs · 190 audio editions · 196 editions
with `language=ar` · 17 with `type=translation&language=en`.

> **Filter trap.** `type=translation&language=ar` returns *5* results, four of which are
> `format=audio` reciters that happen to embed a translation (`ar.abdulbasitmurattal`,
> `ar.minshawi`, `ar.minshawimujawwad`, `ar.minshawi-2`) alongside the real text
> translation `quran-buck`. **Always add `?format=text`** when building a list of text
> translations, or a reciter picker will fill up with audio editions.

### Search (3)

| Endpoint | Params | JSON path | Notes |
| --- | --- | --- | --- |
| `/search/{word}` | `word`, `?offset`, `?limit` | `data.matches[]` | Searches **all English editions** when no language is given. `count`, `total` available. |
| `/search/{word}/{surah}` | `word`, `surah` (1–114 **or the literal `all`**), `?offset`, `?limit` | `data.matches[]` | |
| `/search/{word}/{surah}/{language}` | `word`, `surah`, `language` (2-letter code **or** an edition id such as `en.sahih`), `?offset`, `?limit` | `data.matches[]` | The only route to Arabic search. |

Verified: `/search/Path` → `count: 1848`. `/search/Path?offset=0&limit=3` →
`data` keys become `count, matches, total, offset, limit` and **`count` becomes the number
returned (3), not the total (1848)** — read `total` when paginating. The spec calls this
"additive" and it is verified.

Match object: `{ number, text, edition, surah, numberInSurah }`. `surah` is a partial surah
(`number, name, englishName, englishNameTranslation, revelationType`) — it has **no
`numberOfAyahs`** on this endpoint.

### Sajda (2)

| Endpoint | Params | JSON path | Notes |
| --- | --- | --- | --- |
| `/sajda` | — | `data.ayahs[]` | 9,147 bytes, **15 verses**. |
| `/sajda/{edition}` | `edition` | `data.ayahs[]` | |

`sajda` is a **boolean** (`false`) on every ayah in `/quran/{edition}`, but a **rich object**
`{ id, recommended, obligatory }` on the `/sajda` endpoint itself. Verified live. The 15
verses' `text` carries a trailing `۩` (sajda sign) in the Uthmani edition.

### Meta (1)

`GET /meta` → `data` = `{ ayahs, surahs, sajdas, rukus, pages, manzils, hizbQuarters, juzs }`.
53,035 bytes. Reference counts, useful for a progress bar or a sanity check. Note it is
**53 KB to display a handful of integers** — cache it, do not fetch per screen.

---

## Response schemas (verified against live responses)

### Surah with ayahs — `data.surahs[]` from `/quran/{edition}`, and `data` from `/surah/{n}`

```
{
  number,                      // 1..114
  name,                        // Arabic, decorated: "سُورَةُ ٱلْفَاتِحَةِ"
  englishName,                 // "Al-Faatiha"
  englishNameTranslation,      // "The Opening"
  revelationType,              // "Meccan" | "Medinan"
  numberOfAyahs,               // 7        <- present on /surah/{n} and /surah, ABSENT on /quran/{edition}
  ayahs: [ { ... } ]
}
```

> `numberOfAyahs` is **absent** from `/quran/{edition}` (the endpoint the app calls) but
> present on `/surah`, `/surah/{n}` and the partial-surah schemas. Verified live. If you add
> it to the model, do not assume the first-run download supplies it.

### Ayah — inside a surah

```
{
  number,          // global 1..6236
  text,
  numberInSurah,   // 1..numberOfAyahs
  juz,             // 1..30
  manzil,          // 1..7
  page,            // 1..604   <- mushaf page
  ruku,            // 1..556
  hizbQuarter,     // 1..240
  sajda,           // bool
  surah            // partial surah, ONLY on /ayah/*, /juz/*, /page/*, /sajda — NOT inside a surah's ayahs[]
}
```

### Ayah with audio — `data.ayahs[]` from `/surah/{n}/{audioEdition}`

```
{
  number, audio, audioSecondary, text, numberInSurah, juz, manzil, page, ruku, hizbQuarter, sajda
}
```

`audio` is an absolute CDN URL, e.g.
`https://cdn.islamic.network/quran/audio/128/ar.alafasy/1.mp3`.
**`audioSecondary` exists and the app discards it** — it is a second reciter's reading.

### Single ayah — `data` from `/ayah/*`

```
{ number, text, edition, surah, numberInSurah, juz, manzil, page, ruku, hizbQuarter, sajda }
```

`edition` is the full edition object (see Edition section), so a single-ayah call is
self-describing: the response tells you which edition/language it came from.

### Surah index — `data[]` from `/surah`

```
{ number, name, englishName, englishNameTranslation, numberOfAyahs, revelationType }
```

114 items, 19,276 bytes total. No `ayahs`. Ideal for a search/filter list.

### Grouping — `data` from `/page|page|juz|manzil|ruku|hizbQuarter`

```
{ number, ayahs: [ { number, text, surah, numberInSurah, juz, manzil, page, ruku, hizbQuarter, sajda } ],
  surahs: { "1": {...}, "2": {...} },   // MAP keyed by surah number, not an array
  edition: { ... } }
```

---

## Media CDN

Base `https://cdn.islamic.network`. The CDN has **no API rate limit** and no per-client
throttle, but the terms ask you to cache aggressively.

### Audio by ayah — what the app uses

```
https://cdn.islamic.network/quran/audio/{bitrate}/{edition}/{number}.mp3
```

- `{number}` is a **global ayah number 1–6236**.
- `{edition}` is an identifier from `GET /edition/format/audio`.
- Verified: `.../audio/128/ar.alafasy/262.mp3` → 200, `audio/mpeg`, 831,865 bytes.
  `.../audio/64/ar.alafasy/262.mp3` → 200, 417,111 bytes.

### Audio by surah — unused by the app, a straight win

```
https://cdn.islamic.network/quran/audio-surah/{bitrate}/{edition}/{number}.mp3
```

- `{number}` is a **surah number 1–114**. Not integrated with the API at all.
- Verified: `.../audio-surah/128/ar.alafasy/1.mp3` → 200, 1,420,155 bytes.
- The app currently assembles a per-ayah playlist and calls `player.open` with
  `startIndex: 0`; surah-level files would be one continuous stream with no gaps between
  ayahs. That is a genuine playback-quality improvement, not just a new feature.

### Ayah images

```
https://cdn.islamic.network/quran/images/{surah}_{ayah}.png
https://cdn.islamic.network/quran/images/high-resolution/{surah}_{ayah}.png
```

- Verified: `images/2_255.png` → 200, `image/png`, 16,257 bytes.
  `images/high-resolution/100_1.png` → 200, 4,200 bytes. Sizes are **not** monotonic
  between normal and high-resolution, so do not assume the hi-res path is the bigger file.
- Directly constructible from the `page`/ayah data already in the app's Hive cache.

### Bitrates

`192`, `128`, `64`, `48`, `40`, `32` kbps. 128 is the recommended general use; 32 is best
on cellular. **Not every edition exists at every bitrate** — see the 403 note in
[Gotchas](#gotchas-read-before-you-ship).

### Manifests (authoritative availability data)

| URL | Size | Purpose |
| --- | --- | --- |
| `https://cdn.islamic.network/quran/info/by-ayah/info.json` | **18,163,065 bytes (~18 MB)** | Every edition × bitrate × ayah. Do not fetch on a phone. |
| `https://cdn.islamic.network/quran/info/by-surah/info.json` | 756,783 bytes | Every surah-level audio edition × bitrate. Reasonable to fetch once and cache, or filter at build time. |

---

## How this app integrates today

Two endpoints, both through one shared `Dio` instance.

| | Call site | Effective URL |
| --- | --- | --- |
| Base URL | `lib/utils/helper/dio_helper.dart:8` | `BaseOptions(baseUrl: 'https://api.alquran.cloud/v1/')` |
| Quran text | `lib/repositories/quran/remote_service.dart:14` | `GET quran/quran-uthmani` |
| Surah audio | `lib/repositories/surah_audio/remote_service.dart:16` | `GET surah/{surahId}/{elderFormat}` |

`DioHelper` is initialised once, synchronously, at `lib/main.dart:129`
(`static init()` with no `async`, so there is no `late` hazard — unlike `CacheHelper`).

### What `DioHelper` does *not* configure

- **No timeouts.** `connectTimeout` / `sendTimeout` / `receiveTimeout` are all unset. A
  hung request hangs whatever awaited it — and `WelcomeView` awaits
  `getRemoteData()` (`lib/view/welcome_view/welcome_view.dart:98`), so a stalled first-run
  download leaves the app on the splash with no error.
- **No interceptors.** No logging, no retry, no error normalisation.
- **No default headers.** In particular no explicit `Accept-Encoding` (Dio sends its own).
- **No `validateStatus`**, so `Dio` *throws* on any non-2xx. This makes the
  `if (response.statusCode == 200)` branches in both remote services effectively dead code
  — the reachable path for errors is the `on DioException` handler.
- **No query-parameter helper** exists anywhere in the codebase, so `?offset=`/`?limit=`
  support on the API has no ergonomic wrapper today.
- `postData` (`dio_helper.dart:17`) and the `options` argument of `getData` are both
  **dead code** — zero call sites.

### The `Either` convention

Repositories return `Either<SuccessData, ErrorResult>` where **`Left` is success and
`Right` is error** — inverted from `dartz` intuition. Do not "fix" it; every call site is
`value.fold((left) { /* success */ }, (right) { /* error */ })`.

### Error routing

`lib/core/status_code_errors.dart:5` `returnResponse(Response)` switches on status code
into three `ServerException` subclasses in `lib/core/server_exception.dart` — but **all
three return the identical** `ErrorResult(errorMessage: 'error'.tr(),
errorImage: 'assets/icons/server.png')`. The mapping is currently vestigial: there is no
status-code-specific messaging anywhere.

Error objects are constructed **in the repository layer**, already translated, and carry an
asset path for the UI, which `BuildErrorWidget` (`lib/view/app_components.dart:261`) renders
as `Image.asset` + `Text`. The three error shapes in play:

| Where | `errorMessage` | `errorImage` |
| --- | --- | --- |
| `core/server_exception.dart` (all 3 classes) | `'error'.tr()` | `assets/icons/server.png` |
| both `remote_service.dart` `on DioException` fallback | `'error'.tr()` | `assets/icons/no-internet.png` |
| every `local_service.dart` catch | `'local_exception'.tr()` | `assets/icons/storage_error.png` |

Because the API's 404 body has `data` as a **string**, a new endpoint that does
`jsonData['data'][...]` without a `code` check will throw a `TypeError` that
`on DioException` does **not** catch. Both existing remote services have this exposure.

### The reciter list

`assets/json_db/elders.json` holds 17 `{identifier, name}` pairs, loaded via
`EldersLocalService` from `DefaultAssetBundle`, selected in `listening_view.dart`, and
passed as the `{edition}` path segment.

**All 17 were verified against the live `GET /edition/format/audio` list and all 17
resolve correctly.** `Elder.identifier` values are exactly the `{edition}` segment, so the
identifier is the single source of truth for reciter identity in this app.

---

## The discarded-fields problem

`GET quran/quran-uthmani` — the app's first-run download — returns 9 fields per ayah and 6
per surah. The models keep 2 and 3.

| Model | API field | Kept? |
| --- | --- | --- |
| `Ayah` (`lib/model/ayah.dart:17`) | `text` | yes (`@HiveField(0)`) |
| | `numberInSurah` | yes (`@HiveField(1)`) |
| | `number`, `juz`, `manzil`, `page`, `ruku`, `hizbQuarter`, `sajda` | **discarded** |
| `Surah` (`lib/model/surah.dart:24`) | `number`, `name`, `revelationType`, `ayahs` | yes |
| | `englishName`, `englishNameTranslation` | **discarded** |
| | `numberOfAyahs` | **discarded** (and absent from this endpoint anyway) |

**The data is already on the device.** A mushaf page view, juz/ruku/manzil/hizb-quarter
navigation, sajda markers, per-ayah deep links and CDN image URLs are all reachable from
`page`, `juz`, `ruku`, `manzil`, `hizbQuarter` and `sajda` without a single additional
network call. Only the model layer needs to change.

### Why that change is not trivial — the Hive trap

- `Ayah` is `@HiveType(typeId: 1)` and `Surah` is `@HiveType(typeId: 0)`. **Both typeIds are
  taken**; a new Hive model must use `typeId >= 2` and be registered in
  `lib/main.dart:127-128` alongside the existing two.
- Both models `part` a committed `.g.dart`. Those adapters hardcode the field count —
  `lib/model/ayah.g.dart:28` writes `writeByte(2)`, `lib/model/surah.g.dart:30` writes
  `writeByte(4)` — and cast each field by its concrete type.
- **`build_runner` is in neither `pubspec.yaml` nor `pubspec.lock`.** Only `hive_generator`
  (and its transitive `source_gen`) are present, so `dart run build_runner build` **cannot
  run.** Adding a `@HiveField` requires hand-editing the committed `.g.dart` to match:
  bump the field count and add the read/write pairs at the right indices.

Getting the indices wrong does not throw at write time in a way that is obvious; it
corrupts the existing on-device cache. **Bump the field count, or use a separate
non-Hive DTO.** Existing installs also have no schema-version gate, so a field-order change
needs a cache reset to be safe — which interacts with the fact that `isCachingQuran` is
never reset to `false` anywhere (see `AGENTS.md`), so the app can never re-enter
`WelcomeView` to re-download on its own.

---

## Adoptable features, ranked

Ordered by value per unit of risk. "Files touched" is the minimum realistic set, not a
plan — each of these deserves its own design pass.

| # | Feature | Why | Cost | Blocker |
| --- | --- | --- | --- | --- |
| 1 | **Per-ayah metadata** — persist `page`, `juz`, `ruku`, `manzil`, `hizbQuarter`, `sajda` | Enables features 2–6 with **zero extra download**; already paid for | Low–med | Hive `.g.dart` hand-edit; cache invalidation |
| 2 | **Mushaf page view** from `page` (1–604) + `cdn.islamic.network/quran/images/{surah}_{ayah}.png` | Biggest single UX addition; the site's own flagship feature | Med | Needs #1; new screen + route + provider |
| 3 | **Translations** via `/quran/{edition}` (124 available) and `/surah/{n}/editions/{a,b}` | The app is Arabic-only; a translation toggle is the most-requested class of Quran-app feature | Med | Ayah shape is **identical** (9 fields, verified on `en.sahih`) so no new model — but the `edition` object differs: `type` is `translation` not `quran`, and **`direction` is absent entirely** (Uthmani carries `direction: rtl`). Derive `TextDirection` from the edition's `language`/`type`, never from the `direction` key alone. |
| 4 | **Full-text search** via `/search/{word}/{surah}/{language}` | Missing entirely; `total`/`offset`/`limit` give real pagination | Med | Arabic search needs a 2-letter code; `data.total` vs `data.count` semantics differ when paginating |
| 5 | **Surah-level audio** via `audio-surah/{bitrate}/{edition}/{n}.mp3` | Removes inter-ayah gaps; halves playlist bookkeeping | Low–med | `assets_audio_player` needs a single-file play path; bitrate must be checked against `info.json` |
| 6 | **Juz / hizbQuarter / ruku / manzil browsing** (30 / 240 / 556 / 7) | All four are the same call shape; cheap once #1 lands | Low | Needs #1 |
| 7 | **Lazy per-surah loading** via `/surah/{n}/{edition}?offset=&limit=` | Replaces the 2.1 MB / 19 KB first-run download with a 19 KB index + on-demand surahs; would also let the `isCachingQuran` gate go away | Med | Touches the first-run flow in `welcome_view.dart` and `main.dart`'s `initialRoute` logic — the riskiest change on this list |
| 8 | **Dynamic reciter picker** from `/edition/format/audio` (190) | Replaces the hand-maintained 17-entry `elders.json`; never goes stale | Low | `EldersLocalService` currently takes a `BuildContext`; the remote variant must not |
| 9 | **Tafsir** (6 editions) and **transliteration** | Same shape as translations; trivial once #3 exists | Low | Needs #3 |
| 10 | **"Ayah of the day" / random** via `/ayah/random/{edition}` | Home-screen widget | Low | New provider + a cache key (remember `isCaching*` naming is already misleading) |
| 11 | **`audioSecondary` playback** | Second reciter per ayah, already in the payload | Low | Needs a model field (non-Hive `AyahAudio`, so this one is cheap) |
| 12 | **Ayah images on a CDN** | Shareable/quotable verse cards; no API work at all | Low | `SharePlus` upgrade is still pending per `AGENTS.md` |

Deliberately **not** recommended: `/meta` (53 KB for a few integers), and the
`by-ayah/info.json` manifest (18 MB) at runtime.

---

## Gotchas (read before you ship)

1. **An invalid edition identifier returns HTTP 200, not 404.** Verified:
   `GET /surah/1/ar.bogusreciter` → `200 OK` with
   `edition.identifier: "quran-uthmani-quran-academy"` and **the `audio` key entirely
   absent** from every ayah. It silently substitutes the default text edition.
   - The app's audio path therefore has **no guard**: `AyahAudio.fromJson`
     (`lib/model/surah_audio.dart:8`) reads `json["audio"]` → `null` assigned to
     `final String audio`, which throws under sound null safety. That throw is not a
     `DioException`, so `remote_service.dart`'s handler misses it and the intended
     `no-internet.png` error never renders.
   - This is a **latent** trap, not a live bug: all 17 bundled identifiers are currently
     valid. It activates the moment someone types an identifier by hand, switches to a
     dynamic reciter list (#8), or the upstream list changes.
   - Fix when you touch that file: validate `response.data['data']['edition']['identifier']`
     against the requested `elderFormat` before mapping ayahs.
2. **The site's `/cdn` reciter table is partly wrong.** It lists `ar.sudais`,
   `ar.shuraim`, `ar.abdulbasit`, `ar.ajamy`, `ar.muhammadayoub` — **none of which exist**
   in the live `/edition/format/audio` list. The real identifiers are
   `ar.abdurrahmaansudais`, `ar.saoodshuraym`, `ar.abdulsamad`, `ar.ahmedajamy`,
   `ar.muhammadayyoub`. **Never hardcode an identifier from the docs page.** Query
   `/edition/format/audio`.
3. **`data` is not always an object.** It is an array on `/surah` and the `editions` list
   endpoints, and a *string* on 404s. Check `code` before descending, or catch the
   `TypeError` — `on DioException` will not catch it.
4. **`sajda` has two different types.** `bool` inside a surah's ayahs; `{id, recommended,
   obligatory}` on `/sajda`. Do not reuse one model for both.
5. **`numberOfAyahs` is missing from `/quran/{edition}`.** It is present on `/surah`,
   `/surah/{n}` and the partial-surah schemas. The app's first-run download will not supply
   it.
6. **`surahs` inside grouping responses is a map keyed by surah number**, not a list. Easy
   to mistake for an array.
7. **Ayah `page` is a mushaf page (1–604), not an index into a document you have.** The app
   holds no page data; deriving it from Hive needs #1 first.
8. **Not every edition exists at every bitrate.** Verified 403:
   `audio-surah/64/ar.alafasy/114.mp3` → **403 Forbidden** while
   `audio-surah/128/ar.alafasy/1.mp3` → 200. Check `info.json` before hardcoding a bitrate,
   or you will ship a reciter/bitrate pair that 403s mid-playback.
9. **Search `count` changes meaning when you paginate.** Without `?offset`/`?limit`,
   `count` is the total. With them, `count` becomes the number returned and `total` carries
   the total. Verified: `count: 3, total: 1848` for `/search/Path?offset=0&limit=3`.
10. **`type=translation` includes audio editions.** Always add `?format=text` — see
    [Edition](#edition-7).
11. **`/edition/type` returns 6 values, the spec documents 5.** The extra is
    `surahbysurah`. Trust the live list.
12. **404 bodies carry useful messages** and are safe to surface verbatim:
    `"Surat number should be between 1 and 114."`, `"Please specify an Ayah number (1 to
    6236)."`, `"Juz number should be between 1 and 30"`, `"Nothing matching your search was
    found.."`, `"Invalid type."`. Note the inconsistent punctuation — these are exact.
13. **`README.md:33` documents the wrong URL** (`https://alquran.cloud/api`). The real base
    is `https://api.alquran.cloud/v1/`.

---

## Recipe: adding an endpoint

Follow the existing pattern exactly — it is load-bearing for the widget tree.

1. **Decide the layer.** Only `quran` and `surah_audio` are remote. Ahadith, assmaa Allah,
   azkar and elders are bundled JSON and should stay that way unless there is a reason.
2. **Model.** Prefer a plain class in `lib/model/` with a `factory X.fromJson`. If it must
   be cached to Hive, expect to hand-edit the `.g.dart` (see the Hive trap) and register
   the adapter at `lib/main.dart:127-128` with an unused `typeId >= 2`.
3. **Repository interface** — `lib/repositories/<feature>/repository.dart`:
   ```dart
   abstract class XRepository {
     Future<Either<List<Model>, ErrorResult>> getX({required int id});
   }
   ```
   Return `dartz`'s `Either` with **`Left` = success**. Add the new keys to **both**
   `assets/langs/ar.json` and `assets/langs/en.json` for any user-facing or error string.
4. **Remote service** — `lib/repositories/<feature>/remote_service.dart`, extending the
   interface, using the shared `DioHelper` (relative path against the existing `baseUrl`).
   Mirror the existing error handling: non-200 → `returnResponse(response)`,
   `DioExceptionType.badResponse` → `returnResponse(...)`, anything else →
   `ErrorResult(errorMessage: 'error'.tr(), errorImage: 'assets/icons/no-internet.png')`.
   **Check `code` before descending into `data`** (gotcha 3), and validate the returned
   `edition.identifier` if the response echoes the edition (gotcha 1).
5. **States** — `lib/view_model/<feature>/states.dart`: sibling enums per async operation,
   in the `Initial/Loading/Loaded/Error` PascalCase style already used. Match the naming of
   the file you are editing — some enums use `Success` instead of `Loaded`. Do not mass-rename;
   that PascalCase style is what produces 59 of the repo's 89 baseline lints and is
   load-bearing for view ↔ view_model matching.
6. **ViewModel** — `ChangeNotifier`, `late` state fields initialised to `.Initial` in the
   constructor, `setXData()` methods that set the state and `notifyListeners()`.
7. **Register it** in `lib/utils/providers.dart` `Providers.providers` — a ViewModel missing
   from that list is invisible to the widget tree even though `ChangeNotifierProvider` is
   imported everywhere.
8. **Route it** — declare `static const String id` on the view and add an entry to
   `lib/utils/routes.dart`. Prefer `app_components.dart`'s `namedNavigator` /
   `materialNavigator` / `popNavigate` over raw `Navigator` calls.
9. **Verify** — `flutter analyze`. The baseline is **89 `info`, 0 errors, 0 warnings**, all
   pre-existing. Compare rule counts, not totals. `flutter test` cannot pass in this repo
   and its failure is not a signal.
