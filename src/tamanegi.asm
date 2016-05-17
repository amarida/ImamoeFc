.proc	TamanegiInit
	lda #0
	sta tamanegi0_world_pos_x_low
	sta tamanegi1_world_pos_x_low
	sta tamanegi0_world_pos_x_hi
	sta tamanegi1_world_pos_x_hi
	sta tamanegi00_status
	sta tamanegi01_status
	sta tamanegi00_wait
	sta tamanegi01_wait
	sta tamanegi00_update_step
	sta tamanegi01_update_step
	lda #224	; 画面外;#184
	sta tamanegi0_pos_y
	sta tamanegi1_pos_y
	; 属性は変わらない
	lda #%00000001     ; 0(10進数)をAにロード
	sta tamanegi1_s
	sta tamanegi2_s
	sta tamanegi3_s
	sta tamanegi4_s
	sta tamanegi21_s
	sta tamanegi22_s
	sta tamanegi23_s
	sta tamanegi24_s
	sta tamanegi1_s2
	sta tamanegi2_s2
	sta tamanegi3_s2
	sta tamanegi4_s2
	sta tamanegi21_s2
	sta tamanegi22_s2
	sta tamanegi23_s2
	sta tamanegi24_s2

	rts
.endproc

; 登場
.proc appear_tamanegi

	; 空いているタマネギを探す
	lda #1
	sta palette_change_state

	lda #1
	sta tamanegi_alive_flag_current	; フラグ参照現在位置
	ldx #0
loop_x:
	; 空いているか
	lda tamanegi_alive_flag
	and tamanegi_alive_flag_current
	beq set_tamanegi
	
	; 次
	asl tamanegi_alive_flag_current
	inx
	cpx tamanegi_max_count	; ループ最大数
	bne loop_x				; ループ

	; ここまで来たら空きはないのでスキップ
	jmp skip_tamanegi

set_tamanegi:
	; 空いているタマネギに情報をセットする
	lda enemy_pos_x_hi
	sta tamanegi0_world_pos_x_hi,x
	lda enemy_pos_x_low
	sta tamanegi0_world_pos_x_low,x
	lda enemy_pos_y
	sta tamanegi0_pos_y,x

	; 大砲のマスクを登場させる
	jsr CannonMask_Appear
	
	; 色々初期化

	lda #0
	sta tamanegi00_status,x
	sta tamanegi00_update_step,x
	; タマネギ属性を通常に変える
	lda #%00000001	; パレット2を使用
	sta REG0
	lda #%01000001	; パレット2を使用
	sta REG1
	jsr Tamanegi_SetAttribute

	; 生存フラグを立てる
	clc
	lda tamanegi_alive_flag
	adc tamanegi_alive_flag_current
	sta tamanegi_alive_flag

skip_tamanegi:
	; スキップ
	rts
.endproc	; appear_tamanegi

;;;;; 削除 ;;;;;
.proc Tamanegi_Clear

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
	lda tamanegi_alive_flag
	and REG0
	beq skip_clear		; 存在していない

	lda #0
	sta tamanegi1_y,y
	sta tamanegi1_t,y
	sta tamanegi1_s,y
	sta tamanegi1_x,y
	sta tamanegi2_y,y
	sta tamanegi2_t,y
	sta tamanegi2_s,y
	sta tamanegi2_x,y
	sta tamanegi3_y,y
	sta tamanegi3_t,y
	sta tamanegi3_s,y
	sta tamanegi3_x,y
	sta tamanegi4_y,y
	sta tamanegi4_t,y
	sta tamanegi4_s,y
	sta tamanegi4_x,y
	sta tamanegi1_y2,y
	sta tamanegi1_t2,y
	sta tamanegi1_s2,y
	sta tamanegi1_x2,y
	sta tamanegi2_y2,y
	sta tamanegi2_t2,y
	sta tamanegi2_s2,y
	sta tamanegi2_x2,y
	sta tamanegi3_y2,y
	sta tamanegi3_t2,y
	sta tamanegi3_s2,y
	sta tamanegi3_x2,y
	sta tamanegi4_y2,y
	sta tamanegi4_t2,y
	sta tamanegi4_s2,y
	sta tamanegi4_x2,y

	lda #0
	sta tamanegi0_world_pos_x_low,x
	sta tamanegi0_world_pos_x_hi,x
	sta tamanegi0_pos_y,x
	
	; 生存フラグを落とす
	lda tamanegi_alive_flag
	eor REG0
	sta tamanegi_alive_flag

skip_clear:

	rts
.endproc	; Tamanegi_Clear


