#!/usr/bin/env python3
import sys
import os
import mmap
import struct
import collections
import hashlib
import shutil

FAT_MAGIC = 0xcafebabe
FAT_CIGAM = 0xbebafeca

fat_header = collections.namedtuple(
    'fat_header',
    'magic nfat_arch')
fat_header_struct = '<II'
fat_header_struct_BE = '>II'

CPU_ARCH_ABI64 = 0x01000000
CPU_TYPE_X86 = 7
CPU_TYPE_X86_64 = CPU_TYPE_X86 | CPU_ARCH_ABI64
CPU_TYPE_ARM = 12
CPU_TYPE_ARM64 = CPU_TYPE_ARM | CPU_ARCH_ABI64

fat_arch = collections.namedtuple(
    'fat_arch',
    'cputype cpusubtype offset size align')
fat_arch_struct = '<iiIII'
fat_arch_struct_BE = '>iiIII'

MH_MAGIC_64 = 0xfeedfacf
MH_CIGAM_64 = 0xcffaedfe
MH_EXECUTE = 0x2
MH_DYLIB = 0x6
LC_SEGMENT_64 = 0x19

mach_header_64 = collections.namedtuple(
    'mach_header_64',
    'magic cputype cpusubtype filetype ncmds sizeofcmds flags reserved')
mach_header_64_struct = '<IiiIIIII'
mach_header_64_struct_BE = '>IiiIIIII'

load_command = collections.namedtuple('load_command', 'cmd cmdsize')
load_command_struct = '<II'
load_command_struct_BE = '>II'

segment_command_64 = collections.namedtuple(
    'segment_command_64',
    'cmd cmdsize segname vmaddr vmsize fileoff filesize maxprot initprot nsects flags')
segment_command_64_struct = '<II16sQQQQiiII'
segment_command_64_struct_BE = '>II16sQQQQiiII'

section_64 = collections.namedtuple(
    'section_64',
    'sectname segname addr size offset align reloff nreloc flags reserved1 reserved2 reserved3')
section_64_struct = '<16s16sQQIIIIIIII'
section_64_struct_BE = '>16s16sQQIIIIIIII'

