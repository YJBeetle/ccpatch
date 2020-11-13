# CCpatch

## Way A

BUG: Memory leak on

1.
    Find `adobe::ngl::internal::Json::Value::resolveReference(char const*, char const*)` or `Json::Value::resolveReference(char const*, char const*)`

    This function has string: `in Json::Value::resolveReference(key, end): requires objectValue` Value name: `aInJsonValueRes`

2.
    Find first instruction looks like

        TEST    xx, xx
        JZ      xxx

3.
    Change to

        MOV     xx, 0x1
        JZ      xxx

## Way B

Only Ae Pr and Pl is work.

This is the best way.

Not work on 2021

1.
    Find function `licensingglue::ValidateLicense`

    This function has string: `FREEMIUM` Value name: `aFreemium`

2.
    In mac, find instruction looks like

        cmp     [rbp+var_178], rdx
        setz    cl
        cmp     [rbp+var_180], eax
        setz    al
        and     al, cl
        mov     cs:byte_????????, al

    In win, find instruction looks like

        mov     rcx, [rax+8]
        mov     rax, [rsp+14F0h+var_1490]
        cmp     [rax+8], rcx
        jnz     short label_1
        mov     eax, dword ptr [rsp+14F0h+var_14A8]
        cmp     [rsp+14F0h+var_1498], eax
        jnz     short label_1
        mov     al, 1
        jmp     short label_2
        label_1:
        xor     al, al
        label_2:
        mov     cs:byte_????????, al

    Pseudocode:

        v78 = v138 == v80 && v137 == v79;
        byte_???????? = v78

3.
    Change to

        mov     al, 1
        mov     cs:byte_????????, al

## Way C

Must be online and login

