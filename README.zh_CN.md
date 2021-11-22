# CC patch

## 不工作

* Acrobat

## 执行

### Mac

* 使用 curl 以及 python3

  ```sudo python3 -c "$(curl -fsSL https://raw.githubusercontent.com/YJBeetle/ccpatch/generic/run.py)"```

### Win

* 使用 PowerShell (管理员)

  ```powershell -nop -c "iex(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/YJBeetle/ccpatch/generic/run.ps1')"```

## 还原

### Mac

* 使用 curl 以及 python3

  ```sudo python3 -c "$(curl -fsSL https://raw.githubusercontent.com/YJBeetle/ccpatch/generic/run.py)" restore```

### Win

* 使用 PowerShell (管理员)

  ```powershell -nop -c "icm -ScriptBlock ([ScriptBlock]::Create((New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/YJBeetle/ccpatch/generic/run.ps1'))) -ArgumentList restore"```

## 如果MacOS上无法运行

如果MacOS上在执行后无法运行，则你需要代码签名。

首先安装 `Command Line Tools`

    xcode-select --install

并且执行签名

    sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/YJBeetle/ccpatch/generic/mac-codesign.sh)"
