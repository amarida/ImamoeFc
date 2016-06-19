.proc	Item_Init
	lda #0
	sta item_world_pos_x_low
	sta item_world_pos_x_hi
	sta item_status
	sta item_pos_y
	sta item_alive_flag

	rts
.endproc

; 登場
.proc Item_Appear

	; 空いているか
	lda item_alive_flag
	beq set_item
	
;	jmp skip_appear

set_item:
	lda enemy_pos_x_hi
	sta item_world_pos_x_hi
	lda enemy_pos_x_low
	sta item_world_pos_x_low
	lda enemy_pos_y
	sta item_pos_y
	
	; 色々初期化
	lda #0
	sta item_status
	
	; 属性
	lda #%00000010	; パレット3を使用
	sta char_12_type01_s
	sta char_12_type07_s
	sta char_12_type08_s
	sta char_12_type09_s
	sta char_12_type10_s
	sta char_12_type11_s
	sta char_12_type12_s
	sta char_12_type01_s2
	sta char_12_type07_s2
	sta char_12_type08_s2
	sta char_12_type09_s2
	sta char_12_type10_s2
	sta char_12_type11_s2
	sta char_12_type12_s2
	lda #%00000011	; パレット4を使用
	sta char_12_type02_s
	sta char_12_type03_s
	sta char_12_type04_s
	sta char_12_type05_s
	sta char_12_type06_s
	sta char_12_type02_s2
	sta char_12_type03_s2
	sta char_12_type04_s2
	sta char_12_type05_s2
	sta char_12_type06_s2
	
	; パレット3を酒下4を酒上
	lda #7
	sta palette_change_state

	; フラグを立てる
	clc
	lda #1
	sta item_alive_flag

skip_appear:
	; スキップ
	rts
.endproc	; Item_Appear

; アイテムクリア
.proc Item_Clear
	
	; 生存フラグの確認
	lda item_alive_flag
	bne not_skip_clear		; 存在している
	jmp skip_clear
	not_skip_clear:

	lda #0
	sta char_12_type01_y
	sta char_12_type01_t
	sta char_12_type01_s
	sta char_12_type01_x
	sta char_12_type02_y
	sta char_12_type02_t
	sta char_12_type02_s
	sta char_12_type02_x
	sta char_12_type03_y
	sta char_12_type03_t
	sta char_12_type03_s
	sta char_12_type03_x
	sta char_12_type04_y
	sta char_12_type04_t
	sta char_12_type04_s
	sta char_12_type04_x
	sta char_12_type05_y
	sta char_12_type05_t
	sta char_12_type05_s
	sta char_12_type05_x
	sta char_12_type06_y
	sta char_12_type06_t
	sta char_12_type06_s
	sta char_12_type06_x
	sta char_12_type07_y
	sta char_12_type07_t
	sta char_12_type07_s
	sta char_12_type07_x
	sta char_12_type08_y
	sta char_12_type08_t
	sta char_12_type08_s
	sta char_12_type08_x
	sta char_12_type09_y
	sta char_12_type09_t
	sta char_12_type09_s
	sta char_12_type09_x
	sta char_12_type10_y
	sta char_12_type10_t
	sta char_12_type10_s
	sta char_12_type10_x
	sta char_12_type11_y
	sta char_12_type11_t
	sta char_12_type11_s
	sta char_12_type11_x
	sta char_12_type12_y
	sta char_12_type12_t
	sta char_12_type12_s
	sta char_12_type12_x
	sta char_12_type01_y2
	sta char_12_type01_t2
	sta char_12_type01_s2
	sta char_12_type01_x2
	sta char_12_type02_y2
	sta char_12_type02_t2
	sta char_12_type02_s2
	sta char_12_type02_x2
	sta char_12_type03_y2
	sta char_12_type03_t2
	sta char_12_type03_s2
	sta char_12_type03_x2
	sta char_12_type04_y2
	sta char_12_type04_t2
	sta char_12_type04_s2
	sta char_12_type04_x2
	sta char_12_type05_y2
	sta char_12_type05_t2
	sta char_12_type05_s2
	sta char_12_type05_x2
	sta char_12_type06_y2
	sta char_12_type06_t2
	sta char_12_type06_s2
	sta char_12_type06_x2
	sta char_12_type07_y2
	sta char_12_type07_t2
	sta char_12_type07_s2
	sta char_12_type07_x2
	sta char_12_type08_y2
	sta char_12_type08_t2
	sta char_12_type08_s2
	sta char_12_type08_x2
	sta char_12_type09_y2
	sta char_12_type09_t2
	sta char_12_type09_s2
	sta char_12_type09_x2
	sta char_12_type10_y2
	sta char_12_type10_t2
	sta char_12_type10_s2
	sta char_12_type10_x2
	sta char_12_type11_y2
	sta char_12_type11_t2
	sta char_12_type11_s2
	sta char_12_type11_x2
	sta char_12_type12_y2
	sta char_12_type12_t2
	sta char_12_type12_s2
	sta char_12_type12_x2

	lda #0
	sta item_world_pos_x_low
	sta item_world_pos_x_hi
	sta item_pos_y
	
	; 生存フラグを落とす
	lda #0
	sta item_alive_flag

