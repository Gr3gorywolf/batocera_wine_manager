#!/bin/bash
source_dir="/userdata/system/wine/exe"
backup_dir="/userdata/system/wine/exe.bak"

if [ -d "$source_dir" ]; then
    mv "$source_dir" "$backup_dir"
    echo "Folder '$source_dir' renamed to '$backup_dir'"
else
    echo "Folder '$source_dir' does not exist, no action taken."
fi
