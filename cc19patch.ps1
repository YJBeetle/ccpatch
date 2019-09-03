
function patch($__file, $__find, $__to)
{
	# $find = ($__find -split ' ' | ForEach-Object {[char][byte]"0x$_"}) -join ''
	# $to = ($__to -split ' ' | ForEach-Object {[char][byte]"0x$_"}) -join ''
	[Byte[]] $find = $__find -split ' ' | ForEach-Object {[byte]"0x$_"}
	[Byte[]] $to = $__to -split ' ' | ForEach-Object {[byte]"0x$_"}
	# $to = [Byte[]](0x0F,0xB6,0x41,0x08,0xb0,0x01,0x74,0x0A,0x3C,0x07)

	[Byte[]] $file = [System.Io.File]::ReadAllBytes( $__file )
	$fileHexStr = [System.BitConverter]::ToString($file) -replace "-"
	$findHexStr = [System.BitConverter]::ToString($find) -replace "-"
	$position = ($fileHexStr.IndexOf($findHexStr) / 2)
	if ( $position -gt 0 )
	{
		$fileStream = [System.IO.File]::Open($__file, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Write, [System.IO.FileShare]::ReadWrite)
		$binaryWriter = New-Object System.IO.BinaryWriter($fileStream)
		$binaryWriter.BaseStream.Position = $position;
		$binaryWriter.Write($to)
		$fileStream.Close()
    	( Get-FileHash "$__file" -Algorithm MD5 ).Hash > "$__file.patched.md5"
	    echo "Patch succeeded."
	}
	else
	{
	    echo "Patch faild."
	}
}

function run($__tab, $__file, $__find, $__to)
{
	if ( Test-Path "$__file" -PathType Leaf )
	{
        echo "Found and patching $__tab ..."
		if ( ( ! ( Test-Path "$__file.bak" -PathType Leaf ) ) -or ( ! ( Test-Path "$__file.patched.md5" -PathType Leaf ) ) -or ( ( cat "$__file.patched.md5" ) -ne ( Get-FileHash "$__file" -Algorithm MD5 ).Hash ) )
		{
			cp "$__file" "$__file.bak"
            echo "Backup succeeded."
			patch "$__file" "$__find" "$__to"
		}
		else
		{
            echo "Already patched, skipped."
		}
	}
}

run `
	'Lr' `
	"C:\Program Files\Adobe\Adobe Lightroom Classic\Lightroom.exe" `
	"0F B6 41 08 84 C0 74 0A 3C 07" `
	"0F B6 41 08 B0 01 74 0A 3C 07"