; 更新
.proc	TamanegiUpdate
	lda is_dead
	bne skip_tamanegi

	; そもそも一体も居ない
	lda tamanegi_alive_flag
	beq skip_tamanegi

	lda #1
	sta tamanegi_alive_flag_current	; フラグ参照現在位置
	ldx #0
loop_x:
	; 生存しているか
	lda tamanegi_alive_flag
	and tamanegi_alive_flag_current
	beq next_update		; 存在していない
	; 存在している

	; 状態
	lda tamanegi00_status,x
	cmp #0
	beq case_in_the_cannon
	cmp #1
	beq case_parabola
	cmp #2
	beq case_normal
	cmp #3
	beq case_burst

; 大砲の中
case_in_the_cannon:
	jsr Tamanegi_UpdateInTheCannon
	jmp break;

; 放物線
case_parabola:
	jsr Tamanegi_UpdateParabola
	jmp break;

; 通常
case_normal:
	jsr Tamanegi_UpdateNormal
	jmp break;

; 炎上
case_burst:
	jsr Tamanegi_UpdateBurst
	jmp break;

break:

	; 画面外判定
	sec
	lda field_scroll_x_up
	sbc tamanegi0_world_pos_x_hi,x
	bcc skip_dead
	sec
	lda field_scroll_x_low
	sbc tamanegi0_world_pos_x_low,x
	bcc skip_dead
	; 画面外処理
	jsr Tamanegi_Clear
	;lda tamanegi_alive_flag
	;eor tamanegi_alive_flag_current
	;sta tamanegi_alive_flag
	;lda #224	; 画面外
	;sta tamanegi0_pos_y,x

skip_dead:

next_update:
	; 次
	asl tamanegi_alive_flag_current
	inx
	cpx tamanegi_max_count	; ループ最大数
	bne loop_x				; ループ

skip_tamanegi:
	rts
.endproc	; InosisiUpdate

; 更新大砲の中
.proc	Tamanegi_UpdateInTheCannon
	; 距離が近づくと次へ
	; タマネギのX座標
	; プレイヤーのX座標
	sec
	lda tamanegi0_window_pos_x,x
	sbc window_player_x_low
	sec
	sbc #96
	bcs skip; キャリーフラグがセットされている場合スキップ

	; キャリーフラグがクリアされている場合、距離が64未満
	lda #1
	sta tamanegi00_status,x

	lda #0
	sta tamanegi00_update_step,x

skip:
	
	rts
.endproc	; Tamanegi_UpdateInTheCannon

; 更新放物線
.proc	Tamanegi_UpdateParabola
	lda tamanegi00_update_step,x
	cmp #0
	beq step_init
	cmp #1
	beq step_update
	cmp #2
	beq step_next

step_init:

	; 速度を設定
	lda #6
	sta tamanegi00_spd_y,x
	lda #0
	sta tamanegi00_spd_y_decimal,x

	; 方向は上
	lda #1
	sta tamanegi00_spd_vec,x

	lda #1
	sta tamanegi00_update_step,x
	jmp step_break

step_update:

	; 横位置更新
	sec
	lda tamanegi0_world_pos_x_low,x
	sbc #2
	sta tamanegi0_world_pos_x_low,x
	lda tamanegi0_world_pos_x_hi,x
	sbc #0
	sta tamanegi0_world_pos_x_hi,x

	; 上下方向
	lda tamanegi00_spd_vec,x
	cmp #0
	beq case_down
	cmp #1
	beq case_up

	case_down:
		; 位置更新
		clc
		lda tamanegi0_pos_y,x
		adc tamanegi00_spd_y,x
		sta tamanegi0_pos_y,x

		; 速度更新
		clc
		lda tamanegi00_spd_y_decimal,x
		adc #$70
		sta tamanegi00_spd_y_decimal,x
		lda tamanegi00_spd_y,x
		adc #0
		sta tamanegi00_spd_y,x

		; 着地判定
		jsr tamanegi_collision_object
		
		lda obj_collision_result
		beq roll_skip
		; 当たった処理

		sec
		lda tamanegi0_pos_y,x
		and #%11111000
		sta tamanegi0_pos_y,x
	
		lda #2
		sta tamanegi00_update_step,x

		roll_skip:

		jmp case_break
	case_up:
		; 縦位置更新
		sec
		lda tamanegi0_pos_y,x
		sbc tamanegi00_spd_y,x
		sta tamanegi0_pos_y,x

		; 速度更新
		sec
		lda tamanegi00_spd_y_decimal,x
		sbc #$70
		sta tamanegi00_spd_y_decimal,x
		lda tamanegi00_spd_y,x
		sbc #0
		sta tamanegi00_spd_y,x

		; 速度反転判定
		; 実数部がマイナスになったら
		bpl	skip_negative_proc; ネガティブフラグがクリアされている
		; 速度がマイナスになったので、速度方向を下にする
		lda #0
		sta tamanegi00_spd_vec,x
		sta tamanegi00_spd_y,x
		sta tamanegi00_spd_y_decimal,x
		skip_negative_proc:

		jmp case_break

	case_break:

	jmp step_break

