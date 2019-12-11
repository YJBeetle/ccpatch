#!/bin/sh

function revoke()
{
    __tab=$1
    __file=$2

    if [ -f "$__file" ]; then
        echo "Found and revoke $__tab ..."
        if [ -f "$__file.bak" ]; then
            rm "$__file"
            mv "$__file.bak" "$__file"
            rm "$__file.patched.crc32"
            echo "Revoke succeeded."
        else
            echo "The backup file does not exist, skipped."
        fi
    fi
}

function Ps()
{
    revoke \
        'Ps' \
        '/Applications/Adobe Photoshop 2020/Adobe Photoshop 2020.app/Contents/MacOS/Adobe Photoshop 2020'
}

function Lr()
{
    revoke \
        'Lr' \
        '/Applications/Adobe Lightroom Classic/Adobe Lightroom Classic.app/Contents/MacOS/Adobe Lightroom Classic'
}

function Ai()
{
    revoke \
        'Ai' \
        '/Applications/Adobe Illustrator 2020/Adobe Illustrator.app/Contents/MacOS/Adobe Illustrator'
}

function Id()
{
    revoke \
        'Id' \
        '/Applications/Adobe InDesign 2020/Adobe InDesign 2020.app/Contents/MacOS/PublicLib.dylib'
}

function Ic()
{
    revoke \
        'Ic' \
        '/Applications/Adobe InCopy 2020/Adobe InCopy 2020.app/Contents/MacOS/PublicLib.dylib'
}

function Au()
{
    revoke \
        'Au' \
        '/Applications/Adobe Audition 2020/Adobe Audition 2020.app/Contents/Frameworks/AuUI.framework/Versions/A/AuUI'
}

function Pr()
{
    revoke \
        'Pr' \
        '/Applications/Adobe Premiere Pro 2020/Adobe Premiere Pro 2020.app/Contents/Frameworks/Registration.framework/Versions/A/Registration'
}

function Pl()
{
    revoke \
        'Pl' \
        '/Applications/Adobe Prelude 2020/Adobe Prelude 2020.app/Contents/Frameworks/Registration.framework/Versions/A/Registration'
}

function Ch()
{
    revoke \
        'Ch' \
        '/Applications/Adobe Character Animator 2020/Adobe Character Animator 2020.app/Contents/MacOS/Character Animator'
}

function Ae()
{
    revoke \
        'Ae' \
        '/Applications/Adobe After Effects 2020/Adobe After Effects 2020.app/Contents/Frameworks/AfterFXLib.framework/Versions/A/AfterFXLib'
}

function Me()
{
    revoke \
        'Me' \
        '/Applications/Adobe Media Encoder 2020/Adobe Media Encoder 2020.app/Contents/MacOS/Adobe Media Encoder 2020'
}

function Br()
{
    revoke \
        'Br' \
        '/Applications/Adobe Bridge 2020/Adobe Bridge 2020.app/Contents/MacOS/Adobe Bridge 2020'
}

function An()
{
    revoke \
        'An' \
        '/Applications/Adobe Animate 2020/Adobe Animate 2020.app/Contents/MacOS/Adobe Animate 2020'
}

function Dw()
{
    revoke \
        'Dw' \
        '/Applications/Adobe Dreamweaver 2020/Adobe Dreamweaver 2020.app/Contents/MacOS/Dreamweaver'
}

function Dn()
{
    revoke \
        'Dn' \
        '/Applications/Adobe Dimension/Adobe Dimension.app/Contents/Frameworks/euclid-core-plugin.pepper'
}

function Acrobat()
{
    revoke \
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
