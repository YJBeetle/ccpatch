#!/bin/sh

function patch()
{
    __file=$1
    __find=$2
    __to=$3

    perl -pi -e "s|$__find|$__to|g" "$__file"
    crc32 "$__file" > "$__file.patched.crc32"
    echo "Patch succeeded."
}

function run()
{
    __tab=$1
    __file=$2
    __find=$3
    __to=$4

    if [ -f "$__file" ]; then
        echo "Found and patching $__tab ..."
        if [ ! -f "$__file.bak" ] || [ ! -f "$__file.patched.crc32" ] || [ $(cat "$__file.patched.crc32") != $(crc32 "$__file") ]; then
            cp "$__file" "$__file.bak"
            echo "Backup finished."
            patch "$__file" "$__find" "$__to"
        else
            echo "Already patched, skipped."
        fi
    fi
}

function Ps()
{
    run \
        'Ps' \
        '/Applications/Adobe Photoshop CC 2019/Adobe Photoshop CC 2019.app/Contents/MacOS/Adobe Photoshop CC 2019' \
        "\x66\x41\x8B\x5D\x08\x84\xDB\x74\x09\x80\xFB\x07" \
        "\x66\x41\x8B\x5D\x08\xB3\x01\x74\x09\x80\xFB\x07"
}

function Lr()
{
    run \
        'Lr' \
        '/Applications/Adobe Lightroom Classic/Adobe Lightroom Classic.app/Contents/MacOS/Adobe Lightroom Classic' \
        "\x49\x89\xD4\x49\x89\xF7\x49\x89\xFE\x66\x41\x8B\x5E\x08\x84\xDB\x0F\x84\xF7\x00\x00\x00\x80\xFB\x07" \
        "\x49\x89\xD4\x49\x89\xF7\x49\x89\xFE\x66\x41\x8B\x5E\x08\xB3\x01\x0F\x84\xF7\x00\x00\x00\x80\xFB\x07"
}

function Ai()
{
    run \
        'Ai' \
        '/Applications/Adobe Illustrator CC 2019/Adobe Illustrator.app/Contents/MacOS/Adobe Illustrator' \
        "\x66\x41\x8B\x5E\x08\x84\xDB\x74\x09\x80\xFB\x07" \
        "\x66\x41\x8B\x5E\x08\xB3\x01\x74\x09\x80\xFB\x07"
}

function Id()
{
    run \
        'Id' \
        '/Applications/Adobe InDesign CC 2019/Adobe InDesign CC 2019.app/Contents/MacOS/PublicLib.dylib' \
        "\x41\x0F\xB6\x47\x08\x84\xC0\x74\x08\x3C\x07" \
        "\x41\x0F\xB6\x47\x08\xB0\x01\x74\x08\x3C\x07"
}

function Ic()
{
    run \
        'Ic' \
        '/Applications/Adobe InCopy CC 2019/Adobe InCopy CC 2019.app/Contents/MacOS/PublicLib.dylib' \
        "\x41\x0F\xB6\x47\x08\x84\xC0\x74\x08\x3C\x07" \
        "\x41\x0F\xB6\x47\x08\xB0\x01\x74\x08\x3C\x07"
}

function Au()
{
    run \
        'Au' \
        '/Applications/Adobe Audition CC 2019/Adobe Audition CC 2019.app/Contents/Frameworks/AuUI.framework/Versions/A/AuUI' \
        "\x49\x89\xD7\x49\x89\xF6\x49\x89\xFD\x66\x41\x8B\x5D\x08\x84\xDB\x74\x09\x80\xFB\x07" \
        "\x49\x89\xD7\x49\x89\xF6\x49\x89\xFD\x66\x41\x8B\x5D\x08\xB3\x01\x74\x09\x80\xFB\x07"
}

function Pr()
{
    run \
        'Pr' \
        '/Applications/Adobe Premiere Pro CC 2019/Adobe Premiere Pro CC 2019.app/Contents/Frameworks/Registration.framework/Versions/A/Registration' \
        "\x49\x89\xD7\x49\x89\xF6\x49\x89\xFD\x66\x41\x8B\x5D\x08\x84\xDB\x74\x09\x80\xFB\x07" \
        "\x49\x89\xD7\x49\x89\xF6\x49\x89\xFD\x66\x41\x8B\x5D\x08\xB3\x01\x74\x09\x80\xFB\x07"
}

function Pl()
{
    run \
        'Pl' \
        '/Applications/Adobe Prelude CC 2019/Adobe Prelude CC 2019.app/Contents/Frameworks/Registration.framework/Versions/A/Registration' \
        "\x49\x89\xD7\x49\x89\xF6\x49\x89\xFD\x66\x41\x8B\x5D\x08\x84\xDB\x74\x09\x80\xFB\x07" \
        "\x49\x89\xD7\x49\x89\xF6\x49\x89\xFD\x66\x41\x8B\x5D\x08\xB3\x01\x74\x09\x80\xFB\x07"
}

