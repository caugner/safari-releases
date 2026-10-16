# Safari Releases

This repository keeps a searchable history of WebKit source snapshots corresponding to stable Safari releases.

## Branches

- `main` contains this README, the Safari-to-WebKit mapping, a WebKit version-bump index, and the scripts that build and refresh them.
- `releases` is an orphan history containing one commit per stable Safari release, beginning with Safari 5. Each commit contains the filtered WebKit source snapshot and has an annotated `v<version>` tag. It does not contain this repository's README, mapping, or scripts. The upstream WebKit `README.md` remains part of each source snapshot.

Use `git switch releases` before running `git grep`, `git log -S`, or `git blame` against the snapshots.

## Release mapping

The canonical Safari release list is [`browsers/safari.json`](https://github.com/mdn/browser-compat-data/blob/main/browsers/safari.json) in MDN Browser Compat Data. This table includes stable released versions from Safari 5 onward. Beta, nightly, preview, planned, and other unreleased entries are excluded.

The mapping starts with stable Safari versions and release dates in MDN Browser Compat Data (BCD). For each Safari release, use a matching `releases/Apple/Safari-<version>-macOS-*` tag when one exists. Otherwise, an exact match is a WebKit tag whose `MAJOR_VERSION`, `MINOR_VERSION`, and `TINY_VERSION` values match the BCD engine version. A tag may have additional build components in its name and still be an exact engine-version match. If multiple patch tags match, prefer the earliest tag on the ancestor chain for that version line. If neither tag type exists, use the earliest available patch tag on the closest earlier version line and mark it `nearest`; the release commit message records that no exact tag was found.

Version-file changes help identify WebKit version lines and their release branches. The commit containing a version bump has the new version in its tree; its parent has the previous version. A bump marks the start of a version line, not Safari's ship date, so it is evidence for selecting a branch rather than a substitute snapshot when no release tag exists. Security and maintenance releases remain included because BCD lists them as stable Safari releases, even when they reuse the previous WebKit tag.

For Safari 18.4, the version-bump index contains an untagged commit, [`cfa22cf`](https://github.com/WebKit/WebKit/commit/cfa22cfacaafc3e083e7986c2af9b7b3b2ffa18d), that sets engine version `621.1.15` on 2025-02-25. The table uses the nearest tagged snapshot, `WebKit-7621.1.2`, whose tree has engine version `621.1.2`. The version bump is about a month before Safari 18.4 shipped, but the tagged snapshot is retained to follow the tagged-snapshot rule; using the untagged bump commit would be a deliberate exception.

[`data/version-bumps.tsv`](data/version-bumps.tsv) indexes commits reachable from the WebKit checkout's local refs that change the main WebKit version configuration lines, including their historic JavaScriptCore and WebCore copies. Regenerate it after fetching new WebKit refs with:

```sh
WEBKIT_REPO=../webkit python3 ./scripts/index-webkit-version-bumps.py > data/version-bumps.tsv
```

| Safari release tag | Release date | BCD engine | WebKit tag | Match |
|---|---|---|---|---|
| [v5](https://github.com/caugner/safari-releases/tree/v5) | 2010-06-07 | 533.16 | [Safari-533.16](https://github.com/WebKit/WebKit/tree/Safari-533.16) | exact |
| [v5.1](https://github.com/caugner/safari-releases/tree/v5.1) | 2011-07-20 | 534.48 | [Safari-534.48](https://github.com/WebKit/WebKit/tree/Safari-534.48) | exact |
| [v6](https://github.com/caugner/safari-releases/tree/v6) | 2012-07-25 | 536.25 | [Safari-536.25](https://github.com/WebKit/WebKit/tree/Safari-536.25) | exact |
| [v7](https://github.com/caugner/safari-releases/tree/v7) | 2013-10-22 | 537.71 | [Safari-537.71](https://github.com/WebKit/WebKit/tree/Safari-537.71) | exact |
| [v8](https://github.com/caugner/safari-releases/tree/v8) | 2014-10-16 | 538.35 | [releases/Apple/Safari-8-macOS-10.10](https://github.com/WebKit/WebKit/tree/releases/Apple/Safari-8-macOS-10.10) | exact |
| [v9](https://github.com/caugner/safari-releases/tree/v9) | 2015-09-30 | 601.1.56 | [Safari-601.1.56](https://github.com/WebKit/WebKit/tree/Safari-601.1.56) | exact |
| [v9.1](https://github.com/caugner/safari-releases/tree/v9.1) | 2016-03-21 | 601.5.17 | [Safari-601.5.17](https://github.com/WebKit/WebKit/tree/Safari-601.5.17) | exact |
| [v10](https://github.com/caugner/safari-releases/tree/v10) | 2016-09-20 | 602.1.50 | [Safari-602.1.50](https://github.com/WebKit/WebKit/tree/Safari-602.1.50) | exact |
| [v10.1](https://github.com/caugner/safari-releases/tree/v10.1) | 2017-03-27 | 603.2.1 | [Safari-603.2.1](https://github.com/WebKit/WebKit/tree/Safari-603.2.1) | exact |
| [v11](https://github.com/caugner/safari-releases/tree/v11) | 2017-09-19 | 604.2.4 | [Safari-604.2.4](https://github.com/WebKit/WebKit/tree/Safari-604.2.4) | exact |
| [v11.1](https://github.com/caugner/safari-releases/tree/v11.1) | 2018-04-12 | 605.1.33 | [releases/Apple/Safari-11.1-macOS-10.13.4](https://github.com/WebKit/WebKit/tree/releases/Apple/Safari-11.1-macOS-10.13.4) | exact |
| [v12](https://github.com/caugner/safari-releases/tree/v12) | 2018-09-17 | 606.1.36 | [Safari-606.1.36](https://github.com/WebKit/WebKit/tree/Safari-606.1.36) | exact |
| [v12.1](https://github.com/caugner/safari-releases/tree/v12.1) | 2019-03-25 | 607.1.40 | [releases/Apple/Safari-12.1-macOS-10.14.4](https://github.com/WebKit/WebKit/tree/releases/Apple/Safari-12.1-macOS-10.14.4) | exact |
| [v13](https://github.com/caugner/safari-releases/tree/v13) | 2019-09-19 | 608.2.11 | [Safari-608.2.11](https://github.com/WebKit/WebKit/tree/Safari-608.2.11) | exact |
| [v13.1](https://github.com/caugner/safari-releases/tree/v13.1) | 2020-03-24 | 609.1.20 | [Safari-609.1.20](https://github.com/WebKit/WebKit/tree/Safari-609.1.20) | exact |
| [v14](https://github.com/caugner/safari-releases/tree/v14) | 2020-09-16 | 610.1.28 | [Safari-610.1.28](https://github.com/WebKit/WebKit/tree/Safari-610.1.28) | exact |
| [v14.1](https://github.com/caugner/safari-releases/tree/v14.1) | 2021-04-26 | 611.1.21 | [Safari-611.1.21](https://github.com/WebKit/WebKit/tree/Safari-611.1.21) | exact |
| [v15](https://github.com/caugner/safari-releases/tree/v15) | 2021-09-20 | 612.1.27 | [Safari-612.1.27](https://github.com/WebKit/WebKit/tree/Safari-612.1.27) | exact |
| [v15.1](https://github.com/caugner/safari-releases/tree/v15.1) | 2021-10-25 | 612.2.9 | [Safari-612.2.9](https://github.com/WebKit/WebKit/tree/Safari-612.2.9) | exact |
| [v15.2](https://github.com/caugner/safari-releases/tree/v15.2) | 2021-12-13 | 612.3.6 | [Safari-612.3.6](https://github.com/WebKit/WebKit/tree/Safari-612.3.6) | exact |
| [v15.3](https://github.com/caugner/safari-releases/tree/v15.3) | 2022-01-26 | 612.4.9 | [Safari-612.4.9](https://github.com/WebKit/WebKit/tree/Safari-612.4.9) | exact |
| [v15.4](https://github.com/caugner/safari-releases/tree/v15.4) | 2022-03-14 | 613.1.17 | [Safari-613.1.17](https://github.com/WebKit/WebKit/tree/Safari-613.1.17) | exact |
| [v15.5](https://github.com/caugner/safari-releases/tree/v15.5) | 2022-05-16 | 613.2.7 | [WebKit-7613.2.7](https://github.com/WebKit/WebKit/tree/WebKit-7613.2.7) | exact |
| [v15.6](https://github.com/caugner/safari-releases/tree/v15.6) | 2022-07-20 | 613.3.9 | [WebKit-7613.3.9](https://github.com/WebKit/WebKit/tree/WebKit-7613.3.9) | exact |
| [v16](https://github.com/caugner/safari-releases/tree/v16) | 2022-09-12 | 614.1.25 | [WebKit-7614.1.25](https://github.com/WebKit/WebKit/tree/WebKit-7614.1.25) | exact |
| [v16.1](https://github.com/caugner/safari-releases/tree/v16.1) | 2022-10-24 | 614.2.9 | [WebKit-7614.2.9](https://github.com/WebKit/WebKit/tree/WebKit-7614.2.9) | exact |
| [v16.2](https://github.com/caugner/safari-releases/tree/v16.2) | 2022-12-13 | 614.3.7 | [WebKit-7614.3.7](https://github.com/WebKit/WebKit/tree/WebKit-7614.3.7) | exact |
| [v16.3](https://github.com/caugner/safari-releases/tree/v16.3) | 2023-01-23 | 614.4.6 | [WebKit-7614.4.6](https://github.com/WebKit/WebKit/tree/WebKit-7614.4.6) | exact |
| [v16.4](https://github.com/caugner/safari-releases/tree/v16.4) | 2023-03-27 | 615.1.26 | [WebKit-7615.1.26](https://github.com/WebKit/WebKit/tree/WebKit-7615.1.26) | exact |
| [v16.5](https://github.com/caugner/safari-releases/tree/v16.5) | 2023-05-18 | 615.2.9 | [WebKit-7615.2.9](https://github.com/WebKit/WebKit/tree/WebKit-7615.2.9) | exact |
| [v16.6](https://github.com/caugner/safari-releases/tree/v16.6) | 2023-07-24 | 615.3.12 | [WebKit-7615.3.12](https://github.com/WebKit/WebKit/tree/WebKit-7615.3.12) | exact |
| [v17](https://github.com/caugner/safari-releases/tree/v17) | 2023-09-18 | 616.1.27 | [WebKit-7616.1.27](https://github.com/WebKit/WebKit/tree/WebKit-7616.1.27) | exact |
| [v17.1](https://github.com/caugner/safari-releases/tree/v17.1) | 2023-10-25 | 616.2.9 | [WebKit-7616.2.9](https://github.com/WebKit/WebKit/tree/WebKit-7616.2.9) | exact |
| [v17.2](https://github.com/caugner/safari-releases/tree/v17.2) | 2023-12-11 | 617.1.17 | [WebKit-7617.1.17](https://github.com/WebKit/WebKit/tree/WebKit-7617.1.17) | exact |
| [v17.3](https://github.com/caugner/safari-releases/tree/v17.3) | 2024-01-22 | 617.2.4 | [releases/Apple/Safari-17.3-macOS-14.3](https://github.com/WebKit/WebKit/tree/releases/Apple/Safari-17.3-macOS-14.3) | exact |
| [v17.4](https://github.com/caugner/safari-releases/tree/v17.4) | 2024-03-05 | 618.1.15 | [releases/Apple/Safari-17.4-macOS-14.4](https://github.com/WebKit/WebKit/tree/releases/Apple/Safari-17.4-macOS-14.4) | exact |
| [v17.5](https://github.com/caugner/safari-releases/tree/v17.5) | 2024-05-13 | 618.2.12 | [releases/Apple/Safari-17.5-macOS-14.5](https://github.com/WebKit/WebKit/tree/releases/Apple/Safari-17.5-macOS-14.5) | exact |
| [v17.6](https://github.com/caugner/safari-releases/tree/v17.6) | 2024-07-29 | 618.3.11 | [WebKit-7618.3.11](https://github.com/WebKit/WebKit/tree/WebKit-7618.3.11) | exact |
| [v18](https://github.com/caugner/safari-releases/tree/v18) | 2024-09-16 | 619.1.26 | [releases/Apple/Safari-18-macOS-15.0](https://github.com/WebKit/WebKit/tree/releases/Apple/Safari-18-macOS-15.0) | exact |
| [v18.1](https://github.com/caugner/safari-releases/tree/v18.1) | 2024-10-28 | 619.2.8 | [WebKit-7619.2.8](https://github.com/WebKit/WebKit/tree/WebKit-7619.2.8) | exact |
| [v18.2](https://github.com/caugner/safari-releases/tree/v18.2) | 2024-12-11 | 620.1.16 | [releases/Apple/Safari-18.2-macOS-15.2](https://github.com/WebKit/WebKit/tree/releases/Apple/Safari-18.2-macOS-15.2) | exact |
| [v18.3](https://github.com/caugner/safari-releases/tree/v18.3) | 2025-01-27 | 620.2.4 | [releases/Apple/Safari-18.3-macOS-15.3](https://github.com/WebKit/WebKit/tree/releases/Apple/Safari-18.3-macOS-15.3) | exact |
| [v18.4](https://github.com/caugner/safari-releases/tree/v18.4) | 2025-03-31 | 621.1.15 | [WebKit-7621.1.2](https://github.com/WebKit/WebKit/tree/WebKit-7621.1.2) | nearest, no exact tag |
| [v18.5](https://github.com/caugner/safari-releases/tree/v18.5) | 2025-05-12 | 621.2.5 | [WebKit-7621.2.5.14.1](https://github.com/WebKit/WebKit/tree/WebKit-7621.2.5.14.1) | exact |
| [v18.6](https://github.com/caugner/safari-releases/tree/v18.6) | 2025-07-29 | 621.3.11 | [WebKit-7621.2.5.14.1](https://github.com/WebKit/WebKit/tree/WebKit-7621.2.5.14.1) | nearest, no exact tag |
| [v26](https://github.com/caugner/safari-releases/tree/v26) | 2025-09-15 | 622.1.22 | [WebKit-7622.1.22.10.1](https://github.com/WebKit/WebKit/tree/WebKit-7622.1.22.10.1) | exact |
| [v26.1](https://github.com/caugner/safari-releases/tree/v26.1) | 2025-11-03 | 622.2.11 | [WebKit-7622.2.11](https://github.com/WebKit/WebKit/tree/WebKit-7622.2.11) | exact |
| [v26.2](https://github.com/caugner/safari-releases/tree/v26.2) | 2025-12-12 | 623.1.14 | [WebKit-7623.1.14.14.1](https://github.com/WebKit/WebKit/tree/WebKit-7623.1.14.14.1) | exact |
| [v26.3](https://github.com/caugner/safari-releases/tree/v26.3) | 2026-02-11 | 623.2.7 | [WebKit-7623.1.14.14.1](https://github.com/WebKit/WebKit/tree/WebKit-7623.1.14.14.1) | nearest, no exact tag |
| [v26.4](https://github.com/caugner/safari-releases/tree/v26.4) | 2026-03-24 | 624.1.16 | [WebKit-7624.1.16](https://github.com/WebKit/WebKit/tree/WebKit-7624.1.16) | exact |
| [v26.5](https://github.com/caugner/safari-releases/tree/v26.5) | 2026-05-11 | 624.2.5 | [WebKit-7624.2.5.18.1](https://github.com/WebKit/WebKit/tree/WebKit-7624.2.5.18.1) | exact |
| [v26.6](https://github.com/caugner/safari-releases/tree/v26.6) | 2026-07-27 | 624.4.5 | [WebKit-7624.4.5](https://github.com/WebKit/WebKit/tree/WebKit-7624.4.5) | exact |
| [v27](https://github.com/caugner/safari-releases/tree/v27) | 2026-09-14 | 625.1.29 | [WebKit-7625.1.29](https://github.com/WebKit/WebKit/tree/WebKit-7625.1.29) | exact |

For Safari 18.5, several patch tags have the exact BCD engine version. The table selects the earliest tag on the selected ancestor chain, `WebKit-7621.2.5.14.1`. The same rule selects `WebKit-7622.1.22.10.1` for Safari 26, `WebKit-7623.1.14.14.1` for Safari 26.2, and `WebKit-7624.2.5.18.1` for Safari 26.5. Safari 18.6 and 26.3 have no exact matching tag and reuse the earliest available tag from their closest earlier version line.

## Release commit messages

Release commit subjects use the sibling Chromium releases format, `release: Safari <version> (<tag>)`. Each commit is tagged `v<version>`. Each body includes the match status, Safari release date, and a WebKit tag link. A release links to a comparison with the preceding mapped WebKit tag when the tags differ. Safari 5 starts the history and has no comparison link. Repeated tags have no comparison link because the comparison would be empty. For a nearest match, the body explicitly says no exact tag was found. For example:

```text
release: Safari 18.4 (WebKit-7621.1.2)

Tag match: nearest, no exact WebKit tag found for Safari 18.4 (BCD engine 621.1.15).
Safari release date: 2025-03-31
Tag: https://github.com/WebKit/WebKit/tree/WebKit-7621.1.2
Compare: https://github.com/WebKit/WebKit/compare/releases/Apple/Safari-18.3-macOS-15.3...WebKit-7621.1.2
```

## Snapshot exclusions

Release snapshots use the same exclusion categories as the sibling Chromium releases history: binary and packaged file extensions, test data directories, `huge_trace.json`, and `WPT_BASE_MANIFEST*.json`. The exclusions are defined in [`scripts/build-releases.sh`](scripts/build-releases.sh).

## Building the release history

Start from a clean named branch containing the committed README, mapping, and scripts, with the WebKit tags listed above available in a local WebKit checkout. By default the script looks for `../webkit`. Set `WEBKIT_REPO` to use another path. The script returns to the branch it started from.

```sh
WEBKIT_REPO=../webkit ./scripts/build-releases.sh
```

On the first run, the script creates an orphan `releases` branch. On later runs, it appends only new releases to the existing branch, preserving its history. It refuses to run if the source worktree is dirty, existing release tags are missing from the history or out of order, or a mapped WebKit tag is missing or points to a different commit.

Each release commit's author and committer dates use the BCD release date at 12:00 UTC. The release date is also written in the commit message body. If two releases map to the same WebKit tag, the later release still gets a dated empty commit and `v<version>` tag.