1.
    Find `adobe::ngl::internal::SecureProfilePayload::GetProfileStatusCode(adobe::ngl::internal::SecureProfilePayload *this)`

    This function has string: `PROFILE_AVAILABLE` Value name: `aProfileAvailab`

    eg. Lr Mac 9.2.1

        #0  0x00000001000d2494 in adobe::ngl::internal::SecureProfilePayload::GetProfileStatusCode() const ()
        #1  0x00000001000f304f in adobe::ngl::internal::NUSecureProfileFetcher::ValidateAndGetCachedSP() const ()
        #2  0x00000001000d4c1f in adobe::ngl::internal::NUCachedSecureProfileHandler::Handle(std::__1::unique_ptr<adobe::ngl::WorkflowResult, std::__1::default_delete<adobe::ngl::WorkflowResult> >) ()
        #3  0x00000001000d4bab in adobe::ngl::internal::NUCachedSecureProfileHandler::Handle() ()
        #4  0x00000001001253ed in adobe::ngl::internal::SecureProfileManager::GetCachedSecureProfile() ()
        #5  0x000000010012aed1 in adobe::ngl::NglAppLib::GetCachedNglProfile() ()
        #6  0x000000010007e023 in NglService::RequestCachedProfile() ()
        #7  0x000000010001163e in adobe::nglcontroller::NglController::GetCachedProfile() ()
        #8  0x000000010003414b in adobe::nglcontroller::NglController::GetRegistrationInfo() ()
        #9  0x00000001000340a0 in adobe::nglcontroller::NglController::GetRegistrationInfo() ()
        #10 0x000000010003428f in adobe::nglcontroller::NglController::GetRegistrationInfo() ()
        #11 0x00007fff6c114109 in ?? ()
        #12 0x0000000000000000 in ?? ()

    and

        #0  0x00000001000d2494 in adobe::ngl::internal::SecureProfilePayload::GetProfileStatusCode() const ()
        #1  0x00000001000f500d in adobe::ngl::internal::NUSecureProfileFetcher::ValidateAndGetPrefetchedSP() const ()
        #2  0x00000001000d4e3d in adobe::ngl::internal::NUCachedSecureProfileHandler::ValidateAndGetPrefetchedProfile() ()
        #3  0x00000001001253cb in adobe::ngl::internal::SecureProfileManager::GetPrefetchedSecureProfile() ()
        #4  0x000000010012a965 in adobe::ngl::NglAppLib::GetPrefetchedNglProfile() ()
        #5  0x000000010007e047 in NglService::RequestPrefetchedProfile() ()
        #6  0x000000010001164f in adobe::nglcontroller::NglController::GetCachedProfile() ()
        #7  0x000000010003414b in adobe::nglcontroller::NglController::GetRegistrationInfo() ()
        #8  0x00000001000340a0 in adobe::nglcontroller::NglController::GetRegistrationInfo() ()
        #9  0x000000010003428f in adobe::nglcontroller::NglController::GetRegistrationInfo() ()
        #10 0x00007fff6c114109 in ?? ()
        #11 0x0000000000000000 in ?? ()

    and

        #0  0x00000001000d2494 in adobe::ngl::internal::SecureProfilePayload::GetProfileStatusCode() const ()
        #1  0x00000001000e8cd3 in adobe::ngl::internal::NUSecureProfileFetcher::ProcessAsnp(std::__1::unique_ptr<adobe::ngl::internal::RetrievedCOP, std::__1::default_delete<adobe::ngl::internal::RetrievedCOP> >, std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char> > const&, bool) const ()
        #2  0x00000001000ee3a8 in adobe::ngl::internal::NUSecureProfileFetcher::GetDeviceTokenAndProfile(std::__1::unique_ptr<adobe::ngl::WorkflowResult, std::__1::default_delete<adobe::ngl::WorkflowResult> >, adobe::ngl::internal::GetLatestCallSequence const&) const ()
        #3  0x000000010007ba83 in adobe::ngl::internal::NULatestSecureProfileHandler::Handle(std::__1::unique_ptr<adobe::ngl::WorkflowResult, std::__1::default_delete<adobe::ngl::WorkflowResult> >, adobe::ngl::internal::GetLatestCallSequence const&, adobe::ngl::internal::GetProfileType const&) ()
        #4  0x000000010012541f in adobe::ngl::internal::SecureProfileManager::GetLatestSecureProfile(std::__1::unique_ptr<adobe::ngl::WorkflowResult, std::__1::default_delete<adobe::ngl::WorkflowResult> >, adobe::ngl::internal::GetLatestCallSequence const&, adobe::ngl::internal::GetProfileType const&) ()
        #5  0x000000010012b41a in adobe::ngl::NglAppLib::GetLatestNglProfile(std::__1::unique_ptr<adobe::ngl::WorkflowResult, std::__1::default_delete<adobe::ngl::WorkflowResult> >, adobe::ngl::internal::GetLatestCallSequence const&, adobe::ngl::internal::GetProfileType const&) ()
        #6  0x000000010007e094 in NglService::RequestProfile(std::__1::unique_ptr<adobe::ngl::WorkflowResult, std::__1::default_delete<adobe::ngl::WorkflowResult> >, adobe::ngl::internal::GetLatestCallSequence const&, adobe::ngl::internal::GetProfileType const&) ()
        #7  0x00000001000367cc in adobe::nglcontroller::NglController::GetRegistrationInfo() ()
        #8  0x0000000100034f1c in adobe::nglcontroller::NglController::GetRegistrationInfo() ()
        #9  0x000000010003414b in adobe::nglcontroller::NglController::GetRegistrationInfo() ()
        #10 0x00000001000340a0 in adobe::nglcontroller::NglController::GetRegistrationInfo() ()
        #11 0x000000010003428f in adobe::nglcontroller::NglController::GetRegistrationInfo() ()
        #12 0x00007fff6c114109 in ?? ()
        #13 0x0000000000000000 in ?? ()

2.
    Overwrite

        xor     eax,eax
        ret

## Way D

Bypass dialog

May be killed by the watchdog

1.
    Find `adobe::nglcontroller::NglController::GetAppLicenseMode()`

    This function has string: `FREEMIUM` Value name: `aFreemium`

    eg. Lr Mac 9.2.1

        #0  0x0000000100010f86 in adobe::nglcontroller::NglController::GetAppLicenseMode() ()
        #1  0x0000000100013f65 in adobe::nglcontroller::NglController::CanApplicationRun() ()
        #2  0x00000001000138d5 in adobe::nglcontroller::NglController::InitializeProfileUpdates(std::__1::function<void (unsigned long)>, std::__1::function<void (unsigned long)>, unsigned int) ()
        #3  0x00000001001213d0 in AgNglController_new_L ()
        #4  0x0000000100626fcb in ?? ()
        #5  0x0000000002c20146 in ?? ()
        #6  0x0000000000000000 in ?? ()

