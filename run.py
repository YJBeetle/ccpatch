#!/usr/bin/env python3
import sys
import os
import mmap
import struct
import collections
import hashlib
import shutil

# The 64-bit mach header appears at the very beginning of object files for 64-bit architectures.
mach_header_64 = collections.namedtuple('mach_header_64',
                                        'magic cputype cpusubtype filetype ncmds sizeofcmds flags reserved')
mach_header_64_struct = '@IiiIIIII'

# Constant for the magic field of the mach_header_64 (64-bit architectures)
MH_MAGIC_64 = 0xfeedfacf # the 64-bit mach magic number
MH_CIGAM_64 = 0xcffaedfe # NXSwapInt(MH_MAGIC_64)

# Constants for the filetype field of the mach_header
MH_OBJECT       = 0x1 # relocatable object file
MH_EXECUTE      = 0x2 # demand paged executable file
MH_FVMLIB       = 0x3 # fixed VM shared library file
MH_CORE         = 0x4 # core file
MH_PRELOAD      = 0x5 # preloaded executable file
MH_DYLIB        = 0x6 # dynamically bound shared library
MH_DYLINKER     = 0x7 # dynamic link editor
MH_BUNDLE       = 0x8 # dynamically bound bundle file
MH_DYLIB_STUB   = 0x9 # shared library stub for static linking only, no section contents
MH_DSYM         = 0xa # companion file with only debug sections
MH_KEXT_BUNDLE  = 0xb # x86_64 kexts
MH_FILESET      = 0xc # a file composed of other Mach-Os to be run in the same userspace sharing a single linkedit.

# Constants for the flags field of the mach_header
MH_NOUNDEFS                         = 0x1 # the object file has no undefined references
MH_INCRLINK                         = 0x2 # the object file is the output of an incremental link against a base file and can't be link edited again
MH_DYLDLINK                         = 0x4 # the object file is input for the dynamic linker and can't be staticly link edited again
MH_BINDATLOAD                       = 0x8 # the object file's undefined references are bound by the dynamic linker when loaded.
MH_PREBOUND                         = 0x10 # the file has its dynamic undefined references prebound.
MH_SPLIT_SEGS                       = 0x20 # the file has its read-only and read-write segments split
MH_LAZY_INIT                        = 0x40 # the shared library init routine is to be run lazily via catching memory faults to its writeable segments (obsolete)
MH_TWOLEVEL                         = 0x80 # the image is using two-level name space bindings
MH_FORCE_FLAT                       = 0x100 # the executable is forcing all images to use flat name space bindings
MH_NOMULTIDEFS                      = 0x200 # this umbrella guarantees no multiple defintions of symbols in its sub-images so the two-level namespace hints can always be used.
MH_NOFIXPREBINDING                  = 0x400 # do not have dyld notify the prebinding agent about this executable
MH_PREBINDABLE                      = 0x800 # the binary is not prebound but can have its prebinding redone. only used when MH_PREBOUND is not set.
MH_ALLMODSBOUND                     = 0x1000 # indicates that this binary binds to all two-level namespace modules of its dependent libraries. only used when MH_PREBINDABLE and MH_TWOLEVEL are both set. 
MH_SUBSECTIONS_VIA_SYMBOLS          = 0x2000# safe to divide up the sections into sub-sections via symbols for dead code stripping
MH_CANONICAL                        = 0x4000 # the binary has been canonicalized via the unprebind operation
MH_WEAK_DEFINES                     = 0x8000 # the final linked image contains external weak symbols
MH_BINDS_TO_WEAK                    = 0x10000 # the final linked image uses weak symbols
MH_ALLOW_STACK_EXECUTION            = 0x20000# When this bit is set, all stacks in the task will be given stack execution privilege. Only used in MH_EXECUTE filetypes.
MH_ROOT_SAFE                        = 0x40000 # When this bit is set, the binary declares it is safe for use in processes with uid zero 
MH_SETUID_SAFE                      = 0x80000 # When this bit is set, the binary declares it is safe for use in processes when issetugid() is true
MH_NO_REEXPORTED_DYLIBS             = 0x100000 # When this bit is set on a dylib, the static linker does not need to examine dependent dylibs to see if any are re-exported
MH_PIE                              = 0x200000 # When this bit is set, the OS will load the main executable at a random address. Only used in MH_EXECUTE filetypes.
MH_DEAD_STRIPPABLE_DYLIB            = 0x400000 # Only for use on dylibs. When linking against a dylib that has this bit set, the static linker will automatically not create a LC_LOAD_DYLIB load command to the dylib if no symbols are being referenced from the dylib.
MH_HAS_TLV_DESCRIPTORS              = 0x800000 # Contains a section of type S_THREAD_LOCAL_VARIABLES
MH_NO_HEAP_EXECUTION                = 0x1000000 # When this bit is set, the OS will run the main executable with a non-executable heap even on platforms (e.g. i386) that don't require it. Only used in MH_EXECUTE filetypes.
MH_APP_EXTENSION_SAFE               = 0x02000000 # The code was linked for use in an application extension.
MH_NLIST_OUTOFSYNC_WITH_DYLDINFO    = 0x04000000 # The external symbols listed in the nlist symbol table do not include all the symbols listed in the dyld info.
MH_SIM_SUPPORT                      = 0x08000000 # Allow LC_MIN_VERSION_MACOS and LC_BUILD_VERSION load commands with the platforms macOS, macCatalyst, iOSSimulator, tvOSSimulator and watchOSSimulator. 
MH_DYLIB_IN_CACHE                   = 0x80000000 # Only for use on dylibs. When this bit is set, the dylib is part of the dyld shared cache, rather than loose in the filesystem.

