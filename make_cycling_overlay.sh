#!/bin/bash

# Prüfen, ob eine Datei übergeben wurde
if [ -z "$1" ]; then
    echo "Nutzung: $0 dateiname.osm.pbf"
    exit 1
fi

INPUT_PBF="$1"
# Extrahiert den Namen ohne Endung (z.B. "bayern" statt "bayern.osm.pbf")
BASENAME=$(basename "$INPUT_PBF" .osm.pbf)
EXTRACT_PBF="${BASENAME}_cycling_temp.osm.pbf"
OUTPUT_IMG="${BASENAME}.img"

echo "--- Starte Extraktion für: $INPUT_PBF ---"

# 1. Schritt: Filtern mit Osmium
# Wir filtern Wege (ways), die Radweg-Attribute haben
osmium tags-filter "$INPUT_PBF" \
    w/highway=cycleway \
    w/bicycle=yes,designated,permissive \
    w/cycleway=lane,opposite,opposite_lane,track,opposite_track \
    -o "$EXTRACT_PBF" --overwrite

if [ $? -ne 0 ]; then
    echo "Fehler beim Filtern mit Osmium."
    exit 1
fi

echo "--- Extraktion fertig. Starte mkgmap Konvertierung ---"

# 2. Schritt: Konvertierung in .img
# Wir nutzen --gmapsupp um eine einzelne, fertige Datei zu erhalten
java -jar ~/OSM/mkgmap.jar \
    --transparent \
    --draw-priority=100 \
    --family-id=9999 \
    --family-name="Rad-Overlay ${BASENAME}" \
    --description="Radwege für ${BASENAME}" \
    --gmapsupp \
    "$EXTRACT_PBF"

# 3. Schritt: Aufräumen und Umbenennen
# mkgmap erzeugt im gmapsupp-Modus eine gmapsupp.img
if [ -f "gmapsupp.img" ]; then
    mv gmapsupp.img "$OUTPUT_IMG"
    rm "$EXTRACT_PBF"
    # Entferne die Kacheldateien (63240001.img etc.) und die .tdb Datei
    rm [0-9]*.img 2>/dev/null
    rm osmmap.tdb 2>/dev/null
	rm osmmap.img
	rm ovm_[0-9]*.img 2>/dev/null
    echo "--- Fertig! Deine Karte ist: $OUTPUT_IMG ---"
else
    echo "Fehler: mkgmap hat keine Datei erzeugt."
    exit 1
fi