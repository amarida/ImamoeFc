.proc	TakoHabaInit
	lda #0
	sta tako0_world_pos_x_low
	sta tako1_world_pos_x_low
	sta tako0_world_pos_x_hi
	sta tako1_world_pos_x_hi
	sta tako00_status
	sta tako01_status
	lda #224	; 画面外;#184
	sta tako0_pos_y
	sta tako1_pos_y

	rts
.endproc

; 登場
.proc appear_tako_haba
	; 空いているタコを探す

	lda #1
	sta tako_alive_flag_current	; フラグ参照現在位置
	ldx #0
loop_x:
	; 空いているか
	lda tako_haba_alive_flag
	and tako_alive_flag_current
	beq set_tako
	
	; 次
	asl tako_alive_flag_current
	inx
	cpx tako_max_count	; ループ最大数
	bne loop_x				; ループ

	; ここまで来たら空きはないのでスキップ
	jmp skip_tako

set_tako:
	; 空いているタコに情報をセットする
	lda enemy_pos_x_hi
	sta tako0_world_pos_x_hi,x
	lda enemy_pos_x_low
	sta tako0_world_pos_x_low,x
	lda enemy_pos_y
	sta tako0_pos_y,x
	
	; 色々初期化
	lda #0
	sta tako00_status,x
	; タコ属性を通常に変える
	lda #%00000001	; パレット2を使用
	sta REG0
	jsr TakoHaba_SetAttribute

	; フラグを立てる
	clc
	lda tako_haba_alive_flag
	adc tako_alive_flag_current
	sta tako_haba_alive_flag

	; パレット2をタコ
	lda #5
	sta palette_change_state

skip_tako:
	; スキップ
	rts
.endproc	; appear_tako_haba

; タコはばクリア
.proc TakoHaba_Clear

	; xの0,1でどちらを消すか判断する
	ldy #0
	lda #%00000001
	sta REG0
	txa
	beq not_set16
	ldy #16
	lda #%00000010
	sta REG0
	not_set16:
	
	; 生存フラグの確認
	lda tako_haba_alive_flag
	and REG0
	bne not_skip_clear		; 存在している
	jmp skip_clear
	not_skip_clear:

	lda #0
	sta char4_p1_index1_y,y
	sta char4_p1_index1_t,y
	sta char4_p1_index1_s,y
	sta char4_p1_index1_x,y
	sta char4_p1_index2_y,y
	sta char4_p1_index2_t,y
	sta char4_p1_index2_s,y
	sta char4_p1_index2_x,y
	sta char4_p1_index3_y,y
	sta char4_p1_index3_t,y
	sta char4_p1_index3_s,y
	sta char4_p1_index3_x,y
	sta char4_p1_index4_y,y
	sta char4_p1_index4_t,y
	sta char4_p1_index4_s,y
	sta char4_p1_index4_x,y
	sta char4_p1_index1_y2,y
	sta char4_p1_index1_t2,y
	sta char4_p1_index1_s2,y
	sta char4_p1_index1_x2,y
	sta char4_p1_index2_y2,y
	sta char4_p1_index2_t2,y
	sta char4_p1_index2_s2,y
	sta char4_p1_index2_x2,y
	sta char4_p1_index3_y2,y
	sta char4_p1_index3_t2,y
	sta char4_p1_index3_s2,y
	sta char4_p1_index3_x2,y
	sta char4_p1_index4_y2,y
	sta char4_p1_index4_t2,y
	sta char4_p1_index4_s2,y
	sta char4_p1_index4_x2,y

	lda #0
	sta tako0_world_pos_x_low,x
	sta tako0_world_pos_x_hi,x
	sta tako0_pos_y,x
	
	; 生存フラグを落とす
	lda tako_haba_alive_flag
	eor REG0
	sta tako_haba_alive_flag

skip_clear:

	rts
.endproc ; TakoHaba_Clear


; 更新
.proc	TakoHaba_Update
	lda is_dead
	bne skip_tako

	; そもそも一体も居ない
	lda tako_haba_alive_flag
	beq skip_tako

	lda #1
	sta tako_alive_flag_current	; フラグ参照現在位置
	ldx #0
loop_x:
	; 生存しているか
	lda tako_haba_alive_flag
	and tako_alive_flag_current
	beq next_update		; 存在していない
	; 存在している

	jsr TakoHaba_UpdateNormal

	; 画面外判定
	sec
	lda field_scroll_x_hi
	sbc tako0_world_pos_x_hi,x
	bcc skip_dead
	sec
	lda field_scroll_x_low
	sbc tako0_world_pos_x_low,x
	bcc skip_dead
	; 画面外処理
	jsr TakoHaba_Clear