skip_clear:

	rts
.endproc ; Item_Clear

; 更新
.proc	Item_Update
	lda is_dead
	bne skip_item

	; 居ない
	lda item_alive_flag
	beq skip_item

	; 存在している

	lda item_status
	cmp #0
	beq case_update_normal
	cmp #1
	beq case_update_delete
	
case_update_normal:
	jsr Item_UpdateNormal
	jmp break
case_update_delete:
	jsr Item_UpdateDelete
	jmp break
	
break:

	; 画面外判定
	sec
	lda field_scroll_x_up
	sbc item_world_pos_x_hi
	bcc skip_dead
	sec
	lda field_scroll_x_low
	sbc item_world_pos_x_low
	bcc skip_dead
	; 画面外処理
	jsr Item_Clear


skip_dead:

skip_item:
	rts
.endproc	; Item_Update

; 通常更新
.proc	Item_UpdateNormal

	rts
.endproc	; Item_UpdateNormal

; 破棄更新
.proc	Item_UpdateDelete
	
	dec item_wait
	bne clear_skip
	jsr Item_Clear	
	clear_skip:
	rts
.endproc	; Item_UpdateDelete

; 描画
.proc	Item_DrawDma7

	; 居ない
	lda item_alive_flag
	bne not_skip_draw
	jmp skip_draw
not_skip_draw:


; 生存タイル
	lda #$1C
	sta char_12_type01_t
	lda #$2C
	sta char_12_type02_t
	lda #$3C
	sta char_12_type03_t
	lda #$3D
	sta char_12_type04_t
	lda #$0A
	sta char_12_type05_t
	lda #$0B
	sta char_12_type06_t
	lda #$1A
	sta char_12_type07_t
	lda #$1B
	sta char_12_type08_t
	lda #$2A
	sta char_12_type09_t
	lda #$2B
	sta char_12_type10_t
	lda #$3A
	sta char_12_type11_t
	lda #$3B
	sta char_12_type12_t
	

; Y座標
	clc			; キャリーフラグOFF
	lda item_pos_y
	adc #7
	sta char_12_type01_y

	adc #8
	sta char_12_type02_y

	adc #8
	sta char_12_type03_y
	sta char_12_type04_y

	adc #8
	sta char_12_type05_y
	sta char_12_type06_y

	adc #8
	sta char_12_type07_y
	sta char_12_type08_y

	adc #8
	sta char_12_type09_y
	sta char_12_type10_y

	adc #8
	sta char_12_type11_y
	sta char_12_type12_y

