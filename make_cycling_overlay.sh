#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "Nutzung: $0 dateiname.osm.pbf"
    exit 1
fi

INPUT_PBF="$1"
BASENAME=$(basename "$INPUT_PBF" .osm.pbf)
EXTRACT_PBF="temp_mtb_${BASENAME}.osm.pbf"

# 1. Filtern: Wir nehmen alles mit MTB-Tags oder Mountainbike-Routen
echo "--- Filtere MTB-Trails ---"
osmium tags-filter "$INPUT_PBF" \
    w/mtb:scale \
    w/route=mtb \
    w/highway=path \
    w/highway=track \
    -o "$EXTRACT_PBF" --overwrite

# 2. Prüfen ob Style-Ordner existiert
if [ ! -d "/home/johannes/OSM/mtb_style" ]; then
    echo "Fehler: Ordner 'mtb_style/lines' mit Style-Datei nicht gefunden!"
    exit 1
fi

echo "--- Erstelle IMG Datei mit MTB-Styles ---"

# --style-file sagt mkgmap, dass es unsere Regeln nutzen soll
java -jar ~/OSM/mkgmap.jar --transparent \
    --draw-priority=110 \
    --family-id=9998 \
    --family-name="MTB-Overlay-${BASENAME}" \
    --style-file=/home/johannes/OSM/mtb_style\
    --gmapsupp "$EXTRACT_PBF"

if [ -f "gmapsupp.img" ]; then
    mv gmapsupp.img "${BASENAME}_mtb.img"
    rm "$EXTRACT_PBF" [0-9]*.img osmmap.tdb 2>/dev/null
    echo "--- Erfolg! MTB-Karte erstellt: ${BASENAME}_mtb.img ---"
else
    echo "Fehler beim Erstellen der IMG-Datei."
fi





