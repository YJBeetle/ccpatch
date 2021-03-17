#!/usr/bin/env python3
import sys
import os
import mmap
import struct
import collections
import hashlib
import shutil

MH_MAGIC_64 = 0xfeedfacf
MH_EXECUTE = 0x2
MH_DYLIB = 0x6
LC_SEGMENT_64 = 0x19

mach_header_64 = collections.namedtuple(
    'mach_header_64',
    'magic cputype cpusubtype filetype ncmds sizeofcmds flags reserved')
mach_header_64_struct = '@IiiIIIII'

load_command = collections.namedtuple('load_command', 'cmd cmdsize')
load_command_struct = '@II'

segment_command_64 = collections.namedtuple(
    'segment_command_64',
    'cmd cmdsize segname vmaddr vmsize fileoff filesize maxprot initprot nsects flags')
segment_command_64_struct = '@II16sQQQQiiII'

section_64 = collections.namedtuple(
    'section_64',
    'sectname segname addr size offset align reloff nreloc flags reserved1 reserved2 reserved3')
section_64_struct = '@16s16sQQIIIIIIII'

patchsData = [
    {
        'funcTrait': {
            'type': 'callLeaEsiKeyword',
            'keywordString': b"PROFILE_AVAILABLE"
        },
        'patchPointList': [
            {'find': bytes([0xB8, 0x92, 0x01, 0x00, 0x00]), 'replace': bytes([0x90, 0x90, 0x90, 0x31, 0xC0])},
            {'find': bytes([0xB8, 0x93, 0x01, 0x00, 0x00]), 'replace': bytes([0x90, 0x90, 0x90, 0x31, 0xC0])},
            {'find': bytes([0xB8, 0x94, 0x01, 0x00, 0x00]), 'replace': bytes([0x90, 0x90, 0x90, 0x31, 0xC0])},
            {'find': bytes([0xB8, 0x95, 0x01, 0x00, 0x00]), 'replace': bytes([0x90, 0x90, 0x90, 0x31, 0xC0])},
            {'find': bytes([0xB8, 0x96, 0x01, 0x00, 0x00]), 'replace': bytes([0x90, 0x90, 0x90, 0x31, 0xC0])},
            {'find': bytes([0xB8, 0x97, 0x01, 0x00, 0x00]), 'replace': bytes([0x90, 0x90, 0x90, 0x31, 0xC0])},
            {'find': bytes([0xB9, 0x98, 0x01, 0x00, 0x00]), 'replace': bytes([0x90, 0x90, 0x90, 0x31, 0xC9])},
        ]
    },
]

