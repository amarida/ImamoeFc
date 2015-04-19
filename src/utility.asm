; X座標、Y座標から
; 表示位置の上位ビット下位ビットを計算
.proc ConvertCoordToBit
	;conv_coord_bit_x		X座標
	;conv_coord_bit_y		Y座標
	;conv_coord_bit_up		上位ビット
	;conv_coord_bit_low		下位ビット

	; y * 32
	lda #0
	sta multi_ans_up
	sta multi_ans_low
	lda conv_coord_bit_y
	sta multi_ans_low

	; 32倍
	clc
	asl multi_ans_low		; 下位は左シフト
	rol multi_ans_up		; 上位は左ローテート

	asl multi_ans_low
	rol multi_ans_up

	asl multi_ans_low
	rol multi_ans_up

	asl multi_ans_low
	rol multi_ans_up

	asl multi_ans_low
	rol multi_ans_up

	; + x
;	lda multi_ans_low
;	adc conv_coord_bit_x
;	sta multi_ans_low
	
	; 画面１か画面２か
	lda #$20
	sta draw_bg_display

;jmp noset24
	clc
;	lda conv_coord_bit_x
	asl				; 左シフト
	lsr				; 右シフト
;	asl				; 左シフト
;	lsr				; 右シフト
	lsr
;	bcs set24
	asl	; 左シフト
;	bcs set24
	asl	; 左シフト
;	bcs set24
	jmp noset24
	
set24:
;	lda #$24
;	sta draw_bg_display
;	sec
;	lda conv_coord_bit_x;
;	sbc #32;
;	sta conv_coord_bit_x
noset24:

	; + x
	lda multi_ans_low
	adc conv_coord_bit_x
	sta multi_ans_low

	; 下位＋下位
	clc
	lda multi_ans_low
	adc #$20
	sta conv_coord_bit_low
	; 上位＋上位
	lda multi_ans_up
	adc draw_bg_display;#$20
	sta conv_coord_bit_up

	rts
.endproc
