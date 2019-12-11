
function revoke($__tab, $__file)
{
    if ( Test-Path "$__file" -PathType Leaf )
    {
        echo "Found and revoke $__tab ..."
        if ( Test-Path "$__file.bak" -PathType Leaf )
        {
            rm "$__file"
            mv "$__file.bak" "$__file"
            rm "$__file.patched.crc32"
            echo "Revoke succeeded."
        }
        else
        {
            echo "The backup file does not exist, skipped."
        }
    }
}

function _Ps()
{
    revoke `
        'Ps' `
        "C:\Program Files\Adobe\Adobe Photoshop 2020\Photoshop.exe"
}

function _Lr()
{
    revoke `
        'Lr' `
        "C:\Program Files\Adobe\Adobe Lightroom Classic\Lightroom.exe"
}

function _Ai()
{
    revoke `
        'Ai' `
        'C:\Program Files\Adobe\Adobe Illustrator 2020\Support Files\Contents\Windows\Illustrator.exe'
}

function _Id()
{
    revoke `
        'Id' `
        'C:\Program Files\Adobe\Adobe InDesign 2020\Public.dll'
}

function _Ic()
{
    revoke `
        'Ic' `
        'C:\Program Files\Adobe\Adobe InCopy 2020\Public.dll'
}

function _Au()
{
    revoke `
        'Au' `
        'C:\Program Files\Adobe\Adobe Audition 2020\AuUI.dll'
}

function _Pr()
{
    revoke `
        'Pr' `
        'C:\Program Files\Adobe\Adobe Premiere Pro 2020\Registration.dll'
}

function _Pl()
{
    revoke `
        'Pl' `
        'C:\Program Files\Adobe\Adobe Prelude 2020\Registration.dll'
}

function _Ch()
{
    revoke `
        'Ch' `
        'C:\Program Files\Adobe\Adobe Character Animator 2020\Support Files\Character Animator.exe'
}

function _Ae()
{
    revoke `
        'Ae' `
        'C:\Program Files\Adobe\Adobe After Effects 2020\Support Files\AfterFXLib.dll'
}

function _Me()
{
    revoke `
        'Me' `
        'C:\Program Files\Adobe\Adobe Media Encoder 2020\Adobe Media Encoder.exe'
}

function _Br()
{
    revoke `
        'Br' `
        'C:\Program Files\Adobe\Adobe Bridge 2020\Bridge.exe'
}

function _An()
{
    revoke `
        'An' `
        'C:\Program Files\Adobe\Adobe Animate 2020\Animate.exe'
}

function _Dw()
{
    revoke `
        'Dw' `
        'C:\Program Files\Adobe\Adobe Dreamweaver 2020\Dreamweaver.exe' `
        "0F B6 41 08 84 C0 0F 84 AB 00 00 00 3C 07" `
        "0F B6 41 08 B0 01 0F 84 AB 00 00 00 3C 07"
}

function _Dn()
{
    revoke `
        'Dn' `
        'C:\Program Files\Adobe\Adobe Dimension\euclid-core-plugin.pepper'
}

function _Acrobat()
{
    revoke `
        'Acrobat' `
        'C:\Program Files (x86)\Adobe\Acrobat DC\Acrobat\Acrobat.dll'
}

_Ps
_Lr
_Ai
_Id
_Ic
_Au
_Pr
_Pl
_Ch
_Ae
_Me
_Br
_An
_Dw
_Dn
_Acrobat
