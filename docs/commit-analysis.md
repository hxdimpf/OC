# OpenCaching Commit History Analysis

## Upstream (opencaching/opencaching-pl) — 2019–2026

The canonical opencaching codebase that runs opencaching.de, .pl, .nl, .us, .ro, .uk.

| Author | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 | TOTAL |
|--------|------|------|------|------|------|------|------|------|-------|
| kojoty (lead dev) | 370 | 28 | 199 | 1 | 10 | 0 | 0 | 0 | 608 |
| deg-pl | 21 | 71 | 17 | 34 | 0 | 45 | 0 | 1 | 189 |
| following5 | 158 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 158 |
| stefopl | 0 | 0 | 0 | 2 | 0 | 34 | 58 | 12 | 106 |
| harrieklomp | 85 | 5 | 0 | 0 | 0 | 0 | 0 | 0 | 90 |
| tripper1971 | 7 | 16 | 4 | 3 | 6 | 13 | 4 | 0 | 53 |
| jrmajor | 0 | 0 | 39 | 0 | 0 | 0 | 0 | 0 | 39 |
| rapotek | 0 | 2 | 5 | 6 | 2 | 0 | 15 | 0 | 30 |
| rborowski | 0 | 0 | 0 | 0 | 0 | 0 | 15 | 0 | 15 |
| andrixnet | 2 | 2 | 4 | 0 | 0 | 5 | 0 | 0 | 13 |
| others | 7 | 6 | 9 | 3 | 4 | 11 | 0 | 1 | 41 |
| ocpl-crowdin-robot (translations) | 545 | 86 | 203 | 20 | 13 | 55 | 32 | 2 | 956 |
| **TOTAL** | **1222** | **216** | **480** | **69** | **35** | **163** | **124** | **16** | **2325** |

**Code commits (excl. translation robot):**
| 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 | TOTAL |
|------|------|------|------|------|------|------|------|-------|
| 677 | 130 | 277 | 49 | 22 | 108 | 92 | 14 | 1369 |

### Key observations

1. **97.9% decline**: 677 code commits in 2019 → 14 in 2026 (annualized: ~28).
2. **Original lead dev (kojoty) gone**: 608 commits, nothing since 2023.
3. **One active dev in 2026**: `stefopl` with 12 commits.
4. **Translation robot out-committed every human** (956 vs max 608).
5. **18 contributors total**, but only 2 active in the last 12 months.
6. **More code committed to OC5 in 3 months than to upstream in 2 years**.

---

## OKAPI (inside opencaching/opencaching-pl, `okapi/` directory)

The REST API that powers all opencaching sites. Commits touching `okapi/` only.

| Author | 2019 | 2020 | 2021 | 2022 | 2024 | 2025 | TOTAL |
|--------|------|------|------|------|------|------|-------|
| ocpl-robot | 1 | 1 | 1 | 1 | 1 | 0 | 5 |
| kojoty | 1 | 1 | 1 | 0 | 0 | 0 | 3 |
| following | 1 | 0 | 0 | 0 | 0 | 0 | 1 |
| stefopl | 0 | 0 | 0 | 0 | 0 | 1 | 1 |
| **TOTAL** | **3** | **2** | **2** | **1** | **1** | **1** | **10** |

**10 commits in 7 years.** OKAPI is stable — it doesn't change. The last code change was a single commit in 2025. Zero commits in 2023 or 2026.

---

## OpencachingDeutschland/oc-server3 — 2019–2026

The German opencaching.de development fork. Split by target:

- **Legacy (htdocs/):** PHP files, Smarty templates, the 2005-era codebase
- **Symfony (htdocs_symfony/ + src/ + templates/):** The Symfony 7 "new UI" rewrite

### By year and target

| Year | Legacy (htdocs) | Symfony (new) | Other | TOTAL |
|------|----------------|---------------|-------|-------|
| 2019 | 653 | 149 | 62 | 864 |
| 2020 | 93 | 286 | 188 | 567 |
| 2021 | 27 | 333 | 11 | 371 |
| 2022 | 1389 | 748 | 13 | 2150 |
| 2023 | 69 | 113 | 13 | 195 |
| 2024 | 2 | 2 | 0 | 4 |
| 2025 | 4 | 0 | 6 | 10 |
| 2026 | 300 | 342 | 91 | 733 |

### Top authors

| Author | Legacy | Symfony | Other | TOTAL |
|--------|--------|---------|-------|-------|
| fraggle-DE | 224 | 1427 | 32 | 1683 |
| puttenchor | 1109 | 0 | 0 | 1109 |
| Nick Lubisch | 512 | 290 | 175 | 977 |
| teiling88 | 225 | 55 | 85 | 365 |
| MacGyver-NRW | 137 | 77 | 5 | 219 |
| Samuel Dennler | 106 | 54 | 9 | 169 |
| Thomas Eiling | 74 | 23 | 67 | 164 |
| sdennler | 117 | 4 | 9 | 130 |
| Slini11 | 11 | 40 | 4 | 55 |
| hxdimpf | 14 | 2 | 0 | 16 |

### Key observations

1. **Two distinct codebases**: Legacy peaked in 2022 (1389 file-touches), Symfony peaked same year (748).
2. **The Symfony rewrite is one developer**: `fraggle-DE` wrote 85% of the Symfony code (1427/1683 touches). Nobody else came close.
3. **2024 was dead**: 4 commits total. The project effectively stopped.
4. **2026 spike**: 733 touches — `teiling88` (345), `fraggle-DE` (337), `Samuel Dennler` (116). `hxdimpf` contributed 16 touches; the actual forward-looking work lives on the `hxdimpf/OC4` and `hxdimpf/oc5` forks, not upstream.
5. **The bus factor is 1**: `fraggle-DE` wrote 85% of the Symfony code. Without him, nobody knows it.

---

## hxdimpf forks (OC4 + OC5) — where the forward-looking work lives

Not on the upstream `oc-server3` repo. The real development is on the forks.

| Repo | Branch | Commits | Period |
|------|--------|---------|--------|
| `hxdimpf/oc5` | dev-hx | **205** | 2026-06 |
| `hxdimpf/OC4` | dev-hx | **26** | 2026-06 |
| **TOTAL** | | **231** | ~3 months |

For comparison:
- Upstream `opencaching/opencaching-pl`: **16 commits** in all of 2026
- OKAPI: **10 commits** in **7 years**
- `hxdimpf` upstream contributions to `oc-server3`: **16 touches** (the real work is on the forks)
