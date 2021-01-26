#!/bin/sh

function run()
{
    __tab=$1
    __file=$2

    if [ -f "$__file" ] && [ -f "$__file.bak" ] || [ -f "$__file.patched.sha1" ]; then
        echo "Found and codesign $__tab ..."
        codesign --force --sign - "$__file"
        shasum -a1 "$__file" | awk '{printf $1}' > "$__file.patched.sha1"
    fi
}

function Ps()
{
    run \
        'Ps' \
        '/Applications/Adobe Photoshop 2021/Adobe Photoshop 2021.app/Contents/MacOS/Adobe Photoshop 2021'
}

function Lr()
{
    run \
        'Lr' \
        '/Applications/Adobe Lightroom Classic/Adobe Lightroom Classic.app/Contents/MacOS/Adobe Lightroom Classic'
}

function Ai()
{
    run \
        'Ai' \
        '/Applications/Adobe Illustrator 2021/Adobe Illustrator.app/Contents/MacOS/Adobe Illustrator'
}

function Id()
{
    run \
        'Id' \
        '/Applications/Adobe InDesign 2020/Adobe InDesign 2020.app/Contents/MacOS/PublicLib.dylib'
}

function Ic()
{
    run \
        'Ic' \
        '/Applications/Adobe InCopy 2020/Adobe InCopy 2020.app/Contents/MacOS/PublicLib.dylib'
}

function Au()
{
    run \
        'Au' \
        '/Applications/Adobe Audition 2020/Adobe Audition 2020.app/Contents/Frameworks/AuUI.framework/Versions/A/AuUI'
}

function Pr()
{
    run \
        'Pr' \
        '/Applications/Adobe Premiere Pro 2020/Adobe Premiere Pro 2020.app/Contents/Frameworks/Registration.framework/Versions/A/Registration'
}

function Pl()
{
    run \
        'Pl' \
        '/Applications/Adobe Prelude 2020/Adobe Prelude 2020.app/Contents/Frameworks/Registration.framework/Versions/A/Registration'
}

function Ch()
{
    run \
        'Ch' \
        '/Applications/Adobe Character Animator 2020/Adobe Character Animator 2020.app/Contents/MacOS/Character Animator'
}

function Ae()
{
    run \
        'Ae' \
        '/Applications/Adobe After Effects 2020/Adobe After Effects 2020.app/Contents/Frameworks/AfterFXLib.framework/Versions/A/AfterFXLib'
}

function Me()
{
    run \
        'Me' \
        '/Applications/Adobe Media Encoder 2020/Adobe Media Encoder 2020.app/Contents/MacOS/Adobe Media Encoder 2020'
}

function Br()
{
    run \
        'Br' \
        '/Applications/Adobe Bridge 2020/Adobe Bridge 2020.app/Contents/MacOS/Adobe Bridge 2020'
}

function An()
{
    run \
        'An' \
        '/Applications/Adobe Animate 2020/Adobe Animate 2020.app/Contents/MacOS/Adobe Animate 2020'
}

function Dw()
{
    run \
        'Dw' \
        '/Applications/Adobe Dreamweaver 2020/Adobe Dreamweaver 2020.app/Contents/MacOS/Dreamweaver'
}

function Dn()
{
    run \
        'Dn' \
        '/Applications/Adobe Dimension/Adobe Dimension.app/Contents/Frameworks/euclid-core-plugin.pepper'
}

function Acrobat()
{
    run \
        'Acrobat' \
        '/Applications/Adobe Acrobat DC/Adobe Acrobat.app/Contents/Frameworks/Acrobat.framework/Versions/A/Acrobat'
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
