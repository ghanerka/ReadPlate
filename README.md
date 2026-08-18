# ReadPlate 3.0

ReadPlate is an ImageJ macro by José María Delfino for measuring light intensity and calculating uncorrected, blank, and blank-corrected absorbance values from a color photograph of a multi-well plate. Version 3.0 supports 6-, 12-, 24-, 48-, and 96-well plates.

## Install with Fiji

ReadPlate is registered in ImageJ's canonical list of update sites as **ReadPlate**:

1. Start a current [Fiji](https://fiji.sc/) installation.
2. Choose **Help › Update…**.
3. Click **Manage update sites**.
4. Enable **ReadPlate**, click **Apply and Close**, and apply the offered changes.
5. Restart Fiji.

Update-site URL: <https://sites.imagej.net/ReadPlate/>

The updater belongs to ImageJ2/Fiji; the original ImageJ1 application by itself does not support update sites. For a manual ImageJ1 installation, open ImageJ and choose **Plugins › Install…**, then select `ReadPlate3.0.txt`.

## Requirements

- An RGB plate image (the macro exits for non-RGB images).
- ImageJ 1.43h or newer (`requires("1.43h")`).
- Version 3.0 was tested by its author with ImageJ 1.53c and Java 8.

Before running ReadPlate, use **Analyze › Set Measurements…** and enable:

- Area
- Standard deviation
- Min & max gray value
- Mean gray value
- Modal gray value
- Add to overlay
- Redirect to: None
- Decimal places: 3

See [`index.html`](index.html) for the original release documentation and [`plate.jpg`](plate.jpg) for the original sample plate image.

## Release bundle

The source release preserves the supplied 2020 artifacts byte-for-byte:

| File | Purpose |
|---|---|
| [`ReadPlate3.0.txt`](ReadPlate3.0.txt) | ImageJ macro source, version 3.0 |
| [`index.html`](index.html) | Original documentation |
| [`plate.jpg`](plate.jpg) | Original 96-well sample image |
| `imagej/ij.jar` | Local ImageJ 1.53c runtime; retained in the local bundle but intentionally excluded from source control and update-site payloads |

The bundled runtime is not needed when installing through Fiji. Checksums and provenance are recorded in [`release-manifest.json`](release-manifest.json).

## Version and citation

- Version: **3.0**
- Release date: **2020-08-15**
- Author: **José María Delfino**
- Relevant publication: Angelani *et al.* (2018), “A Metabolic Control Analysis Approach to Introduce the Study of Systems in Biochemistry: the Glycolytic Pathway in the Red Blood Cell,” <https://doi.org/10.1002/bmb.21139>

Machine-readable citation metadata is in [`CITATION.cff`](CITATION.cff).

## Licensing status

The supplied release bundle contains no software license declaration. See [`LICENSE.md`](LICENSE.md); no open-source license has been inferred or added.

## Distribution records

ImageJ's central update-site registry has contained a ReadPlate entry since 2020. The registry source is [`imagej/list-of-update-sites`](https://github.com/imagej/list-of-update-sites), and the addition was merged as [PR #54](https://github.com/imagej/list-of-update-sites/pull/54). See [`DISTRIBUTION.md`](DISTRIBUTION.md) for the verified release and installation state.
