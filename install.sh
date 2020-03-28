#!/bin/bash

# ------------------------------------------------------------------------
# Author     : Weilun Fong | wlf@zhishan-iot.tk
# Date       : 2020-03-28
# Description: install msp430gcc
# E-mail     : wlf@zhishan-iot.tk
# ------------------------------------------------------------------------

# Script information
SCRIPT_HELP="Try '$0' --help for more information."
SCRIPT_USAGE="\
Usage: $0 [--mode <mode>] [--action <action>]

Options:
    -a, --action <action>    value of <action> must be 'install' or 'uninstall', default one is
'install'
    -m, --mode <mode>        value of <mode> must be 'bin'(install via binary package) or 'src'
(install via source code). If you select latter, the script will install newer version. Default
one is 'src'. Default mode is 'bin' and this mode only for amd64 host!!!
    -p, --prefix <path>      specify target install path, default value is /opt and msp430-gcc 
will be installed under path /opt/ti

    -h, --help               print help informatio, then exit
    -v, --version            print version information, then exit

Report bugs and patch to <mcu@zhishan-iot.tk>"
SCRIPT_VERSION="\
[`basename $0`]
Copyright (C) 2020 ZHISHAN-IoT
One-step script for msp430-gcc installation.
Written by Weilun Fong <wlf@zhishan-iot.tk>"

# ------------------------------------------------------------------------
# DOWNLOAD LINK DEFINE, USER CAN MODIFY IT MANUALLY
# ------------------------------------------------------------------------
url="https://raw.githubusercontent.com/WeilunFong/install-msp430-gcc/lastest-link.txt"
# ------------------------------------------------------------------------

# Get download link
for((i=1;i<=3;i++));
do
    downloadLink="`wget -q -O - $url`"
    if [ -n "$downloadLink" ]; then
        break
    fi
done
if [ -z "$downloadLink" ]; then
    echo "$0: failed to get download link online" >&2 && exit 1
fi
downloadFile="`echo $downloadLink |  awk -F '/' '{print $NF}' | awk -F '?' '{print $1}'`"

# Get parameters
while test $# -gt 0 ; do
    case $1 in
        --action | -a )
            installAction="$2"; shift 2 ;;
        --help | -h )
            echo "$SCRIPT_USAGE"; exit ;;
        --mode | -m )
            installMode="$2" ; shift 2 ;;
        --prefix | -p )
            installPrefix="$2"; shift 2 ;;
        --version | -v )
            echo "$SCRIPT_VERSION" && exit ;;
        -- )
            shift; break ;;
        - )
            break ;;
        -* )
            echo "$0: invalid option $1"
            echo "$SCRIPT_HELP" >&2 && exit 1 ;;
        * )
            break ;;
    esac
done

if [ -z "$installAction" ]; then
    installAction=install
else
    if [ -z "`echo $installAction | grep -i -w -E 'install|uninstall'`" ]; then
        echo "$0: invalid <action> value" >&2 && exit 1
    fi
fi

if [ -z "$installMode" ]; then
    installMode=bin
else
    if [ -z "`echo $installMode | grep -i -w -E 'bin|src'`" ]; then
        echo "$0: invalid <mode> value" >&2 && exit 1
    fi
fi

if [ -z "$installPrefix" ]; then
    installPrefix=/opt
else
    if [ ! -d "$installPrefix" ]; then
        echo "$0: no such directory $installPrefix" >&2 && exit 1
    fi
fi
if [ ! -w "$installPrefix" ]; then
    echo "$0: current user [$USER] have no rights to do write operations for $installPrefix" >&2 && exit 1
fi

# Installation
echo " - Start to install"
if [ "$installMode" == bin ]; then
    if [ "$installAction" == install ]; then

        mkdir -p $installPrefix/ti/msp430-gcc-8
        cd $installPrefix/ti

        echo " - Download binary file"
        wget $downloadLink -O $downloadFile && tar -jxf $ downloadFile
        mv `basename $downloadFile .tar.bz2` msp430-gcc-8

        echo " - Do final works"
        rm -f $downloadFile
    elif [ "$installAction" == uninstall ]; then
        echo " - Remove msp430-gcc..."
        sudo rm -rf $prefix/ti/msp430-gcc-8
    fi
elif [ "$installMode" == src ]; then
    echo "$0: unspported now..." >&2 && exit 2
fi
    
# Done!
echo " - Done! Please add path $installPrefix/ti/msp430-gcc-8/bin into environment variable \
\$PATH before using manually"