def patch(path: str):
    with open(path, "r+b") as f:
        textAddress = 0
        textOffset = 0
        textOffsetEnd = 0
        cstringAddress = 0
        cstringOffset = 0
        cstringOffsetEnd = 0
        mm = mmap.mmap(f.fileno(), 0)
        header = mach_header_64._make(
            struct.unpack(mach_header_64_struct,
                          mm[:struct.calcsize(mach_header_64_struct)]))
        # print(header)
        if header.magic == MH_MAGIC_64 and (header.filetype == MH_EXECUTE or header.filetype == MH_DYLIB):
            ncmdOffset = 32
            for ncmd in range(0, header.ncmds):
                cmd = load_command._make(
                    struct.unpack(load_command_struct,
                                  mm[ncmdOffset:ncmdOffset+struct.calcsize(load_command_struct)]))
                # print(cmd)
                if cmd.cmd == LC_SEGMENT_64:
                    cmd = segment_command_64._make(
                        struct.unpack(segment_command_64_struct,
                                      mm[ncmdOffset:ncmdOffset+struct.calcsize(segment_command_64_struct)]))
                    # print(cmd)
                    nsectOffset = ncmdOffset + struct.calcsize(segment_command_64_struct)
                    for nsect in range(0, cmd.nsects):
                        sect = section_64._make(
                            struct.unpack(section_64_struct,
                                          mm[nsectOffset:nsectOffset+struct.calcsize(section_64_struct)]))
                        if sect.sectname.decode("ascii").startswith("__text"):
                            textAddress = sect.addr
                            textOffset = sect.offset
                            textOffsetEnd = textOffset + sect.size
                        elif sect.sectname.decode("ascii").startswith("__cstring"):
                            cstringAddress = sect.addr
                            cstringOffset = sect.offset
                            cstringOffsetEnd = cstringOffset + sect.size
                        nsectOffset += struct.calcsize(section_64_struct)
                ncmdOffset += cmd.cmdsize
        if textOffset and textOffsetEnd:
            patched = 0
            for patchData in patchsData:
                funcOffsetList = []
                if patchData['funcTrait']['type'] == 'callLeaEsiKeyword':
                    if cstringOffset and cstringOffsetEnd:
                        addressDifferenceForTextAndCstring = (cstringAddress - cstringOffset) - (textAddress - textOffset)
                        strOffset = mm.find(patchData['funcTrait']['keywordString'],
                                            cstringOffset, cstringOffsetEnd)
                        if strOffset:
                            callKeywordOffset = textOffset
                            while True:
                                callKeywordOffset = mm.find(bytes([0x48, 0x8D, 0x35]), callKeywordOffset, textOffsetEnd)
                                if callKeywordOffset == -1:
                                    break
                                op, = struct.unpack("@I", mm[callKeywordOffset + 3: callKeywordOffset + 7])
                                if callKeywordOffset + 7 + op - addressDifferenceForTextAndCstring == strOffset:
                                    start = mm.rfind(bytes([0xC3, 0x55]), textOffset, callKeywordOffset)
                                    end = mm.find(bytes([0xC3, 0x55]), callKeywordOffset + 7, textOffsetEnd)
                                    if start != -1 and end != -1:
                                        funcOffsetList.append({"start": start, "end": end})
                                callKeywordOffset += 7
                        else:
                            print("Error: Keyword String '%s' not found." % patchData['funcTrait']['keywordString'], file=sys.stderr)
                    else:
                        print("Error: '__cstring' not found.", file=sys.stderr)
                else:
                    print("Error: Unknow funstion trait type.", file=sys.stderr)
                for funcOffset in funcOffsetList:
                    for patchPoint in patchData['patchPointList']:
                        patchPointOffset = mm.find(patchPoint['find'], funcOffset['start'], funcOffset['end'])
                        if patchPointOffset != -1:
                            mm[patchPointOffset:patchPointOffset + len(patchPoint['find'])] = patchPoint['replace']
                            patched+=1
                        else:
                            print("Error: %s not found." % str(patchPoint['find']), file=sys.stderr)
            return patched
        else:
            print("Error: '__text' not found.", file=sys.stderr)
        mm.close()
    return False


appList = {
    "ps": {
        "paths": [
            "/Applications/Adobe Photoshop 2020/Adobe Photoshop 2020.app/Contents/MacOS/Adobe Photoshop 2020",
            "/Applications/Adobe Photoshop 2021/Adobe Photoshop 2021.app/Contents/MacOS/Adobe Photoshop 2021",
        ]
    },
    "lr": {
        "paths": [
            "/Applications/Adobe Lightroom Classic/Adobe Lightroom Classic.app/Contents/MacOS/Adobe Lightroom Classic",
        ]
    },
    "ai": {
        "paths": [
            "/Applications/Adobe Illustrator 2020/Adobe Illustrator.app/Contents/MacOS/Adobe Illustrator",
            "/Applications/Adobe Illustrator 2021/Adobe Illustrator.app/Contents/MacOS/Adobe Illustrator",
        ]
    },
    "id": {
        "paths": [
            "/Applications/Adobe InDesign 2020/Adobe InDesign 2020.app/Contents/MacOS/PublicLib.dylib",
            "/Applications/Adobe InDesign 2021/Adobe InDesign 2021.app/Contents/MacOS/PublicLib.dylib",
        ]
    },
    "ic": {
        "paths": [
            "/Applications/Adobe InCopy 2020/Adobe InCopy 2020.app/Contents/MacOS/PublicLib.dylib",
            "/Applications/Adobe InCopy 2021/Adobe InCopy 2021.app/Contents/MacOS/PublicLib.dylib",
        ]
    },
    "au": {
        "paths": [
            "/Applications/Adobe Audition 2020/Adobe Audition 2020.app/Contents/Frameworks/AuUI.framework/Versions/A/AuUI",
            "/Applications/Adobe Audition 2021/Adobe Audition 2021.app/Contents/Frameworks/AuUI.framework/Versions/A/AuUI",
        ]
    },
    "pr": {
        "paths": [
            "/Applications/Adobe Premiere Pro 2020/Adobe Premiere Pro 2020.app/Contents/Frameworks/Registration.framework/Versions/A/Registration",
            "/Applications/Adobe Premiere Pro 2021/Adobe Premiere Pro 2021.app/Contents/Frameworks/Registration.framework/Versions/A/Registration",
        ]
    },
    "pl": {
        "paths": [
            "/Applications/Adobe Prelude 2020/Adobe Prelude 2020.app/Contents/Frameworks/Registration.framework/Versions/A/Registration",
            "/Applications/Adobe Prelude 2021/Adobe Prelude 2021.app/Contents/Frameworks/Registration.framework/Versions/A/Registration",
        ]
    },
    "ch": {
        "paths": [
            "/Applications/Adobe Character Animator 2020/Adobe Character Animator 2020.app/Contents/MacOS/Character Animator",
            "/Applications/Adobe Character Animator 2021/Adobe Character Animator 2021.app/Contents/MacOS/Character Animator",
        ]
    },
    "ae": {
        "paths": [
            "/Applications/Adobe After Effects 2020/Adobe After Effects 2020.app/Contents/Frameworks/AfterFXLib.framework/Versions/A/AfterFXLib",
            "/Applications/Adobe After Effects 2021/Adobe After Effects 2021.app/Contents/Frameworks/AfterFXLib.framework/Versions/A/AfterFXLib",
        ]
    },
    "me": {
        "paths": [
            "/Applications/Adobe Media Encoder 2020/Adobe Media Encoder 2020.app/Contents/MacOS/Adobe Media Encoder 2020",
            "/Applications/Adobe Media Encoder 2021/Adobe Media Encoder 2021.app/Contents/MacOS/Adobe Media Encoder 2021",
        ]
    },
    "br": {
        "paths": [
            "/Applications/Adobe Bridge 2020/Adobe Bridge 2020.app/Contents/MacOS/Adobe Bridge",
            "/Applications/Adobe Bridge 2021/Adobe Bridge 2021.app/Contents/MacOS/Adobe Bridge",
        ]
    },
    "an": {
        "paths": [
            "/Applications/Adobe Animate 2020/Adobe Animate 2020.app/Contents/MacOS/Adobe Animate",
            "/Applications/Adobe Animate 2021/Adobe Animate 2021.app/Contents/MacOS/Adobe Animate",
        ]
    },
    "dw": {
        "paths": [
            "/Applications/Adobe Dreamweaver 2020/Adobe Dreamweaver 2020.app/Contents/MacOS/Dreamweaver",
            "/Applications/Adobe Dreamweaver 2021/Adobe Dreamweaver 2021.app/Contents/MacOS/Dreamweaver",
        ]
    },
    "dn": {
        "paths": [
            "/Applications/Adobe Dimension/Adobe Dimension.app/Contents/Frameworks/euclid-core-plugin.pepper",
        ]
    },
    "acrobat": {
        "paths": [
            "/Applications/Adobe Acrobat DC/Adobe Acrobat.app/Contents/Frameworks/Acrobat.framework/Versions/A/Acrobat",
        ]
    },
}