load_command = collections.namedtuple('load_command', 'cmd cmdsize')
load_command_struct = '@II'

LC_REQ_DYLD = 0x80000000

# Constants for the cmd field of all load commands, the type
LC_SEGMENT                  = 0x1 # segment of this file to be mapped
LC_SYMTAB                   = 0x2 # link-edit stab symbol table info
LC_SYMSEG                   = 0x3 # link-edit gdb symbol table info (obsolete)
LC_THREAD                   = 0x4 # thread
LC_UNIXTHREAD               = 0x5 # unix thread (includes a stack)
LC_LOADFVMLIB               = 0x6 # load a specified fixed VM shared library
LC_IDFVMLIB                 = 0x7 # fixed VM shared library identification
LC_IDENT                    = 0x8 # object identification info (obsolete)
LC_FVMFILE                  = 0x9 # fixed VM file inclusion (internal use)
LC_PREPAGE                  = 0xa #  /* prepage command (internal use)
LC_DYSYMTAB                 = 0xb # dynamic link-edit symbol table info
LC_LOAD_DYLIB               = 0xc # load a dynamically linked shared library
LC_ID_DYLIB                 = 0xd # dynamically linked shared lib ident
LC_LOAD_DYLINKER            = 0xe # load a dynamic linker
LC_ID_DYLINKER              = 0xf # dynamic linker identification
LC_PREBOUND_DYLIB           = 0x10 # modules prebound for a dynamically linked shared library
LC_ROUTINES                 = 0x11 # image routines
LC_SUB_FRAMEWORK            = 0x12 # sub framework
LC_SUB_UMBRELLA             = 0x13 # sub umbrella
LC_SUB_CLIENT               = 0x14 # sub client
LC_SUB_LIBRARY              = 0x15 # sub library
LC_TWOLEVEL_HINTS           = 0x16 # two-level namespace lookup hints
LC_PREBIND_CKSUM            = 0x17 # prebind checksum
LC_LOAD_WEAK_DYLIB          = (0x18 | LC_REQ_DYLD) # load a dynamically linked shared library that is allowed to be missing
LC_SEGMENT_64               = 0x19 # 64-bit segment of this file to be mapped
LC_ROUTINES_64              = 0x1a # 64-bit image routines
LC_UUID                     = 0x1b # the uuid
LC_RPATH                    = (0x1c | LC_REQ_DYLD) # runpath additions
LC_CODE_SIGNATURE           = 0x1d # local of code signature
LC_SEGMENT_SPLIT_INFO       = 0x1e # local of info to split segments
LC_REEXPORT_DYLIB           = (0x1f | LC_REQ_DYLD) # load and re-export dylib
LC_LAZY_LOAD_DYLIB          = 0x20 # delay load of dylib until first use
LC_ENCRYPTION_INFO          = 0x21 # encrypted segment information
LC_DYLD_INFO                = 0x22 # compressed dyld information
LC_DYLD_INFO_ONLY           = (0x22 | LC_REQ_DYLD) # compressed dyld information only
LC_LOAD_UPWARD_DYLIB        = (0x23 | LC_REQ_DYLD) # load upward dylib
LC_VERSION_MIN_MACOSX       = 0x24 # build for MacOSX min OS version
LC_VERSION_MIN_IPHONEOS     = 0x25 # build for iPhoneOS min OS version
LC_FUNCTION_STARTS          = 0x26 # compressed table of function start addresses
LC_DYLD_ENVIRONMENT         = 0x27 # string for dyld to treat like environment variable
LC_MAIN                     = (0x28 | LC_REQ_DYLD) # replacement for LC_UNIXTHREAD
LC_DATA_IN_CODE             = 0x29 # table of non-instructions in __text
LC_SOURCE_VERSION           = 0x2A # source version used to build binary
LC_DYLIB_CODE_SIGN_DRS      = 0x2B # Code signing DRs copied from linked dylibs
LC_ENCRYPTION_INFO_64       = 0x2C # 64-bit encrypted segment information
LC_LINKER_OPTION            = 0x2D # linker options in MH_OBJECT files
LC_LINKER_OPTIMIZATION_HINT = 0x2E # optimization hints in MH_OBJECT files
LC_VERSION_MIN_TVOS         = 0x2F # build for AppleTV min OS version
LC_VERSION_MIN_WATCHOS      = 0x30 # build for Watch min OS version
LC_NOTE                     = 0x31 # arbitrary data included within a Mach-O file
LC_BUILD_VERSION            = 0x32 # build for platform min OS version
LC_DYLD_EXPORTS_TRIE        = (0x33 | LC_REQ_DYLD) # used with linkedit_data_command, payload is trie
LC_DYLD_CHAINED_FIXUPS      = (0x34 | LC_REQ_DYLD) # used with linkedit_data_command
LC_FILESET_ENTRY            = (0x35 | LC_REQ_DYLD) # used with fileset_entry_command

