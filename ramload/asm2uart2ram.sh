#!/usr/bin/sh
# Usage:
# ./asm2uart2ram.sh program.asm /dev/ttyUSB0
#

./asmitp.pl $1 -o instr.coe
./bin2hex.pl instr.coe -o ram.hex
./uart2ram.sh ram.hex 2400 $2
