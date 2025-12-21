#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ -z "$1" ]; then
    echo "Usage: $0 filename.osm.pbf"
    exit 1
fi

MKGMAP="java -jar $SCRIPT_DIR/mkgmap.jar"
INPUT_PBF="$1"
BASENAME=$(basename "$INPUT_PBF" .osm.pbf)
EXTRACT_PBF="temp_mtb_${BASENAME}.osm.pbf"

# 1. Filter
echo "--- Filtering MTB trails ---"
osmium tags-filter "$INPUT_PBF" \
    w/mtb:scale \
    w/route=mtb \
    w/highway=path \
    w/highway=track \
    -o "$EXTRACT_PBF" --overwrite

# 2. Compile TYP file (creates mtb.typ)
echo "--- Compiling TYP file ---"
$MKGMAP "$SCRIPT_DIR/mtb.txt"

# 3. Build IMG file with style AND TYP file
echo "--- Creating IMG file with style and TYP ---"
$MKGMAP --transparent \
    --draw-priority=110 \
    --family-id=9998 \
    --product-id=1 \
    --family-name="MTB-Overlay" \
    --style-file="$SCRIPT_DIR/mtb_style" \
    --gmapsupp "$EXTRACT_PBF" mtb.typ

# 4. Clean up
if [ -f "gmapsupp.img" ]; then
    mv gmapsupp.img "${BASENAME}_mtbtrails.img"
    rm osmmap.img 2>/dev/null
    find . -maxdepth 1 -type f -regex './[0-9]+\.img' -delete
    rm "$EXTRACT_PBF" osmmap.tdb mtb.typ 2>/dev/null
    echo "--- Success! MTB map created: ${BASENAME}_mtbtrails.img ---"
else
    echo "Error during creation."
fi