2.
    Find parent function `adobe::nglcontroller::NglController::CanApplicationRun`
3.
    Find first instruction looks like

        CMP     eax, 0x1
        JE      0x?

4.
    Change to

        CMP     eax, 0x1
        NOP
        JMP     0x?

---

## Ps

* File

        Mac: /Applications/Adobe Photoshop 2021/Adobe Photoshop 2021.app/Contents/MacOS/Adobe Photoshop 2021
        Win: C:\Program Files\Adobe\Adobe Photoshop 2021\Photoshop.exe

* Version
  * 22.0.0  
    Use way C
    * Mac  
      Same as [Ae](#Ae)
    * Win
      * find: **B8 92 01 00 00** E9 86 01 00 00 48 8B CB 48 83 FE 10 72 03 48 8B 0B B8 13 00 00 00 48 8D 15*1D 41 36 01*48 3B F8 4C 8B C7 4C 0F 47 C0 E8*BE A4 D3 FC*85 C0 75 10 48 83 FF 13 75 0A **B8 93 01 00 00** E9 4B 01 00 00 48 89 6C 24 30 48 8B CB 48 83 FE 10 72 03 48 8B 0B B8 0E 00 00 00 48 8D 15 F5 40 36 01 48 3B F8 48 8B EF 48 0F 47 E8 4C 8B C5 E8 7B A4 D3 FC 85 C0 75 10 48 83 FF 0E 75 0A **B8 94 01 00 00** E9 03 01 00 00 48 8B CB 48 83 FE 10 72 03 48 8B 0B B8 15 00 00 00 48 8D 15 C7 40 36 01 48 3B F8 4C 8B C7 4C 0F 47 C0 E8 40 A4 D3 FC 85 C0 75 10 48 83 FF 15 75 0A **B8 95 01 00 00** E9 C8 00 00 00 48 8B CB 48 83 FE 10 72 03 48 8B 0B B8 11 00 00 00 48 8D 15 A4 40 36 01 48 3B F8 4C 8B C7 4C 0F 47 C0 E8 05 A4 D3 FC 85 C0 75 0A 48 83 FF 11 0F 84 93 00 00 00 48 8B CB 48 83 FE 10 72 03 48 8B 0B B8 1A 00 00 00 48 8D 15 87 40 36 01 48 3B F8 4C 8B C7 4C 0F 47 C0 E8 D0 A3 D3 FC 85 C0 75 0D 48 83 FF 1A 75 07 **B8 96 01 00 00** EB 5B 48 8B CB 48 83 FE 10 72 03 48 8B 0B 4C 8B C5 48 8D 15 71 40 36 01 E8 A4 A3 D3 FC 85 C0 75 0D 48 83 FF 0E 75 07 **B8 97 01 00 00** EB 2F 48 83 FE 10 72 03 48 8B 1B 4D 8B C6 48 8D 15 58 40 36 01 48 8B CB E8 78 A3 D3 FC 85 C0 75 0B **B8 98 01 00 00**
      * repe: **B8 00 00 00 00** E9 86 01 00 00 48 8B CB 48 83 FE 10 72 03 48 8B 0B B8 13 00 00 00 48 8D 15*1D 41 36 01*48 3B F8 4C 8B C7 4C 0F 47 C0 E8*BE A4 D3 FC*85 C0 75 10 48 83 FF 13 75 0A **B8 00 00 00 00** E9 4B 01 00 00 48 89 6C 24 30 48 8B CB 48 83 FE 10 72 03 48 8B 0B B8 0E 00 00 00 48 8D 15 F5 40 36 01 48 3B F8 48 8B EF 48 0F 47 E8 4C 8B C5 E8 7B A4 D3 FC 85 C0 75 10 48 83 FF 0E 75 0A **B8 00 00 00 00** E9 03 01 00 00 48 8B CB 48 83 FE 10 72 03 48 8B 0B B8 15 00 00 00 48 8D 15 C7 40 36 01 48 3B F8 4C 8B C7 4C 0F 47 C0 E8 40 A4 D3 FC 85 C0 75 10 48 83 FF 15 75 0A **B8 00 00 00 00** E9 C8 00 00 00 48 8B CB 48 83 FE 10 72 03 48 8B 0B B8 11 00 00 00 48 8D 15 A4 40 36 01 48 3B F8 4C 8B C7 4C 0F 47 C0 E8 05 A4 D3 FC 85 C0 75 0A 48 83 FF 11 0F 84 93 00 00 00 48 8B CB 48 83 FE 10 72 03 48 8B 0B B8 1A 00 00 00 48 8D 15 87 40 36 01 48 3B F8 4C 8B C7 4C 0F 47 C0 E8 D0 A3 D3 FC 85 C0 75 0D 48 83 FF 1A 75 07 **B8 00 00 00 00** EB 5B 48 8B CB 48 83 FE 10 72 03 48 8B 0B 4C 8B C5 48 8D 15 71 40 36 01 E8 A4 A3 D3 FC 85 C0 75 0D 48 83 FF 0E 75 07 **B8 00 00 00 00** EB 2F 48 83 FE 10 72 03 48 8B 1B 4D 8B C6 48 8D 15 58 40 36 01 48 8B CB E8 78 A3 D3 FC 85 C0 75 0B **B8 00 00 00 00**

## Lr

* File

        Mac: /Applications/Adobe Lightroom Classic/Adobe Lightroom Classic.app/Contents/MacOS/Adobe Lightroom Classic
        Win: C:\Program Files\Adobe\Adobe Lightroom Classic\Lightroom.exe

* Version
  * 9.x (trying...)
    * Mac
      * 0x13EBF: 0F 84 -> 90 E9
      * find and replace: 41 B6 01 83 F8 01 **0F 84** -> 41 B6 01 83 F8 01 **90 E9**
      * ...
  * 8.3.1
    * Mac
      * 0x9A7A0: 84 DB -> B3 01
      * find and replace: 49 89 D4 49 89 F7 49 89 FE 66 41 8B 5E 08 **84 DB** 0F 84 F7 00 00 00 80 FB 07 -> 49 89 D4 49 89 F7 49 89 FE 66 41 8B 5E 08 **B3 01** 0F 84 F7 00 00 00 80 FB 07
    * Win
      * 0x1401A954C (0x1A894C): 84 C0 -> B0 01
      * find and replace: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07

## Ai

* File

        Mac: /Applications/Adobe Illustrator 2021/Adobe Illustrator.app/Contents/MacOS/Adobe Illustrator
        Win: C:\Program Files\Adobe\Adobe Illustrator\Support Files\Contents\Windows\Illustrator.exe

* Version
  * 25.0  
    Use way C
    * Mac
      * find: **B9 98 01 00 00** B8 0A 00 00 00 0F 44 C1 EB 2C **B8 92 01 00 00** EB 25 **B8 93 01 00 00** EB 1E **B8 94 01 00 00** EB 17 **B8 95 01 00 00** EB 10 31 C0 EB 0C **B8 96 01 00 00** EB 05 **B8 97 01 00 00** 48 83 C4 08 5B 5D C3
      * repe: **B9 00 00 00 00** B8 0A 00 00 00 90 31 C0 EB 2C **90 90 90 31 C0** EB 25 **90 90 90 31 C0** EB 1E **90 90 90 31 C0** EB 17 **90 90 90 31 C0** EB 10 31 C0 EB 0C **90 90 90 31 C0** EB 05 **90 90 90 31 C0** 48 83 C4 08 5B 5D C3
    * Win
      * 0x14040F660: 84 C0 -> B0 01
      * find and replace: **48 89 5C** 24 10 48 89 74 24 18 48 89 7C 24 20 41 56 48 83 EC 20 48 8B 71 58 -> **33 C0 C3** 24 10 48 89 74 24 18 48 89 7C 24 20 41 56 48 83 EC 20 48 8B 71 58

## Id

* File

        Mac: /Applications/Adobe InDesign/Adobe InDesign.app/Contents/MacOS/PublicLib.dylib
        Win: C:\Program Files\Adobe\Adobe InDesign\Public.dll

* Version
  * 15.0.0.155
    * Mac
      * 0x3393F2: 84 C0 -> B0 01
      * find and replace: 41 0F B6 47 08 **84 C0** 74 08 3C 07 -> 41 0F B6 47 08 **B0 01** 74 08 3C 07
    * Win
      * 0x1803F84FC: 84 C0 -> B0 01
      * find and replace: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07

## Ic

* File

        Mac: /Applications/Adobe InCopy/Adobe InCopy.app/Contents/MacOS/PublicLib.dylib
        Win: C:\Program Files\Adobe\Adobe InCopy\Public.dll

* Version
  * 15.0.0.155
    * Mac
      * 0x3393F2: 84 C0 -> B0 01
      * find and replace: 41 0F B6 47 08 **84 C0** 74 08 3C 07 -> 41 0F B6 47 08 **B0 01** 74 08 3C 07
    * Win
      * 0x1803F84FC: 84 C0 -> B0 01
      * find and replace: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07

## Au

* File

        Mac: /Applications/Adobe Audition/Adobe Audition.app/Contents/Frameworks/AuUI.framework/Versions/A/AuUI
        Win: C:\Program Files\Adobe\Adobe Audition\AuUI.dll

* Version
  * 13.0.0.519  
    Use way B
    * Mac
      * 0x?: ```20 C8``` -> ```B0 01```
      * find: FE FF FF 0F 94 C0 **20 C8**
      * repe:    FE FF FF 0F 94 C0 **B0 01**
    * Win
      * 0x?: ```32 C0``` -> ```B0 01```
      * find:    48 8B 48 08 48 8B 44 24 60 48 39 48 08 75 0E 8B 44 24 48 39 44 24 58 75 04 B0 01 EB 02 **32 C0**
      * repe:    48 8B 48 08 48 8B 44 24 60 48 39 48 08 75 0E 8B 44 24 48 39 44 24 58 75 04 B0 01 EB 02 **B0 01**

## Pr

* File

        Mac: /Applications/Adobe Premiere Pro/Adobe Premiere Pro.app/Contents/Frameworks/Registration.framework/Versions/A/Registration
        Win: C:\Program Files\Adobe\Adobe Premiere Pro\Registration.dll

* Version
  * 14.0  
    Use way B
    * Mac
      * 0x?: ```20 C8``` -> ```B0 01```
      * find:    FE FF FF 0F 94 C0 **20 C8**
      * repe:    FE FF FF 0F 94 C0 **B0 01**
    * Win
      * 0x?: ```32 C0``` -> ```B0 01```
      * find:    48 8B 48 08 48 8B 44 24 60 48 39 48 08 75 0E 8B 44 24 48 39 44 24 58 75 04 B0 01 EB 02 **32 C0**
      * repe:    48 8B 48 08 48 8B 44 24 60 48 39 48 08 75 0E 8B 44 24 48 39 44 24 58 75 04 B0 01 EB 02 **B0 01**

## Pl

* File

        Mac: /Applications/Adobe Prelude/Adobe Prelude.app/Contents/Frameworks/Registration.framework/Versions/A/Registration
        Win: C:\Program Files\Adobe\Adobe Prelude\Registration.dll

* Version
  * 9.0  
    Use way B
    * Mac
      * 0x?: ```20 C8``` -> ```B0 01```
      * find:    FE FF FF 0F 94 C0 **20 C8**
      * repe:    FE FF FF 0F 94 C0 **B0 01**
    * Win
      * 0x?: ```32 C0``` -> ```B0 01```
      * find:    48 8B 48 08 48 8B 44 24 60 48 39 48 08 75 0E 8B 44 24 48 39 44 24 58 75 04 B0 01 EB 02 **32 C0**
      * repe:    48 8B 48 08 48 8B 44 24 60 48 39 48 08 75 0E 8B 44 24 48 39 44 24 58 75 04 B0 01 EB 02 **B0 01**

## Ch

* File

        Mac: /Applications/Adobe Character Animator/Adobe Character Animator.app/Contents/MacOS/Character Animator
        Win: C:\Program Files\Adobe\Adobe Character Animator\Support Files\Character Animator.exe

* Version
  * 3.0  
    Use way B
    * Mac
      * 0x?: ```20 C8``` -> ```B0 01```
      * find:    FE FF FF 0F 94 C0 **20 C8**
      * repe:    FE FF FF 0F 94 C0 **B0 01**
    * Win
      * 0x?: ```32 C0``` -> ```B0 01```
      * find:    48 8B 48 08 48 8B 44 24 60 48 39 48 08 75 0E 8B 44 24 48 39 44 24 58 75 04 B0 01 EB 02 **32 C0**
      * repe:    48 8B 48 08 48 8B 44 24 60 48 39 48 08 75 0E 8B 44 24 48 39 44 24 58 75 04 B0 01 EB 02 **B0 01**

## Ae

* File

        Mac: /Applications/Adobe After Effects 2020/Adobe After Effects 2020.app/Contents/Frameworks/AfterFXLib.framework/Versions/A/AfterFXLib
        Win: C:\Program Files\Adobe\Adobe After Effects 2020\Support Files\AfterFXLib.dll

* Version
  * 17.5  
    Use way C
    * Mac
      * find: **B9 98 01 00 00** B8 0A 00 00 00 0F 44 C1 48 83 C4 08 5B 5D C3 **B8 92 01 00 00** 48 83 C4 08 5B 5D C3 **B8 93 01 00 00** 48 83 C4 08 5B 5D C3 **B8 94 01 00 00** 48 83 C4 08 5B 5D C3 **B8 95 01 00 00** 48 83 C4 08 5B 5D C3 31 C0 48 83 C4 08 5B 5D C3 **B8 96 01 00 00** 48 83 C4 08 5B 5D C3 **B8 97 01 00 00** 48 83 C4 08 5B 5D C3
      * repe: **B9 00 00 00 00** B8 0A 00 00 00 0F 44 C1 48 83 C4 08 5B 5D C3 **90 90 90 31 C0** 48 83 C4 08 5B 5D C3 **90 90 90 31 C0** 48 83 C4 08 5B 5D C3 **90 90 90 31 C0** 48 83 C4 08 5B 5D C3 **90 90 90 31 C0** 48 83 C4 08 5B 5D C3 31 C0 48 83 C4 08 5B 5D C3 **90 90 90 31 C0** 48 83 C4 08 5B 5D C3 **90 90 90 31 C0** 48 83 C4 08 5B 5D C3
    * Win
      * find: **B8 92 01 00 00** E9 86 01 00 00 48 8B CB 48 83 FE 10 72 03 48 8B 0B B8 13 00 00 00 48 8D 15 A5 16 4F 00 48 3B F8 4C 8B C7 4C 0F 47 C0 E8 D8 C6 0E 00 85 C0 75 10 48 83 FF 13 75 0A **B8 93 01 00 00** E9 4B 01 00 00 48 89 6C 24 30 48 8B CB 48 83 FE 10 72 03 48 8B 0B B8 0E 00 00 00 48 8D 15 7D 16 4F 00 48 3B F8 48 8B EF 48 0F 47 E8 4C 8B C5 E8 95 C6 0E 00 85 C0 75 10 48 83 FF 0E 75 0A **B8 94 01 00 00** E9 03 01 00 00 48 8B CB 48 83 FE 10 72 03 48 8B 0B B8 15 00 00 00 48 8D 15 4F 16 4F 00 48 3B F8 4C 8B C7 4C 0F 47 C0 E8 5A C6 0E 00 85 C0 75 10 48 83 FF 15 75 0A **B8 95 01 00 00** E9 C8 00 00 00 48 8B CB 48 83 FE 10 72 03 48 8B 0B B8 11 00 00 00 48 8D 15 2C 16 4F 00 48 3B F8 4C 8B C7 4C 0F 47 C0 E8 1F C6 0E 00 85 C0 75 0A 48 83 FF 11 0F 84 93 00 00 00 48 8B CB 48 83 FE 10 72 03 48 8B 0B B8 1A 00 00 00 48 8D 15 0F 16 4F 00 48 3B F8 4C 8B C7 4C 0F 47 C0 E8 EA C5 0E 00 85 C0 75 0D 48 83 FF 1A 75 07 **B8 96 01 00 00** EB 5B 48 8B CB 48 83 FE 10 72 03 48 8B 0B 4C 8B C5 48 8D 15 F9 15 4F 00 E8 BE C5 0E 00 85 C0 75 0D 48 83 FF 0E 75 07 **B8 97 01 00 00** EB 2F 48 83 FE 10 72 03 48 8B 1B 4D 8B C6 48 8D 15 E0 15 4F 00 48 8B CB E8 92 C5 0E 00 85 C0 75 0B **B8 98 01 00 00**
      * repe: **B8 00 00 00 00** E9 86 01 00 00 48 8B CB 48 83 FE 10 72 03 48 8B 0B B8 13 00 00 00 48 8D 15 A5 16 4F 00 48 3B F8 4C 8B C7 4C 0F 47 C0 E8 D8 C6 0E 00 85 C0 75 10 48 83 FF 13 75 0A **B8 00 00 00 00** E9 4B 01 00 00 48 89 6C 24 30 48 8B CB 48 83 FE 10 72 03 48 8B 0B B8 0E 00 00 00 48 8D 15 7D 16 4F 00 48 3B F8 48 8B EF 48 0F 47 E8 4C 8B C5 E8 95 C6 0E 00 85 C0 75 10 48 83 FF 0E 75 0A **B8 00 00 00 00** E9 03 01 00 00 48 8B CB 48 83 FE 10 72 03 48 8B 0B B8 15 00 00 00 48 8D 15 4F 16 4F 00 48 3B F8 4C 8B C7 4C 0F 47 C0 E8 5A C6 0E 00 85 C0 75 10 48 83 FF 15 75 0A **B8 00 00 00 00** E9 C8 00 00 00 48 8B CB 48 83 FE 10 72 03 48 8B 0B B8 11 00 00 00 48 8D 15 2C 16 4F 00 48 3B F8 4C 8B C7 4C 0F 47 C0 E8 1F C6 0E 00 85 C0 75 0A 48 83 FF 11 0F 84 93 00 00 00 48 8B CB 48 83 FE 10 72 03 48 8B 0B B8 1A 00 00 00 48 8D 15 0F 16 4F 00 48 3B F8 4C 8B C7 4C 0F 47 C0 E8 EA C5 0E 00 85 C0 75 0D 48 83 FF 1A 75 07 **B8 00 00 00 00** EB 5B 48 8B CB 48 83 FE 10 72 03 48 8B 0B 4C 8B C5 48 8D 15 F9 15 4F 00 E8 BE C5 0E 00 85 C0 75 0D 48 83 FF 0E 75 07 **B8 00 00 00 00** EB 2F 48 83 FE 10 72 03 48 8B 1B 4D 8B C6 48 8D 15 E0 15 4F 00 48 8B CB E8 92 C5 0E 00 85 C0 75 0B **B8 00 00 00 00**

## Me

* File

        Mac: /Applications/Adobe Media Encoder/Adobe Media Encoder.app/Contents/MacOS/Adobe Media Encoder
        Win: C:\Program Files\Adobe\Adobe Media Encoder\Adobe Media Encoder.exe

* Version
  * 14.0  
    Use way B
    * Mac
      * 0x?: ```20 C8``` -> ```B0 01```
      * find:    FE FF FF 0F 94 C0 **20 C8**
      * repe:    FE FF FF 0F 94 C0 **B0 01**
    * Win
      * 0x?: ```32 C0``` -> ```B0 01```
      * find:    48 8B 48 08 48 8B 44 24 60 48 39 48 08 75 0E 8B 44 24 48 39 44 24 58 75 04 B0 01 EB 02 **32 C0**
      * repe:    48 8B 48 08 48 8B 44 24 60 48 39 48 08 75 0E 8B 44 24 48 39 44 24 58 75 04 B0 01 EB 02 **B0 01**

## Br

* File

        Mac: /Applications/Adobe Bridge/Adobe Bridge.app/Contents/MacOS/Adobe Bridge
        Win: C:\Program Files\Adobe\Adobe Bridge\Bridge.exe

* Version
  * 10.0.0.124
    * Mac
      * 0x1005A3DB1: 84 DB -> B3 01
      * find and replace: 0F B7 5F 08 **84 DB** 0F 84 EE 00 00 00 80 FB 07 -> 0F B7 5F 08 **B3 01** 0F 84 EE 00 00 00 80 FB 07
    * Win
      * 0x140A2BE03: 84 C0 -> B0 01
      * find and replace: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07

## An

* File

        Mac: /Applications/Adobe Animate/Adobe Animate.app/Contents/MacOS/Adobe Animate
        Win: C:\Program Files\Adobe\Adobe Animate\Animate.exe

* Version
  * 20.0.0.17400
    * Mac
      * 0x1000C5DB2: 66 25 FF 00 -> 90 90 B0 01
      * find and replace: 41 0F B7 5E 08 **84 DB** 0F 84 F0 00 00 00 80 FB 07 -> 41 0F B7 5E 08 **B3 01** 0F 84 F0 00 00 00 80 FB 07
    * Win
      * 0x14047FBAD: 84 C0 -> B0 01
      * find and replace: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07

## Dw

* File

        Mac: /Applications/Adobe Dreamweaver/Adobe Dreamweaver.app/Contents/MacOS/Dreamweaver
        Win: C:\Program Files\Adobe\Adobe Dreamweaver\Dreamweaver.exe

* Version
  * 20.0.0.15196
    * Mac
      * 0x10176DA52: 84 DB -> B3 01
      * find and replace: 66 41 8B 5D 08 **84 DB** 74 09 80 FB 07 -> 66 41 8B 5D 08 **B3 01** 74 09 80 FB 07
    * Win
      * 0xA62BA3: 84 C0 -> B0 01
      * find and replace: 0F B6 41 08 **84 C0** 0F 84 AB 00 00 00 3C 07 -> 0F B6 41 08 **B0 01** 0F 84 AB 00 00 00 3C 07

## Dn

* File

        Mac: /Applications/Adobe Dimension/Adobe Dimension.app/Contents/Frameworks/euclid-core-plugin.pepper
        Win: C:\Program Files\Adobe\Adobe Dimension\euclid-core-plugin.pepper

* Version
  * 3.0
    * Mac
      * 0x4589FC2: 84 DB -> B3 01
      * find and replace: 66 41 8B 5E 08 **84 DB** 0F 84 0F 01 00 00 80 FB 07 -> 66 41 8B 5E 08 **B3 01** 0F 84 0F 01 00 00 80 FB 07
    * Win
      * 0x18204481D: 84 C0 -> B0 01
      * find and replace: 8B 05 92 C9 C1 02 48 33 C4 48 89 85 A8 00 00 00 49 8B F8 4C 8B FA 4C 8B E1 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 8B 05 92 C9 C1 02 48 33 C4 48 89 85 A8 00 00 00 49 8B F8 4C 8B FA 4C 8B E1 0F B6 41 08 **B0 01** 74 0A 3C 07

## Acrobat

* File

        Mac: /Applications/Adobe Acrobat DC/Adobe Acrobat.app/Contents/Frameworks/Acrobat.framework/Versions/A/Acrobat
        Win: C:\Program Files (x86)\Adobe\Acrobat DC\Acrobat\Acrobat.dll

* Version
  * 19.012.20040
    * Mac
      * find and replace: 66 41 8B 5E 08 **84 DB** 74 09 80 FB 07 -> 66 41 8B 5E 08 **B3 01** 74 09 80 FB 07
    * Win
      * find and replace: 8A 43 08 **84 C0** 74 0A 3C 07 -> 8A 43 08 **B0 01** 74 0A 3C 07
