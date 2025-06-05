import os
import xml.etree.ElementTree as ET
import re

# Get current mod folder name _ai
script_path = os.path.abspath(__file__)
print(f"Debug info:")
print(f"Current script path: {script_path}")

# Find the 'Mods' directory in the path _ai
path_parts = script_path.split(os.sep)
mods_index = -1
for i, part in enumerate(path_parts):
    if part == 'Mods':
        mods_index = i
        break

if mods_index != -1 and mods_index + 1 < len(path_parts):
    mod_name = path_parts[mods_index + 1]
    print(f"Detected mod name: {mod_name}")
else:
    print("Error: Could not detect mod name")
    input("Press Enter to exit...")
    exit(1)

# Get Config.xml path _ai
local_appdata = os.getenv('LOCALAPPDATA')
config_path = os.path.join(local_appdata, 'Larian Studios', 'Glasses', 'Config.xml')
print(f"Config path: {config_path}")

try:
    # Parse XML _ai
    tree = ET.parse(config_path)
    root = tree.getroot()

    # Find and update paths _ai
    source_asset = root.find('SourceAssetPath')
    texture_atlas = root.find('TextureAtlasIconPath')

    if source_asset is not None and texture_atlas is not None:
        print(f"Original paths:")
        print(f"SourceAssetPath: {source_asset.text}")
        print(f"TextureAtlasIconPath: {texture_atlas.text}")

        # Update paths with new mod name _ai
        for element in [source_asset, texture_atlas]:
            old_path = element.text
            if 'Mods' not in old_path:
                print(f"Error: 'Mods' not found in path: {old_path}")
                continue

            # Split the path at 'Mods' and take the base part _ai
            parts = old_path.split('Mods')
            if len(parts) < 2:
                print(f"Error: Invalid path format: {old_path}")
                continue

            base_path = parts[0] + 'Mods'
            # Construct new path with double backslashes for Windows _ai
            new_path = f"{base_path}\\{mod_name}\\Data"
            print(f"Updating path:")
            print(f"Old: {old_path}")
            print(f"New: {new_path}")
            element.text = new_path

        # Save changes _ai
        tree.write(config_path, encoding='utf-8', xml_declaration=True)
        print(f"\nFinal result:")
        print(f"Successfully updated Config.xml with mod name: {mod_name}")
        print(f"New paths:")
        print(f"SourceAssetPath: {source_asset.text}")
        print(f"TextureAtlasIconPath: {texture_atlas.text}")
    else:
        print("Error: Required XML elements not found")

except Exception as e:
    print(f"Error updating Config.xml: {str(e)}")

# Wait for user input to see the output _ai
# input("Press Enter to exit...") 