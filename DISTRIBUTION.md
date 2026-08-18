# ReadPlate distribution record

## What Fiji distribution requires

A normal opt-in Fiji distribution has two independent pieces:

1. **Installability:** a public ImageJ update site with a valid updater database (`db.xml.gz`) and timestamped payload files.
2. **Discovery:** an entry in ImageJ's canonical update-site registry, which populates Fiji's **Manage update sites** dialog.

A source repository, release tag, citation file, Maven project, or bundled ImageJ runtime is not required for an ImageJ macro to be installed by the updater. Source hosting and documentation are nevertheless important for provenance and long-term maintenance.

## Existing upstream records

The canonical registry already includes:

- Name/ID: `ReadPlate`
- URL: `https://sites.imagej.net/ReadPlate/`
- Maintainer: José María Delfino (`delfino@qb.ffyb.uba.ar`)
- Description: ReadPlate 3.0 and its supported plate formats and blank-correction behavior

The entry was added on 2020-09-03 in commit [`ee4e333`](https://github.com/imagej/list-of-update-sites/commit/ee4e333cb98d41d7b889ea2f0b394bacd6ada158) and merged through [`imagej/list-of-update-sites#54`](https://github.com/imagej/list-of-update-sites/pull/54), following the Image.sc release discussion.

Consequently, creating a second update site or a duplicate registry entry would be incorrect. Any future payload release should update the existing `ReadPlate` site using its authorized ImageJ WebDAV uploader account.

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

## Payload layout for a future update

For Fiji, the macro should be stored under `plugins/` with an `.ijm` extension and an underscore in the command filename, for example:

```text
plugins/ReadPlate_3.0.ijm
plugins/ReadPlate/index.html
plugins/ReadPlate/plate.jpg
```

The `.ijm` file can be a byte-for-byte copy of `ReadPlate3.0.txt`; only the distribution filename needs to change. The HTML and JPEG can likewise be copied unchanged. The legacy `imagej/ij.jar` must not be uploaded: Fiji already supplies ImageJ and the updater manages it as a core dependency.

The upload must be performed by Fiji's updater rather than by copying files directly, so that it creates synchronized timestamped payloads and `db.xml.gz` metadata.

## Upstream update procedure

An authorized ReadPlate uploader should use a clean, current Fiji installation:

1. Fully update Fiji and restart it.
2. Put the payload files in the paths shown above.
3. Open **Help › Update… › Manage update sites**.
4. Configure the existing site URL and `webdav:<upload-user>` host for `ReadPlate`.
5. In **Advanced Mode**, assign only those three local files to the ReadPlate site.
6. Add file descriptions, author, and project/documentation links in the Details panel.
7. Apply the upload, restart a separate clean Fiji, enable ReadPlate, install, and verify the menu command and installed resources.

Do not use `upload-complete-site` from an arbitrary Fiji installation: it synchronizes the complete local site state and can mark omitted site files obsolete.

## Verification record

The automated audit workflow at [`.github/workflows/audit-distribution.yml`](.github/workflows/audit-distribution.yml) checks the canonical registry, downloads and validates the hosted updater database and every current payload, and performs a clean Fiji updater installation. Audit results are summarized below once run.

<!-- AUDIT-RESULTS-START -->
Audit pending.
<!-- AUDIT-RESULTS-END -->
