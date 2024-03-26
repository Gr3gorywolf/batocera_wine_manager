#!/bin/bash

# Define URLs
BATOCERA_WINE_MANAGER_URL="https://github.com/Gr3gorywolf/batocera_wine_manager/releases/latest/download/batocera_wine_manager.zip"

# Define paths
TEMP_FOLDER="/userdata/system/temp"
WINE_MANAGER_FOLDER="/userdata/system/wine_manager"
ROMS_PORTS_FOLDER="/userdata/roms/ports"
IMAGE_FOLDER="$ROMS_PORTS_FOLDER/images"
DESKTOP_FOLDER="/usr/share/applications"
echo "Initiallizing install"
# Create temporary folder if it doesn't exist
mkdir -p "$TEMP_FOLDER"
echo "Downloading.."
# Download Batocera Wine Manager zip
wget -P "$TEMP_FOLDER" "$BATOCERA_WINE_MANAGER_URL"
echo "Extracting.."
# Unzip Batocera Wine Manager to /userdata/system/wine_manager
unzip "$TEMP_FOLDER/batocera_wine_manager.zip" -d "$WINE_MANAGER_FOLDER"
echo "Installing..."
# Copy scripts from extracted folder to /userdata/roms/ports
cp  "$WINE_MANAGER_FOLDER/batocera_wine_manager.sh" "$ROMS_PORTS_FOLDER/batocera_wine_manager.sh"

# Download image and put it in the specified location
mkdir -p "$IMAGE_FOLDER"
cp "$WINE_MANAGER_FOLDER/data/flutter_assets/assets/icons/app-icon.png" "$IMAGE_FOLDER/batocera_wine_manager.png"

# Create .desktop file
echo "[Desktop Entry]
Name=Batocera Wine Manager
Exec=/userdata/system/wine_manager/run.sh
Icon=/userdata/system/wine_manager/data/flutter_assets/assets/icons/app-icon.png
Type=Application
Categories=Utility;" > "$TEMP_FOLDER/batocera_wine_manager.desktop"

# Move .desktop file to /usr/share/applications
sudo mv "$TEMP_FOLDER/batocera_wine_manager.desktop" "$DESKTOP_FOLDER"

# Clean up temporary files
rm -rf "$TEMP_FOLDER"
echo "Done!"