step_next:
	lda #2
	sta tamanegi00_status,x

	lda #0
	sta tamanegi00_update_step,x
	
	jsr CannonMask_Clear	; マスク大砲クリア

	jmp step_break

step_break:

	rts
.endproc	; Tamanegi_UpdateParabola

; 通常更新
.proc	Tamanegi_UpdateNormal
	; 重力
	clc
	lda #2
	adc tamanegi0_pos_y,x
	sta tamanegi0_pos_y,x

	; あたり判定
	jsr tamanegi_collision_object
	
	lda obj_collision_result
	beq roll_skip
	; 当たった処理


	;下の処理
	sec
	lda tamanegi0_pos_y,x
	and #%11111000
	sta tamanegi0_pos_y,x
	
roll_skip:

	; 左移動
	sec
	lda tamanegi0_world_pos_x_low,x
	sbc #1
	sta tamanegi0_world_pos_x_low,x
	lda tamanegi0_world_pos_x_hi,x
	sbc #0
	sta tamanegi0_world_pos_x_hi,x

	; ある程度距離
	sec
	lda window_player_x_low
	sbc tamanegi0_window_pos_x,x
	sta REG0
	bcc not_burst	; キャリーフラグが立っていない
	sec
	lda #48
	sbc REG0
	bcs not_burst; キャリーフラグがセットされている場合スキップ
	
	lda #3
	sta tamanegi00_status,x
	lda #0
	sta tamanegi00_update_step,x

	not_burst:

	rts
.endproc	; Tamanegi_UpdateNormal

; 更新炎上
.proc	Tamanegi_UpdateBurst
	lda tamanegi00_update_step,x
	cmp #0
	beq step_init
	cmp #1
	beq step_burst1
	cmp #2
	beq step_burst2
	cmp #3
	beq step_burst3
	cmp #4
	beq step_next

step_init:

	lda #1
	sta tamanegi00_update_step,x

	lda #15
	sta tamanegi00_wait,x

	; 火の登場
	jsr TamanegiFire_Appear

	jmp case_break

step_burst1:

	sec
	dec tamanegi00_wait,x
	bne case_break
	; 0になったら
	lda #15
	sta tamanegi00_wait,x
	lda #2
	sta tamanegi00_update_step,x

	jmp case_break

step_burst2:

	sec
	dec tamanegi00_wait,x
	bne case_break
	; 0になったら
	lda #10
	sta tamanegi00_wait,x
	lda #3
	sta tamanegi00_update_step,x

	jmp case_break

step_burst3:

	sec
	dec tamanegi00_wait,x
	bne case_break
	; 0になったら
	lda #4
	sta tamanegi00_update_step,x

	jmp case_break

step_next:
	; 炎削除
	jsr TamanegiFire_Clear
	; タマネギ削除
	jsr Tamanegi_Clear

	jmp case_break

case_break:


	rts
.endproc	; Tamanegi_UpdateBurst

; 描画
.proc	TamanegiDrawDma7
	; そもそも一体も居ない
;	lda tamanegi_alive_flag
;	bne not_skip_tamanegi
;	jmp skip_tamanegi
;not_skip_tamanegi:

	ldx #0
	ldy #0
	
	lda #1
	sta tamanegi_alive_flag_current	; フラグ参照現在位置

loop_x:
	txa		; xをaにコピー
	; aを16倍
	asl		; 左シフト
	asl
	asl
	asl
	tay		; aをyにコピー

	; 状態
	lda tamanegi00_status,x
	cmp #0
	beq case_in_the_cannon
	cmp #1
	beq case_parabola
	cmp #2
	beq case_normal
	cmp #3
	jmp case_burst

; 大砲の中
case_in_the_cannon:
; 放物線
case_parabola:
	; ななめタイル
	lda #$AB
	sta tamanegi1_t,y
	lda #$AC
	sta tamanegi2_t,y
	lda #$BB
	sta tamanegi3_t,y
	lda #$BC
	sta tamanegi4_t,y
	
	; 反転なし
	lda #%00000001
	sta tamanegi2_s,y
	sta tamanegi4_s,y

	jmp break;

