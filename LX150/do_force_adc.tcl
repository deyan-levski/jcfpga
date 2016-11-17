force -freeze sim:/adc_ctrl/CLOCK 1 0, 0 {5 ns} -r 10 ns
force -freeze sim:/adc_ctrl/RESET 0 0
run 250 ns
force -freeze sim:/adc_ctrl/RESET 1 0
run 250 ns
force -freeze sim:/adc_ctrl/RESET 0 0
run 25000 ns


