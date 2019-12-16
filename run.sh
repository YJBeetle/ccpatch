#!/bin/sh

function patch()
{
    __file=$1
    __find=$2
    __to=$3

    perl -pi -e "s|$__find|$__to|g" "$__file"
    if diff "$__file" "$__file.bak" 2>/dev/null 1>/dev/null; then
        echo "Patch faild."
    else
        crc32 "$__file" > "$__file.patched.crc32"
        echo "Patch succeeded."
    fi 
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
            mv "$__file" "$__file.bak"
            cp "$__file.bak" "$__file"
            echo "Backup succeeded."
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
        '/Applications/Adobe Photoshop 2020/Adobe Photoshop 2020.app/Contents/MacOS/Adobe Photoshop 2020' \
        "\x0F\xB7\x5F\x08\x84\xDB\x0F\x84\xEE\x00\x00\x00\x80\xFB\x07" \
        "\x0F\xB7\x5F\x08\xB3\x01\x0F\x84\xEE\x00\x00\x00\x80\xFB\x07"
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
        '/Applications/Adobe Illustrator 2020/Adobe Illustrator.app/Contents/MacOS/Adobe Illustrator' \
        "\x0F\xB7\x5F\x08\x84\xDB\x0F\x84\xC2\x00\x00\x00\x80\xFB\x07" \
        "\x0F\xB7\x5F\x08\xB3\x01\x0F\x84\xC2\x00\x00\x00\x80\xFB\x07"
}

function Id()
{
    run \
        'Id' \
        '/Applications/Adobe InDesign 2020/Adobe InDesign 2020.app/Contents/MacOS/PublicLib.dylib' \
        "\x41\x0F\xB6\x47\x08\x84\xC0\x74\x08\x3C\x07" \
        "\x41\x0F\xB6\x47\x08\xB0\x01\x74\x08\x3C\x07"
}

function Ic()
{
    run \
        'Ic' \
        '/Applications/Adobe InCopy 2020/Adobe InCopy 2020.app/Contents/MacOS/PublicLib.dylib' \
        "\x41\x0F\xB6\x47\x08\x84\xC0\x74\x08\x3C\x07" \
        "\x41\x0F\xB6\x47\x08\xB0\x01\x74\x08\x3C\x07"
}

function Au()
{
    run \
        'Au' \
        '/Applications/Adobe Audition 2020/Adobe Audition 2020.app/Contents/Frameworks/AuUI.framework/Versions/A/AuUI' \
        "\x48\x39\x95\x88\xFE\xFF\xFF\x0F\x94\xC1\x39\x85\x80\xFE\xFF\xFF\x0F\x94\xC0\x20\xC8" \
        "\x48\x39\x95\x88\xFE\xFF\xFF\x0F\x94\xC1\x39\x85\x80\xFE\xFF\xFF\x0F\x94\xC0\xB0\x01"
}

function Pr()
{
    run \
        'Pr' \
        '/Applications/Adobe Premiere Pro 2020/Adobe Premiere Pro 2020.app/Contents/Frameworks/Registration.framework/Versions/A/Registration' \
        "\x48\x39\x95\x88\xFE\xFF\xFF\x0F\x94\xC1\x39\x85\x80\xFE\xFF\xFF\x0F\x94\xC0\x20\xC8" \
        "\x48\x39\x95\x88\xFE\xFF\xFF\x0F\x94\xC1\x39\x85\x80\xFE\xFF\xFF\x0F\x94\xC0\xB0\x01"
}

function Pl()
{
    run \
        'Pl' \
        '/Applications/Adobe Prelude 2020/Adobe Prelude 2020.app/Contents/Frameworks/Registration.framework/Versions/A/Registration' \
        "\x48\x39\x95\x88\xFE\xFF\xFF\x0F\x94\xC1\x39\x85\x80\xFE\xFF\xFF\x0F\x94\xC0\x20\xC8" \
        "\x48\x39\x95\x88\xFE\xFF\xFF\x0F\x94\xC1\x39\x85\x80\xFE\xFF\xFF\x0F\x94\xC0\xB0\x01"
}