; 通常
case_normal:

	; アニメパターン
	;REG0 = (p_pat == 0) ? #$0 : #1;
	;REG1 = (p_pat == 0) ? #$1 : #0;

	lda #0
	eor p_pat
	sta REG0
	eor #1
	sta REG1

	; 生存タイル
	clc
	lda #$AD     ; 
	adc REG0
	sta tamanegi1_t,y
	clc
	lda #$AD
	adc REG1
	sta tamanegi2_t,y
	clc
	lda #$BD
	adc REG0
	sta tamanegi3_t,y
	clc
	lda #$BD
	adc REG1
	sta tamanegi4_t,y
	
	; 反転あり
	lda #%01000001
	sta tamanegi2_s,y
	sta tamanegi4_s,y

	jmp break;

; 炎上
case_burst:

	lda tamanegi00_update_step,x
	cmp #0
	beq skip_hide
	cmp #1
	beq skip_hide
	; 本体は非表示
	lda #$00
	sta tamanegi1_t,y
	lda #$00
	sta tamanegi2_t,y
	lda #$00
	sta tamanegi3_t,y
	lda #$00
	sta tamanegi4_t,y

	skip_hide:
	
	jmp break

break:	

; 表示確認準備

; Y座標は更新必須
	clc			; キャリーフラグOFF
	lda tamanegi0_pos_y,x
	adc #7
	sta tamanegi1_y,y
	sta tamanegi2_y,y

	clc			; キャリーフラグOFF
	lda tamanegi0_pos_y,x
	adc #15
	sta tamanegi3_y,y
	sta tamanegi4_y,y

; Y座標以外は非表示時スキップ
	; 生存しているか
	lda tamanegi_alive_flag
	and tamanegi_alive_flag_current
	beq next_draw		; 存在していない

	; 存在していれば、ワールド座標からウィンドウ座標に変換
	sec
	lda tamanegi0_world_pos_x_low,x
	sbc field_scroll_x_low
	sta tamanegi0_window_pos_x,x

	lda tamanegi0_window_pos_x,x
	sta tamanegi1_x,y
	sta tamanegi3_x,y

	lda tamanegi0_window_pos_x,x
	clc			; キャリーフラグOFF
	adc #8
	bcc not_overflow_8	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta tamanegi2_y,y
	sta tamanegi4_y,y
not_overflow_8:
	sta tamanegi2_x,y
	sta tamanegi4_x,y

next_draw:

	; 次
	asl tamanegi_alive_flag_current
	inx
	cpx tamanegi_max_count	; ループ最大数
	beq skip_loop_x				; ループ
	jmp loop_x
	skip_loop_x:


skip_tamanegi:

	rts

.endproc	; TamanegiDrawDma7

; 描画
.proc	TamanegiDrawDma6
	; そもそも一体も居ない
;	lda tamanegi_alive_flag
;	bne not_skip_tamanegi
;	jmp skip_tamanegi
;not_skip_tamanegi:

	ldx #0
	ldy #0
	
	lda #1
	sta tamanegi_alive_flag_current	; フラグ参照現在位置

loop_x:
	txa		; xをaにコピー
	; aを16倍
	asl		; 左シフト
	asl
	asl
	asl
	tay		; aをyにコピー

	; 状態
	lda tamanegi00_status,x
	cmp #0
	beq case_in_the_cannon
	cmp #1
	beq case_parabola
	cmp #2
	beq case_normal
	cmp #3
	jmp case_burst

; 大砲の中
case_in_the_cannon:
; 放物線
case_parabola:
	; ななめタイル
	lda #$AB
	sta tamanegi1_t2,y
	lda #$AC
	sta tamanegi2_t2,y
	lda #$BB
	sta tamanegi3_t2,y
	lda #$BC
	sta tamanegi4_t2,y
	
	; 反転なし
	lda #%00000001
	sta tamanegi2_s2,y
	sta tamanegi4_s2,y
	
	jmp break;

; 通常
case_normal:
	; アニメパターン
	;REG0 = (p_pat == 0) ? #$0 : #1;
	;REG1 = (p_pat == 0) ? #$1 : #0;

	lda #0
	eor p_pat
	sta REG0
	eor #1
	sta REG1

	; 生存タイル
	clc
	lda #$AD     ; 
	adc REG0
	sta tamanegi1_t2,y
	clc
	lda #$AD
	adc REG1
	sta tamanegi2_t2,y
	clc
	lda #$BD
	adc REG0
	sta tamanegi3_t2,y
	clc
	lda #$BD
	adc REG1
	sta tamanegi4_t2,y
	
	; 反転あり
	lda #%01000001
	sta tamanegi2_s2,y
	sta tamanegi4_s2,y

	jmp break;