; X座標

	; 存在していれば、ワールド座標からウィンドウ座標に変換
	sec
	lda item_world_pos_x_low
	sbc field_scroll_x_low
	sta item_window_pos_x

	lda item_window_pos_x
	sta char_12_type03_x
	sta char_12_type05_x
	sta char_12_type07_x
	sta char_12_type09_x
	sta char_12_type11_x

	lda item_window_pos_x
	clc
	adc #4
	bcc not_overflow_4
	lda #231	; 画面外
	sta char_12_type01_y
	sta char_12_type02_y
not_overflow_4:
	sta char_12_type01_x
	sta char_12_type02_x

	lda item_window_pos_x
	clc			; キャリーフラグOFF
	adc #8
	bcc not_overflow_8	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta char_12_type04_y
	sta char_12_type06_y
	sta char_12_type08_y
	sta char_12_type10_y
	sta char_12_type12_y
not_overflow_8:
	sta char_12_type04_x
	sta char_12_type06_x
	sta char_12_type08_x
	sta char_12_type10_x
	sta char_12_type12_x

skip_draw:

	rts

.endproc	; Item_DrawDma7

; 描画
.proc	Item_DrawDma6
	; 居ない
	lda item_alive_flag
	bne not_skip_draw
	jmp skip_draw
not_skip_draw:


; 生存タイル
	lda #$1C
	sta char_12_type01_t2
	lda #$2C
	sta char_12_type02_t2
	lda #$3C
	sta char_12_type03_t2
	lda #$3D
	sta char_12_type04_t2
	lda #$0A
	sta char_12_type05_t2
	lda #$0B
	sta char_12_type06_t2
	lda #$1A
	sta char_12_type07_t2
	lda #$1B
	sta char_12_type08_t2
	lda #$2A
	sta char_12_type09_t2
	lda #$2B
	sta char_12_type10_t2
	lda #$3A
	sta char_12_type11_t2
	lda #$3B
	sta char_12_type12_t2
	

; Y座標
	clc			; キャリーフラグOFF
	lda item_pos_y
	adc #7
	sta char_12_type01_y2

	adc #8
	sta char_12_type02_y2

	adc #8
	sta char_12_type03_y2
	sta char_12_type04_y2

	adc #8
	sta char_12_type05_y2
	sta char_12_type06_y2

	adc #8
	sta char_12_type07_y2
	sta char_12_type08_y2

	adc #8
	sta char_12_type09_y2
	sta char_12_type10_y2

	adc #8
	sta char_12_type11_y2
	sta char_12_type12_y2

; X座標

	; 存在していれば、ワールド座標からウィンドウ座標に変換
	sec
	lda item_world_pos_x_low
	sbc field_scroll_x_low
	sta item_window_pos_x

	lda item_window_pos_x
	sta char_12_type03_x2
	sta char_12_type05_x2
	sta char_12_type07_x2
	sta char_12_type09_x2
	sta char_12_type11_x2

	lda item_window_pos_x
	clc
	adc #4
	bcc not_overflow_4
	lda #231	; 画面外
	sta char_12_type01_y2
	sta char_12_type02_y2
not_overflow_4:
	sta char_12_type01_x2
	sta char_12_type02_x2

	lda item_window_pos_x
	clc			; キャリーフラグOFF
	adc #8
	bcc not_overflow_8	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta char_12_type04_y2
	sta char_12_type06_y2
	sta char_12_type08_y2
	sta char_12_type10_y2
	sta char_12_type12_y2
not_overflow_8:
	sta char_12_type04_x2
	sta char_12_type06_x2
	sta char_12_type08_x2
	sta char_12_type10_x2
	sta char_12_type12_x2

skip_draw:

	rts

.endproc	; Item_DrawDma6

.proc Item_GetAction
	lda #1
	sta item_status
	
	lda #24
	sta item_wait

	jsr Sound_PlayItem
	
	; パレット3を酒下獲得色4を酒上獲得色
	lda #8
	sta palette_change_state

	rts
.endproc	; Item_GetAction