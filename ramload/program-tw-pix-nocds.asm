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

;|--------------------|
;| Photo-core related |
;|--------------------|
MOV ROW 0x03 1		; col_vln_sh
MOV ROW 0x00 1		; row sel always on 0 as of PFET

MOV ROW 0x01 1
MOV ROW 0x02 1

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

NOP 50			; halt 420 ns — phase 1 in vref_ramp

MOV REF 0x01 0		; d_ref_vref_sh

NOP 7			; halt 150 ns

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

; halt 1020 ns — wait for ramp buffer to settle
NOP 94			; prehalt — wait for ramp buffer

LOAD PAR
MOV ROW 0x01 0		; reset off
MOV ROW 0x02 0		; tx off
SET PAR

NOP 15

MOV SHX 0x00 0		; complete shr sampling

NOP 15

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

; transfer johnsons to lsb counter
MOV CNT 0x06 1		; open jc_shift_en
NOP 2
MOV CNT 0x07 1		; open lsb_en
NOP 2
MOV CNT 0x08 0		; run lsb clocks
NOP 2
MOV CNT 0x08 1		; clk 1
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1		; clk 2
NOP 2
MOV CNT 0x08 0
NOP 2
MOV CNT 0x08 1		; clk 3
NOP 2
MOV CNT 0x08 0		
NOP 2
MOV CNT 0x08 1		; clk 4
NOP 2
MOV CNT 0x08 0		
NOP 2
MOV CNT 0x08 1		; clk 5
NOP 2
MOV CNT 0x08 0		
NOP 2
MOV CNT 0x08 1		; clk 6
NOP 2
MOV CNT 0x08 0		
NOP 2
MOV CNT 0x08 1		; clk 7
NOP 2
MOV CNT 0x08 0		
NOP 2
MOV CNT 0x08 1		; clk 8
NOP 2
MOV CNT 0x08 0		
NOP 2
MOV CNT 0x08 1		; clk 9
NOP 2
MOV CNT 0x08 0		
NOP 2
MOV CNT 0x08 1		; clk 10
NOP 2
MOV CNT 0x08 0		
NOP 2
MOV CNT 0x08 1		; clk 11
NOP 2
MOV CNT 0x08 0		
NOP 2
MOV CNT 0x08 1		; clk 12
NOP 2
MOV CNT 0x07 0		; close lsb_en
NOP 2
MOV CNT 0x06 0		; close jc_shift_en
NOP 4

; start SHR DCDS inversion

;LOAD PAR
;MOV CNT 0x02 1		; inv_clk '1'
;MOV CNT 0x03 1		; hold '1'
;SET PAR
;NOP 4
;MOV CNT 0x02 0		; inv_clk '0'
;NOP 4
;MOV CNT 0x05 0		; inc_one '0'
;NOP 4
;MOV CNT 0x05 1		; inc_one '1'
;NOP 4
;MOV CNT 0x04 0		; updn '0'
;NOP 4
;MOV CNT 0x03 0		; hold '0'
;NOP 4
;MOV CNT 0x04 1		; updn '1'

;MOV ADX 0x00 0		; switch off d_adr

; references and shs sampling
;LOAD PAR
;MOV ADX 0x01 1		; d_ads
;MOV SHX 0x01 1		; d_shs
;MOV REF 0x01 1		; d_ref_vref_sh
;MOV REF 0x00 1		; d_ref_vref_ramp_rst
;MOV COM 0x00 1		; d_comp_bias_sh
;SET PAR

;NOP 50	      		; halt 420 ns — phase 1 in vref_ramp

;MOV REF 0x01 0		; d_ref_vref_sh

;MOV ROW 0x02 1		; tx on

;NOP 74       		; halt 1020 ns — wait for ramp buffer to settle

;MOV ROW 0x02 0		; tx off
;NOP 20
;MOV SHX 0x01 0		; complete shs sampling
;NOP 30

; start count & ramp current
;LOAD PAR
;MOV REF 0x00 0
;MOV CNT 0x00 1
;SET PAR

;NOP 102 		; halt 1020 ns (ramp slew time)

;MOV CNT 0x00 0		; stop counter
;MOV REF 0x00 1		; stop ramp current

;NOP 2

; transfer johnsons to lsb counter
;MOV CNT 0x06 1		; open jc_shift_en
;NOP 2
;MOV CNT 0x07 1		; open lsb_en
;NOP 2
;MOV CNT 0x08 0		; run lsb clocks
;NOP 2
;MOV CNT 0x08 1		; clk 1
;NOP 2
;MOV CNT 0x08 0		
;NOP 2
;MOV CNT 0x08 1		; clk 2
;NOP 2
;MOV CNT 0x08 0		
;NOP 2
;MOV CNT 0x08 1		; clk 3
;NOP 2
;MOV CNT 0x08 0		
;NOP 2
;MOV CNT 0x08 1		; clk 4
;NOP 2
;MOV CNT 0x08 0		
;NOP 2
;MOV CNT 0x08 1		; clk 5
;NOP 2
;MOV CNT 0x08 0		
;NOP 2
;MOV CNT 0x08 1		; clk 6
;NOP 2
;MOV CNT 0x08 0		
;NOP 2
;MOV CNT 0x08 1		; clk 7
;NOP 2
;MOV CNT 0x08 0		
;NOP 2
;MOV CNT 0x08 1		; clk 8
;NOP 2
;MOV CNT 0x08 0		
;NOP 2
;MOV CNT 0x08 1		; clk 9
;NOP 2
;MOV CNT 0x08 0		
;NOP 2
;MOV CNT 0x08 1		; clk 10
;NOP 2
;MOV CNT 0x08 0		
;NOP 2
;MOV CNT 0x08 1		; clk 11
;NOP 2
;MOV CNT 0x08 0		
;NOP 2
;MOV CNT 0x08 1		; clk 12
;NOP 2
;MOV CNT 0x07 0		; close lsb_en
;NOP 2
;MOV CNT 0x06 0		; close jc_shift_en
;NOP 4
;
;MOV ADX 0x01 0		; switch off d_ads


;write to memory
MOV MEM 0x00 0		; write to SRAM
NOP 8
MOV MEM 0x00 1		; write to SRAM
NOP 4

NOP 56

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
