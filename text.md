# Way

*
	1.	Find SUBROUTINE has "in Json::Value::resolveReference(key, end): requires objectValue" (maybe "aInJsonValueRes")(in "adobe::ngl::internal::Json::Value::resolveReference(char const*, char const*)" or "Json::Value::resolveReference(char const*, char const*)")
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

# Ps

## File

	Mac: /Applications/Adobe Photoshop 2020/Adobe Photoshop 2020.app/Contents/MacOS/Adobe Photoshop 2020
	Win: C:\Program Files\Adobe\Adobe Photoshop 2020\Photoshop.exe

## Version

*	21.0.0.37
	*	Mac
		*	0x10079EBC1: 84 DB -> B3 01
		*	find: 0F B7 5F 08 **84 DB** 0F 84 EE 00 00 00 80 FB 07 -> 0F B7 5F 08 **B3 01** 0F 84 EE 00 00 00 80 FB 07
	*	Win
		*	0x147132CF9: 84 C0 -> B0 01
		*	find: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07

# Lr

## File

	Mac: /Applications/Adobe Lightroom Classic/Adobe Lightroom Classic.app/Contents/MacOS/Adobe Lightroom Classic
	Win: C:\Program Files\Adobe\Adobe Lightroom Classic\Lightroom.exe

## Version

*	8.3.1
	*	Mac
		*	0x9A7A0: 84 DB -> B3 01
		*	find: 49 89 D4 49 89 F7 49 89 FE 66 41 8B 5E 08 **84 DB** 0F 84 F7 00 00 00 80 FB 07 -> 49 89 D4 49 89 F7 49 89 FE 66 41 8B 5E 08 **B3 01** 0F 84 F7 00 00 00 80 FB 07
	*	Win
		*	0x1401A954C (0x1A894C): 84 C0 -> B0 01
		*	find: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07

# Ai

## File

	Mac: /Applications/Adobe Illustrator 2020/Adobe Illustrator.app/Contents/MacOS/Adobe Illustrator
	Win: C:\Program Files\Adobe\Adobe Illustrator 2020\Support Files\Contents\Windows\Illustrator.exe

## Version

*	24.0.0
	*	Mac
		*	0x100501015: 84 DB -> B3 01
		*	find: 0F B7 5F 08 **84 DB** 0F 84 C2 00 00 00 80 FB 07 -> 0F B7 5F 08 **B3 01** 0F 84 C2 00 00 00 80 FB 07
	*	Win
		*	0x1407BB89D: 84 C0 -> B0 01
		*	find: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07

# Id

## File

	Mac: /Applications/Adobe InDesign 2020/Adobe InDesign 2020.app/Contents/MacOS/PublicLib.dylib
	Win: C:\Program Files\Adobe\Adobe InDesign 2020\Public.dll

## Version

*	15.0.0.155
	*	Mac
		*	0x3393F2: 84 C0 -> B0 01
		*	find: 41 0F B6 47 08 **84 C0** 74 08 3C 07 -> 41 0F B6 47 08 **B0 01** 74 08 3C 07
	*	Win
		*	0x1803F84FC: 84 C0 -> B0 01
		*	find: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07

# Ic

## File

	Mac: /Applications/Adobe InCopy 2020/Adobe InCopy 2020.app/Contents/MacOS/PublicLib.dylib
	Win: C:\Program Files\Adobe\Adobe InCopy 2020\Public.dll

## Version

*	15.0.0.155
	*	Mac
		*	0x3393F2: 84 C0 -> B0 01
		*	find: 41 0F B6 47 08 **84 C0** 74 08 3C 07 -> 41 0F B6 47 08 **B0 01** 74 08 3C 07
	*	Win
		*	0x1803F84FC: 84 C0 -> B0 01
		*	find: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07

# Au

## File

	Mac: /Applications/Adobe Audition 2020/Adobe Audition 2020.app/Contents/Frameworks/AuUI.framework/Versions/A/AuUI
	Win: C:\Program Files\Adobe\Adobe Audition 2020\AuUI.dll