skip_dead:

next_update:
	; 次
	asl tako_alive_flag_current
	inx
	cpx tako_max_count	; ループ最大数
	bne loop_x				; ループ

skip_tako:
	rts
.endproc	; TakoHaba_Update

; 通常更新
.proc	TakoHaba_UpdateNormal
	; 重力
	clc
	lda #2
	adc tako0_pos_y,x
	sta tako0_pos_y,x

	; あたり判定
	jsr tako_collision_object
	
	lda obj_collision_result
	beq roll_skip
	; 当たった処理


	;下の処理
	sec
	lda tako0_pos_y,x
	and #%11111000
	sta tako0_pos_y,x
	
roll_skip:

	; 左移動
	sec
	lda tako0_world_pos_x_decimal,x
	sbc #$80
	sta tako0_world_pos_x_decimal,x
	lda tako0_world_pos_x_low,x
	sbc #1
	sta tako0_world_pos_x_low,x
	lda tako0_world_pos_x_hi,x
	sbc #0
	sta tako0_world_pos_x_hi,x

	rts
.endproc	; TakoHaba_UpdateNormal

; 描画
.proc	TakoHaba_DrawDma7

	; そもそも一体も居ない
	lda tako_haba_alive_flag
	bne not_skip_alltako
	jmp skip_alltako
not_skip_alltako:

	ldx #0
	
	lda #1
	sta tako_alive_flag_current	; フラグ参照現在位置
	
loop_x:
	; 生存しているか
	lda tako_haba_alive_flag
	and tako_alive_flag_current
	bne not_skip_draw		; 存在してる
	jmp skip_draw
	not_skip_draw:

	ldy #0
	txa		; xをaにコピー
	beq skip_set16
	ldy #16	; xが0ならyは0、xが1ならyは16
	skip_set16:

	; アニメパターン
	;REG0 = (p_pat == 0) ? #$00 : #$02;

	lda p_pat
	beq set_pat0
	bne set_pat1
	
set_pat0:
	lda #$00
	sta REG0
	sta REG1
	sta REG2
	jmp break_pat
set_pat1:
	lda #$04
	sta REG0
	lda #$00
	sta REG1
	lda #$02
	sta REG2
	jmp break_pat
	
break_pat:

	lda tako00_status,x
	cmp #0
	beq case_normal
	cmp #1
	beq case_fire

case_normal:
; 生存タイル
	sec
	lda #$68     ; 
	sbc REG1
	sta char4_p1_index1_t,y
	sec
	lda #$69
	sbc REG1
	sta char4_p1_index2_t,y
	sec
	lda #$78
	sbc REG0
	sta char4_p1_index3_t,y
	sec
	lda #$79
	sbc REG0
	sta char4_p1_index4_t,y

	jmp case_break

case_fire:
; 燃えタイル
	clc
	lda #$70     ; 
	adc REG2
	sta char4_p1_index1_t,y
	clc
	lda #$71
	adc REG2
	sta char4_p1_index2_t,y
	sec
	lda #$78
	sbc REG0
	sta char4_p1_index3_t,y
	sec
	lda #$79
	sbc REG0
	sta char4_p1_index4_t,y

	; タコ属性を燃えに変える
	lda #%00000010	; パレット3を使用
	sta REG0
	jsr TakoHaba_SetAttribute

	jmp case_break

case_break:

; Y座標
	clc			; キャリーフラグOFF
	lda tako0_pos_y,x
	adc #7
	sta char4_p1_index1_y,y
	sta char4_p1_index2_y,y

	clc			; キャリーフラグOFF
	lda tako0_pos_y,x
	adc #15
	sta char4_p1_index3_y,y
	sta char4_p1_index4_y,y

; X座標

	; 存在していれば、ワールド座標からウィンドウ座標に変換
	sec
	lda tako0_world_pos_x_low,x
	sbc field_scroll_x_low
	sta tako0_window_pos_x,x

	lda tako0_window_pos_x,x
	sta char4_p1_index1_x,y
	sta char4_p1_index3_x,y

	lda tako0_window_pos_x,x
	clc			; キャリーフラグOFF
	adc #8
	bcc not_overflow_8	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta char4_p1_index2_y,y
	sta char4_p1_index4_y,y
not_overflow_8:
	sta char4_p1_index2_x,y
	sta char4_p1_index4_x,y

skip_draw:

	; 次
	asl tako_alive_flag_current
	inx
	cpx tako_max_count	; ループ最大数
	beq skip_loop_x				; ループ
	jmp loop_x
	skip_loop_x:

