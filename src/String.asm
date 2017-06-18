.proc	String_Init
	lda REG0
	sta str_speedup_pos_x
	lda REG1
	sta str_speedup_pos_y
	lda #0
	sta str_speedup_frame

	rts
.endproc

; 文字列クリア
.proc String_Clear
	lda #0
	sta str4_index1_y
	sta str4_index1_t
	sta str4_index1_s
	sta str4_index1_x
	sta str4_index2_y
	sta str4_index2_t
	sta str4_index2_s
	sta str4_index2_x
	sta str4_index3_y
	sta str4_index3_t
	sta str4_index3_s
	sta str4_index3_x
	sta str4_index4_y
	sta str4_index4_t
	sta str4_index4_s
	sta str4_index4_x
	sta str4_index1_y2
	sta str4_index1_t2
	sta str4_index1_s2
	sta str4_index1_x2
	sta str4_index2_y2
	sta str4_index2_t2
	sta str4_index2_s2
	sta str4_index2_x2
	sta str4_index3_y2
	sta str4_index3_t2
	sta str4_index3_s2
	sta str4_index3_x2
	sta str4_index4_y2
	sta str4_index4_t2
	sta str4_index4_s2
	sta str4_index4_x2

	rts
.endproc ; String_Clear

; 更新
.proc String_Update
	lda str_speedup_state
	cmp #1
	beq case_up

case_up:
	jsr String_UpdateSpeedUpPos
	jmp break

break:

	rts
.endproc	; String_Update

.proc String_UpdateSpeedUpPos

	; スピードアップ文字上昇
	dec str_speedup_pos_y
	inc str_speedup_frame
	lda str_speedup_frame
	cmp #60
	bne no_update
	lda #0
	sta str_speedup_state
	jsr String_Clear
no_update:

	rts
.endproc	; String_UpdateSpeedUpPos

; 描画
.proc	String_DrawDma7

	; 居ない
	lda str_speedup_state
	bne not_skip_draw
	jmp skip_draw
not_skip_draw:


; 生存タイル
	lda #$03
	sta str4_index1_t
	lda #$04
	sta str4_index2_t
	lda #$05
	sta str4_index3_t
	lda #$06
	sta str4_index4_t

; Y座標
	clc			; キャリーフラグOFF
	lda str_speedup_pos_y
	adc #0
	sta str4_index1_y
	sta str4_index2_y
	sta str4_index3_y
	sta str4_index4_y

; X座標

	lda str_speedup_pos_x
	sta str4_index1_x

	lda str_speedup_pos_x
	clc
	adc #8
	bcc not_overflow_8
	lda #231	; 画面外
	sta str4_index2_y
not_overflow_8:
	sta str4_index2_x

	lda str_speedup_pos_x
	clc			; キャリーフラグOFF
	adc #16
	bcc not_overflow_16	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta str4_index3_y
not_overflow_16:
	sta str4_index3_x

	lda str_speedup_pos_x
	clc			; キャリーフラグOFF
	adc #25
	bcc not_overflow_25	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta str4_index4_y
not_overflow_25:
	sta str4_index4_x

skip_draw:

	rts

.endproc	; String_DrawDma7

; 描画
.proc	String_DrawDma6

	; 居ない
	lda str_speedup_state
	bne not_skip_draw
	jmp skip_draw
not_skip_draw:


; 生存タイル
	lda #$03
	sta str4_index1_t2
	lda #$04
	sta str4_index2_t2
	lda #$05
	sta str4_index3_t2
	lda #$06
	sta str4_index4_t2

; Y座標
	clc			; キャリーフラグOFF
	lda str_speedup_pos_y
	adc #0
	sta str4_index1_y2
	sta str4_index2_y2
	sta str4_index3_y2
	sta str4_index4_y2

; X座標

	lda str_speedup_pos_x
	sta str4_index1_x2

	lda str_speedup_pos_x
	clc
	adc #8
	bcc not_overflow_8
	lda #231	; 画面外
	sta str4_index2_y2
not_overflow_8:
	sta str4_index2_x2

	lda str_speedup_pos_x
	clc			; キャリーフラグOFF
	adc #16
	bcc not_overflow_16	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta str4_index3_y2
not_overflow_16:
	sta str4_index3_x2

	lda str_speedup_pos_x
	clc			; キャリーフラグOFF
	adc #25
	bcc not_overflow_25	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta str4_index4_y2
not_overflow_25:
	sta str4_index4_x2

skip_draw:

	rts
.endproc	; String_DrawDma6