; 炎上
case_burst:

	lda tamanegi00_update_step,x
	cmp #0
	beq skip_hide
	cmp #1
	beq skip_hide
	; 本体は非表示
	lda #$00
	sta tamanegi1_t2,y
	lda #$00
	sta tamanegi2_t2,y
	lda #$00
	sta tamanegi3_t2,y
	lda #$00
	sta tamanegi4_t2,y

	skip_hide:
	
	jmp break

break:

	

; 表示確認準備

; Y座標は更新必須
	clc			; キャリーフラグOFF
	lda tamanegi0_pos_y,x
	adc #7
	sta tamanegi1_y2,y
	sta tamanegi2_y2,y

	clc			; キャリーフラグOFF
	lda tamanegi0_pos_y,x
	adc #15
	sta tamanegi3_y2,y
	sta tamanegi4_y2,y

; Y座標以外は非表示時スキップ
	; 生存しているか
	lda tamanegi_alive_flag
	and tamanegi_alive_flag_current
	beq next_draw		; 存在していない

	; 存在していれば、ワールド座標からウィンドウ座標に変換
	sec
	lda tamanegi0_world_pos_x_low,x
	sbc field_scroll_x_low
	sta tamanegi0_window_pos_x,x

	lda tamanegi0_window_pos_x,x
	sta tamanegi1_x2,y
	sta tamanegi3_x2,y

	lda tamanegi0_window_pos_x,x
	clc			; キャリーフラグOFF
	adc #8
	bcc not_overflow_8	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta tamanegi2_y2,y
	sta tamanegi4_y2,y
not_overflow_8:
	sta tamanegi2_x2,y
	sta tamanegi4_x2,y

next_draw:

	; 次
	asl tamanegi_alive_flag_current
	inx
	cpx tamanegi_max_count	; ループ最大数
	beq skip_loop_x				; ループ
	jmp loop_x
	skip_loop_x:

	rts

.endproc	; TamanegiDrawDma6

; タマネギとオブジェクトとのあたり判定
.proc tamanegi_collision_object
	; 死亡中は判定しない
	lda is_dead
	beq skip_return
	lda #0
	sta obj_collision_result
	rts
