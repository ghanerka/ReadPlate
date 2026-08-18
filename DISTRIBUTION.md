# ReadPlate distribution record

## What Fiji distribution requires

A normal opt-in Fiji distribution has two independent pieces:

1. **Installability:** a public ImageJ update site with a valid updater database (`db.xml.gz`) and timestamped payload files.
2. **Discovery:** an entry in ImageJ's canonical update-site registry, which populates Fiji's **Manage update sites** dialog.

A source repository, release tag, citation file, Maven project, or bundled ImageJ runtime is not required for an ImageJ macro to be installed by the updater. Source hosting and documentation are nevertheless important for provenance and long-term maintenance.

## Existing upstream record and availability

The canonical registry already includes:

- Name/ID: `ReadPlate`
- Registered URL: `https://sites.imagej.net/ReadPlate/`
- Maintainer: José María Delfino (`delfino@qb.ffyb.uba.ar`)
- Description: ReadPlate 3.0 and its supported plate formats and blank-correction behavior

The entry was added on 2020-09-03 in commit [`ee4e333`](https://github.com/imagej/list-of-update-sites/commit/ee4e333cb98d41d7b889ea2f0b394bacd6ada158) and merged through [`imagej/list-of-update-sites#54`](https://github.com/imagej/list-of-update-sites/pull/54), following the Image.sc release discussion.

That proves **canonical discovery**, so creating a duplicate registry entry would be incorrect. It does not by itself prove installability. During the 2026-08-18 audit, direct HTTP and HTTPS requests to the registered host timed out, and independent server-side fetch services returned HTTP 522. Its `db.xml.gz` and payload could therefore not be verified or installed.

A replacement static update site is now live at <https://ghanerka.github.io/ReadPlate/>. [`imagej/list-of-update-sites#217`](https://github.com/imagej/list-of-update-sites/pull/217) updates the existing registry record to that URL; the PR is open and awaits upstream workflow approval/review.

## Release metadata recovered from the bundle

| Field | Value/source |
|---|---|
| Project | ReadPlate |
| Version | 3.0 (macro header and documentation) |
| Release date | 2020-08-15 (macro header and history) |
| Author/maintainer | José María Delfino |
| Contact | `delfino@qb.ffyb.uba.ar` |
| Minimum ImageJ | 1.43h (`requires("1.43h")`) |
| Tested runtime | ImageJ 1.53c; Java 8 |
| Input constraint | 24-bit RGB image |
| Literature DOI | `10.1002/bmb.21139` |
| License | Not declared in the supplied bundle |

## Published payload layout

The working update site installs:

```text
plugins/ReadPlate_3.0.ijm
plugins/ReadPlate/index.html
plugins/ReadPlate/plate.jpg
```

`ReadPlate_3.0.ijm` is a byte-for-byte copy of `ReadPlate3.0.txt`; only its distribution filename changes. The installed HTML and JPEG are also byte-for-byte copies. The legacy `imagej/ij.jar` is not uploaded: Fiji already supplies ImageJ as a core component.

The original HTML refers to a `ReadPlate3.0_files/` directory of figure assets that was not present in the supplied bundle. The HTML is distributed unchanged rather than fabricating or silently removing those references; the separately supplied `plate.jpg` sample is complete and preserved.

The site was built with ImageJ Updater 2.0.3 using [`tools/PrepareReadPlateSite.java`](tools/PrepareReadPlateSite.java) and [`tools/build-update-site.sh`](tools/build-update-site.sh). Explicit updater API indexing is necessary for the `.html` and `.jpg`, because the updater's generic `plugins/` scanner does not automatically select those extensions. The updater itself still computes checksums, generates timestamped payload names, and writes `db.xml.gz`; the files were not simply copied into an ad hoc index.

## Future update procedure

For the GitHub Pages site:

1. Update the source artifacts and release metadata on `main`.
2. Run `tools/build-update-site.sh https://ghanerka.github.io/ReadPlate/` with JDK 17 or newer.
3. Review the three payloads and generated `db.xml.gz` under the ignored `update-site/` directory.
4. Publish that complete generated directory on the `gh-pages` branch.
5. Test with a clean Fiji installation before announcing the release.

An authorized uploader can instead repopulate the original hosted `ReadPlate` site with Fiji's Advanced Updater and its `webdav:<upload-user>` credential. Do not use `upload-complete-site` from an arbitrary Fiji installation: it synchronizes a complete local site state and can mark omitted site files obsolete.

## Verification record — 2026-08-18

| Check | Verified state |
|---|---|
| Source hosting | Public at <https://github.com/ghanerka/ReadPlate> |
| Static update site | GitHub Pages reports `built`, HTTPS enforced; landing page, `db.xml.gz`, manifest, and all timestamped payloads return HTTP 200 |
| Updater database | Valid gzip/XML with exactly three current payload records, descriptions, author, links, sizes, updater checksums, and one shared publication timestamp |
| Updater protocol install | ImageJ Updater 2.0.3 clean harness reported all three files `NEW`, downloaded them, and installed them |
| Fiji install | A clean Fiji 2025-02-06 distribution using its bundled updater reported all three files `NEW` before update and `INSTALLED` afterward |
| File integrity | Installed SHA-256 values equal `release-manifest.json`: macro `cebc7a…`, HTML `dbe08e…`, sample JPEG `d32206…` |
| ImageJ menu discovery | ImageJ 1.53c registered `Plugins › ReadPlate 3.0` as `ij.plugin.Macro_Runner("ReadPlate_3.0.ijm")` |
| Canonical discovery | Existing ReadPlate registry record verified; URL-change PR [#217](https://github.com/imagej/list-of-update-sites/pull/217) is open, not merged |
| Original hosted site | Not verifiable from this environment because `sites.imagej.net` did not respond |

The reusable workflow definition is stored as [`tools/audit-distribution.workflow.yml.example`](tools/audit-distribution.workflow.yml.example). It is an example rather than an active workflow because the available publication credential had repository scope but not GitHub's separate `workflow` scope.
