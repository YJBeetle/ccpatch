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

*	23.0.3
	*	Win
		*	0x14030DCED (0x30D0ED): 84 C0 -> B0 01
		*	or find: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07

*	23.0.4
	*	Mac
		*	0x49C5AC: 84 DB -> B3 01
		*	or find: 66 41 8B 5E 08 **84 DB** 74 09 80 FB 07 -> 66 41 8B 5E 08 **B3 01** 74 09 80 FB 07

# PS

## Version

*	20.0.5
	*	Mac
		*	0x64B002: 84 DB -> B3 01
		*	or find: 66 41 8B 5D 08 **84 DB** 74 09 80 FB 07 -> 66 41 8B 5D 08 **B3 01** 74 09 80 FB 07
	*	Win
		*	0x147F78F19 (0x7F78319): 84 C0 -> B0 01
		*	or find: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07

# AU

## File
	Mac: /Applications/Adobe Audition CC 2019/Adobe Audition CC 2019.app/Contents/Frameworks/AuUI.framework/Versions/A/AuUI
	Win: C:\Program Files\Adobe\Adobe Audition CC 2019\AuUI.dll

## Version

*	12.1.1
	*	Mac
		*	0xD5CF92: 84 DB -> B3 01
		*	or find: 49 89 D7 49 89 F6 49 89 FD 66 41 8B 5D 08 **84 DB** 74 09 80 FB 07 -> 49 89 D7 49 89 F6 49 89 FD 66 41 8B 5D 08 **B3 01** 74 09 80 FB 07
	*	Win
		*	0x180AB658D (0xAB598D): 84 C0 -> B0 01
		*	or find: 4C 8B FA 4C 8B E1 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 4C 8B FA 4C 8B E1 0F B6 41 08 **B0 01** 74 0A 3C 07

# PR

## File
	Mac: /Applications/Adobe Premiere Pro CC 2019/Adobe Premiere Pro CC 2019.app/Contents/Frameworks/Registration.framework/Versions/A/Registration
	Win: C:\Program Files\Adobe\Adobe Premiere Pro CC 2019\Registration.dll

## Version

*	12.1.1
	*	Mac
		*	0xDB0E2: 84 DB -> B3 01
		*	or find: 49 89 D7 49 89 F6 49 89 FD 66 41 8B 5D 08 **84 DB** 74 09 80 FB 07 -> 49 89 D7 49 89 F6 49 89 FD 66 41 8B 5D 08 **B3 01** 74 09 80 FB 07
	*	Win
		*	0x1800B983D (0xB8C3D): 84 C0 -> B0 01
		*	or find: 4C 8B FA 4C 8B E1 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 4C 8B FA 4C 8B E1 0F B6 41 08 **B0 01** 74 0A 3C 07

# PL

## File
	Mac: /Applications/Adobe Prelude CC 2019/Adobe Prelude CC 2019.app/Contents/Frameworks/Registration.framework/Versions/A/Registration
	Win: C:\Program Files\Adobe\Adobe Prelude CC 2019\Registration.dll

## Version

*	12.1.1
	*	Mac
		*	0xDB0E2: 84 DB -> B3 01
		*	or find: 49 89 D7 49 89 F6 49 89 FD 66 41 8B 5D 08 **84 DB** 74 09 80 FB 07 -> 49 89 D7 49 89 F6 49 89 FD 66 41 8B 5D 08 **B3 01** 74 09 80 FB 07
	*	Win
		*	0x1800B983D (0xB8C3D): 84 C0 -> B0 01
		*	or find: 4C 8B FA 4C 8B E1 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 4C 8B FA 4C 8B E1 0F B6 41 08 **B0 01** 74 0A 3C 07

# AE

## File
	Mac: /Applications/Adobe After Effects CC 2019/Adobe After Effects CC 2019.app/Contents/Frameworks/AfterFXLib.framework/Versions/A/AfterFXLib
	Win: C:\Program Files\Adobe\Adobe After Effects CC 2019\Support Files\AfterFXLib.dll

## Version

*	16.1.2
	*	Mac
		*	0xBC63C2: 84 DB -> B3 01
		*	or find: 66 41 8B 5D 08 **84 DB** 74 09 80 FB 07 -> 66 41 8B 5D 08 **B3 01** 74 09 80 FB 07
	*	Win
		*	0x182330D7D (0x233017D): 84 C0 -> B0 01
		*	or find: 4C 8B FA 4C 8B E1 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 4C 8B FA 4C 8B E1 0F B6 41 08 **B0 01** 74 0A 3C 07

# LR

## Version