patchsData = [
    {
        'funcTrait': {
            'cpuType': CPU_TYPE_X86_64,
            'type': 'callKeyword',
            'opPrefix': bytes([0x48, 0x8D, 0x35]), # LeaEsi
            'keywordString': b"PROFILE_AVAILABLE",
            'functionSplitUp': bytes([0xC3, 0x55]),
            'functionSplitDown': bytes([0xC3, 0x55]),
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
    patched = 0
    with open(path, "r+b") as f:
        mm = mmap.mmap(f.fileno(), 0)

        global fat_header_struct
        global fat_arch_struct
        fatHeader = fat_header._make(
            struct.unpack(fat_header_struct,
                          mm[:struct.calcsize(fat_header_struct)]))
        if fatHeader.magic == FAT_CIGAM:
            fat_header_struct = fat_header_struct_BE
            fat_arch_struct = fat_arch_struct_BE
            fatHeader = fat_header._make(
                struct.unpack(fat_header_struct,
                              mm[:struct.calcsize(fat_header_struct)]))
        machOffsetList = []
        if fatHeader.magic == FAT_MAGIC:
            # print(fatHeader)
            fatArchOffset = 0 + struct.calcsize(fat_header_struct)
            for nfatArch in range(0, fatHeader.nfat_arch):
                fatArch = fat_arch._make(
                    struct.unpack(fat_arch_struct,
                                  mm[fatArchOffset:fatArchOffset+struct.calcsize(fat_arch_struct)]))
                # print(fatArch)
                fatArchOffset += struct.calcsize(fat_arch_struct)
                machOffsetList.append({"start": fatArch.offset, "end": fatArch.offset+fatArch.size})
        else:
            machOffsetList.append({"start": 0, "end": mm.size})

        for machOffset in machOffsetList:
            global mach_header_64_struct
            global load_command_struct
            global segment_command_64_struct
            global section_64_struct
            machHeader = mach_header_64._make(
                struct.unpack(mach_header_64_struct,
                            mm[machOffset['start']:machOffset['start']+struct.calcsize(mach_header_64_struct)]))
            if machHeader.magic == MH_CIGAM_64:
                mach_header_64_struct = mach_header_64_struct_BE
                load_command_struct = load_command_struct_BE
                segment_command_64_struct = segment_command_64_struct_BE
                section_64_struct = section_64_struct_BE
            # print(machHeader)
            if machHeader.magic != MH_MAGIC_64:
                print("Error: Unknow magic number.", file=sys.stderr)
                continue
            if machHeader.cputype != CPU_TYPE_X86_64 and machHeader.cputype != CPU_TYPE_ARM64:
                print("Error: Unknow CPU type.", file=sys.stderr)
                continue
            if machHeader.filetype != MH_EXECUTE and machHeader.filetype != MH_DYLIB:
                print("Error: Not executable or library.", file=sys.stderr)
                continue
            cmdOffset = machOffset['start'] + struct.calcsize(mach_header_64_struct)
            textAddress = 0
            textOffset = 0
            textOffsetEnd = 0
            cstringAddress = 0
            cstringOffset = 0
            cstringOffsetEnd = 0
            for ncmd in range(0, machHeader.ncmds):
                cmd = load_command._make(
                    struct.unpack(load_command_struct,
                                mm[cmdOffset:cmdOffset+struct.calcsize(load_command_struct)]))
                # print(cmd)
                if cmd.cmd == LC_SEGMENT_64:
                    cmd = segment_command_64._make(
                        struct.unpack(segment_command_64_struct,
                                    mm[cmdOffset:cmdOffset+struct.calcsize(segment_command_64_struct)]))
                    # print(cmd)
                    nsectOffset = cmdOffset + struct.calcsize(segment_command_64_struct)
                    for nsect in range(0, cmd.nsects):
                        sect = section_64._make(
                            struct.unpack(section_64_struct,
                                        mm[nsectOffset:nsectOffset+struct.calcsize(section_64_struct)]))
                        if sect.sectname.decode("ascii").startswith("__text"):
                            textAddress = sect.addr
                            textOffset = machOffset['start'] + sect.offset
                            textOffsetEnd = textOffset + sect.size
                        elif sect.sectname.decode("ascii").startswith("__cstring"):
                            cstringAddress = sect.addr
                            cstringOffset = machOffset['start'] + sect.offset
                            cstringOffsetEnd = cstringOffset + sect.size
                        nsectOffset += struct.calcsize(section_64_struct)
                cmdOffset += cmd.cmdsize
            # print("textAddress: 0x%x" % textAddress)
            # print("textOffset: 0x%x" % textOffset)
            # print("textOffsetEnd: 0x%x" % textOffsetEnd)
            # print("cstringAddress: 0x%x" % cstringAddress)
            # print("cstringOffset: 0x%x" % cstringOffset)
            # print("cstringOffsetEnd: 0x%x" % cstringOffsetEnd)
            if textOffset == 0 or textOffsetEnd == 0:
                print("Error: '__text' not found.", file=sys.stderr)
                continue
            for patchData in patchsData:
                if patchData['funcTrait']['cpuType'] != machHeader.cputype:
                    continue
                funcOffsetList = []
                if patchData['funcTrait']['type'] == 'callKeyword':
                    opPrefixLen = len(patchData['funcTrait']['opPrefix'])
                    opLen = opPrefixLen + 4
                    if cstringOffset == 0 or cstringOffsetEnd == 0:
                        print("Error: '__cstring' not found.", file=sys.stderr)
                        continue
                    strOffset = mm.find(patchData['funcTrait']['keywordString'],
                                        cstringOffset, cstringOffsetEnd)
                    if strOffset == -1:
                        print("Error: Keyword String '%s' not found." % patchData['funcTrait']['keywordString'], file=sys.stderr)
                        continue
                    strAddress = cstringAddress + (strOffset - cstringOffset)
                    # print("strOffset: 0x%x" % strOffset)
                    # print("strAddress: 0x%x" % strAddress)
                    callKeywordOffset = textOffset
                    while True:
                        callKeywordOffset = mm.find(patchData['funcTrait']['opPrefix'], callKeywordOffset, textOffsetEnd)
                        if callKeywordOffset == -1:
                            break
                        callKeywordAddress = textAddress + (callKeywordOffset - textOffset)
                        # print("callKeywordOffset: %x" % callKeywordOffset)
                        # print("callKeywordAddress: %x" % callKeywordAddress)
                        op, = struct.unpack("@I", mm[callKeywordOffset+opPrefixLen:callKeywordOffset+opLen])
                        if callKeywordAddress+opLen+op == strAddress:
                            # print("OK!")
                            start = mm.rfind(patchData['funcTrait']['functionSplitUp'], textOffset, callKeywordOffset)
                            end = mm.find(patchData['funcTrait']['functionSplitDown'], callKeywordOffset+opLen, textOffsetEnd)
                            if start != -1 and end != -1:
                                funcOffsetList.append({"start": start, "end": end})
                        callKeywordOffset += opLen
                else:
                    print("Error: Unknow funstion trait type.", file=sys.stderr)
                for funcOffset in funcOffsetList:
                    for patchPoint in patchData['patchPointList']:
                        patchPointOffset = mm.find(patchPoint['find'], funcOffset['start'], funcOffset['end'])
                        if patchPointOffset == -1:
                            print("Error: %s not found." % str(patchPoint['find']), file=sys.stderr)
                            continue
                        mm[patchPointOffset:patchPointOffset + len(patchPoint['find'])] = patchPoint['replace']
                        patched+=1
            # print(patched)
        mm.close()
    return patched


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