segment_command = collections.namedtuple('segment_command', 'cmd cmdsize segname vmaddr vmsize fileoff filesize maxprot initprot nsects flags')
segment_command_struct = '@II16sIIIIiiII'

section = collections.namedtuple('section', 'sectname segname addr size offset align reloff nreloc flags reserved1 reserved2 reserved3')
section_struct = '@16s16sIIIIIIIIII'

segment_command_64 = collections.namedtuple('segment_command_64', 'cmd cmdsize segname vmaddr vmsize fileoff filesize maxprot initprot nsects flags')
segment_command_64_struct = '@II16sQQQQiiII'

section_64 = collections.namedtuple('section_64', 'sectname segname addr size offset align reloff nreloc flags reserved1 reserved2 reserved3')
section_64_struct = '@16s16sQQIIIIIIII'


def patch(path: str):
    with open(path, "r+b") as f:
        textOffset = 0
        textOffsetEnd = 0
        cstringOffset = 0
        cstringOffsetEnd = 0
        mm = mmap.mmap(f.fileno(), 0)
        header = mach_header_64._make(
            struct.unpack(mach_header_64_struct,
                          mm[:struct.calcsize(mach_header_64_struct)]))
        if header.magic == MH_MAGIC_64 and header.filetype == MH_EXECUTE:
            # print(header)
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
                    nsectOffset = ncmdOffset + \
                        struct.calcsize(segment_command_64_struct)
                    for nsect in range(0, cmd.nsects):
                        sect = section_64._make(
                            struct.unpack(section_64_struct,
                                          mm[nsectOffset:nsectOffset+struct.calcsize(section_64_struct)]))
                        # print(sect)
                        if sect.sectname == b'__text\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00':
                            textOffset = sect.offset
                            textOffsetEnd = textOffset + sect.size
                        if sect.sectname == b'__cstring\x00\x00\x00\x00\x00\x00\x00':
                            cstringOffset = sect.offset
                            cstringOffsetEnd = cstringOffset + sect.size
                        nsectOffset += struct.calcsize(section_64_struct)
                ncmdOffset += cmd.cmdsize
        if textOffset and textOffsetEnd and cstringOffset and cstringOffsetEnd:
            strOffset = mm.find(b"PROFILE_AVAILABLE",
                                cstringOffset, cstringOffsetEnd)
            if strOffset:
                callKeywordOffset = textOffset
                while True:
                    callKeywordOffset = mm.find(b"\x48\x8D\x35",
                                                callKeywordOffset, textOffsetEnd)
                    if callKeywordOffset == -1:
                        break
                    op = mm[callKeywordOffset + 3: callKeywordOffset + 7]
                    opi, = struct.unpack("@I", op)
                    if callKeywordOffset + opi + 7 == strOffset:
                        break
                    callKeywordOffset += 7
                if callKeywordOffset != -1:
                    funOffset = mm.rfind(b"\x55",
                                         textOffset, callKeywordOffset)
                    funOffsetEnd = mm.find(b"\x5B\x5D\xC3",
                                           callKeywordOffset, textOffsetEnd) + 3
                    patch0192hOffset = mm.find(b"\xB8\x92\x01\x00\x00",
                                               funOffset, funOffsetEnd)
                    patch0193hOffset = mm.find(b"\xB8\x93\x01\x00\x00",
                                               funOffset, funOffsetEnd)
                    patch0194hOffset = mm.find(b"\xB8\x94\x01\x00\x00",
                                               funOffset, funOffsetEnd)
                    patch0195hOffset = mm.find(b"\xB8\x95\x01\x00\x00",
                                               funOffset, funOffsetEnd)
                    patch0196hOffset = mm.find(b"\xB8\x96\x01\x00\x00",
                                               funOffset, funOffsetEnd)
                    patch0197hOffset = mm.find(b"\xB8\x97\x01\x00\x00",
                                               funOffset, funOffsetEnd)
                    patch0198hOffset = mm.find(b"\xB9\x98\x01\x00\x00",
                                               funOffset, funOffsetEnd)
                    if patch0192hOffset == -1:
                        sys.stderr.write("Error: '0192h' not found.\n")
                    else:
                        mm[patch0192hOffset:patch0192hOffset+5] = b"\x90\x90\x90\x31\xC0"
                    if patch0193hOffset == -1:
                        sys.stderr.write("Error: '0193h' not found.\n")
                    else:
                        mm[patch0193hOffset:patch0193hOffset+5] = b"\x90\x90\x90\x31\xC0"
                    if patch0194hOffset == -1:
                        sys.stderr.write("Error: '0194h' not found.\n")
                    else:
                        mm[patch0194hOffset:patch0194hOffset+5] = b"\x90\x90\x90\x31\xC0"
                    if patch0195hOffset == -1:
                        sys.stderr.write("Error: '0195h' not found.\n")
                    else:
                        mm[patch0195hOffset:patch0195hOffset+5] = b"\x90\x90\x90\x31\xC0"
                    if patch0196hOffset == -1:
                        sys.stderr.write("Error: '0196h' not found.\n")
                    else:
                        mm[patch0196hOffset:patch0196hOffset+5] = b"\x90\x90\x90\x31\xC0"
                    if patch0197hOffset == -1:
                        sys.stderr.write("Error: '0197h' not found.\n")
                    else:
                        mm[patch0197hOffset:patch0197hOffset+5] = b"\x90\x90\x90\x31\xC0"
                    if patch0198hOffset == -1:
                        sys.stderr.write("Error: '0198h' not found.\n")
                    else:
                        mm[patch0198hOffset:patch0198hOffset+5] = b"\x90\x90\x90\x31\xC9"
                    return True
                else:
                    sys.stderr.write("Error: 'GetProfileStatusCode' function not found.\n")
            else:
                sys.stderr.write("Error: 'PROFILE_AVAILABLE' not found.\n")
        else:
            sys.stderr.write("Error: '__text' or '__cstring' not found.\n")
        mm.close()
    return False