## Version

*	13.0.0.519
	*	Mac
		*	0xDA5D41: 84 DB -> B3 01
		*	find: 49 89 F4 49 89 FD 0F B7 5F 08 **84 DB** 0F 84 EE 00 00 00 80 FB 07 -> 49 89 F4 49 89 FD 0F B7 5F 08 **B3 01** 0F 84 EE 00 00 00 80 FB 07
	*	Win
		*	0x1807880BD: 84 C0 -> B0 01
		*	find: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07

# Pr

## File

	Mac: /Applications/Adobe Premiere Pro 2020/Adobe Premiere Pro 2020.app/Contents/Frameworks/Registration.framework/Versions/A/Registration
	Win: C:\Program Files\Adobe\Adobe Premiere Pro 2020\Registration.dll

## Version

*	14.0
	*	Mac
		*	0xDEA51: 84 DB -> B3 01
		*	find: 0F B7 5F 08 **84 DB** 0F 84 EE 00 00 00 80 FB 07 -> 0F B7 5F 08 **B3 01** 0F 84 EE 00 00 00 80 FB 07
	*	Win
		*	0x18008FCDD: 84 C0 -> B0 01
		*	find: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07

# Pl

## File

	Mac: /Applications/Adobe Prelude 2020/Adobe Prelude 2020.app/Contents/Frameworks/Registration.framework/Versions/A/Registration
	Win: C:\Program Files\Adobe\Adobe Prelude 2020\Registration.dll

## Version

*	9.0
	*	Mac
		*	0xDEA61: 84 DB -> B3 01
		*	find: 0F B7 5F 08 **84 DB** 0F 84 EE 00 00 00 80 FB 07 -> 0F B7 5F 08 **B3 01** 0F 84 EE 00 00 00 80 FB 07
	*	Win
		*	0x18008FCDD: 84 C0 -> B0 01
		*	find: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07

# Ch

## File

	Mac: /Applications/Adobe Character Animator 2020/Adobe Character Animator 2020.app/Contents/MacOS/Character Animator
	Win: C:\Program Files\Adobe\Adobe Character Animator 2020\Support Files\Character Animator.exe

## Version

*	3.0
	*	Mac (not work)
		*	0x100D25FC1: 84 DB -> B3 01
		*	find: 49 89 F4 49 89 FD 0F B7 5F 08 **84 DB** 0F 84 EE 00 00 00 80 FB 07 -> 49 89 F4 49 89 FD 0F B7 5F 08 **B3 01** 0F 84 EE 00 00 00 80 FB 07
	*	Win
		*	0x1411C95CD: 84 C0 -> B0 01
		*	find: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07

# Ae

## File

	Mac: /Applications/Adobe After Effects 2020/Adobe After Effects 2020.app/Contents/Frameworks/AfterFXLib.framework/Versions/A/AfterFXLib
	Win: C:\Program Files\Adobe\Adobe After Effects 2020\Support Files\AfterFXLib.dll

## Version

*	17.0
	*	Mac
		*	0xC10BA1: 84 DB -> B3 01
		*	find: 0F B7 5F 08 **84 DB** 0F 84 EE 00 00 00 80 FB 07 -> 0F B7 5F 08 **B3 01** 0F 84 EE 00 00 00 80 FB 07
	*	Win
		*	0x181AFA98D: 84 C0 -> B0 01
		*	find: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07

# Me

## File

	Mac: /Applications/Adobe Media Encoder 2020/Adobe Media Encoder 2020.app/Contents/MacOS/Adobe Media Encoder 2020
	Win: C:\Program Files\Adobe\Adobe Media Encoder 2020\Adobe Media Encoder.exe

## Version

*	14.0
	*	Mac
		*	0x100147DF1: 84 DB -> B3 01
		*	find: 0F B7 5F 08 **84 DB** 0F 84 EE 00 00 00 80 FB 07 -> 0F B7 5F 08 **B3 01** 0F 84 EE 00 00 00 80 FB 07
	*	Win
		*	0x1400CE4DD: 84 C0 -> B0 01
		*	find: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07

