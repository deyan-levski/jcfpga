;|------------------------------------------------------------------|
;| Sample assembler file for ADC Testchip readout board             |
;|------------------------------------------------------------------|
;| Version A, Deyan Levski, deyan.levski@eng.ox.ac.uk, 05.11.2016   |
;|------------------------------------------------------------------|
;|-+-|
;|------------------------------------------------------------------|
;| Instruction List and Function                                    |
;|------------------------------------------------------------------|
;| ROW 0x00 1/0 — set d_row_rs                                      |
;| ROW 0x01 1/0 — set d_row_rst                                     |
;| ROW 0x02 1/0 — set d_row_tx                                      |
;| ROW 0x03 1/0 — set d_col_vln_sh                                  |
;| ROW 0x04 1/0 — set ROW_NEXT                                      |
;| SHX 0x00 1/0 — set d_shr                                         |
;| SHX 0x01 1/0 — set d_shs                                         |
;| ADX 0x00 1/0 — set d_adr                                         |
;| ADX 0x01 1/0 - set d_ads                                         |
;| COM 0x00 1/0 — set d_comp_bias_sh                                |
;| COM 0x01 1/0 — set d_comp_dyn_pon                                |
;| CNT 0x00 1/0 — set d_count_en                                    |
;| CNT 0x01 1/0 — set d_count_rst                                   |
;| CNT 0x02 1/0 — set d_count_inv_clk                               |
;| CNT 0x03 1/0 — set d_count_hold                                  |
;| CNT 0x04 1/0 — set d_count_updn                                  |
;| CNT 0x05 1/0 — set d_count_inc_one                               |
;| CNT 0x06 1/0 — set d_count_jc_shift_en                           |
;| CNT 0x07 1/0 — set d_count_lsb_en                                |
;| CNT 0x08 1/0 — set d_count_lsb_clk                               |
;| MEM 0x00 1/0 — set d_count_mem_wr                                |
;| REF 0x00 1/0 — set d_ref_vref_ramp_rst                           |
;| REF 0x01 1/0 — set d_ref_vref_sh                                 |
;| REF 0x02 1/0 — set d_ref_vref_clamp_en                           |
;| REF 0x03 1/0 — set d_ref_vref_ramp_ota_dyn_pon                   |
;| SER 0x00 1/0 — set d_digif_seraial_rst                           |
;| LOAD PAR — load follow-up instructions to buf register           |
;| SET PAR  — set the loaded in buf register to output              |
;| START    — initialize output register to 0x0000                  |
;| NOP      — NOP operation (stall) one cycle                       |
;| NOP n    — NOP operation (stall) n cycles                        |
;| FVAL 0x00 1/0 — FVAL_SEQ                                         |
;| LVAL 0x00 1/0 — LVAL_SEQ                                         |
;|------------------------------------------------------------------|
;|-+-|
;

START	
; initialize startup signals
LOAD PAR
MOV REF 0x03 1	; ota_dyn_pon always @ '1'
MOV CNT 0x04 1	; count_updn '1'
MOV CNT 0x01 1	; count_rst '1'
MOV CNT 0x05 1	; count_inc_one '1'
MOV CNT 0x08 1	; count_lsb_clk '1'
MOV FVAL 0x00 1 ; Tie FVAL '1'
MOV LVAL 0x00 1 ; Tie LVAL '1'

; references and shr sampling
MOV ADX 0x00 1	; d_adr
MOV SHX 0x00 1	; d_shr
MOV REF 0x01 1	; d_ref_vref_sh
MOV REF 0x00 1	; d_ref_vref_ramp_rst
MOV COM 0x00 1  ; d_comp_bias_sh
MOV SER 0x00 1	; d_digif_serial_rst
SET PAR

NOP 40		; halt 320 ns — phase 1 in vref_ramp

LOAD PAR
MOV REF 0x01 0	; d_ref_vref_sh
MOV REF 0x02 1	; clamp on
SET PAR

NOP 10		; halt 80 ns
MOV REF 0x02 0	; clamp off
NOP 2

; memory write and digif enable
MOV MEM 0x00 1	; write to SRAM (prev. conversion)
NOP 2
MOV SER 0x00 0	; start data serialization out
NOP 2

