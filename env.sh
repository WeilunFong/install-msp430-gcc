#!/bin/bash

# ------------------------------------------------------------------------
# Author     : Weilun Fong | wlf@zhishan-iot.tk
# Date       : 2020-03-31
# Description: configure MSP430 build system environment 
# E-mail     : mcu@zhishan-iot.tk
# Page       : https://github.com/WeilunFong/install-msp430gcc
# Project    : install-msp430gcc
# Version    :
# ------------------------------------------------------------------------

# Timestamp
timestamp=20200331

# Script print
script="env.sh"
help="Try 'source $script --help' for more information."
usage="\
Usage: source $script -c [msp430gcc-path] <-d [debug-tool-path]>

Options:
    -c, --cc-path=PATH       root path of msp430-gcc toolchain
    -d, --dbg-path=PATH      root path of debug tool, support mspdebug, it will
export via environment variable <MSPDEBUG>

    -h, --help               print help informatio, then exit
    -v, --version            print version information, then exit

Report bugs and patch to <mcu@zhishan-iot.tk>"
version="\
[install-msp430gcc] $script ($timestamp)
Copyright (C) 2020 ZHISHAN-IoT
One-step script for msp430-gcc build system configurations.
Written by Weilun Fong <wlf@zhishan-iot.tk>"

# Check execute way
if [ "$0" != bash ]; then
    echo "$0: Invalid execute way."
    echo "$help" >&2 && exit 1
fi

# Obtain input
if [ $# -eq 0 ]; then
    echo "You need to specify a path at least."
    echo "$help" >&2 && return 1
fi

# Get parameters
while test $# -gt 0 ; do
    case $1 in
        --cc-path | -c )
            p_cc_path="$2"; shift 2 ;;
        --dbg-path | -d )
            p_dbg_path="$2"; shift 2 ;;
        --help | -h )
            echo "$usage"; return 0 ;;
        --version | -v )
            echo "$version" && return 0 ;;
        -- )
            shift; break ;;
        - )
            break ;;
        -* )
            echo "$scirpt: invalid option $1"
            echo "$help" >&2 && return 1 ;;
        * )
            break ;;
    esac
done

# ------------------------------------------------------------------------
# cc path
# ------------------------------------------------------------------------
if [ -d "$p_cc_path" ]; then
    export SYSROOT="$p_cc_path"
    export PATH="$PATH:$SYSROOT/bin"
else
    echo "$scirpt: No such directory $p_cc_path"
    echo "$help" >&2 && return 1
fi

# ------------------------------------------------------------
# @note: the CROSS_COMPILE value in older version is "msp430-"!!!
# ------------------------------------------------------------
# Export CROSS_COMPILE=msp430-
export CROSS_COMPILE=msp430-elf-

# Define toolchain
export ARCH=msp430
export CC=${CROSS_COMPILE}gcc
export CXX=${CROSS_COMPILE}g++
export CPP=${CROSS_COMPILE}cpp
export AS=${CROSS_COMPILE}as
export AR=${CROSS_COMPILE}ar
export GDB=${CROSS_COMPILE}gdb
export LD=${CROSS_COMPILE}ld
export M4=m4
export NM=${CROSS_COMPILE}nm
export OBJCOPY=${CROSS_COMPILE}objcopy
export OBJDUMP=${CROSS_COMPILE}objdump
export RANLIB=${CROSS_COMPILE}ranlib
export STRIP=${CROSS_COMPILE}strip

# ------------------------------------------------------------------------
# mspdebug path
# ------------------------------------------------------------------------
if [ -n "$p_dbg_path" ]; then
    if [ -d "$p_dbg_patt" ]; then
        export PATH="$PATH:$p_dbg_path"
        export MSPDEBUG=mspdebug
    else
        echo "$scirpt: No such directory $p_dbg_path"
        echo "$help" >&2 && return 1
    fi
else
    which mspdebug > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        export MSPDEBUG=mspdebug
    fi
fi

# Done!
echo "Done!"