#!/usr/bin/env pwsh

$IMAGE_FILE_MACHINE_AMD64 = 0x8664
$IMAGE_FILE_MACHINE_I386 = 0x14c

$DOT_TEXT = 0x747865742E
$DOT_RDATA = 0x61746164722E

Add-Type @"
public struct CoffHeader {
    public System.UInt16 Machine;
    public System.UInt16 NumberOfSections;
    public System.UInt32 TimeDateStamp;
    public System.UInt32 PointerToSymbolTable;
    public System.UInt32 NumberOfSymbols;
    public System.UInt16 SizeOfOptionalHeader;
    public System.UInt16 Characteristics;
}
"@

Add-Type @"
public struct OptionalHeader {
    public System.UInt16 Magic;
    public System.Byte MajorLinkerVersion;
    public System.Byte MinorLinkerVersion;
    public System.UInt32 SizeOfCode;
    public System.UInt32 SizeOfInitializedData;
    public System.UInt32 SizeOfUninitializedData;
    public System.UInt32 AddressOfEntryPoint;
    public System.UInt32 BaseOfCode;
}
"@

Add-Type @"
public struct SectionHeader {
    public System.UInt64 Name;
    public System.UInt32 VirtualSize;
    public System.UInt32 VirtualAddress;
    public System.UInt32 SizeOfRawData;
    public System.UInt32 PointerToRawData;
    public System.UInt32 PointerToRelocations;
    public System.UInt32 PointerToLinenumbers;
    public System.UInt16 NumberOfRelocations;
    public System.UInt16 NumberOfLinenumbers;
    public System.UInt32 Characteristics;
}
"@

