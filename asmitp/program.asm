; Test assembler file for ADC Testchip readout board
;
; Version A, Deyan Levski, deyan.levski@eng.ox.ac.uk, 05.11.2016
;

START
; initialize startup signals
LOAD PAR
MOV REF 0x03 1	; ota_dyn_pon always @ '1'
MOV CNT 0x04 1	; count_updn '1'
MOV CNT 0x01 1	; count_rst '1'
MOV CNT 0x05 1	; count_inc_one '1'
MOV CNT 0x08 1	; count_lsb_clk '1'
SET PAR
; references and shr
LOAD PAR
MOV ADX 0x01 1	; d_adr
MOV SHX 0x00 1	; d_shr
MOV REF 0x01 1	; d_ref_vref_sh
MOV REF 0x00 1	; d_ref_vref_ramp_rst
MOV COM 0x00 1  ; d_comp_bias_sh
SET PAR
; halt 320 ns
NOP 40		
LOAD PAR
MOV REF 0x01 0	; d_ref_vref_sh
MOV REF 0x02 1	; d_ref_vref_clamp_en
SET PAR
; halt 80 ns
NOP 10		
MOV REF 0x02 0	; d_ref_vref_clamp_en

LOAD PAR	; reset counter
MOV CNT 0x04 0
MOV CNT 0x01 0
MOV CNT 0x05 0
SET PAR
NOP 2
LOAD PAR
MOV CNT 0x04 1
MOV CNT 0x01 1
MOV CNT 0x05 1
SET PAR
NOP
MOV MEM 0x00 1	; open SRAM (/wr)

; halt 1040 ns
NOP 130	

LOAD PAR	; start count & ramp current
MOV REF 0x00 0
MOV CNT 0x00 1
SET PAR

; halt 1024 ns
NOP 128
MOV CNT 0x00 0	; stop counter
MOV REF 0x00 1	; stop ramp current

NOP 2

MOV CNT 0x06 1	; open jc_shift_en
NOP 2
MOV CNT 0x07 1	; open lsb_en
NOP 2
MOV CNT 0x08 0	; run lsb clocks
NOP 2
MOV CNT 0x08 1
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1
NOP 2
MOV CNT 0x07 0	; close lsb_en
NOP 2
MOV CNT 0x06 0	; close jc_shift_en
NOP 4


NOP 8196

