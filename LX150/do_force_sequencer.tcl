force -freeze sim:/sequencer/CLOCK 1 0, 0 {2 ns} -r 4 ns
force -freeze sim:/sequencer/RESET 0 0
run 25 ns
force -freeze sim:/sequencer/RESET 1 0
run 25 ns
force -freeze sim:/sequencer/RESET 0 0


