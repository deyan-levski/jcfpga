; Test assembly file for ADC Testchip readout board
;
; Version A, Deyan Levski, deyan.levski@eng.ox.ac.uk, 05.11.2016
;

START
MOV SHX 0x00 1
NOP 3
MOV SHX 0x00 0
NOP 10
MOV SHX 0x01 1
MOV SHX 0x01 0 ; shr
MOV COM 0x00 1 ; comparator sample bias
;convert
MOV SER 0x00 1
MOV SHX 0x01 1
MOV COM 0x01 1
NOP 1000
MOV COM 0x01 0
NOP 8196