*	8.3.1
	*	Mac
		*	0x9A7A0: 84 DB -> B3 01
		*	or find: 49 89 D4 49 89 F7 49 89 FE 66 41 8B 5E 08 **84 DB** 0F 84 F7 00 00 00 80 FB 07 -> 49 89 D4 49 89 F7 49 89 FE 66 41 8B 5E 08 **B3 01** 0F 84 F7 00 00 00 80 FB 07
	*	Win
		*	0x1401A954C (0x1A894C): 84 C0 -> B0 01
		*	or find: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07

# ID

## File
	Mac: /Applications/Adobe InDesign CC 2019/Adobe InDesign CC 2019.app/Contents/MacOS/PublicLib.dylib
	Win: C:\Program Files\Adobe\Adobe InDesign CC 2019\Public.dll

## Version

*	14.0.2
	*	Mac
		*	0x318672: 84 C0 -> B0 01
		*	or find: 41 0F B6 47 08 **84 C0** 74 08 3C 07 -> 41 0F B6 47 08 **B0 01** 74 08 3C 07
	*	Win
		*	0x1803D6E2C (0x3D6228): 84 C0 -> B0 01
		*	or find: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07

# IC

## File
	Mac: /Applications/Adobe InCopy CC 2019/Adobe InCopy CC 2019.app/Contents/MacOS/PublicLib.dylib
	Win: C:\Program Files\Adobe\Adobe InCopy CC 2019\Public.dll

## Version

*	14.0.2
	*	Mac
		*	0x318672: 84 C0 -> B0 01
		*	or find: 41 0F B6 47 08 **84 C0** 74 08 3C 07 -> 41 0F B6 47 08 **B0 01** 74 08 3C 07
	*	Win
		*	0x1803D6E2C (0x3D6228): 84 C0 -> B0 01
		*	or find: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07

# ME

## Version

*	13.1.0
	*	Mac
		*	0x12BCF2: 84 DB -> B3 01
		*	or find: 66 41 8B 5D 08 **84 DB** 74 09 80 FB 07 -> 66 41 8B 5D 08 **B3 01** 74 09 80 FB 07
	*	Win
		*	0x14012498D (0x123D8D): 84 C0 -> B0 01
		*	or find: 4C 8B FA 4C 8B E1 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 4C 8B FA 4C 8B E1 0F B6 41 08 **B0 01** 74 0A 3C 07

# DW

## Version

*	19.2.0
	*	Mac
		*	0x175C152: 84 DB -> B3 01
		*	or find: 66 41 8B 5D 08 **84 DB** 74 09 80 FB 07 -> 66 41 8B 5D 08 **B3 01** 74 09 80 FB 07
	*	Win
		*	0xA5F8A3 (0x25ECA3): 84 C0 -> B0 01
		*	or find: 0F B6 41 08 **84 C0** 0F 84 AB 00 00 00 3C 07 -> 0F B6 41 08 **B0 01** 0F 84 AB 00 00 00 3C 07

# CH

## Version

*	2.1.1
	*	Mac
		*	0x988592: 84 DB -> B3 01
		*	or find: 49 89 D7 49 89 F6 49 89 FD 66 41 8B 5D 08 **84 DB** 74 09 80 FB 07 -> 49 89 D7 49 89 F6 49 89 FD 66 41 8B 5D 08 **B3 01** 74 09 80 FB 07
	*	Win
		*	0x1411F3C7D (0x11F307D): 84 C0 -> B0 01
		*	or find: 4C 8B FA 4C 8B E1 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 4C 8B FA 4C 8B E1 0F B6 41 08 **B0 01** 74 0A 3C 07

# AN

## Version

*	19.2.1
	*	Mac
		*	0x976606: 66 25 FF 00 -> 90 90 B0 01
		*	or find: 66 89 D8 **66 25 FF 00** 0F 84 71 01 00 00 0F B7 C0 83 F8 07 -> 66 89 D8 **90 90 B0 01** 0F 84 71 01 00 00 0F B7 C0 83 F8 07
	*	Win
		*	0x140525A13 (0x524E13): 84 C0 -> B0 01
		*	or find: 0F B6 41 08 **84 C0** 0F 84 9C 00 00 00 3C 07 -> 0F B6 41 08 **B0 01** 0F 84 9C 00 00 00 3C 07

# BR

## Version

*	9.1.0
	*	Mac
		*	0x5B2002: 84 DB -> B3 01
		*	or find: 66 41 8B 5E 08 **84 DB** 0F 84 0F 01 00 00 80 FB 07 -> 66 41 8B 5E 08 **B3 01** 0F 84 0F 01 00 00 80 FB 07
	*	Win
		*	0x1409CEE73 (0x9CE273): 84 C0 -> B0 01
		*	or find: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07
