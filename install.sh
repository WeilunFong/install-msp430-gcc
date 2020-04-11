#!/bin/bash

# ------------------------------------------------------------------------
# Author     : Weilun Fong | wlf@zhishan-iot.tk
# Date       : 2020-04-11
# Description: install msp430gcc
# E-mail     : mcu@zhishan-iot.tk
# Page       : https://github.com/WeilunFong/install-msp430gcc
# Project    : install-msp430gcc
# Version    :
# ------------------------------------------------------------------------


# Script information
SCRIPT_HELP="Try '$0' --help for more information."
SCRIPT_USAGE="\
Usage: $0 [--mode <mode>] [--action <action>]

Options:
    -a, --action <action>    value of <action> must be 'install' or 'uninstall', default one is
'install'. Uninstall operation will remove directory <prefix>/ti/msp430-gcc
    -m, --mode <mode>        value of <mode> must be 'bin'(install via binary package) or 'src'
(install via source code). If you select latter, the script will install newer version. Default
one is 'src'. Default mode is 'bin' and this mode only for amd64 host!!!
    -p, --prefix <path>      specify target install path, default value is /opt and msp430-gcc 
will be installed under path /opt/ti.

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
url="https://raw.githubusercontent.com/WeilunFong/install-msp430-gcc/master/lastest-link.txt"
# ------------------------------------------------------------------------


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

if [ "$installAction" == install ];then
    if [ "$installMode" == src ]; then
        if [ -z "$installPrefix" ]; then
            installPrefix=/opt
        fi
        if [ ! -d $installPrefix ]; then
            echo "$0: no such directory $installPrefix" >&2 && exit 1
        fi
        if [ ! -w "$installPrefix" ]; then
            echo "$0: current user [$USER] have no rights to do write operations for $installPrefix" >&2 && exit 1
        fi
    fi
elif [ "$installAction" == uninstall ]; then
    if [ -z "$installPrefix" ]; then
        echo "$0: <prefix> parameter is required when you do uninstall operation" >&2 && exit 1
    else
        if [ ! -d "$installPrefix" ]; then
            echo "$0: no such directory $installPrefix" >&2 && exit 1
        fi
    fi
fi

# Installation
echo " - Start!"
if [ "$installMode" == bin ]; then
    if [ "$installAction" == install ]; then
        # get download link
        for((i=1;i<=3;i++));
        do
            downloadLink="`wget -q -O - $url`"
            if [ -n "$downloadLink" ]; then
                break
            fi
        done
        wait
        if [ -z "$downloadLink" ]; then
            echo "$0: failed to get download link online" >&2 && exit 1
        fi
        downloadFile="`echo $downloadLink |  awk -F '/' '{print $NF}' | awk -F '?' '{print $1}'`"
        # start to install
        echo " - Download binary file"
        wget $downloadLink
        chmod +x $downloadFile
        ./$downloadFile
        echo " - Do final works"
        rm -f $downloadFile
    elif [ "$installAction" == uninstall ]; then
        echo " - Remove msp430-gcc..."
        u=$installPrefix/ti/msp430-gcc/uninstall
        if [ ! -f $u ]; then
            echo "$0: uninstall file $u not found..." >&2 && exit 2
        else
            $u
        fi
    fi
elif [ "$installMode" == src ]; then
    echo "$0: not spported now..." >&2 && exit 2
fi
    
# Done!
echo " - Done!"