# Br

## File

	Mac: /Applications/Adobe Bridge 2020/Adobe Bridge 2020.app/Contents/MacOS/Adobe Bridge 2020
	Win: C:\Program Files\Adobe\Adobe Bridge 2020\Bridge.exe

## Version

*	10.0.0.124
	*	Mac
		*	0x1005A3DB1: 84 DB -> B3 01
		*	find: 0F B7 5F 08 **84 DB** 0F 84 EE 00 00 00 80 FB 07 -> 0F B7 5F 08 **B3 01** 0F 84 EE 00 00 00 80 FB 07
	*	Win
		*	0x140A2BE03: 84 C0 -> B0 01
		*	find: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07

# An

## File

	Mac: /Applications/Adobe Animate 2020/Adobe Animate 2020.app/Contents/MacOS/Adobe Animate 2020
	Win: C:\Program Files\Adobe\Adobe Animate 2020\Animate.exe

## Version

*	20.0.0.17400
	*	Mac
		*	0x1000C5DB2: 66 25 FF 00 -> 90 90 B0 01
		*	find: 41 0F B7 5E 08 **84 DB** 0F 84 F0 00 00 00 80 FB 07 -> 41 0F B7 5E 08 **B3 01** 0F 84 F0 00 00 00 80 FB 07
	*	Win
		*	0x14047FBAD: 84 C0 -> B0 01
		*	find: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07

# Dw

## File

	Mac: /Applications/Adobe Dreamweaver 2020/Adobe Dreamweaver 2020.app/Contents/MacOS/Dreamweaver
	Win: C:\Program Files\Adobe\Adobe Dreamweaver 2020\Dreamweaver.exe

## Version

*	20.0.0.15196
	*	Mac
		*	0x10176DA52: 84 DB -> B3 01
		*	find: 66 41 8B 5D 08 **84 DB** 74 09 80 FB 07 -> 66 41 8B 5D 08 **B3 01** 74 09 80 FB 07
	*	Win
		*	0xA62BA3: 84 C0 -> B0 01
		*	find: 0F B6 41 08 **84 C0** 0F 84 AB 00 00 00 3C 07 -> 0F B6 41 08 **B0 01** 0F 84 AB 00 00 00 3C 07

# Dn

## File

	Mac: /Applications/Adobe Dimension/Adobe Dimension.app/Contents/Frameworks/euclid-core-plugin.pepper
	Win: C:\Program Files\Adobe\Adobe Dimension\euclid-core-plugin.pepper

## Version

*	3.0
	*	Mac
		*	0x4589FC2: 84 DB -> B3 01
		*	find: 66 41 8B 5E 08 **84 DB** 0F 84 0F 01 00 00 80 FB 07 -> 66 41 8B 5E 08 **B3 01** 0F 84 0F 01 00 00 80 FB 07
	*	Win
		*	0x18204481D: 84 C0 -> B0 01
		*	find: 8B 05 92 C9 C1 02 48 33 C4 48 89 85 A8 00 00 00 49 8B F8 4C 8B FA 4C 8B E1 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 8B 05 92 C9 C1 02 48 33 C4 48 89 85 A8 00 00 00 49 8B F8 4C 8B FA 4C 8B E1 0F B6 41 08 **B0 01** 74 0A 3C 07

# Acrobat

## File

	Mac: /Applications/Adobe Acrobat DC/Adobe Acrobat.app/Contents/Frameworks/Acrobat.framework/Versions/A/Acrobat
	Win: C:\Program Files (x86)\Adobe\Acrobat DC\Acrobat\Acrobat.dll

## Version

*	19.012.20040
	*	Mac
		*	find: 66 41 8B 5E 08 **84 DB** 74 09 80 FB 07 -> 66 41 8B 5E 08 **B3 01** 74 09 80 FB 07
	*	Win
		*	find: 8A 43 08 **84 C0** 74 0A 3C 07 -> 8A 43 08 **B0 01** 74 0A 3C 07
