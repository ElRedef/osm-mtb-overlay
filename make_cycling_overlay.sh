#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ -z "$1" ]; then
    echo "Nutzung: $0 dateiname.osm.pbf"
    exit 1
fi

MKGMAP="java -jar $SCRIPT_DIR/mkgmap.jar"
INPUT_PBF="$1"
BASENAME=$(basename "$INPUT_PBF" .osm.pbf)
EXTRACT_PBF="temp_mtb_${BASENAME}.osm.pbf"

# 1. Filtern
echo "--- Filtere MTB-Trails ---"
osmium tags-filter "$INPUT_PBF" \
    w/mtb:scale \
    w/route=mtb \
    w/highway=path \
    w/highway=track \
    -o "$EXTRACT_PBF" --overwrite

# 2. TYP-Datei kompilieren (erzeugt mtb.typ)
echo "--- Kompiliere TYP-Datei ---"
$MKGMAP "$SCRIPT_DIR/mtb.txt"

# 3. IMG Datei mit Style UND TYP-Datei bauen
echo "--- Erstelle IMG Datei mit Style und TYP ---"
$MKGMAP --transparent \
    --draw-priority=110 \
    --family-id=9998 \
    --product-id=1 \
    --family-name="MTB-Overlay" \
    --style-file="$SCRIPT_DIR/mtb_style" \
    --gmapsupp "$EXTRACT_PBF" mtb.typ

# 4. Aufräumen
if [ -f "gmapsupp.img" ]; then
    mv gmapsupp.img "${BASENAME}_mtbtrails.img"
    rm osmmap.img 2>/dev/null
    rm "$EXTRACT_PBF" [0-9]*.img osmmap.tdb mtb.typ 2>/dev/null
    echo "--- Erfolg! MTB-Karte erstellt: ${BASENAME}_mtbtrails.img ---"
else
    echo "Fehler beim Erstellen."
fi