def verify_patched_hash(path: str):
    if os.path.exists("%s.patched.sha1" % path):
        with open("%s.patched.sha1" % path, "r") as fp:
            hashed = fp.read()
        with open(path, "rb") as fp:
            original = hashlib.sha1(fp.read()).hexdigest()
        return hashed == original
    return False


def patchPath(path: str):
    if os.path.exists(path):
        print("Found and patching %s" % app)
        if os.path.exists('%s.bak' % path) and verify_patched_hash(path):
            print("Already patched, skipped.")
            return
        shutil.move(path, '%s.bak' % path)
        shutil.copy('%s.bak' % path, path)
        print("Backup succeeded.")
        patched = patch(path)
        if patched:
            with open(path, "rb") as f:
                with open('%s.patched.sha1' % path, "w") as fp:
                    fp.write(hashlib.sha1(f.read()).hexdigest())
            print("Patch succeeded, patched point: %d" % patched)
        else:
            print("Patch faild.")

def patchApp(app: str):
    if app in appList:
        paths = appList[app.lower()]["paths"]
        for path in paths:
            patchPath(path)
    else:
        patchPath(app)

def restoreApp(app: str):
    if app in appList:
        path = appList[app.lower()]["path"]
    else:
        path = app
    if os.path.exists('%s.bak' % path):
        print("Found and restore %s" % app)
        shutil.move("%s.bak" % path, path)
        if os.path.exists('%s.patched.sha1' % path):
            os.remove("%s.patched.sha1" % path)
        print("Restore succeeded.")
    else:
        print("The backup file does not exist, skipped.")


if __name__ == '__main__':
    if os.geteuid():
        print("Privilege is not sufficient, elevating...")
        args = [sys.executable] + sys.argv
        os.execlp('sudo', 'sudo', *args)

    if len(sys.argv) > 1:
        if sys.argv[1].lower() == "restore":
            if len(sys.argv) > 2:
                for app in sys.argv[2:]:
                    restoreApp(app)
            else:
                for app in appList:
                    restoreApp(app)
        else:
            for app in sys.argv[1:]:
                patchApp(app)
    else:
        for app in appList:
            patchApp(app)