skip_return:

	lda #0
	sta obj_collision_sea

	; TODO:	左上の左は左下の左を流用する
	;		右下の下は左下の下を流用する
	;		右上は左上の上と右下の右を流用する
	; あたり判定用の4隅を格納
	clc
	lda tamanegi0_pos_y,x ;player_y
	sta player_y_top_for_collision		; あたり判定用上Y座標（Y座標）
	clc
	adc #15
	sta player_y_bottom_for_collision	; あたり判定用下Y座標（Y座標+15）

	lda tamanegi0_world_pos_x_hi,x ;player_x_up
	sta player_x_left_hi_for_collision	; あたり判定用左X座標上位（X座標）
	lda tamanegi0_world_pos_x_low,x ;player_x_low
	sta player_x_left_low_for_collision	; あたり判定用左X座標下位（X座標）
	clc
	adc #23
	sta player_x_right_low_for_collision; あたり判定用右X座標下位（X座標+23）
	lda player_x_left_hi_for_collision
	adc #0
	sta player_x_right_hi_for_collision	; あたり判定用右X座標上位（X座標+23）


	; プレイヤーのフィールド上の位置(左下の左下)(player_x_left_low_for_collision, player_x_left_hi_for_collision)
	; それを8で割った値（ｘ）が、マップチップの位置
	; map_chipから加える値は、X*25
	lda player_x_left_low_for_collision
	sta map_chip_player_x_low
	lda player_x_left_hi_for_collision
	sta map_chip_player_x_hi
	; 8で割る
	clc
	lsr map_chip_player_x_hi	; 上位は右シフト
	ror map_chip_player_x_low	; 下位は右ローテート
	lsr map_chip_player_x_hi	; 上位は右シフト
	ror map_chip_player_x_low	; 下位は右ローテート
	lsr map_chip_player_x_hi	; 上位は右シフト
	ror map_chip_player_x_low	; 下位は右ローテート
	; 結果を25倍(16+8+1)する　マップチップの起点を算出する
	; REG0を16倍のlow REG1を16倍のhiとして
	; REG2を 8倍のlow REG3を 8倍のhiとして
	; REG4を 1倍のlow REG5を 1倍のhiとして
	; 16倍
	lda map_chip_player_x_hi
	sta REG1
	lda map_chip_player_x_low
	sta REG0
	clc
	asl REG0		; 下位は左シフト
	rol REG1		; 上位は左ローテート
	asl REG0		; 下位は左シフト
	rol REG1		; 上位は左ローテート
	asl REG0		; 下位は左シフト
	rol REG1		; 上位は左ローテート
	asl REG0		; 下位は左シフト
	rol REG1		; 上位は左ローテート
	; 8倍
	lda map_chip_player_x_hi
	sta REG3
	lda map_chip_player_x_low
	sta REG2
	clc
	asl REG2		; 下位は左シフト
	rol REG3		; 上位は左ローテート
	asl REG2		; 下位は左シフト
	rol REG3		; 上位は左ローテート
	asl REG2		; 下位は左シフト
	rol REG3		; 上位は左ローテート
	; 1倍
	lda map_chip_player_x_hi
	sta REG5
	lda map_chip_player_x_low
	sta REG4
	; 16倍+8倍
	clc
	lda REG0
	adc REG2
	sta map_chip_collision_index_base_low
	lda REG1
	adc REG3
	sta map_chip_collision_index_base_hi
	; (16倍+8倍) + 1倍
	clc
	lda map_chip_collision_index_base_low
	adc REG4
	sta map_chip_collision_index_base_low
	lda map_chip_collision_index_base_hi
	adc REG5
	sta map_chip_collision_index_base_hi
	; ここまででキャラの左列の一番下（画面的に）を指す。

	; 左下
	clc
	lda player_y_bottom_for_collision
	sta REG0
	lsr REG0	; 右シフト
	lsr REG0	; 右シフト
	lsr REG0	; 右シフト	; 8で割る

	; 27から引く
	sec
	lda #27
	sbc REG0
	sta REG0	; 一番下からのブロック数

	clc
	lda REG0
	adc map_chip_collision_index_base_low			; キャラ左画面一番下
	sta map_chip_collision_index_left_bottom_low	; キャラ左キャラ下
	lda map_chip_collision_index_base_hi
	adc #0
	sta map_chip_collision_index_left_bottom_hi

	; キャラクタの左下のブロックの左下
	; □□
	; □□
	; □□
	; ■□
	; マップチップの起点
	lda #< map_chip
	sta map_table_char_pos_offset_low
	lda #> map_chip
	sta map_table_char_pos_offset_hi

	clc
	lda map_table_char_pos_offset_low
	adc map_chip_collision_index_left_bottom_low
	sta map_table_char_pos_offset_low
	lda map_table_char_pos_offset_hi
	adc map_chip_collision_index_left_bottom_hi
	sta map_table_char_pos_offset_hi

	ldy #0	; ずらし終わっているのでyは0
	lda (map_table_char_pos_offset_low), y
	sta map_table_char_pos_value

	; obj_collision_resultを戻り値として使用する
	; 0ならfalse
	; 1ならtrue
	lda #0
	sta obj_collision_result
	lda map_table_char_pos_value
	cmp #$01
	beq hit0
	cmp #$02
	beq hit0
	cmp #$11
	beq hit0
	cmp #$12
	beq hit0
	cmp #$07
	beq hit0
	cmp #$08
	beq hit0
	cmp #$17
	beq hit0
	cmp #$18
	beq hit0
	jmp skip0
hit0:
	lda #1
	sta obj_collision_result
	lda #0	; あたり判定0番
	sta obj_collision_pos
	rts
skip0:

	lda map_table_char_pos_value
	cmp #$05
	beq hit_sea
	cmp #$06
	beq hit_sea
	jmp skip_sea
hit_sea:
	lda #1
	sta obj_collision_sea
skip_sea:

	; y座標(左上)を8で割る 28からそれをひく
	; map_chip_collision_indexにそれを足す

	; 左下
