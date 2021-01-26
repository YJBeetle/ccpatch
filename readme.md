# CC patch

## Not work

* Acrobat

## Run

### Mac

* Via curl

  ```curl -fsSL https://raw.githubusercontent.com/YJBeetle/ccpatch/generic/run.py | sudo python3```

* Via wget

  ```wget https://raw.githubusercontent.com/YJBeetle/ccpatch/generic/run.sh -O - | sudo python3```

### Win

* Via PowerShell (Administrator)

  ```powershell -nop -c "iex(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/YJBeetle/ccpatch/generic/run.ps1')"```

## Restore

### Mac

* Via curl

  ```curl -fsSL https://raw.githubusercontent.com/YJBeetle/ccpatch/generic/run.py | sudo python3 restore```

* Via wget

  ```wget https://raw.githubusercontent.com/YJBeetle/ccpatch/generic/run.sh -O - | sudo python3 restore```

### Win

* Via PowerShell (Administrator)

  ```powershell -nop -c "icm -ScriptBlock ([ScriptBlock]::Create((New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/YJBeetle/ccpatch/generic/run.ps1'))) -ArgumentList restore"```
