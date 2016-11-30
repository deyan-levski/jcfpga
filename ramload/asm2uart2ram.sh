./asmitp.pl $1 -o instr.coe
./bin2hex.pl instr.coe -o ram.hex
./uart2ram.sh ram.hex 2400 $2