;	clc
;	lda player_y_top_for_collision
;	sta REG0
;	lsr REG0	; 右シフト
;	lsr REG0	; 右シフト
;	lsr REG0	; 右シフト
;
;	sec
;	lda #28
;	sbc REG0
;	sta REG0
;
;	clc
;	lda REG0
;	adc map_chip_collision_index_base_low
;	sta map_chip_collision_index_base_low
;	lda map_chip_collision_index_base_hi
;	adc #0
;	sta map_chip_collision_index_base_hi

	; キャラクタの左上のブロックの左上
	; ■□
	; □□
	; □□
	; □□
	; マップチップの起点
	; プレイヤーのフィールド上の位置(左上の左上)(player_x_left_low_for_collision, player_x_left_hi_for_collision)
	; それを8で割った値（ｘ）が、マップチップの位置

	; 左上
	clc
	lda player_y_top_for_collision
	sta REG0
	lsr REG0	; 右シフト
	lsr REG0	; 右シフト
	lsr REG0	; 右シフト	; 8で割る

	; 27から引く
	sec
	lda #27
	sbc REG0
	sta REG0	; 一番下からのブロック数

	clc
	lda REG0
	adc map_chip_collision_index_base_low			; キャラ左画面一番下
	sta map_chip_collision_index_left_top_low		; キャラ左キャラ上
	lda map_chip_collision_index_base_hi
	adc #0
	sta map_chip_collision_index_left_top_hi

	lda #< map_chip
	sta map_table_char_pos_offset_low
	lda #> map_chip
	sta map_table_char_pos_offset_hi

	clc
	lda map_table_char_pos_offset_low
	adc map_chip_collision_index_left_top_low
	sta map_table_char_pos_offset_low
	lda map_table_char_pos_offset_hi
	adc map_chip_collision_index_left_top_hi
	sta map_table_char_pos_offset_hi

	ldy #0	; ずらし終わっているのでyは0
	lda (map_table_char_pos_offset_low), y
	sta map_table_char_pos_value

	; obj_collision_resultを戻り値として使用する
	; 0ならfalse
	; 1ならtrue
	lda #0
	sta obj_collision_result
	lda map_table_char_pos_value
	cmp #$01
	beq hit1
	cmp #$02
	beq hit1
	cmp #$11
	beq hit1
	cmp #$12
	beq hit1
	cmp #$07
	beq hit1
	cmp #$08
	beq hit1
	cmp #$17
	beq hit1
	cmp #$18
	beq hit1
	jmp skip1
hit1:
	lda #1
	sta obj_collision_result
	lda #1	; あたり判定1番
	sta obj_collision_pos
	rts
skip1:


	; キャラクタの右下のブロックの右下
	; □□
	; □□
	; □□
	; □■
	; マップチップの起点
	; プレイヤーのフィールド上の位置(右下の右下)(player_x_right_low_for_collision, player_x_right_hi_for_collision)
	; それを8で割った値（ｘ）が、マップチップの位置
	lda player_x_right_low_for_collision
	sta map_chip_player_x_low
	lda player_x_right_hi_for_collision
	sta map_chip_player_x_hi
	; 8で割る
	clc
	lsr map_chip_player_x_hi	; 上位は右シフト
	ror map_chip_player_x_low	; 下位は右ローテート
	lsr map_chip_player_x_hi	; 上位は右シフト
	ror map_chip_player_x_low	; 下位は右ローテート
	lsr map_chip_player_x_hi	; 上位は右シフト
	ror map_chip_player_x_low	; 下位は右ローテート
	; 結果を25倍(16+8+1)する　マップチップの起点を算出する
	; REG0を16倍のlow REG1を16倍のhiとして
	; REG2を 8倍のlow REG3を 8倍のhiとして
	; REG4を 1倍のlow REG5を 1倍のhiとして
	; 16倍
	lda map_chip_player_x_hi
	sta REG1
	lda map_chip_player_x_low
	sta REG0
	clc
	asl REG0		; 下位は左シフト
	rol REG1		; 上位は左ローテート
	asl REG0		; 下位は左シフト
	rol REG1		; 上位は左ローテート
	asl REG0		; 下位は左シフト
	rol REG1		; 上位は左ローテート
	asl REG0		; 下位は左シフト
	rol REG1		; 上位は左ローテート
	; 8倍
	lda map_chip_player_x_hi
	sta REG3
	lda map_chip_player_x_low
	sta REG2
	clc
	asl REG2		; 下位は左シフト
	rol REG3		; 上位は左ローテート
	asl REG2		; 下位は左シフト
	rol REG3		; 上位は左ローテート
	asl REG2		; 下位は左シフト
	rol REG3		; 上位は左ローテート
	; 1倍
	lda map_chip_player_x_hi
	sta REG5
	lda map_chip_player_x_low
	sta REG4
	; 16倍+8倍
	clc
	lda REG0
	adc REG2
	sta map_chip_collision_index_base_low
	lda REG1
	adc REG3
	sta map_chip_collision_index_base_hi
	; (16倍+8倍) + 1倍
	clc
	lda map_chip_collision_index_base_low
	adc REG4
	sta map_chip_collision_index_base_low
	lda map_chip_collision_index_base_hi
	adc REG5
	sta map_chip_collision_index_base_hi
	; ここまででキャラの左列の一番下（画面的に）を指す。


	; 右下
	clc
	lda player_y_bottom_for_collision
	sta REG0
	lsr REG0	; 右シフト
	lsr REG0	; 右シフト
	lsr REG0	; 右シフト	; 8で割る

	; 27から引く
	sec
	lda #27
	sbc REG0
	sta REG0	; 一番下からのブロック数

	clc
	lda REG0
	adc map_chip_collision_index_base_low			; キャラ左画面一番下
	sta map_chip_collision_index_right_bottom_low		; キャラ右キャラ下
	lda map_chip_collision_index_base_hi
	adc #0
	sta map_chip_collision_index_right_bottom_hi

	lda #< map_chip
	sta map_table_char_pos_offset_low
	lda #> map_chip
	sta map_table_char_pos_offset_hi

	clc
	lda map_table_char_pos_offset_low
	adc map_chip_collision_index_right_bottom_low
	sta map_table_char_pos_offset_low
	lda map_table_char_pos_offset_hi
	adc map_chip_collision_index_right_bottom_hi
	sta map_table_char_pos_offset_hi

	ldy #0	; ずらし終わっているのでyは0
	lda (map_table_char_pos_offset_low), y
	sta map_table_char_pos_value

	; obj_collision_resultを戻り値として使用する
	; 0ならfalse
	; 1ならtrue
	lda #0
	sta obj_collision_result
	lda map_table_char_pos_value
	cmp #$01
	beq hit2
	cmp #$02
	beq hit2
	cmp #$11
	beq hit2
	cmp #$12
	beq hit2
	cmp #$07
	beq hit2
	cmp #$08
	beq hit2
	cmp #$17
	beq hit2
	cmp #$18
	beq hit2
	jmp skip2
