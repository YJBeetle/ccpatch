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

## Lr

* File

        Mac: /Applications/Adobe Lightroom Classic/Adobe Lightroom Classic.app/Contents/MacOS/Adobe Lightroom Classic
        Win: C:\Program Files\Adobe\Adobe Lightroom Classic\Lightroom.exe

## Ai

* File

        Mac: /Applications/Adobe Illustrator 2021/Adobe Illustrator.app/Contents/MacOS/Adobe Illustrator
        Win: C:\Program Files\Adobe\Adobe Illustrator 2021\Support Files\Contents\Windows\Illustrator.exe

## Id

* File

        Mac: /Applications/Adobe InDesign/Adobe InDesign.app/Contents/MacOS/PublicLib.dylib
        Win: C:\Program Files\Adobe\Adobe InDesign\Public.dll

## Ic

* File

        Mac: /Applications/Adobe InCopy/Adobe InCopy.app/Contents/MacOS/PublicLib.dylib
        Win: C:\Program Files\Adobe\Adobe InCopy\Public.dll

## Au

* File

        Mac: /Applications/Adobe Audition/Adobe Audition.app/Contents/Frameworks/AuUI.framework/Versions/A/AuUI
        Win: C:\Program Files\Adobe\Adobe Audition\AuUI.dll

## Pr

* File

        Mac: /Applications/Adobe Premiere Pro 2020/Adobe Premiere Pro 2020.app/Contents/Frameworks/Registration.framework/Versions/A/Registration
        Win: C:\Program Files\Adobe\Adobe Premiere Pro\Registration.dll

## Pl

* File

        Mac: /Applications/Adobe Prelude/Adobe Prelude.app/Contents/Frameworks/Registration.framework/Versions/A/Registration
        Win: C:\Program Files\Adobe\Adobe Prelude\Registration.dll

## Ch

* File

        Mac: /Applications/Adobe Character Animator/Adobe Character Animator.app/Contents/MacOS/Character Animator
        Win: C:\Program Files\Adobe\Adobe Character Animator\Support Files\Character Animator.exe

## Ae

* File

        Mac: /Applications/Adobe After Effects 2020/Adobe After Effects 2020.app/Contents/Frameworks/AfterFXLib.framework/Versions/A/AfterFXLib
        Win: C:\Program Files\Adobe\Adobe After Effects 2020\Support Files\AfterFXLib.dll

## Me

* File

        Mac: /Applications/Adobe Media Encoder 2020/Adobe Media Encoder 2020.app/Contents/MacOS/Adobe Media Encoder
        Win: C:\Program Files\Adobe\Adobe Media Encoder\Adobe Media Encoder.exe

## Br

* File

        Mac: /Applications/Adobe Bridge/Adobe Bridge.app/Contents/MacOS/Adobe Bridge
        Win: C:\Program Files\Adobe\Adobe Bridge\Bridge.exe

## An

* File

        Mac: /Applications/Adobe Animate/Adobe Animate.app/Contents/MacOS/Adobe Animate
        Win: C:\Program Files\Adobe\Adobe Animate\Animate.exe

## Dw

* File

        Mac: /Applications/Adobe Dreamweaver/Adobe Dreamweaver.app/Contents/MacOS/Dreamweaver
        Win: C:\Program Files\Adobe\Adobe Dreamweaver\Dreamweaver.exe

## Dn

* File

        Mac: /Applications/Adobe Dimension/Adobe Dimension.app/Contents/Frameworks/euclid-core-plugin.pepper
        Win: C:\Program Files\Adobe\Adobe Dimension\euclid-core-plugin.pepper

## Acrobat

* File

        Mac: /Applications/Adobe Acrobat DC/Adobe Acrobat.app/Contents/Frameworks/Acrobat.framework/Versions/A/Acrobat
        Win: C:\Program Files (x86)\Adobe\Acrobat DC\Acrobat\Acrobat.dll
