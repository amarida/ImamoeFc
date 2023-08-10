.include "macro.asm"

.proc	Button_Init
	lda #0
	sta item_world_pos_x_low
	sta item_world_pos_x_hi
	sta item_status
	sta item_pos_y
	sta button_alive_flag
	sta boss_room_status

	rts
.endproc

; 登場
.proc appear_button

	; 空いているか
	lda button_alive_flag
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
	lda #%00000001	; パレット2を使用
	sta sw_index1_s
	sta sw_index2_s
	sta sw_index3_s
	sta sw_index4_s
	sta sw_index1_s2
	sta sw_index2_s2
	sta sw_index3_s2
	sta sw_index4_s2

	; フラグを立てる
	clc
	lda #1
	sta button_alive_flag

skip_appear:
	; スキップ
	rts
.endproc	; Button_Appear

; ボタンクリア
.proc Button_Clear
	
	; 生存フラグの確認
	lda button_alive_flag
	bne not_skip_clear		; 存在している
	jmp skip_clear
	not_skip_clear:

	lda #0

	lda #0
	sta item_world_pos_x_low
	sta item_world_pos_x_hi
	sta item_pos_y
	
	; 生存フラグを落とす
	lda #0
	sta button_alive_flag

skip_clear:

	rts
.endproc ; Button_Clear

; 更新
.proc	Button_Update
	lda is_dead
	bne skip_item

	; 居ない
	lda button_alive_flag
	beq skip_item

	; 存在している

	lda item_status
	cmp #0
	beq case_update_normal
	cmp #1
	beq case_update_push
	
case_update_normal:
	jsr Button_UpdateNormal
	jmp break
case_update_push:
	jsr Button_UpdatePush
	jmp break
	
break:

	; 画面外判定
	sec
	lda field_scroll_x_hi
	sbc item_world_pos_x_hi
	bcc skip_dead
	sec
	lda field_scroll_x_low
	sbc item_world_pos_x_low
	bcc skip_dead
	; 画面外処理
	jsr Button_Clear


skip_dead:

skip_item:
	rts
.endproc	; Button_Update

; 通常更新
.proc	Button_UpdateNormal

	rts
.endproc	; Button_UpdateNormal

; 破棄更新
.proc	Button_UpdatePush
	
	rts
.endproc	; Button_UpdatePush

; 描画
.proc	Button_DrawDma7

	; 居ない
	lda button_alive_flag
	bne not_skip_draw
	jmp skip_draw
not_skip_draw:

	lda item_status
	cmp #0
	beq case_normal
	cmp #1
	beq case_push

case_normal:
	; 通常タイル
	lda #$7D
	sta sw_index1_t
	lda #$7E
	sta sw_index2_t
	lda #$8D
	sta sw_index3_t
	lda #$8E
	sta sw_index4_t	

	jmp tile_exit

case_push:
	; 押したタイル
	lda #$00
	sta sw_index1_t
	lda #$00
	sta sw_index2_t
	lda #$6D
	sta sw_index3_t
	lda #$6E
	sta sw_index4_t	

	jmp tile_exit


tile_exit:

; Y座標
	clc			; キャリーフラグOFF
	lda item_pos_y
	sta sw_index1_y
	sta sw_index2_y

	adc #8
	sta sw_index3_y
	sta sw_index4_y

; X座標

	; 存在していれば、ワールド座標からウィンドウ座標に変換
	sec
	lda item_world_pos_x_low
	sbc field_scroll_x_low
	sta item_window_pos_x

	lda item_window_pos_x
	sta sw_index1_x
	sta sw_index3_x

	lda item_window_pos_x
	clc
	adc #8
	bcc not_overflow_8
	lda #231	; 画面外
	sta sw_index2_y
	sta sw_index4_y
not_overflow_8:
	sta sw_index2_x
	sta sw_index4_x

skip_draw:

	rts

.endproc	; Button_DrawDma7

; 描画
.proc	Button_DrawDma6
	; 居ない
	lda button_alive_flag
	bne not_skip_draw
	jmp skip_draw
not_skip_draw:


	lda item_status
	cmp #0
	beq case_normal
	cmp #1
	beq case_push

case_normal:
	; 通常タイル
	lda #$7D
	sta sw_index1_t2
	lda #$7E
	sta sw_index2_t2
	lda #$8D
	sta sw_index3_t2
	lda #$8E
	sta sw_index4_t2

	jmp tile_exit

case_push:
	; 押したタイル
	lda #$00
	sta sw_index1_t2
	lda #$00
	sta sw_index2_t2
	lda #$6D
	sta sw_index3_t2
	lda #$6E
	sta sw_index4_t2

	jmp tile_exit

tile_exit:	

; Y座標
	clc			; キャリーフラグOFF
	lda item_pos_y
	sta sw_index1_y2
	sta sw_index2_y2

	adc #8
	sta sw_index3_y2
	sta sw_index4_y2

; X座標

	; 存在していれば、ワールド座標からウィンドウ座標に変換
	sec
	lda item_world_pos_x_low
	sbc field_scroll_x_low
	sta item_window_pos_x

	lda item_window_pos_x
	sta sw_index1_x2
	sta sw_index3_x2

	lda item_window_pos_x
	clc
	adc #8
	bcc not_overflow_8
	lda #231	; 画面外
	sta sw_index2_y2
	sta sw_index4_y2
not_overflow_8:
	sta sw_index2_x2
	sta sw_index4_x2

skip_draw:

	rts

.endproc	; Button_DrawDma6

.proc Button_Action
	lda #1
	sta item_status
	; ボス上移動
	lda #3
	sta boss_status
	; ボス決着
	lda #5 ; scene_maingameのscene_update_step
	sta scene_update_step
	; 屋根
	lda #1
	sta boss_room_status
	lda #0
	sta boss_room_status_wait

	rts
.endproc	; Button_GetAction