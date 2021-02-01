# CC patch

## Not work

* Acrobat

## Run

### Mac

* Via curl and python3

  ```sudo python3 -c "$(curl -fsSL https://raw.githubusercontent.com/YJBeetle/ccpatch/generic/run.py)"```

### Win

* Via PowerShell (Administrator)

  ```powershell -nop -c "iex(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/YJBeetle/ccpatch/generic/run.ps1')"```

## Restore

### Mac

* Via curl and python3

  ```sudo python3 -c "$(curl -fsSL https://raw.githubusercontent.com/YJBeetle/ccpatch/generic/run.py)" restore```

### Win

* Via PowerShell (Administrator)

  ```powershell -nop -c "icm -ScriptBlock ([ScriptBlock]::Create((New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/YJBeetle/ccpatch/generic/run.ps1'))) -ArgumentList restore"```

## If macOS user crash

If macOS user crash after patched, you need codesign.

First install `Command Line Tools`

    xcode-select --install

And codesign

    sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/YJBeetle/ccpatch/generic/mac-codesign.sh)"
