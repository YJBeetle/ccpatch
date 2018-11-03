#!/bin/bash
echo 'Patch PS CC 19'
PSCC19='/Applications/Adobe Photoshop CC 2019/Adobe Photoshop CC 2019.app/Contents/MacOS/Adobe Photoshop CC 2019'
if [ ! -f "$PSCC19.bak" ]; then
    sudo mv "$PSCC19" "$PSCC19.bak"
    sudo cp "$PSCC19.bak" "$PSCC19"
    echo "Backup file: $PSCC19.bak"
fi
sudo perl -pi -e 's|\x0F\xB6\x32\x48\x83\xFE\x20|\x90\x90\x90\x48\x83\xFE\x20|g' "$PSCC19"
sudo perl -pi -e 's|\x48\x39\xD0\x75\xE2|\x48\x39\xD0\x90\x90|g' "$PSCC19"
echo 'Patch complete'

echo 'Patch AI CC 19'
AICC19='/Applications/Adobe Illustrator CC 2019/Adobe Illustrator.app/Contents/MacOS/Adobe Illustrator'
if [ ! -f "$AICC19.bak" ]; then
    sudo mv "$AICC19" "$AICC19.bak"
    sudo cp "$AICC19.bak" "$AICC19"
    echo "Backup file: $AICC19.bak"
fi
sudo perl -pi -e 's|\x0F\xB6\x10\x48\x83\xFA\x20|\x90\x90\x90\x48\x83\xFA\x20|g' "$AICC19"
sudo perl -pi -e 's|\x48\x39\xC3\x75\xE1|\x48\x39\xC3\x90\x90|g' "$AICC19"
echo 'Patch complete'
