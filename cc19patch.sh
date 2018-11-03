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

echo 'Patch PR CC 19'
PRCC19='/Applications/Adobe Premiere Pro CC 2019/Adobe Premiere Pro CC 2019.app/Contents/Frameworks/Registration.framework/Versions/A/Registration'
if [ ! -f "$PRCC19.bak" ]; then
    sudo mv "$PRCC19" "$PRCC19.bak"
    sudo cp "$PRCC19.bak" "$PRCC19"
    echo "Backup file: $PRCC19.bak"
fi
sudo perl -pi -e 's|\x0F\xB6\x32\x48\x83\xFE\x20\x77\x1B\x48\x0F\xA3\xF1\x73\x15\x48\xFF\xC2\x49\x89\x97\x88\x00\x00\x00\x48\x39\xD0\x75\xE2\x49\x89\x56\x08\xEB\x1C\x49\x89\x56\x08\x48\x39\xC2\x74\x13\x48\x8D\x4A\x01\x49\x89\x8F\x88\x00\x00\x00\x40\x8A\x32\x48\x89\xCA\xEB\x05\x31\xF6\x48\x89\xC1\x40\x0F\xBE\xF6\x83\xFE\x7D\x0F\x87\x55\x03|\x90\x90\x90\x48\x83\xFE\x20\x77\x1B\x48\x0F\xA3\xF1\x73\x15\x48\xFF\xC2\x49\x89\x97\x88\x00\x00\x00\x48\x39\xD0\x90\x90\x49\x89\x56\x08\xEB\x1C\x49\x89\x56\x08\x48\x39\xC2\x74\x13\x48\x8D\x4A\x01\x49\x89\x8F\x88\x00\x00\x00\x40\x8A\x32\x48\x89\xCA\xEB\x05\x31\xF6\x48\x89\xC1\x40\x0F\xBE\xF6\x83\xFE\x7D\x0F\x87\x55\x03|g' "$PRCC19"
echo 'Patch complete'

echo 'Patch AE CC 19'
AECC19='/Applications/Adobe After Effects CC 2019/Adobe After Effects CC 2019.app/Contents/Frameworks/AfterFXLib.framework/Versions/A/AfterFXLib'
if [ ! -f "$AECC19.bak" ]; then
    sudo mv "$AECC19" "$AECC19.bak"
    sudo cp "$AECC19.bak" "$AECC19"
    echo "Backup file: $AECC19.bak"
fi
sudo perl -pi -e 's|\x0F\xB6\x32\x48\x83\xFE\x20|\x90\x90\x90\x48\x83\xFE\x20|g' "$AECC19"
sudo perl -pi -e 's|\x48\x39\xD0\x75\xE2|\x48\x39\xD0\x90\x90|g' "$AECC19"
echo 'Patch complete'

echo 'Patch AU CC 19'
AUCC19='/Applications/Adobe Audition CC 2019/Adobe Audition CC 2019.app/Contents/Frameworks/AuUI.framework/Versions/A/AuUI'
if [ ! -f "$AUCC19.bak" ]; then
    sudo mv "$AUCC19" "$AUCC19.bak"
    sudo cp "$AUCC19.bak" "$AUCC19"
    echo "Backup file: $AUCC19.bak"
fi
sudo perl -pi -e 's|\x0F\xB6\x32\x48\x83\xFE\x20\x77\x1B\x48\x0F\xA3\xF1\x73\x15\x48\xFF\xC2\x49\x89\x97\x88\x00\x00\x00\x48\x39\xD0\x75\xE2\x49\x89\x56\x08\xEB\x1C\x49\x89\x56\x08\x48\x39\xC2\x74\x13\x48\x8D\x4A\x01\x49\x89\x8F\x88\x00\x00\x00\x40\x8A\x32\x48\x89\xCA\xEB\x05\x31\xF6\x48\x89\xC1\x40\x0F\xBE\xF6\x83\xFE\x7D\x0F\x87\x55\x03|\x90\x90\x90\x48\x83\xFE\x20\x77\x1B\x48\x0F\xA3\xF1\x73\x15\x48\xFF\xC2\x49\x89\x97\x88\x00\x00\x00\x48\x39\xD0\x90\x90\x49\x89\x56\x08\xEB\x1C\x49\x89\x56\x08\x48\x39\xC2\x74\x13\x48\x8D\x4A\x01\x49\x89\x8F\x88\x00\x00\x00\x40\x8A\x32\x48\x89\xCA\xEB\x05\x31\xF6\x48\x89\xC1\x40\x0F\xBE\xF6\x83\xFE\x7D\x0F\x87\x55\x03|g' "$AUCC19"
echo 'Patch complete'