appList = {
    "ps": {
        "path": "/Applications/Adobe Photoshop 2021/Adobe Photoshop 2021.app"
        "/Contents/MacOS/Adobe Photoshop 2021"
    },
    "lr": {
        "path": "/Applications/Adobe Lightroom Classic/Adobe Lightroom Classic.app"
        "/Contents/MacOS/Adobe Lightroom Classic"
    },
    "ai": {
        "path": "/Applications/Adobe Illustrator 2021/Adobe Illustrator.app"
        "/Contents/MacOS/Adobe Illustrator"
    },
    "id": {
        "path": "/Applications/Adobe InDesign/Adobe InDesign.app"
        "/Contents/MacOS/PublicLib.dylib"
    },
    "ic": {
        "path": "/Applications/Adobe InCopy/Adobe InCopy.app"
        "/Contents/MacOS/PublicLib.dylib"
    },
    "au": {
        "path": "/Applications/Adobe Audition/Adobe Audition.app"
        "/Contents/Frameworks/AuUI.framework/Versions/A/AuUI"
    },
    "pr": {
        "path": "/Applications/Adobe Premiere Pro 2020/Adobe Premiere Pro 2020.app"
        "/Contents/Frameworks/Registration.framework/Versions/A/Registration"
    },
    "pl": {
        "path": "/Applications/Adobe Prelude/Adobe Prelude.app"
        "/Contents/Frameworks/Registration.framework/Versions/A/Registration"
    },
    "ch": {
        "path": "/Applications/Adobe Character Animator/Adobe Character Animator.app"
        "/Contents/MacOS/Character Animator"
    },
    "ae": {
        "path": "/Applications/Adobe After Effects 2020/Adobe After Effects 2020.app"
        "/Contents/Frameworks/AfterFXLib.framework/Versions/A/AfterFXLib"
    },
    "me": {
        "path": "/Applications/Adobe Media Encoder 2020/Adobe Media Encoder 2020.app"
        "/Contents/MacOS/Adobe Media Encoder"
    },
    "br": {
        "path": "/Applications/Adobe Bridge/Adobe Bridge.app"
        "/Contents/MacOS/Adobe Bridge"
    },
    "an": {
        "path": "/Applications/Adobe Animate/Adobe Animate.app"
        "/Contents/MacOS/Adobe Animate"
    },
    "dw": {
        "path": "/Applications/Adobe Dreamweaver/Adobe Dreamweaver.app"
        "/Contents/MacOS/Dreamweaver"
    },
    "dn": {
        "path": "/Applications/Adobe Dimension/Adobe Dimension.app"
        "/Contents/Frameworks/euclid-core-plugin.pepper"
    },
    "acrobat": {
        "path": "/Applications/Adobe Acrobat DC/Adobe Acrobat.app"
        "/Contents/Frameworks/Acrobat.framework/Versions/A/Acrobat"
    },
}

