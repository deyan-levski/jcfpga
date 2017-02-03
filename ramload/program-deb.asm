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

;|----------------------------|
;| Initialize startup signals |
;|----------------------------|

LOAD PAR
MOV REF 0x03 1		; ota_dyn_pon always @ '1'
MOV CNT 0x04 1		; count_updn '1'
MOV CNT 0x01 1		; count_rst '1'
MOV CNT 0x05 1		; count_inc_one '1'
MOV CNT 0x08 1		; count_lsb_clk '1'
MOV MEM 0x00 1		; count_mem_wr '1'
MOV FVAL 0x00 1 	; FVAL '1'
MOV COM 0x01 1		; comp_dyn_pon always @ '1'

;|-----------------|
;| Sequencer start |
;|-----------------|

; references and shr sampling
MOV ADX 0x00 1		; d_adr
MOV SHX 0x00 1		; d_shr
MOV REF 0x01 1		; d_ref_vref_sh
MOV REF 0x00 1		; d_ref_vref_ramp_rst
MOV COM 0x00 1		; d_comp_bias_sh
SET PAR

NOP 52			; halt 320 ns — phase 1 in vref_ramp

LOAD PAR
MOV REF 0x01 0		; d_ref_vref_sh
MOV REF 0x02 0		; clamp on
SET PAR

NOP 8			; halt 80 ns
MOV REF 0x02 0		; clamp off
NOP 6

; reset counter
LOAD PAR
MOV CNT 0x04 0
MOV CNT 0x01 0
MOV CNT 0x05 0
SET PAR
NOP 10
LOAD PAR
MOV CNT 0x04 1
MOV CNT 0x01 1
MOV CNT 0x05 1
SET PAR

; halt 1020 ns — wait for ramp buffer to settle
NOP 92
NOP 94			; prehalt — wait for ramp buffer

MOV SHX 0x00 0		; complete shr sampling
NOP 2

; start count & ramp current
LOAD PAR
MOV REF 0x00 0
MOV CNT 0x00 1
SET PAR

; halt 1024 ns (ramp slew time)
NOP 102

MOV CNT 0x00 0		; stop counter
MOV REF 0x00 1		; stop ramp current

NOP 2

NOP 60

; start SHR DCDS inversion

;LOAD PAR
;MOV CNT 0x02 1		; inv_clk '1'
;MOV CNT 0x03 1		; hold '1'
;SET PAR

;NOP 8
;MOV CNT 0x02 0		; inv_clk '0'
;NOP 8
;MOV CNT 0x05 0		; inc_one '0'
;NOP 8
;MOV CNT 0x05 1		; inc_one '1'
;NOP 8
;MOV CNT 0x04 0		; updn '0'
;NOP 8
;MOV CNT 0x03 0		; hold '0'
;NOP 8
;MOV CNT 0x04 1		; updn '1'


;write to memory
MOV MEM 0x00 0		; write to SRAM
NOP 12
MOV MEM 0x00 1		; write to SRAM

NOP 32

NOP 12

LOAD PAR
MOV SER 0x00 0		; start data serialization out
MOV FVAL 0x00 0
MOV LVAL 0x00 1		; line trigger pulse on
SET PAR
NOP 4
LOAD PAR
MOV LVAL 0x00 0		; line trigger pulse off
MOV FVAL 0x00 1
SET PAR

NOP 1080		; fill extra ROM /w NOP
