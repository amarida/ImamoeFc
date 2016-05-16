.proc	CannonMask_Init
	jsr CannonMask_Clear
	
	rts
.endproc

; マスク大砲クリア
.proc CannonMask_Clear
	lda #0
	sta cannonLeft1_y
	sta cannonLeft1_t
	sta cannonLeft1_s
	sta cannonLeft1_x
	sta cannonLeft2_y
	sta cannonLeft2_t
	sta cannonLeft2_s
	sta cannonLeft2_x
	sta cannonLeft1_y2
	sta cannonLeft1_t2
	sta cannonLeft1_s2
	sta cannonLeft1_x2
	sta cannonLeft2_y2
	sta cannonLeft2_t2
	sta cannonLeft2_s2
	sta cannonLeft2_x2

	lda #0
	sta cannon_world_x_low
	sta cannon_world_x_hi
	sta cannon_y
	
	lda #0
	sta cannon_alive_flag

	rts
.endproc ; CannonMask_Clear

; 登場
.proc CannonMask_Appear
	lda #1
	sta cannon_alive_flag
	
	; タイル番号
	lda #$8F
	sta cannonLeft1_t
	sta cannonLeft1_t2
	lda #$9F
	sta cannonLeft2_t
	sta cannonLeft2_t2
	; 属性
	lda #%00000011
	sta cannonLeft1_s
	sta cannonLeft2_s
	sta cannonLeft1_s2
	sta cannonLeft2_s2

	; 大砲の位置を保持する
	lda enemy_pos_x_hi
	sta cannon_world_x_hi
	lda enemy_pos_x_low
	sta cannon_world_x_low
	lda enemy_pos_y
	sta cannon_y

	clc
	lda cannon_world_x_low
	adc #9
	sta cannon_world_x_low
	lda cannon_world_x_hi
	adc #0
	sta cannon_world_x_hi

	rts
.endproc	; CannonMask_Appear

; 更新
.proc	CannonMask_Update
	lda is_dead
	bne skip_mask

	lda cannon_alive_flag
	beq skip_mask

skip_mask:
	rts
.endproc	; CannonMask_Update


; 描画
.proc	CannonMask_DrawDma7

	lda cannon_alive_flag
	bne not_skip_draw
	jmp skip_draw
not_skip_draw:

	; 存在していれば、ワールド座標からウィンドウ座標に変換
	sec
	lda cannon_world_x_low
	sbc field_scroll_x_low
	sta cannonLeft1_x
	sta cannonLeft2_x
	clc
	lda cannon_y
	adc #7
	sta cannonLeft1_y
	adc #8
	sta cannonLeft2_y

	sec
	lda cannonLeft1_x
	sbc #16
	bcs not_skip	; キャリーフラグが立っている
	lda #231	; 画面外
	sta cannonLeft1_y
	sta cannonLeft2_y

	not_skip:

skip_draw:

;End:
	rts

.endproc	; CannonMask_DrawDma7

; 描画
.proc	CannonMask_DrawDma6

	lda cannon_alive_flag
	bne not_skip_draw
	jmp skip_draw
not_skip_draw:

	; 存在していれば、ワールド座標からウィンドウ座標に変換
	sec
	lda cannon_world_x_low
	sbc field_scroll_x_low
	sta cannonLeft1_x2
	sta cannonLeft2_x2
	clc
	lda cannon_y
	adc #7
	sta cannonLeft1_y2
	adc #8
	sta cannonLeft2_y2

	sec
	lda cannonLeft1_x2
	sbc #16
	bcs not_skip	; キャリーフラグが立っている
	lda #231	; 画面外
	sta cannonLeft1_y2
	sta cannonLeft2_y2
	not_skip:

skip_draw:

	rts

.endproc	; CannonMask_DrawDma6