skip_alltako:

	rts

.endproc	; TakoHaba_DrawDma7

; 描画
.proc	TakoHaba_DrawDma6
	; そもそも一体も居ない
	lda tako_haba_alive_flag
	bne not_skip_alltako
	jmp skip_alltako
not_skip_alltako:

	ldx #0
	
	lda #1
	sta tako_alive_flag_current	; フラグ参照現在位置
	
loop_x:
	; 生存しているか
	lda tako_haba_alive_flag
	and tako_alive_flag_current
	bne not_skip_draw		; 存在してる
	jmp skip_draw
	not_skip_draw:

	ldy #0
	txa		; xをaにコピー
	beq skip_set16
	ldy #16	; xが0ならyは0、xが1ならyは16
	skip_set16:

	; アニメパターン
	;REG0 = (p_pat == 0) ? #$00 : #$02;

	lda p_pat
	beq set_pat0
	bne set_pat1
	
set_pat0:
	lda #$00
	sta REG0
	sta REG1
	sta REG2
	jmp break_pat
set_pat1:
	lda #$04
	sta REG0
	lda #$00
	sta REG1
	lda #$02
	sta REG2
	jmp break_pat
	
break_pat:

	lda tako00_status,x
	cmp #0
	beq case_normal
	cmp #1
	beq case_fire

case_normal:
; 生存タイル
	sec
	lda #$68     ; 
	sbc REG1
	sta char4_p1_index1_t2,y
	sec
	lda #$69
	sbc REG1
	sta char4_p1_index2_t2,y
	sec
	lda #$78
	sbc REG0
	sta char4_p1_index3_t2,y
	sec
	lda #$79
	sbc REG0
	sta char4_p1_index4_t2,y
	
	jmp case_break

case_fire:
; 燃えタイル
	clc
	lda #$70     ; 
	adc REG2
	sta char4_p1_index1_t2,y
	clc
	lda #$71
	adc REG2
	sta char4_p1_index2_t2,y
	sec
	lda #$78
	sbc REG0
	sta char4_p1_index3_t2,y
	sec
	lda #$79
	sbc REG0
	sta char4_p1_index4_t2,y

	; タコ属性を燃えに変える
	lda #%00000010	; パレット3を使用
	sta REG0
	jsr TakoHaba_SetAttribute

	jmp case_break

case_break:

; Y座標
	clc			; キャリーフラグOFF
	lda tako0_pos_y,x
	adc #7
	sta char4_p1_index1_y2,y
	sta char4_p1_index2_y2,y

	clc			; キャリーフラグOFF
	lda tako0_pos_y,x
	adc #15
	sta char4_p1_index3_y2,y
	sta char4_p1_index4_y2,y

; X座標

	; 存在していれば、ワールド座標からウィンドウ座標に変換
	sec
	lda tako0_world_pos_x_low,x
	sbc field_scroll_x_low
	sta tako0_window_pos_x,x

	lda tako0_window_pos_x,x
	sta char4_p1_index1_x2,y
	sta char4_p1_index3_x2,y

	lda tako0_window_pos_x,x
	clc			; キャリーフラグOFF
	adc #8
	bcc not_overflow_8	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta char4_p1_index2_y2,y
	sta char4_p1_index4_y2,y
not_overflow_8:
	sta char4_p1_index2_x2,y
	sta char4_p1_index4_x2,y

skip_draw:

	; 次
	asl tako_alive_flag_current
	inx
	cpx tako_max_count	; ループ最大数
	beq skip_loop_x				; ループ
	jmp loop_x
	skip_loop_x:

skip_alltako:

	rts

.endproc	; TakoHaba_DrawDma6

.proc TakoHaba_SetAttribute
	; 引数REG0：属性(0か1)
	; 引数x：タコ１かタコ２
	; xが0か1かで変える属性を判定する
	txa
	cmp #0
	beq tako1
	cmp #1
	beq tako2
tako1:
	lda REG0
	sta char4_p1_index1_s
	sta char4_p1_index2_s
	sta char4_p1_index3_s
	sta char4_p1_index4_s
	sta char4_p1_index1_s2
	sta char4_p1_index2_s2
	sta char4_p1_index3_s2
	sta char4_p1_index4_s2
	
	jmp break
tako2:
	lda REG0
	sta char4_p2_index1_s
	sta char4_p2_index2_s
	sta char4_p2_index3_s
	sta char4_p2_index4_s
	sta char4_p2_index1_s2
	sta char4_p2_index2_s2
	sta char4_p2_index3_s2
	sta char4_p2_index4_s2

break:
	rts
.endproc	; Tako_SetSplashAttribute
