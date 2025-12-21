# OSM MTB Overlay

This project provides a script to create a transparent Garmin map overlay (.img format) of MTB trails from OpenStreetMap data. This is useful for displaying MTB trails on top of a base map in applications like QMapShack or on Garmin devices.

## Features

*   Extracts MTB-relevant ways (mtb:scale, route=mtb, highway=path/track) from an OSM file.
*   Creates a transparent overlay, so it can be used on top of other maps.
*   Uses a custom style and TYP file to render the MTB trails.
*   The script is configurable and the style can be easily customized.

## Prerequisites

*   [Osmium Tool](https://osmcode.org/osmium-tool/): A versatile command-line tool for working with OSM data.
*   [Mkgmap](https://www.mkgmap.org.uk/): A tool to convert OSM data into a Garmin map.

## Installation

1.  **Install Osmium Tool:**
    ```bash
    sudo apt install osmium-tool
    ```

2.  **Install Mkgmap:**
    Follow the instructions on the [Mkgmap website](https://www.mkgmap.org.uk/download/mkgmap.html) to download and install Mkgmap. Make sure the `mkgmap.jar` file is executable and its location is known. The script will look for `mkgmap.jar` in the project directory.

## Usage

1.  Download an OSM data file (e.g., from [Geofabrik](https://download.geofabrik.de/)).
2.  Run the `create_mtb_overlay.sh` script with the OSM file as an argument:

    ```bash
    ./create_mtb_overlay.sh your_map.osm.pbf
    ```

The script will generate a file named `your_map_mtbtrails.img` in the same directory.

### Example

To download a specific area from the OpenStreetMap API and create an overlay:

```bash
wget -O brandenburg.osm "http://api.openstreetmap.org/api/0.6/map?bbox=11.1,51.5,14.8,53.6"
./create_mtb_overlay.sh brandenburg.osm
```

## Style Customization

The appearance of the MTB trails on the map is defined in the `mtb_style` directory and the `mtb.txt` file.

*   `mtb_style/lines`: Defines the style of the lines (e.g., color, width).
*   `mtb.txt`: Defines the TYP file, which contains additional information about the map features.

You can modify these files to change the appearance of the map. After modifying the style, you need to re-run the script to apply the changes.

## License

This project is not licensed. Please feel free to use and modify it as you wish.

## Acknowledgments

This script relies on the following open-source tools:

*   [OpenStreetMap](https://www.openstreetmap.org/)
*   [Osmium Tool](https://osmcode.org/osmium-tool/)
*   [Mkgmap](https://www.mkgmap.org.uk/)