function Ch()
{
    run \
        'Ch' \
        '/Applications/Adobe Character Animator CC 2019/Adobe Character Animator CC 2019.app/Contents/MacOS/Character Animator' \
        "\x49\x89\xD7\x49\x89\xF6\x49\x89\xFD\x66\x41\x8B\x5D\x08\x84\xDB\x74\x09\x80\xFB\x07" \
        "\x49\x89\xD7\x49\x89\xF6\x49\x89\xFD\x66\x41\x8B\x5D\x08\xB3\x01\x74\x09\x80\xFB\x07"
}

function Ae()
{
    run \
        'Ae' \
        '/Applications/Adobe After Effects CC 2019/Adobe After Effects CC 2019.app/Contents/Frameworks/AfterFXLib.framework/Versions/A/AfterFXLib' \
        "\x66\x41\x8B\x5D\x08\x84\xDB\x74\x09\x80\xFB\x07" \
        "\x66\x41\x8B\x5D\x08\xB3\x01\x74\x09\x80\xFB\x07"
}

function Me()
{
    run \
        'Me' \
        '/Applications/Adobe Media Encoder CC 2019/Adobe Media Encoder CC 2019.app/Contents/MacOS/Adobe Media Encoder CC 2019' \
        "\x66\x41\x8B\x5D\x08\x84\xDB\x74\x09\x80\xFB\x07" \
        "\x66\x41\x8B\x5D\x08\xB3\x01\x74\x09\x80\xFB\x07"
}

function Br()
{
    run \
        'Br' \
        '/Applications/Adobe Bridge CC 2019/Adobe Bridge CC 2019.app/Contents/MacOS/Adobe Bridge CC 2019' \
        "\x66\x41\x8B\x5E\x08\x84\xDB\x0F\x84\x0F\x01\x00\x00\x80\xFB\x07" \
        "\x66\x41\x8B\x5E\x08\xB3\x01\x0F\x84\x0F\x01\x00\x00\x80\xFB\x07"
}

function An()
{
    run \
        'An' \
        '/Applications/Adobe Animate CC 2019/Adobe Animate CC 2019.app/Contents/MacOS/Adobe Animate CC 2019' \
        "\x66\x89\xD8\x66\x25\xFF\x00\x0F\x84\x71\x01\x00\x00\x0F\xB7\xC0\x83\xF8\x07" \
        "\x66\x89\xD8\x90\x90\xB0\x01\x0F\x84\x71\x01\x00\x00\x0F\xB7\xC0\x83\xF8\x07"
}

function Dw()
{
    run \
        'Dw' \
        '/Applications/Adobe Dreamweaver CC 2019/Adobe Dreamweaver CC 2019.app/Contents/MacOS/Dreamweaver' \
        "\x66\x41\x8B\x5D\x08\x84\xDB\x74\x09\x80\xFB\x07" \
        "\x66\x41\x8B\x5D\x08\xB3\x01\x74\x09\x80\xFB\x07"
}

# function Dn()
# {
#     echo 'Patch DN CC 19'
#     DNCC19='/Applications/Adobe Dimension CC/Adobe Dimension CC.app/Contents/Frameworks/amtlib.framework/Versions/A/amtlib'
#     if [ ! -f "$DNCC19.bak" ]; then
#         sudo mv "$DNCC19" "$DNCC19.bak"
#         sudo cp "$DNCC19.bak" "$DNCC19"
#         echo "Backup file: $DNCC19.bak"
#     fi
#     sudo perl -pi -e 's|\x0F\xB6\x16\x48\x83\xFA\x20|\x90\x90\x90\x48\x83\xFA\x20|g' "$DNCC19"
#     sudo perl -pi -e 's|\x48\x39\xF0\x75\xE2|\x48\x39\xF0\x90\x90|g' "$DNCC19"
#     echo 'Patch complete'
# }

if [ $UID -ne 0 ]; then
    sudo $0 $@
    exit
fi

case $(echo "$1" | tr [a-z] [A-Z]) in
    "")
        echo "All."
        Ps
        Lr
        Ai
        Id
        Ic
        Au
        Pr
        Pl
        Ch
        Ae
        Me
        Br
        An
        Dw
        # Dn
        ;;
    "PS")
        Ps
        ;;
    "LR")
        Lr
        ;;
    "AI")
        Ai
        ;;
    "ID")
        Id
        ;;
    "IC")
        Ic
        ;;
    "AU")
        Au
        ;;
    "PR")
        Pr
        ;;
    "PL")
        Pl
        ;;
    "CH")
        Ch
        ;;
    "AE")
        Ae
        ;;
    "ME")
        Me
        ;;
    "BR")
        Br
        ;;
    "AN")
        An
        ;;
    "DW")
        Dw
        ;;
    # "DN")
    #     Dn
    #     ;;
    *)
        echo "Unknow."
        ;;
esac
