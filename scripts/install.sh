#!/bin/bash

# Define URLs
BATOCERA_WINE_MANAGER_URL="https://github.com/Gr3gorywolf/batocera_wine_manager/releases/latest/download/batocera_wine_manager.zip"

# Define paths
TEMP_FOLDER="/userdata/system/temp"
WINE_MANAGER_FOLDER="/userdata/system/wine_manager"
ROMS_PORTS_FOLDER="/userdata/roms/ports"
IMAGE_FOLDER="$ROMS_PORTS_FOLDER/images"
DESKTOP_FOLDER="/usr/share/applications"
xml_file="/userdata/roms/ports/gamelist.xml"
echo "Initiallizing install"
# Create temporary folder if it doesn't exist
mkdir -p "$TEMP_FOLDER"
echo "Downloading.."
# Download Batocera Wine Manager zip
wget -P "$TEMP_FOLDER" "$BATOCERA_WINE_MANAGER_URL"
echo "Extracting.."
# Unzip Batocera Wine Manager to /userdata/system/wine_manager
if [ -f "$WINE_MANAGER_FOLDER" ]; then
    # Folder exists, so delete it
    rm -rf "$WINE_MANAGER_FOLDER"
fi
unzip "$TEMP_FOLDER/batocera_wine_manager.zip" -d "$WINE_MANAGER_FOLDER"
echo "Installing..."
# Copy scripts from extracted folder to /userdata/roms/ports
cp  "$WINE_MANAGER_FOLDER/batocera_wine_manager.sh" "$ROMS_PORTS_FOLDER/wine_manager.sh"
cp  "$WINE_MANAGER_FOLDER/enable_redist_install.sh" "$ROMS_PORTS_FOLDER/enable_redist_install.sh"
cp  "$WINE_MANAGER_FOLDER/disable_redist_install.sh" "$ROMS_PORTS_FOLDER/disable_redist_install.sh"
# Download image and put it in the specified location
mkdir -p "$IMAGE_FOLDER"
cp "$WINE_MANAGER_FOLDER/data/flutter_assets/assets/icons/app-icon.png" "$IMAGE_FOLDER/batocera_wine_manager.png"

# inserts the batocera wine shortcut to the corresponding path
if [ ! -f "$xml_file" ]; then
    echo '<?xml version="1.0"?>
<gameList>
</gameList>' > "$xml_file"
    echo "Created new XML file: $xml_file"
fi
if grep -q '<name>Wine manager</name>' "$xml_file"; then
    echo "Entry already exists."
else
    xml_entry='
	<game>
		<path>./wine_manager.sh</path>
		<name>Wine manager</name>
        <desc>Manage the batocera proton wine versions</desc>
		<rating>0</rating>
        <image>./images/batocera_wine_manager.png</image>
        <developer>gr3gorywolf</developer>
		<playcount>1</playcount>
		<lang>en</lang>
	</game>'

    sed -i '/<\/gameList>/i '"$xml_entry"'' "$xml_file"
    echo "Entry added successfully."
fi

# Create .desktop file
echo "[Desktop Entry]
Name=Batocera Wine Manager
Exec=/userdata/system/wine_manager/run.sh
Icon=/userdata/system/wine_manager/data/flutter_assets/assets/icons/app-icon.png
Type=Application
Categories=Utility;" > "$TEMP_FOLDER/batocera_wine_manager.desktop"

# Move .desktop file to /usr/share/applications
mv "$TEMP_FOLDER/batocera_wine_manager.desktop" "$DESKTOP_FOLDER"

# Clean up temporary files
rm -rf "$TEMP_FOLDER"
echo "Done!"