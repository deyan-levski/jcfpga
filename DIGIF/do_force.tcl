log -r /*
restart
vcom -reportprogress 300 -work work /media/data/git/jcfpga/DIGIF/DIGIF.vhd
#vcom -reportprogress 300 -work work /media/data/git/jcfpga/DIGIF/DESERIAL.vhd
#vcom -reportprogress 300 -work work /media/data/git/jcfpga/DIGIF/DESERIAL_TB.vhd

#add wave *
#add wave DIGIF_INST/*
#add wave DIGIF_INST/rising_edge_process/*
#add wave DIGIF_INST/falling_edge_process/*
#
#add wave *
#add wave DESERIAL_INST/*
#add wave DESERIAL_INST/deserialization_rising_edge/*
#add wave DESERIAL_INST/deserialization_falling_edge/*


force -freeze sim:/DIGIF/d_digif_sck 1 0, 0 {2000 ps} -r 4000
force -freeze sim:/DIGIF/RESET 1 0
run 10 ns
force -freeze sim:/DIGIF/RESET 0 0
run 30 ns
force -freeze sim:/DIGIF/RESET 1 0
run 50 ns
force -freeze sim:/DIGIF/d_digif_rst 1 0
run 50 ns
force -freeze sim:/DIGIF/RESET 0 0
run 180 ns
force -freeze sim:/DIGIF/d_digif_rst 0 0
run 184 ns
force -freeze sim:/DIGIF/d_digif_rst 1 0
run 208 ns
force -freeze sim:/DIGIF/d_digif_rst 0 0
run 222 ns
force -freeze sim:/DIGIF/d_digif_rst 1 0
run 302 ns
force -freeze sim:/DIGIF/d_digif_rst 0 0
run 148 ns
force -freeze sim:/DIGIF/d_digif_rst 1 0
run 144 ns
force -freeze sim:/DIGIF/d_digif_rst 0 0
run 146 ns
force -freeze sim:/DIGIF/d_digif_rst 1 0
run 122 ns
force -freeze sim:/DIGIF/d_digif_rst 0 0
run 246 ns
force -freeze sim:/DIGIF/d_digif_rst 1 0
run 308 ns
force -freeze sim:/DIGIF/d_digif_rst 0 0
run 245 ns
force -freeze sim:/DIGIF/d_digif_rst 1 0
run 305 ns
force -freeze sim:/DIGIF/d_digif_rst 0 0
run 245 ns
force -freeze sim:/DIGIF/d_digif_rst 1 0
run 305 ns
force -freeze sim:/DIGIF/d_digif_rst 0 0
run 246 ns
force -freeze sim:/DIGIF/d_digif_rst 1 0
run 305 ns





