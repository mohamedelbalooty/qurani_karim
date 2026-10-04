# AGENTS.md

Flutter app (Android + iOS) for reading/listening to the Quran. MVVM + Provider, `dartz` for
error-as-value, Hive for caching, `alquran.cloud` for the two remote features.

For anything touching `api.alquran.cloud` or `cdn.islamic.network` — all 35 endpoints, the
media CDN, the current two call sites, and the gotchas that bite (an invalid edition returns
200 not 404; the site docs' reciter table is wrong) — read
[`docs/alquran-cloud-api.md`](docs/alquran-cloud-api.md) first.

## Commands

No task runner, Makefile, CI (`.github/` does not exist), or `opencode.json`. Everything is plain
`flutter`:

| Task | Command |
| --- | --- |
| Resolve deps | `flutter pub get` |
| Static analysis (the only real check) | `flutter analyze` |
| Analyze one file | `flutter analyze lib/view/welcome_view/welcome_view.dart` |
| Format | `dart format .` |
| Run | `flutter run` (needs a real device: geolocation + YouTube player) |

`analysis_options.yaml` is stock `flutter_lints` with **no custom or disabled rules**.

### `intl` is pinned to the SDK version

Flutter 3.35.5 pins `intl 0.20.2` via `flutter_localizations`, and `localize_and_translate >=4.0.0`
requires that same pin. `intl: ^0.20.2` in `pubspec.yaml` is not a preference — loosening it to `any`
or an older range breaks version solving outright. `lib/view/prayer_times_view/components.dart` is
the only `intl` consumer; re-check it before bumping.

### What "analyze is clean" means

Baseline is **89 issues, all `info`, 0 errors, 0 warnings** — so `flutter analyze` is *expected* to
print a long list and still pass. Compare rule counts, not totals. All 89 are pre-existing:

| Rule | Count |
| --- | --- |
| `constant_identifier_names` (the `Initial`/`Loading`/`Loaded`/`Error` enums) | 59 |
| `deprecated_member_use` | 11 |
| `library_private_types_in_public_api` | 9 |
| `use_build_context_synchronously` | 8 |
| `overridden_fields` | 2 |

Do not mass-`dart fix` these: 59 are the state-enum naming convention (see below) and 8 are genuine
`BuildContext`-across-async-gap bugs that need judgement, not a mechanical rewrite.

## `flutter test` cannot pass — treat failures as pre-existing

`test/widget_test.dart` is the untouched `flutter create` counter test. It pumps a bare
`QuraniKarim()` and asserts a counter increments. The first thing it hits is
`ProviderNotFoundException` on `Consumer<AppThemeProvider>`, because `main()` wraps the app in
`MultiProvider(providers: Providers.providers)` and the test does not. Even after wrapping it, the
build calls `CacheHelper.getBooleanData` against an uninitialized `late` field.

There is no meaningful test suite. Adding one means replacing this file and mocking Hive +
SharedPreferences + `LocalizeAndTranslate` — the same three statics `main()` sets up.

## Architecture

```
lib/
  model/          plain data classes; Surah/Ayah also carry Hive annotations
  core/           ServerException subclasses + status-code -> ErrorResult mapping
  repositories/<feature>/
                    repository.dart    abstract interface, returns dartz Either
                    local_service.dart  implements it over Hive / bundled JSON
                    remote_service.dart implements it over Dio
  view_model/<feature>/
                    <feature>_view_model.dart   ChangeNotifier, orchestrates services
                    states.dart                enums (Initial/Loading/Loaded/Error)
  view/<feature>/
                    <feature>_view.dart         screen
                    components.dart             that screen's private widgets
  ui_provider/    app-wide ChangeNotifiers (theme, font scale, tasbih, toggle, time)
  utils/          routes, theme, colors, cache keys, singletons
```

**The layering is not universal — check before assuming.** Only 6 of 8 view models use the
repository layer. `view_model/prayer_times/` goes straight to `adhan` + `geolocator`, and
`view_model/radio/` hardcodes a `radiojar.com` stream URL and drives `assets_audio_player` directly.

**Only two features are remote** (both against `https://api.alquran.cloud/v1/`): `quran` →
`quran/quran-uthmani` and `surah_audio` → `surah/$surahId/$elderFormat`. Ahadith, assmaa Allah,
azkar, and elders are 100% bundled JSON from `assets/json_db/*.json` (5 files) loaded via
`DefaultAssetBundle` — that is why their local services take a `BuildContext` parameter, which is
why the "repository" layer imports `package:flutter/material.dart`.

Conventions an agent will get wrong if it assumes defaults:

- **`Either` is inverted from intuition.** Repositories return `Either<SuccessData, ErrorResult>`
  where `Left` = success and `Right` = error. Every call site is
  `value.fold((left) { /* success */ }, (right) { /* error */ })`. Do not "fix" this.
- **Error objects are built in the repository layer**, already translated, carrying an asset path
  for the UI: `ErrorResult(errorMessage: 'error'.tr(), errorImage: 'assets/icons/no-internet.png')`.
  Note `core/status_code_errors.dart` switches on status code, but all three `ServerException`
  subclasses in `core/server_exception.dart` return the *same* generic `'error'` + `server.png`, so
  the mapping is currently vestigial.
- **State is a sibling enum, not a sealed class.** Each `view_model/<feature>/states.dart` declares
  independent enums per async operation (e.g. `QuranGetRemoteDataStates`,
  `QuranGetLocalDataStates`, `QuranGetCachedSurahDataStates`). Views `switch` on the enum. Some
  enums use `Success`, others `Loaded` — match the file you are editing. The
  `Initial/Loading/...` PascalCase naming is what produces 59 of the 89 lints; it is load-bearing
  for matching across view ↔ view_model, so leave it alone.
- **Register every new ViewModel in `lib/utils/providers.dart`.** `Providers.providers` is the only
  provider list; a ViewModel missing from it is invisible to the widget tree even though
  `ChangeNotifierProvider` is imported everywhere.
- **Navigation is string-keyed.** Each view declares `static const String id`, and every entry must
  be registered in `lib/utils/routes.dart` (12 routes today) or `pushNamed` throws at runtime.
  Prefer the `app_components.dart` helpers (`namedNavigator`, `materialNavigator`, `popNavigate`).

## Two files carry a commented-out duplicate of themselves

Editing the wrong copy is the single easiest mistake in this repo.

- **`lib/main.dart` lines 1-97 are a full commented-out copy of the entire entrypoint** (imports,
  `main()`, and `QuraniKarim`), followed by `library;` at line 98. The live code starts at line
  101. The dead copy is *stale* — it uses `context.delegates` where the live version uses
  `LocalizeAndTranslate.delegates`. Make changes below line 98 only.
- **`android/app/build.gradle` lines 1-52 are a commented-out legacy `apply plugin:`-style body**
  (`compileSdkVersion 34` / `targetSdkVersion 34`) sitting above the live `plugins { }` DSL block
  with `compileSdk = 35`. Read the bottom half.

## Cache keys (`lib/utils/constants/cache_keys.dart`)

Five keys, and the naming actively misleads:

- `isCachingQuran` — the only genuine boolean. Read at `main.dart:175` to pick `initialRoute`,
  written `true` once at `quran_view_model.dart:42`.
- `isCachingSurahText` — **despite the `isCaching` prefix this is an int, not a flag.** It stores
  the currently-read surah number (`getIntData`/`setIntData` at `quran_view_model.dart:70,84`) and
  defaults to surah 1. Don't "fix" it to a bool.
- `isCachingSurahAudio` — same trap, in `view_model/audio/audio_view_model.dart:52,73`.
- `quranResponse` — the Hive box name (`Box<Surah>`), not a pref key.
- `themeKey` — the dark-mode boolean.

## Startup order and the `CacheHelper` trap

`main()` runs these once, in order: `LocalizeAndTranslate.init` → `Hive.initFlutter` →
`Hive.registerAdapter` → `DioHelper.init` → `CacheHelper.init`.

`CacheHelper` matters most, and the reason is subtle: `AppThemeProvider` reads
`CacheHelper.getBooleanData(key: themeKey)` in a **field initializer**
(`ui_provider/app_theme_povider.dart:6`), and `QuraniKarim.build` calls
`CacheHelper.getBooleanData(key: isCachingQuran)` (`main.dart:175`). But `CacheHelper.init()` is
itself `static init() async` and `main()` calls it **without `await`**, so `sharedPreferences` is
only assigned in a later microtask. It currently survives only because `SharedPreferences.getInstance()`
resolves before the first frame builds. Anything that reads `CacheHelper` earlier — or a slower
`init` — throws `LateInitializationError`. `await CacheHelper.init();` is the real fix.

## Hive

**Codegen is not runnable.** `model/surah.dart` and `model/ayah.dart` use `@HiveType`/`@HiveField`
with `part '*.g.dart'`, and `hive_generator` is a dev dependency — but **`build_runner` is in
neither `pubspec.yaml` nor `pubspec.lock`** (only `hive_generator` and its transitive `source_gen`).
So `dart run build_runner build` cannot run. If you change a `@HiveField` index you must hand-edit
the committed `surah.g.dart` / `ayah.g.dart` to match, or add `build_runner` to `dev_dependencies`
first.

**Box lifetime is inconsistent — read the method you are editing.** In
`repositories/quran/local_service.dart` (box `quranResponse`), `getQuranData()` and
`getSurahData()` open the box and **never close it**; only `cachingQuranData()` closes. Do not
assume a long-lived box and do not add a cached `Box` field without handling close.

### First-run download gate

`main.dart` picks `initialRoute` from the `isCachingQuran` SharedPreferences flag: `WelcomeView` if
false, `HomeView` if true. The flag is set to `true` only after the *entire* Quran is fetched and
written to Hive (`view_model/quran/quran_view_model.dart:42`). Consequences:

- A fresh install has **no** Quran text locally. Reading/listening views read from Hive, so they are
  empty until Welcome completes. Run the Welcome flow once or pre-seed Hive to exercise them.
- **The flag is never set back to `false` anywhere in `lib/`.** Once set, the app cannot re-enter
  WelcomeView on its own.
- `QuranViewModel.disposeData()` does **not** do what its name suggests. It is `void … async`
  (so callers cannot await it), it clears the in-memory `_quranData` list, and it closes the box —
  it never empties the Hive box and never touches the `isCachingQuran` flag. It is called from
  `reading_view.dart:169` and `surah_audio_view.dart:174`, not from a reset flow.

## Localization

- Every user-facing string uses `'key'.tr()` (including error messages built in repositories).
  Keys live in **both** `assets/langs/ar.json` and `assets/langs/en.json` (58 keys each) — add to
  both. Arabic is the primary locale and the supported set is `['ar', 'en']`.
- **Known bug:** `main.dart:124` passes `AssetLoaderRootBundleJson('assets/lang')` (no `s`), but
  the files are in `assets/langs/` and `pubspec.yaml` declares `assets/langs/*.json`. The loader
  looks for `assets/lang/<locale>.json`, so translations do not resolve and `.tr()` falls through
  to the raw key. The correct argument is `'assets/langs'`. Until fixed, expect raw keys in the UI.

## UI conventions

- Responsive sizing via `ScreenUtilInit(designSize: Size(360, 640), minTextAdapt: true)`. Use the
  spacing helpers in `lib/view/app_components.dart` (`verticalSpace0..5`, `horizontalSpace0..5`,
  `padding1..3`, `defaultBorderRadius`, `lightGradient`, `darkGradient`, `showToast`) rather than
  raw numbers — they already apply `.h`/`.w`/`.sp`.
- `MaterialApp.builder` pins `textScaler` to a fixed `1.0`. User font-size control is
  `ChangeFontSizeProvider` instead; don't reintroduce OS text scaling.
- Dark mode is `AppThemeProvider.isDark`, persisted under the `themeKey` pref (defaults to `true`).
  Theme selection in widgets is via `context.select`/`Selector` so only dependents rebuild.
- Fonts: `Tajawal` (theme body text) and `ReemKufi` (display/headings).
- `SizeConfigurationHelper` exposes `late` statics; `initSizeConfiguration(context)` must be called
  before reading `screenOrientation` (used by `BuildAlertDialogWidget`).
- **Formatting is inconsistent** after the Dart 3 migration — several constructors have the closing
  paren on the first param's line (e.g. `app_components.dart:75-81`). `dart format` on a file you
  touch will produce a noisy but correct diff; keep it scoped to your own edits.

## Deprecation cleanup in progress

An uncommitted Dart 3 modernization pass is partway through. The working tree already has
`super.key`, `WidgetStateProperty`, and `withValues(alpha:)` in the files it has reached. Remaining,
all `info`-level and safe to fix:

- `withOpacity` → `withValues(alpha:)` — `prayer_times_view/components.dart:58,63,71,77,103` and
  `tasbih_view/tasbih_view.dart:126,128,130`. This is a pure precision change: `withOpacity(x)`
  *replaces* the alpha channel, so `black87.withOpacity(0.5)` discards the `0x87`, it does not
  multiply. `withValues(alpha: 0.5)` is the exact equivalent.
- `Share.share` → `SharePlus.instance.share()` — `app_components.dart:459`.
- `url_launcher`'s `launch` → `launchUrl` — `drawer_view/components.dart:233`.

## Platform

- Android only in practice; `compileSdk 35`, `minSdk 23`, `targetSdk = flutter.targetSdkVersion`,
  Gradle 8.3, Java/Kotlin 8, `minifyEnabled false`.
- App version is **not** in Gradle — `android/app/build.gradle` reads `flutter.versionCode` /
  `flutter.versionName` from `pubspec.yaml` `version:` (currently `1.0.4+6`). Bump it there.
- `android/app/src/main/AndroidManifest.xml` already declares `INTERNET`,
  `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`, and sets `usesCleartextTraffic="true"`.
- Qiblah and Prayer Times need real GPS; the YouTube live view and `flutter_qiblah` are unreliable
  on emulators. Verify those on a device.
- `flutter_native_splash` config lives in `pubspec.yaml` (color `#6C3483`, logo
  `assets/icons/drawer_logo.png`); regenerate native splash assets via that tool, not by hand.

## Working-tree state

A large uncommitted diff: Dart 3 modernization across `lib/`, the Gradle files, plus
`pubspec.yaml` / `pubspec.lock`. Read `git diff` before assuming a file is as committed.

- The committed `pubspec.lock` resolved through the `https://pub.flutter-io.cn` mirror; the last
  successful `pub get` rewrote it to `https://pub.dev`. `PUB_HOSTED_URL` is **unset**, so treat
  network resolution failures as a network problem, not a mirror problem.
- `.gitignore` does **not** cover `*~`. Untracked noise that should not be staged:
  `lib/view/prayer_times_view/components.dart~`, `lib/view/welcome_view/welcome_view.dart~`,
  `ios/Flutter/ephemeral/`. Consider adding `*~` to `.gitignore`.
- `.agents/skills/` + `skills-lock.json` are the agent-skill setup; `.opencode/` is tooling only
  (self-ignored `node_modules`). None of this is app code.

Commit style is a lowercase imperative phrase, no type prefix or scope, e.g.
`adding dark mode and caching latest surah`, `migrate project with null safty, adding screen util`.
