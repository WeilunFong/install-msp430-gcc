# install-msp430gcc
install msp430-gcc automatically on Linux

# Usage

## install.sh

This is a bash shell script which helps you install msp430-gcc on your Liunx machine(amd64 required) from TI binary source. 
User can enter `./install -h` for usages. Default setup path is */opt/ti* and the script will not modify add this path into 
environment variable `$PATH`. We recommand to use msp430-gcc via a environment config script(such as env.sh) instead of useing it directly via
modifying `$PATH`

## env.sh

This is a bash shell script which helps you config MSP430 cross compile environment temporarily. Please startup a new bash and
use `source` command to execute it. You can also get all usages via command `source env.sh -h`. *env.sh* will export or modify 
following variables:

+ SYSROOT
+ PATH
+ CROSS_COMPILE
+ CC
+ CXX
+ CPP
+ AS
+ AR
+ GDB
+ LD
+ M4
+ NM
+ OBJCOPY
+ OBJDUMP
+ RANLIB
+ STRIP
+ MSPDEBUG *(if you have installed it)*