echo 'Patch ME CC 19'
MECC19='/Applications/Adobe Media Encoder CC 2019/Adobe Media Encoder CC 2019.app/Contents/MacOS/Adobe Media Encoder CC 2019'
if [ ! -f "$MECC19.bak" ]; then
    sudo mv "$MECC19" "$MECC19.bak"
    sudo cp "$MECC19.bak" "$MECC19"
    echo "Backup file: $MECC19.bak"
fi
sudo perl -pi -e 's|\x0F\xB6\x32\x48\x83\xFE\x20|\x90\x90\x90\x48\x83\xFE\x20|g' "$MECC19"
sudo perl -pi -e 's|\x48\x39\xD0\x75\xE2|\x48\x39\xD0\x90\x90|g' "$MECC19"
echo 'Patch complete'

echo 'Patch LR CC 19'
LRCC19='/Applications/Adobe Lightroom Classic CC/Adobe Lightroom Classic CC.app/Contents/MacOS/Adobe Lightroom Classic'
if [ ! -f "$LRCC19.bak" ]; then
    sudo mv "$LRCC19" "$LRCC19.bak"
    sudo cp "$LRCC19.bak" "$LRCC19"
    echo "Backup file: $LRCC19.bak"
fi
sudo perl -pi -e 's|\x0F\xB6\x30\x48\x83\xFE\x20\x77\x1B|\x90\x90\x90\x48\x83\xFE\x20\x77\x1B|g' "$LRCC19"
sudo perl -pi -e 's|\x73\x15\x48\xFF\xC0\x48\x89\x83\x88\x00\x00\x00\x48\x39\xC1\x75\xE2|\x73\x15\x48\xFF\xC0\x48\x89\x83\x88\x00\x00\x00\x48\x39\xC1\x90\x90|g' "$LRCC19"
echo 'Patch complete'

echo 'Patch BR CC 19'
BRCC19='/Applications/Adobe Bridge CC 2019/Adobe Bridge CC 2019.app/Contents/MacOS/Adobe Bridge CC 2019'
if [ ! -f "$BRCC19.bak" ]; then
    sudo mv "$BRCC19" "$BRCC19.bak"
    sudo cp "$BRCC19.bak" "$BRCC19"
    echo "Backup file: $BRCC19.bak"
fi
sudo perl -pi -e 's|\x0F\xB6\x31\x48\x83\xFE\x20|\x90\x90\x90\x48\x83\xFE\x20|g' "$BRCC19"
sudo perl -pi -e 's|\x48\x39\xC8\x75\xE2|\x48\x39\xC8\x90\x90|g' "$BRCC19"
echo 'Patch complete'

echo 'Patch DW CC 19'
DWCC19='/Applications/Adobe Dreamweaver CC 2019/Adobe Dreamweaver CC 2019.app/Contents/MacOS/Dreamweaver'
if [ ! -f "$DWCC19.bak" ]; then
    sudo mv "$DWCC19" "$DWCC19.bak"
    sudo cp "$DWCC19.bak" "$DWCC19"
    echo "Backup file: $DWCC19.bak"
fi
sudo perl -pi -e 's|\x0F\xB6\x32\x48\x83\xFE\x20|\x90\x90\x90\x48\x83\xFE\x20|g' "$DWCC19"
sudo perl -pi -e 's|\x48\x39\xD0\x75\xE2|\x48\x39\xD0\x90\x90|g' "$DWCC19"
echo 'Patch complete'

echo 'Patch CH CC 19'
CHCC19='/Applications/Adobe Character Animator CC 2019/Adobe Character Animator CC 2019.app/Contents/MacOS/Character Animator'
if [ ! -f "$CHCC19.bak" ]; then
    sudo mv "$CHCC19" "$CHCC19.bak"
    sudo cp "$CHCC19.bak" "$CHCC19"
    echo "Backup file: $CHCC19.bak"
fi
sudo perl -pi -e 's|\x0F\xB6\x32\x48\x83\xFE\x20|\x90\x90\x90\x48\x83\xFE\x20|g' "$CHCC19"
sudo perl -pi -e 's|\x48\x39\xD0\x75\xE2|\x48\x39\xD0\x90\x90|g' "$CHCC19"
echo 'Patch complete'