function Ch()
{
    run \
        'Ch' \
        '/Applications/Adobe Character Animator 2020/Adobe Character Animator 2020.app/Contents/MacOS/Character Animator' \
        "\x48\x39\x95\x88\xFE\xFF\xFF\x0F\x94\xC1\x39\x85\x80\xFE\xFF\xFF\x0F\x94\xC0\x20\xC8" \
        "\x48\x39\x95\x88\xFE\xFF\xFF\x0F\x94\xC1\x39\x85\x80\xFE\xFF\xFF\x0F\x94\xC0\xB0\x01"
}

function Ae()
{
    run \
        'Ae' \
        '/Applications/Adobe After Effects 2020/Adobe After Effects 2020.app/Contents/Frameworks/AfterFXLib.framework/Versions/A/AfterFXLib' \
        "\x48\x39\x95\x88\xFE\xFF\xFF\x0F\x94\xC1\x39\x85\x80\xFE\xFF\xFF\x0F\x94\xC0\x20\xC8" \
        "\x48\x39\x95\x88\xFE\xFF\xFF\x0F\x94\xC1\x39\x85\x80\xFE\xFF\xFF\x0F\x94\xC0\xB0\x01"
}

function Me()
{
    run \
        'Me' \
        '/Applications/Adobe Media Encoder 2020/Adobe Media Encoder 2020.app/Contents/MacOS/Adobe Media Encoder 2020' \
        "\x48\x39\x95\x88\xFE\xFF\xFF\x0F\x94\xC1\x39\x85\x80\xFE\xFF\xFF\x0F\x94\xC0\x20\xC8" \
        "\x48\x39\x95\x88\xFE\xFF\xFF\x0F\x94\xC1\x39\x85\x80\xFE\xFF\xFF\x0F\x94\xC0\xB0\x01"
}

function Br()
{
    run \
        'Br' \
        '/Applications/Adobe Bridge 2020/Adobe Bridge 2020.app/Contents/MacOS/Adobe Bridge 2020' \
        "\x0F\xB7\x5F\x08\x84\xDB\x0F\x84\xEE\x00\x00\x00\x80\xFB\x07" \
        "\x0F\xB7\x5F\x08\xB3\x01\x0F\x84\xEE\x00\x00\x00\x80\xFB\x07"
}

function An()
{
    run \
        'An' \
        '/Applications/Adobe Animate 2020/Adobe Animate 2020.app/Contents/MacOS/Adobe Animate 2020' \
        "\x41\x0F\xB7\x5E\x08\x84\xDB\x0F\x84\xF0\x00\x00\x00\x80\xFB\x07" \
        "\x41\x0F\xB7\x5E\x08\xB3\x01\x0F\x84\xF0\x00\x00\x00\x80\xFB\x07"
}

function Dw()
{
    run \
        'Dw' \
        '/Applications/Adobe Dreamweaver 2020/Adobe Dreamweaver 2020.app/Contents/MacOS/Dreamweaver' \
        "\x66\x41\x8B\x5D\x08\x84\xDB\x74\x09\x80\xFB\x07" \
        "\x66\x41\x8B\x5D\x08\xB3\x01\x74\x09\x80\xFB\x07"
}

function Dn()
{
    run \
        'Dn' \
        '/Applications/Adobe Dimension/Adobe Dimension.app/Contents/Frameworks/euclid-core-plugin.pepper' \
        "\x66\x41\x8B\x5E\x08\x84\xDB\x0F\x84\x0F\x01\x00\x00\x80\xFB\x07" \
        "\x66\x41\x8B\x5E\x08\xB3\x01\x0F\x84\x0F\x01\x00\x00\x80\xFB\x07"
}

function Acrobat()
{
    run \
        'Acrobat' \
        '/Applications/Adobe Acrobat DC/Adobe Acrobat.app/Contents/Frameworks/Acrobat.framework/Versions/A/Acrobat' \
        "\x66\x41\x8B\x5E\x08\x84\xDB\x74\x09\x80\xFB\x07" \
        "\x66\x41\x8B\x5E\x08\xB3\x01\x74\x09\x80\xFB\x07"
}

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
        Dn
        Acrobat
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
    "DN")
        Dn
        ;;
    "ACROBAT")
        Acrobat
        ;;
    *)
        echo "Unknow."
        ;;
esac
