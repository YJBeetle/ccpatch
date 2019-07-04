# Way

*
	1.	Find SUBROUTINE has "in Json::Value::resolveReference(key, end): requires objectValue" (maybe "aInJsonValueRes")
	2.	Find first instruction looks like
		```
		TEST	xx, xx
		JZ	xxx
		```
	3.	Change to
		```
		MOV	xx, 0x1
		JZ	xxx
		```

---

# AI

## Version

### Win 23.0.3

*	0x14030DCED (0x30D0ED): 84 C0 -> B0 01
	or find: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07

### Mac 23.0.4

*	0x49C5AC: 84 DB -> B3 01
	or find: 66 41 8B 5E 08 **84 DB** 74 09 80 FB 07 -> 66 41 8B 5E 08 **B3 01** 74 09 80 FB 07

# PS

## Version

Mac 20.0.5

*	0x64B002: 84 DB -> B3 01
	or find: 66 41 8B 5D 08 **84 DB** 74 09 80 FB 07 -> 66 41 8B 5D 08 **B3 01** 74 09 80 FB 07

Win 20.0.5

*	0x147F78F19 (0x7F78319): 84 C0 -> B0 01
	or find: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07

# AU

## File
	AuUI
	Mac: /Applications/Adobe Audition CC 2019/Adobe Audition CC 2019.app/Contents/Frameworks/AuUI.framework/Versions/A/AuUI
	Win: C:\Program Files\Adobe\Adobe Audition CC 2019\AuUI.dll

## Version

Mac 12.1.1

*	0xD5CF92: 84 DB -> B3 01
	or find: 49 89 D7 49 89 F6 49 89 FD 66 41 8B 5D 08 **84 DB** 74 09 80 FB 07 -> 49 89 D7 49 89 F6 49 89 FD 66 41 8B 5D 08 **B3 01** 74 09 80 FB 07

Win 12.1.1

*	0x180AB658D (0xAB598D): 84 C0 -> B0 01
	or find: 4C 8B FA 4C 8B E1 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 4C 8B FA 4C 8B E1 0F B6 41 08 **B0 01** 74 0A 3C 07

# PR

## File
	AuUI
	Mac: /Applications/Adobe Premiere Pro CC 2019/Adobe Premiere Pro CC 2019.app/Contents/Frameworks/Registration.framework/Versions/A/Registration
	Win: C:\Program Files\Adobe\Adobe Premiere Pro CC 2019\Registration.dll

## Version

Mac 12.1.1

*	0xDB0E2: 84 DB -> B3 01
	or find: 49 89 D7 49 89 F6 49 89 FD 66 41 8B 5D 08 **84 DB** 74 09 80 FB 07 -> 49 89 D7 49 89 F6 49 89 FD 66 41 8B 5D 08 **B3 01** 74 09 80 FB 07

Win 13.1.2

*	0x1800B983D (0xB8C3D): 84 C0 -> B0 01
	or find: 4C 8B FA 4C 8B E1 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 4C 8B FA 4C 8B E1 0F B6 41 08 **B0 01** 74 0A 3C 07

# AE

## File
	AfterFXLib
	Mac: /Applications/Adobe After Effects CC 2019/Adobe After Effects CC 2019.app/Contents/Frameworks/AfterFXLib.framework/Versions/A/AfterFXLib
	Win: C:\Program Files\Adobe\Adobe After Effects CC 2019\Support Files\AfterFXLib.dll

## Version

Mac 16.1.2

*	0xBC63C2: 84 DB -> B3 01
	or find: 66 41 8B 5D 08 **84 DB** 74 09 80 FB 07 -> 66 41 8B 5D 08 **B3 01** 74 09 80 FB 07

Win 16.1.2

*	0x182330D7D (0x233017D): 84 C0 -> B0 01
	or find: 4C 8B FA 4C 8B E1 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 4C 8B FA 4C 8B E1 0F B6 41 08 **B0 01** 74 0A 3C 07

# LR

## Version

Mac 8.3.1

*	0x9A7A0: 84 DB -> B3 01
	49 89 D4 49 89 F7 49 89 FE 66 41 8B 5E 08 **84 DB** 0F 84 F7 00 00 00 80 FB 07 -> 49 89 D4 49 89 F7 49 89 FE 66 41 8B 5E 08 **B3 01** 0F 84 F7 00 00 00 80 FB 07

Win 8.3.1

*	0x1401A954C (0x1A894C): 84 C0 -> B0 01
	or find: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07