; reset counter
LOAD PAR
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

NOP 128 	; halt 1028 ns — wait for ramp buffer to settle

MOV SHX 0x00 0	; complete shr sampling
NOP 2

; start count & ramp current
LOAD PAR
MOV REF 0x00 0
MOV CNT 0x00 1
SET PAR

NOP 128 	; halt 1024 ns (ramp slew time)

MOV CNT 0x00 0	; stop counter
MOV REF 0x00 1	; stop ramp current

NOP 2

; transfer johnsons to lsb counter
MOV CNT 0x06 1	; open jc_shift_en
NOP 2
MOV CNT 0x07 1	; open lsb_en
NOP 2
MOV CNT 0x08 0	; run lsb clocks
NOP 2
MOV CNT 0x08 1	; clk 1
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1	; clk 2
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1	; clk 3
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1	; clk 4
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1	; clk 5
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1	; clk 6
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1	; clk 7
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1	; clk 8
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1	; clk 9
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1	; clk 10
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1	; clk 11
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1	; clk 12
NOP 2
MOV CNT 0x07 0	; close lsb_en
NOP 2
MOV CNT 0x06 0	; close jc_shift_en
NOP 4

; start SHR DCDS inversion
LOAD PAR
MOV CNT 0x02 1	; inv_clk '1'
MOV CNT 0x03 1	; hold '1'
SET PAR
NOP 4
MOV CNT 0x02 0	; inv_clk '0'
NOP 4
MOV CNT 0x05 0	; inc_one '0'
NOP 4
MOV CNT 0x05 1	; inc_one '1'
NOP 4
MOV CNT 0x04 0	; updn '0'
NOP 4
MOV CNT 0x03 0	; hold '0'
NOP 4
MOV CNT 0x04 1	; updn '1'

; stop serializer
MOV SER 0x00 1	; stop data serialization out
MOV ADX 0x00 0	; switch off d_adr



; references and shs sampling
LOAD PAR
MOV ADX 0x01 1	; d_ads
MOV SHX 0x01 1	; d_shs
MOV REF 0x01 1	; d_ref_vref_sh
MOV REF 0x00 1	; d_ref_vref_ramp_rst
MOV COM 0x00 1  ; d_comp_bias_sh
MOV SER 0x00 1	; d_digif_serial_rst
SET PAR

NOP 40		; halt 320 ns — phase 1 in vref_ramp

LOAD PAR
MOV REF 0x01 0	; d_ref_vref_sh
MOV REF 0x02 1	; clamp on
SET PAR
NOP 10		; halt 80 ns
MOV REF 0x02 0	; clamp off
NOP 2

; reset counter
;LOAD PAR
;MOV CNT 0x04 0
;MOV CNT 0x01 0
;MOV CNT 0x05 0
;SET PAR
;NOP 2
;LOAD PAR
;MOV CNT 0x04 1
;MOV CNT 0x01 1
;MOV CNT 0x05 1
;SET PAR
;NOP

NOP 128 	; halt 1028 ns — wait for ramp buffer to settle

MOV SHX 0x01 0	; complete shs sampling
NOP 2

; start count & ramp current
LOAD PAR
MOV REF 0x00 0
MOV CNT 0x00 1
SET PAR

NOP 128 	; halt 1024 ns (ramp slew time)

MOV CNT 0x00 0	; stop counter
MOV REF 0x00 1	; stop ramp current

NOP 2

; transfer johnsons to lsb counter
MOV CNT 0x06 1	; open jc_shift_en
NOP 2
MOV CNT 0x07 1	; open lsb_en
NOP 2
MOV CNT 0x08 0	; run lsb clocks
NOP 2
MOV CNT 0x08 1	; clk 1
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1	; clk 2
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1	; clk 3
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1	; clk 4
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1	; clk 5
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1	; clk 6
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1	; clk 7
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1	; clk 8
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1	; clk 9
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1	; clk 10
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1	; clk 11
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1	; clk 12
NOP 2
MOV CNT 0x07 0	; close lsb_en
NOP 2
MOV CNT 0x06 0	; close jc_shift_en
NOP 4

MOV ADX 0x01 0	; switch off d_ads

NOP 1024	; fill extra ROM /w NOP

