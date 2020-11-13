#!/bin/sh

function patch()
{
    __file=$1
    __find=$2
    __to=$3

    perl -pi -0170 -e "@f = pack('H*','$__find'); @r = pack('H*','$__to'); s|@f|@r|g" "$__file"
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
        "0F44C14883C4085B5DC3B8920100004883C4085B5DC3B8930100004883C4085B5DC3B8940100004883C4085B5DC3B8950100004883C4085B5DC331C04883C4085B5DC3B8960100004883C4085B5DC3B8970100004883C4085B5DC3" \
        "9031C04883C4085B5DC390909031C04883C4085B5DC390909031C04883C4085B5DC390909031C04883C4085B5DC390909031C04883C4085B5DC331C04883C4085B5DC390909031C04883C4085B5DC390909031C04883C4085B5DC3"
}

function Lr()
{
    run \
        'Lr' \
        '/Applications/Adobe Lightroom Classic/Adobe Lightroom Classic.app/Contents/MacOS/Adobe Lightroom Classic' \
        "4989D44989F74989FE66418B5E0884DB0F84F700000080FB07" \
        "4989D44989F74989FE66418B5E08B3010F84F700000080FB07"
}

function Ai()
{
    run \
        'Ai' \
        '/Applications/Adobe Illustrator 2020/Adobe Illustrator.app/Contents/MacOS/Adobe Illustrator' \
        "0F44C1EB2CB892010000EB25B893010000EB1EB894010000EB17B895010000EB1031C0EB0CB896010000EB05B897010000" \
        "9031C0EB2C90909031C0EB2590909031C0EB1E90909031C0EB1790909031C0EB1031C0EB0C90909031C0EB0590909031C0"
}

function Id()
{
    run \
        'Id' \
        '/Applications/Adobe InDesign 2020/Adobe InDesign 2020.app/Contents/MacOS/PublicLib.dylib' \
        "410FB6470884C074083C07" \
        "410FB64708B00174083C07"
}

function Ic()
{
    run \
        'Ic' \
        '/Applications/Adobe InCopy 2020/Adobe InCopy 2020.app/Contents/MacOS/PublicLib.dylib' \
        "410FB6470884C074083C07" \
        "410FB64708B00174083C07"
}

function Au()
{
    run \
        'Au' \
        '/Applications/Adobe Audition 2020/Adobe Audition 2020.app/Contents/Frameworks/AuUI.framework/Versions/A/AuUI' \
        "FEFFFF0F94C020C8" \
        "FEFFFF0F94C0B001"
}

function Pr()
{
    run \
        'Pr' \
        '/Applications/Adobe Premiere Pro 2020/Adobe Premiere Pro 2020.app/Contents/Frameworks/Registration.framework/Versions/A/Registration' \
        "FEFFFF0F94C020C8" \
        "FEFFFF0F94C0B001"
}

function Pl()
{
    run \
        'Pl' \
        '/Applications/Adobe Prelude 2020/Adobe Prelude 2020.app/Contents/Frameworks/Registration.framework/Versions/A/Registration' \
        "FEFFFF0F94C020C8" \
        "FEFFFF0F94C0B001"
}

function Ch()
{
    run \
        'Ch' \
        '/Applications/Adobe Character Animator 2020/Adobe Character Animator 2020.app/Contents/MacOS/Character Animator' \
        "FEFFFF0F94C020C8" \
        "FEFFFF0F94C0B001"
}

function Ae()
{
    run \
        'Ae' \
        '/Applications/Adobe After Effects 2020/Adobe After Effects 2020.app/Contents/Frameworks/AfterFXLib.framework/Versions/A/AfterFXLib' \
        "FEFFFF0F94C020C8" \
        "FEFFFF0F94C0B001"
}

function Me()
{
    run \
        'Me' \
        '/Applications/Adobe Media Encoder 2020/Adobe Media Encoder 2020.app/Contents/MacOS/Adobe Media Encoder 2020' \
        "FEFFFF0F94C020C8" \
        "FEFFFF0F94C0B001"
}

function Br()
{
    run \
        'Br' \
        '/Applications/Adobe Bridge 2020/Adobe Bridge 2020.app/Contents/MacOS/Adobe Bridge 2020' \
        "0FB75F0884DB0F84EE00000080FB07" \
        "0FB75F08B3010F84EE00000080FB07"
}

function An()
{
    run \
        'An' \
        '/Applications/Adobe Animate 2020/Adobe Animate 2020.app/Contents/MacOS/Adobe Animate 2020' \
        "410FB75E0884DB0F84F000000080FB07" \
        "410FB75E08B3010F84F000000080FB07"
}

function Dw()
{
    run \
        'Dw' \
        '/Applications/Adobe Dreamweaver 2020/Adobe Dreamweaver 2020.app/Contents/MacOS/Dreamweaver' \
        "66418B5D0884DB740980FB07" \
        "66418B5D08B301740980FB07"
}

function Dn()
{
    run \
        'Dn' \
        '/Applications/Adobe Dimension/Adobe Dimension.app/Contents/Frameworks/euclid-core-plugin.pepper' \
        "66418B5E0884DB0F840F01000080FB07" \
        "66418B5E08B3010F840F01000080FB07"
}

function Acrobat()
{
    run \
        'Acrobat' \
        '/Applications/Adobe Acrobat DC/Adobe Acrobat.app/Contents/Frameworks/Acrobat.framework/Versions/A/Acrobat' \
        "66418B5E0884DB740980FB07" \
        "66418B5E08B301740980FB07"
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
