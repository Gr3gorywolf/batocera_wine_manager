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
WINE_MANAGER_EXEC="/userdata/system/wine_manager/batocera_wine_manager"
echo "Initiallizing install"
# Create temporary folder if it doesn't exist
mkdir -p "$TEMP_FOLDER"
echo "Downloading.."
# Download Batocera Wine Manager zip
wget -P "$TEMP_FOLDER" "$BATOCERA_WINE_MANAGER_URL"
echo "Extracting.."
# Unzip Batocera Wine Manager to /userdata/system/wine_manager
rm -rf $WINE_MANAGER_FOLDER
unzip "$TEMP_FOLDER/batocera_wine_manager.zip" -d "$WINE_MANAGER_FOLDER"
echo "Installing..."
chmod +x $WINE_MANAGER_EXEC
# Copy scripts from extracted folder to /userdata/roms/ports and also the keys mapping
cp  "$WINE_MANAGER_FOLDER/batocera_wine_manager.sh" "$ROMS_PORTS_FOLDER/wine_manager.sh"
cp  "$WINE_MANAGER_FOLDER/enable_redist_install.sh" "$ROMS_PORTS_FOLDER/enable_redist_install.sh"
cp  "$WINE_MANAGER_FOLDER/disable_redist_install.sh" "$ROMS_PORTS_FOLDER/disable_redist_install.sh"
cp  "$WINE_MANAGER_FOLDER/data/flutter_assets/assets/data/pad2keys.json" "$ROMS_PORTS_FOLDER/wine_manager.sh.keys"
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

if ! grep -q '<name>Wine manager</name>' "$xml_file"; then
    # Insert the entry into the XML file
    awk -v entry="$xml_entry" '/<\/gameList>/ {print entry} 1' "$xml_file" > tmpfile && mv tmpfile "$xml_file"
    echo "Entry added successfully."
else
    echo "Entry already exists."
fi

# Create .desktop file
shortcut="$TEMP_FOLDER/batocera_wine_manager.desktop"
rm -rf $shortcut
echo "[Desktop Entry]" >> $shortcut
echo "Version=1.0" >> $shortcut
echo "Icon=/userdata/system/wine_manager/data/flutter_assets/assets/icons/app-icon.png" >> $shortcut
echo "Exec=$WINE_MANAGER_EXEC" >> $shortcut
echo "Terminal=false" >> $shortcut
echo "Type=Application" >> $shortcut
echo "Categories=Game;batocera.linux;" >> $shortcut
echo "Name=Batocera Wine Manager" >> $shortcut

# Move .desktop file to /usr/share/applications
mv "$TEMP_FOLDER/batocera_wine_manager.desktop" "$DESKTOP_FOLDER"

# Clean up temporary files
rm -rf "$TEMP_FOLDER"
echo "Done!"