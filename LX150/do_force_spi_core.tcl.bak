vcom -reportprogress 300 -work work /media/data/git/jcfpga/LX150/hdl/SPI_CORE.vhd

restart
force -freeze sim:/spi_core/CLOCK 1 0, 0 {2000 ps} -r 4ns
force -freeze sim:/spi_core/RESET 0 0
force -freeze sim:/spi_core/SPI_DATA 32'b10000000100000000000000000000010 0
#force -freeze sim:/spi_core/COMMAND 0100 0
#force -freeze sim:/spi_core/CHANNEL 0001 0
#force -freeze sim:/spi_core/INT_REF_ON 0 0
force -freeze sim:/spi_core/CSEL_I 0 0
force -freeze sim:/spi_core/SPI_DATA_LOAD 0 0

run 40ns
force -freeze sim:/spi_core/RESET 1 0
run 40ns
force -freeze sim:/spi_core/RESET 0 0
run 1000ns
force -freeze sim:/spi_core/SPI_DATA_LOAD 1 0
run 1000ns