# Function originally by https://www.reddit.com/r/PowerShell/comments/7b9fxu/search_byte_array_for_byte_pattern/
function Search-Binary {
    [cmdletbinding()]
    Param (
        [parameter(ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True, Mandatory = $True)]
        [Byte[]]$BinaryValue,
        [parameter(ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True, Mandatory = $True)]
        [Byte[]]$Pattern,
        [parameter(ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [bool]$First,
        [parameter(ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [bool]$Reverse
    )
    #  Original method function originally by Tommaso Belluzzo
    #  https://stackoverflow.com/questions/16252518/boyer-moore-horspool-algorithm-for-all-matches-find-byte-array-inside-byte-arra
    $MethodDefinition = @'
        public static System.Collections.Generic.List<Int64> IndexesOf(Byte[] binaryValue, Byte[] pattern, bool first = false, bool reverse = false)
        {
            if (binaryValue == null)
                throw new ArgumentNullException("binaryValue");
            if (pattern == null)
                throw new ArgumentNullException("pattern");
            Int64 binaryValueLength = binaryValue.LongLength;
            Int64 patternLength = pattern.LongLength;
            Int64 searchLength = binaryValueLength - patternLength;
            if ((binaryValueLength == 0) || (patternLength == 0) || (patternLength > binaryValueLength))
                return (new System.Collections.Generic.List<Int64>());
            Int64[] badCharacters = new Int64[256];
            for (Int64 i = 0; i < 256; ++i)
                badCharacters[i] = patternLength;
            Int64 lastPatternByte = patternLength - 1;
            for (Int64 i = 0; i < lastPatternByte; ++i)
                badCharacters[pattern[i]] = lastPatternByte - i;
            // Beginning
            System.Collections.Generic.List<Int64> indexes = new System.Collections.Generic.List<Int64>();
            if(reverse){
                Int64 index = searchLength;
                while (index >= 0)
                {
                    for (Int64 i = lastPatternByte; binaryValue[(index + i)] == pattern[i]; --i)
                    {
                        if (i == 0)
                        {
                            indexes.Add(index);
                            if (first)
                                return indexes;
                            break;
                        }
                    }
                    index -= badCharacters[binaryValue[(index + lastPatternByte)]];
                }
            }else{
                Int64 index = 0;
                while (index <= searchLength)
                {
                    for (Int64 i = lastPatternByte; binaryValue[(index + i)] == pattern[i]; --i)
                    {
                        if (i == 0)
                        {
                            indexes.Add(index);
                            if (first)
                                return indexes;
                            break;
                        }
                    }
                    index += badCharacters[binaryValue[(index + lastPatternByte)]];
                }
            }
            return indexes;
        }
'@
    if (-not ([System.Management.Automation.PSTypeName]'Random.Search').Type) {
        Add-Type -MemberDefinition $MethodDefinition -Name 'Search' -Namespace 'Random' | Out-Null
    }
    return [Random.Search]::IndexesOf($binaryValue, $Pattern, $First, $Reverse)
}

$patchsData = @(
    @{
        funcTrait = @{
            type = 'callKeyword'
            opPrefix = [Byte[]](0x48, 0x8D, 0x15) # LeaRdx
            keywordString = "PROFILE_AVAILABLE"
            functionSplitUp = [Byte[]](0xCC)
            functionSplitDown = [Byte[]](0xCC)
        }
        patchPointList = @(
            @{find = [Byte[]](0xB8, 0x92, 0x01, 0x00, 0x00); replace = [Byte[]](0x90, 0x90, 0x90, 0x31, 0xC0) },
            @{find = [Byte[]](0xB8, 0x93, 0x01, 0x00, 0x00); replace = [Byte[]](0x90, 0x90, 0x90, 0x31, 0xC0) },
            @{find = [Byte[]](0xB8, 0x94, 0x01, 0x00, 0x00); replace = [Byte[]](0x90, 0x90, 0x90, 0x31, 0xC0) },
            @{find = [Byte[]](0xB8, 0x95, 0x01, 0x00, 0x00); replace = [Byte[]](0x90, 0x90, 0x90, 0x31, 0xC0) },
            @{find = [Byte[]](0xB8, 0x96, 0x01, 0x00, 0x00); replace = [Byte[]](0x90, 0x90, 0x90, 0x31, 0xC0) },
            @{find = [Byte[]](0xB8, 0x97, 0x01, 0x00, 0x00); replace = [Byte[]](0x90, 0x90, 0x90, 0x31, 0xC0) },
            @{find = [Byte[]](0xB8, 0x98, 0x01, 0x00, 0x00); replace = [Byte[]](0x90, 0x90, 0x90, 0x31, 0xC0) }
        )
    }
)

function patch($path) {
    $patched = 0
    $mmf = [System.IO.MemoryMappedFiles.MemoryMappedFile]::CreateFromFile($path)
    $accessor = $mmf.CreateViewAccessor()
    try {
        $peOffset = $accessor.ReadUInt32(0x3C)
        $signature = [Byte[]]::new(4)
        $null = $accessor.ReadArray($peOffset, $signature, 0, $signature.Length)
        if (Compare-Object $signature ([Byte[]](0x50, 0x45, 0x00, 0x00))) {
            Write-Host "Error: signature wrong."
            return $false
        }

        $coffHeaderOffset = $peOffset + 4
        # echo "coffHeaderOffset" $coffHeaderOffset
        $coffHeader = [CoffHeader]@{}
        $null = $accessor.Read($coffHeaderOffset, [ref]$coffHeader)
        # echo "coffHeader" $coffHeader

        $optionalHeaderOffset = $coffHeaderOffset + [Runtime.InteropServices.Marshal]::SizeOf($coffHeader)
        # echo "optionalHeaderOffset" $optionalHeaderOffset
        $optionalHeader = [OptionalHeader]@{}
        $null = $accessor.Read($optionalHeaderOffset, [ref]$OptionalHeader)
        # echo "optionalHeader" $optionalHeader

        $SectionHeadersOffset = $optionalHeaderOffset + $coffHeader.SizeOfOptionalHeader
        # echo "SectionHeadersOffset" $SectionHeadersOffset
        $textAddress = 0
        $textOffset = 0
        $textSize = 0
        $rdataAddress = 0
        $rdataOffset = 0
        $rdataSize = 0
        for ($i = 0; $i -lt $coffHeader.NumberOfSections; $i++) {
            $sectionHeader = [SectionHeader]@{}
            $null = $accessor.Read($SectionHeadersOffset + [Runtime.InteropServices.Marshal]::SizeOf($sectionHeader) * $i, [ref]$sectionHeader)
            # echo $sectionHeader
            if ($sectionHeader.Name -eq $DOT_TEXT) {
                $textAddress = $sectionHeader.VirtualAddress
                $textOffset = $sectionHeader.PointerToRawData
                $textSize = $sectionHeader.SizeOfRawData
            }
            elseif ($sectionHeader.Name -eq $DOT_RDATA) {
                $rdataAddress = $sectionHeader.VirtualAddress
                $rdataOffset = $sectionHeader.PointerToRawData
                $rdataSize = $sectionHeader.SizeOfRawData
            }
        }

        if ($textOffset -and $textSize) {
            foreach ($patchData in $patchsData) {
                $funcOffsetList = @()
                if ($patchData.funcTrait.type -eq "callKeyword") {
                    $opLen = $patchData.funcTrait.opPrefix.length + 4
                    if (($rdataOffset -eq 0) -or ($rdataSize -eq 0)) {
                        Write-Host "Error: '.rdata' not found."
                        continue
                    }
                    $b = [Byte[]]::new($rdataSize)
                    $null = $accessor.ReadArray($rdataOffset, $b, 0, $b.length)
                    $p = Search-Binary $b ($patchData.funcTrait.keywordString.ToCharArray()) $true
                    if ($p.Length -eq 0) {
                        Write-Host ("Error: Keyword String '" + $patchData.funcTrait.keywordString + "' not found.")
                        continue
                    }
                    $strOffset = $rdataOffset + $p[0]
                    $strAddress = $rdataAddress + $p[0]
                    $b = [Byte[]]::new($textSize)
                    $null = $accessor.ReadArray($textOffset, $b, 0, $b.length)
                    $p = Search-Binary $b $patchData.funcTrait.opPrefix
                    foreach ($pp in $p) {
                        $callKeywordOffset = $textOffset + $opLen + $pp
                        $callKeywordAddress = $textAddress + $opLen + $pp
                        $op = $accessor.ReadUInt32($textOffset + $pp + 3)
                        if (($callKeywordAddress + $op) -eq $strAddress) {
                            $b = [Byte[]]::new($callKeywordOffset - $opLen - $textOffset)
                            $null = $accessor.ReadArray($textOffset, $b, 0, $b.length)
                            $sp = Search-Binary $b $patchData.funcTrait.functionSplitUp $true $true
                            $start = $textOffset
                            if ($sp.Length) {
                                $start = $textOffset + $sp[0] + 1
                            }
                            $b = [Byte[]]::new($textOffset + $textSize - $callKeywordOffset)
                            $null = $accessor.ReadArray($callKeywordOffset, $b, 0, $b.length)
                            $ep = Search-Binary $b $patchData.funcTrait.functionSplitDown $true
                            $end = $textOffset + $textSize
                            if ($ep.Length) {
                                $end = $callKeywordOffset + $ep[0]
                            }
                            $funcOffsetList += @{start = $start; size = $end - $start }
                        }
                    }
                }
                else {
                    Write-Host "Error: Unknow funstion trait type."
                }
                foreach ($funcOffset in $funcOffsetList) {
                    $b = [Byte[]]::new($funcOffset.size)
                    $null = $accessor.ReadArray($funcOffset.start, $b, 0, $b.length)
                    foreach ($patchPoint in $patchData.patchPointList) {
                        $p = Search-Binary $b $patchPoint.find $true
                        if ($p.Length -eq 0) {
                            Write-Host ("Warn: (" + $patchPoint.find + ") not found.")
                            continue
                        }
                        $patchPointOffset = $funcOffset.start + $p
                        $accessor.WriteArray($patchPointOffset, $patchPoint.replace, 0, $patchPoint.replace.Length)
                        $patched += 1
                    }
                }
            }
            # echo $patched
        }
        else {
            Write-Host "Error: '.text' not found."
        }
    }
    finally {
        $accessor.Dispose()
        $mmf.Dispose()
    }
    return $patched
}

$appList = @{
    ps = @{
        paths = @(
            'C:\Program Files\Adobe\Adobe Photoshop 2020\Photoshop.exe',
            'C:\Program Files\Adobe\Adobe Photoshop 2021\Photoshop.exe',
            'C:\Program Files\Adobe\Adobe Photoshop 2022\Photoshop.exe'
        )
    }
    lr = @{
        paths = @(
            'C:\Program Files\Adobe\Adobe Lightroom Classic\Lightroom.exe'
        )
    }
    ai = @{
        paths = @(
            'C:\Program Files\Adobe\Adobe Illustrator 2020\Support Files\Contents\Windows\Illustrator.exe',
            'C:\Program Files\Adobe\Adobe Illustrator 2021\Support Files\Contents\Windows\Illustrator.exe',
            'C:\Program Files\Adobe\Adobe Illustrator 2022\Support Files\Contents\Windows\Illustrator.exe'
        )
    }
    id = @{
        paths = @(
            'C:\Program Files\Adobe\Adobe InDesign 2020\Public.dll',
            'C:\Program Files\Adobe\Adobe InDesign 2021\Public.dll',
            'C:\Program Files\Adobe\Adobe InDesign 2022\Public.dll'
        )
    }
    ic = @{
        paths = @(
            'C:\Program Files\Adobe\Adobe InCopy 2020\Public.dll',
            'C:\Program Files\Adobe\Adobe InCopy 2021\Public.dll',
            'C:\Program Files\Adobe\Adobe InCopy 2022\Public.dll'
        )
    }
    au = @{
        paths = @(
            'C:\Program Files\Adobe\Adobe Audition 2020\AuUI.dll',
            'C:\Program Files\Adobe\Adobe Audition 2021\AuUI.dll',
            'C:\Program Files\Adobe\Adobe Audition 2022\AuUI.dll'
        )
    }
    pr = @{
        paths = @(
            'C:\Program Files\Adobe\Adobe Premiere Pro 2020\Registration.dll',
            'C:\Program Files\Adobe\Adobe Premiere Pro 2021\Registration.dll',
            'C:\Program Files\Adobe\Adobe Premiere Pro 2022\Registration.dll'
        )
    }
    pl = @{
        paths = @(
            'C:\Program Files\Adobe\Adobe Prelude 2020\Registration.dll',
            'C:\Program Files\Adobe\Adobe Prelude 2021\Registration.dll',
            'C:\Program Files\Adobe\Adobe Prelude 2022\Registration.dll'
        )
    }
    ch = @{
        paths = @(
            'C:\Program Files\Adobe\Adobe Character Animator 2020\Support Files\Character Animator.exe',
            'C:\Program Files\Adobe\Adobe Character Animator 2021\Support Files\Character Animator.exe',
            'C:\Program Files\Adobe\Adobe Character Animator 2022\Support Files\Character Animator.exe'
        )
    }
    ae = @{
        paths = @(
            'C:\Program Files\Adobe\Adobe After Effects 2020\Support Files\AfterFXLib.dll',
            'C:\Program Files\Adobe\Adobe After Effects 2021\Support Files\AfterFXLib.dll',
            'C:\Program Files\Adobe\Adobe After Effects 2022\Support Files\AfterFXLib.dll'
        )
    }
    me = @{
        paths = @(
            'C:\Program Files\Adobe\Adobe Media Encoder 2020\Adobe Media Encoder.exe',
            'C:\Program Files\Adobe\Adobe Media Encoder 2021\Adobe Media Encoder.exe',
            'C:\Program Files\Adobe\Adobe Media Encoder 2022\Adobe Media Encoder.exe'
        )
    }
    br = @{
        paths = @(
            'C:\Program Files\Adobe\Adobe Bridge 2020\Bridge.exe',
            'C:\Program Files\Adobe\Adobe Bridge 2021\Bridge.exe',
            'C:\Program Files\Adobe\Adobe Bridge 2022\Bridge.exe'
        )
    }
    an = @{
        paths = @(
            'C:\Program Files\Adobe\Adobe Animate 2020\Animate.exe',
            'C:\Program Files\Adobe\Adobe Animate 2021\Animate.exe',
            'C:\Program Files\Adobe\Adobe Animate 2022\Animate.exe'
        )
    }
    dw = @{
        paths = @(
            'C:\Program Files\Adobe\Adobe Dreamweaver 2020\Dreamweaver.exe',
            'C:\Program Files\Adobe\Adobe Dreamweaver 2021\Dreamweaver.exe',
            'C:\Program Files\Adobe\Adobe Dreamweaver 2022\Dreamweaver.exe'
        )
    }
    dn = @{
        paths = @(
            'C:\Program Files\Adobe\Adobe Dimension\euclid-core-plugin.pepper'
        )
    }
    acrobat = @{
        paths = @(
            'C:\Program Files (x86)\Adobe\Acrobat DC\Acrobat\Acrobat.dll'
        )
    }
}

function verifyPatchedHash($path) {
    if (Test-Path "$path.patched.md5" -PathType Leaf) {
        return (cat "$path.patched.md5") -eq (Get-FileHash "$path" -Algorithm MD5).Hash
    }
    return $false
}

function patchPath($path) {
    if (Test-Path "$path" -PathType Leaf) {
        Write-Host "Found and patching $app"
        if ((Test-Path "$path.bak" -PathType Leaf) -and (verifyPatchedHash "$path")) {
            Write-Host "Already patched, skipped."
            return
        }
        if (Test-Path "$path.bak" -PathType Leaf) {
            rm "$path.bak"
        }
        mv "$path" "$path.bak"
        cp "$path.bak" "$path"
        Write-Host "Backup succeeded."
        $patched = patch "$path"
        if ($patched) {
            (Get-FileHash "$path" -Algorithm MD5).Hash > "$path.patched.md5"
            Write-Host "Patch succeeded, patched point: $patched"
        }
        else {
            Write-Host "Patch faild."
        }
    }
}

function patchApp($app) {
    if ($appList.ContainsKey($app)) {
        $paths = $appList[$app].paths
        foreach ($path in $paths) {
            patchPath $path
        }
    }
    else {
        patchPath $app
    }
}

function restorePath($path) {
    if (Test-Path "$path.bak" -PathType Leaf) {
        Write-Host "Found and restore $app ..."
        rm "$path"
        mv "$path.bak" "$path"
        rm "$path.patched.md5"
        Write-Host "Restore succeeded."
    }
    else {
        Write-Host "The backup file does not exist, skipped."
    }
}

function restoreApp($app) {
    if ($appList.ContainsKey($app)) {
        $paths = $appList[$app].paths
        foreach ($path in $paths) {
            restorePath $path
        }
    }
    else {
        restorePath $app
    }
}

if ((Get-Variable -Name IsWindows -ErrorAction SilentlyContinue) -eq $null) {
    # IsWindows is PowerShell Core 5.0's feature
    $IsWindows = [System.Environment]::OSVersion.Platform -eq [System.PlatformID]::Win32NT
}
if ($IsWindows) {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if (!$currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "Privilege is not sufficient, elevating..."
        $_args = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb runas -ArgumentList $_args
        exit
    }
}
if ($args.length) {
    if ($args[0] -ieq "restore" -or $args[0] -ieq "--restore" -or $args[0] -ieq "-r") {
        if ($args.length -gt 1) {
            foreach ($app in $args[1..$args.Length]) {
                restoreApp $app
            }
        }
        else {
            foreach ($app in $appList.Keys) {
                restoreApp $app
            }
        }
    }
    else {
        foreach ($app in $args) {
            patchApp $app
        }
    }
}
else {
    foreach ($app in $appList.Keys) {
        patchApp $app
    }
}
