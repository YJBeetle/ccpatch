#!/bin/sh
sudo perl -pi -e 's|\x0F\xB6\x32\x48\x83\xFE\x20|\x90\x90\x90\x48\x83\xFE\x20|g' /Applications/Adobe\ Photoshop\ CC\ 2019/Adobe\ Photoshop\ CC\ 2019.app/Contents/MacOS/Adobe\ Photoshop\ CC\ 2019
sudo perl -pi -e 's|\x48\x39\xD0\x75\xE2|\x48\x39\xD0\x90\x90|g' /Applications/Adobe\ Photoshop\ CC\ 2019/Adobe\ Photoshop\ CC\ 2019.app/Contents/MacOS/Adobe\ Photoshop\ CC\ 2019

sudo perl -pi -e 's|\x0F\xB6\x10\x48\x83\xFA\x20|\x90\x90\x90\x48\x83\xFA\x20|g' /Applications/Adobe\ Illustrator\ CC\ 2019/Adobe\ Illustrator.app/Contents/MacOS/Adobe\ Illustrator
sudo perl -pi -e 's|\x48\x39\xC3\x75\xE1|\x48\x39\xC3\x90\x90|g' /Applications/Adobe\ Illustrator\ CC\ 2019/Adobe\ Illustrator.app/Contents/MacOS/Adobe\ Illustrator