hit2:
	lda #1
	sta obj_collision_result
	lda #0	; あたり判定0番
	sta obj_collision_pos
	rts
skip2:

	; キャラクタの右上のブロックの右上
	; □■
	; □□
	; □□
	; □□
	; マップチップの起点
	; プレイヤーのフィールド上の位置(右上の右上)(player_x_right_low_for_collision, player_x_right_hi_for_collision)
	; それを8で割った値（ｘ）が、マップチップの位置

	; 右上
	clc
	lda player_y_top_for_collision
	sta REG0
	lsr REG0	; 右シフト
	lsr REG0	; 右シフト
	lsr REG0	; 右シフト	; 8で割る

	; 27から引く
	sec
	lda #27
	sbc REG0
	sta REG0	; 一番下からのブロック数

	clc
	lda REG0
	adc map_chip_collision_index_base_low			; キャラ左画面一番下
	sta map_chip_collision_index_right_top_low		; キャラ左キャラ上
	lda map_chip_collision_index_base_hi
	adc #0
	sta map_chip_collision_index_right_top_hi

	lda #< map_chip
	sta map_table_char_pos_offset_low
	lda #> map_chip
	sta map_table_char_pos_offset_hi

	clc
	lda map_table_char_pos_offset_low
	adc map_chip_collision_index_right_top_low
	sta map_table_char_pos_offset_low
	lda map_table_char_pos_offset_hi
	adc map_chip_collision_index_right_top_hi
	sta map_table_char_pos_offset_hi

	ldy #0	; ずらし終わっているのでyは0
	lda (map_table_char_pos_offset_low), y
	sta map_table_char_pos_value

	; collision_resultを戻り値として使用する
	; 0ならfalse
	; 1ならtrue
	lda #0
	sta obj_collision_result
	lda map_table_char_pos_value
	cmp #$01
	beq hit3
	cmp #$02
	beq hit3
	cmp #$11
	beq hit3
	cmp #$12
	beq hit3
	cmp #$07
	beq hit3
	cmp #$08
	beq hit3
	cmp #$17
	beq hit3
	cmp #$18
	beq hit3
	jmp skip3
hit3:
	lda #1
	sta obj_collision_result
	lda #1	; あたり判定1番
	sta obj_collision_pos
	rts
skip3:

	rts
.endproc	; tamanegi_collision_object

.proc Tamanegi_SetAttribute
	; 引数REG0：属性(0か1)
	; 引数x：タマネギ１かタマネギ２
	; xが0か1かで変える属性を判定する
	txa
	cmp #0
	beq tamanegi1
	cmp #1
	beq tamanegi2
tamanegi1:
	lda REG0
	sta tamanegi1_s
	sta tamanegi3_s
	sta tamanegi1_s2
	sta tamanegi3_s2
	lda REG1
	sta tamanegi2_s
	sta tamanegi4_s
	sta tamanegi2_s2
	sta tamanegi4_s2
	
	jmp break
tamanegi2:
	lda REG0
	sta tamanegi21_s
	sta tamanegi23_s
	sta tamanegi21_s2
	sta tamanegi23_s2
	lda REG1
	sta tamanegi22_s
	sta tamanegi24_s
	sta tamanegi22_s2
	sta tamanegi24_s2

break:
	rts
.endproc	; Tamanegi_SetSplashAttribute
