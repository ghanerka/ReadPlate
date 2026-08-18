#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
site_url="${1:-https://ghanerka.github.io/ReadPlate/}"
output="${2:-$root/update-site}"
cache="${XDG_CACHE_HOME:-$HOME/.cache}/readplate-imagej-updater-2.0.3"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

mkdir -p "$cache" "$work/staging/plugins/ReadPlate" "$work/classes"
rm -rf "$output"
mkdir -p "$output"

base="https://downloads.micron.ox.ac.uk/fiji_update/mirrors/sites-fiji/jars"

fetch() {
    local remote="$1" name="$2" expected="$3"
    local target="$cache/$name"
    if [[ ! -f "$target" ]] || \
       [[ "$(sha256sum "$target" | awk '{print $1}')" != "$expected" ]]; then
        curl --fail --location --retry 5 --retry-all-errors \
            "$base/$remote" -o "$target"
    fi
    echo "$expected  $target" | sha256sum --check --status
}

fetch "imagej-updater-2.0.3.jar-20251111201226" \
    "imagej-updater-2.0.3.jar" \
    "21bb17cfd4d45a941cec294d3739000a0ee12bc6859486367817fa23bd38ceb6"
fetch "scijava-common-2.100.1.jar-20260716221137" \
    "scijava-common-2.100.1.jar" \
    "af53bb31087dd46bfe15645c8b7cc69fe837795516816c60f5be78b9ff0ce6a3"
fetch "imagej-common-2.1.1.jar-20250122172943" \
    "imagej-common-2.1.1.jar" \
    "aa0292e424d960378525837f7c4f30ed8adc6528655eafb87c6f2a8a995cc426"
fetch "app-launcher-2.3.1.jar-20250613135551" \
    "app-launcher-2.3.1.jar" \
    "9bab5a5275da2070804ea72b8f5b965e1533b9a14b31c607683f8fb8d0ef0c68"
fetch "parsington-3.1.0.jar-20230710192037" \
    "parsington-3.1.0.jar" \
    "7943c91a1e62918ea47d0a08f6b5989a8b388e019216441002236528f769c72a"
fetch "jakarta.xml.bind-api-2.3.3.jar-20220912165414" \
    "jakarta.xml.bind-api-2.3.3.jar" \
    "c04539f472e9a6dd0c7685ea82d677282269ab8e7baca2e14500e381e0c6cec5"

cp -p "$root/ReadPlate3.0.txt" \
    "$work/staging/plugins/ReadPlate_3.0.ijm"
cp -p "$root/index.html" "$root/plate.jpg" \
    "$work/staging/plugins/ReadPlate/"

javac -proc:none -cp "$cache/*" -d "$work/classes" \
    "$root/tools/PrepareReadPlateSite.java"
java -cp "$work/classes:$cache/*" PrepareReadPlateSite \
    "$work/staging" "$output" "$site_url"

gzip --test "$output/db.xml.gz"
python3 - "$output" "$work/staging" <<'PY'
import gzip
import pathlib
import sys
import xml.etree.ElementTree as ET

output, staging = map(pathlib.Path, sys.argv[1:])
root = ET.fromstring(gzip.decompress((output / "db.xml.gz").read_bytes()))
expected = {
    "plugins/ReadPlate_3.0.ijm": "ReadPlate3.0.txt",
    "plugins/ReadPlate/index.html": "index.html",
    "plugins/ReadPlate/plate.jpg": "plate.jpg",
}
plugins = {node.attrib["filename"]: node for node in root.findall("plugin")}
assert set(plugins) == set(expected), (set(plugins), set(expected))
for logical, source_name in expected.items():
    version = plugins[logical].find("version")
    assert version is not None
    remote = output / f"{logical}-{version.attrib['timestamp']}"
    local = staging / logical
    assert remote.read_bytes() == local.read_bytes(), logical
    assert remote.stat().st_size == int(version.attrib["filesize"]), logical
    print(f"OK {logical} -> {remote.relative_to(output)}")
PY

printf 'Update site generated at %s for %s\n' "$output" "$site_url"