def verify_patched_hash(path: str):
    if not os.path.exists("%s.patched.sha1" % path):
        return False
    with open("%s.patched.sha1" % path, "r") as fp:
        hashed = fp.read()
    with open(path, "rb") as fp:
        original = hashlib.sha1(fp.read()).hexdigest()
    return hashed == original

def patchApp(app: str):
    path = appList[app]["path"]
    if not os.path.exists(path):
        return
    print("Found and patching %s" % app)
    if os.path.exists('%s.bak' % path) and verify_patched_hash(path):
        print("Already patched, skipped.")
        return
    shutil.move(path, '%s.bak' % path)
    shutil.copy('%s.bak' % path, path)
    print("Backup succeeded.")
    if patch(path):
        with open(path, "rb") as f:
            with open('%s.patched.sha1' % path, "w") as fp:
                fp.write(hashlib.sha1(f.read()).hexdigest())
        print("Patch succeeded.")
    else:
        print("Patch faild.")

def restoreApp(name: str):
    path = appList[name]["path"]
    if not os.path.exists(path):
        print("The backup file does not exist, skipped.")
        return
    print("Found and revoke %s" % name)
    shutil.move("%s.bak" % path, path)
    os.remove("%s.patched.sha1" % path)
    print("Revoke succeeded.")

def main():
    if len(sys.argv) > 1:
        if sys.argv[1] == "restore":
            if len(sys.argv) > 2:
                for app in sys.argv[2:]:
                    restoreApp(app.lower())
            else:
                for app in appList:
                    restoreApp(app)
        else:
            for app in sys.argv[1:]:
                patchApp(app.lower())
    else:
        for app in appList:
            patchApp(app)

if __name__ == '__main__':
    main()
