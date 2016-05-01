.proc	TakoInit
	lda #0
	sta tako0_world_pos_x_low
	sta tako1_world_pos_x_low
	sta tako0_world_pos_x_hi
	sta tako1_world_pos_x_hi
	sta tako00_status
	sta tako01_status
	sta tako00_wait
	sta tako01_wait
	sta tako00_update_dead_step
	sta tako01_update_dead_step
	lda #224	; 画面外;#184
	sta tako0_pos_y
	sta tako1_pos_y
	; 属性は変わらない
	lda #%00000001     ; 0(10進数)をAにロード
	sta tako1_s
	sta tako2_s
	sta tako3_s
	sta tako4_s
	sta tako21_s
	sta tako22_s
	sta tako23_s
	sta tako24_s
	sta tako1_s2
	sta tako2_s2
	sta tako3_s2
	sta tako4_s2
	sta tako21_s2
	sta tako22_s2
	sta tako23_s2
	sta tako24_s2

	rts
.endproc

; 登場
.proc appear_tako
	; 空いているタコを探す

	lda #1
	sta tako_alive_flag_current	; フラグ参照現在位置
	ldx #0
loop_x:
	; 空いているか
	lda tako_alive_flag
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
	sta tako00_update_dead_step,x
	; タコ属性を通常に変える
	lda #%00000010	; パレット3を使用
	sta REG0
	jsr Tako_SetAttribute

	; フラグを立てる
	clc
	lda tako_alive_flag
	adc tako_alive_flag_current
	sta tako_alive_flag

skip_tako:
	; スキップ
	rts
.endproc	; appear_tako

; 更新
.proc	TakoUpdate
	lda is_dead
	bne skip_tako

	lda #1
	sta tako_alive_flag_current	; フラグ参照現在位置
	ldx #0
loop_x:
	; 生存しているか
	lda tako_alive_flag
	and tako_alive_flag_current
	beq next_update		; 存在していない
	; 存在している

	jsr Tako_UpdateNormal

	; 画面外判定
	sec
	lda field_scroll_x_up
	sbc tako0_world_pos_x_hi,x
	bcc skip_dead
	sec
	lda field_scroll_x_low
	sbc tako0_world_pos_x_low,x
	bcc skip_dead
	; 画面外処理
	lda tako_alive_flag
	eor tako_alive_flag_current
	sta tako_alive_flag
	lda #224	; 画面外
	sta tako0_pos_y,x

skip_dead:

next_update:
	; 次
	asl tako_alive_flag_current
	inx
	cpx tako_max_count	; ループ最大数
	bne loop_x				; ループ

skip_tako:
	rts
.endproc	; InosisiUpdate

; 通常更新
.proc	Tako_UpdateNormal
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
	lda tako0_world_pos_x_low,x
	sbc #1
	sta tako0_world_pos_x_low,x
	lda tako0_world_pos_x_hi,x
	sbc #0
	sta tako0_world_pos_x_hi,x

	rts
.endproc	; Tako_UpdateNormal

; 描画
.proc	TakoDrawDma7
	; アニメパターン
	;REG0 = (p_pat == 0) ? #$20 : #0;

	ldx #$02
	lda p_pat
	bne	Pat1
	ldx #0
Pat1:
	stx REG0

; 生存タイル
	clc
	lda #$8B     ; 
	adc REG0
	sta tako1_t
	clc
	lda #$8C
	adc REG0
	sta tako2_t
	clc
	lda #$9B
	adc REG0
	sta tako3_t
	clc
	lda #$9C
	adc REG0
	sta tako4_t
	

; 表示確認準備
	lda #1
	sta tako_alive_flag_current	; フラグ参照現在位置

; Y座標は更新必須
	clc			; キャリーフラグOFF
	lda tako0_pos_y
	adc #7
	sta tako1_y
	sta tako2_y

	clc			; キャリーフラグOFF
	lda tako0_pos_y
	adc #15
	sta tako3_y
	sta tako4_y

; Y座標以外は非表示時スキップ

	; 生存しているか
	lda tako_alive_flag
	and tako_alive_flag_current
	beq skip_tako0		; 存在していない

	; 存在していれば、ワールド座標からウィンドウ座標に変換
	sec
	lda tako0_world_pos_x_low
	sbc field_scroll_x_low
	sta tako0_window_pos_x

	lda tako0_window_pos_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta tako1_x
	sta tako3_x

	lda tako0_window_pos_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	clc			; キャリーフラグOFF
	adc #8
	bcc not_overflow_8	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta tako2_y
	sta tako4_y
not_overflow_8:
	sta tako2_x
	sta tako4_x

skip_tako0:

; タイル
	;REG0 = (p_pat == 0) ? #$20 : #0;

	ldx #$20
	lda p_pat
	bne	skip_pat2
	ldx #0
skip_pat2:
	stx REG0

	lda tako01_status
	cmp #1
	beq drown_tail2
	cmp #2
	beq splash1_tail2
	cmp #3
	beq splash2_tail2
; 生存タイル
	clc
	lda #$84     ; 
	adc REG0
	sta tako21_t
	clc
	lda #$85
	adc REG0
	sta tako22_t
	clc
	lda #$86
	adc REG0
	sta tako23_t
	clc
	lda #$94
	adc REG0
	sta tako24_t
	
	jmp break_tile2
; 溺れタイル
drown_tail2:
	clc
	lda #$87     ; 
	adc REG0
	sta tako21_t
	clc
	lda #$88
	adc REG0
	sta tako22_t
	clc
	lda #$97
	adc REG0
	sta tako24_t

	lda #$03	; ブランク
	sta tako23_t

	jmp break_tile2

; 水しぶき1タイル
splash1_tail2:
	lda #$89     ; 
	sta tako21_t
	lda #$8A
	sta tako22_t
	lda #$99
	sta tako24_t

	lda #$03	; ブランク
	sta tako3_t

	jmp break_tile2

; 水しぶき2タイル
splash2_tail2:
	lda #$A9     ; 
	sta tako21_t
	lda #$AA
	sta tako22_t
	lda #$B9
	sta tako24_t

	lda #$03	; ブランク
	sta tako23_t

	jmp break_tile2


break_tile2:

; Y座標は更新必須

	clc			; キャリーフラグOFF
	lda tako1_pos_y
	adc #7
	sta tako21_y
	sta tako22_y
	sta tako23_y

	clc			; キャリーフラグOFF
	lda tako1_pos_y
	adc #15
	sta tako24_y

; Y座標以外は非表示時スキップ

	; 生存しているか
	asl tako_alive_flag_current	; 左シフト
	lda tako_alive_flag
	and tako_alive_flag_current
	beq skip_tako1		; 存在していない

	; 存在していれば、ワールド座標からウィンドウ座標に変換
	sec
	lda tako1_world_pos_x_low
	sbc field_scroll_x_low
	sta tako1_window_pos_x

	lda tako1_window_pos_x
	sta tako21_x
	sta tako23_x

	lda tako1_window_pos_x
	clc			; キャリーフラグOFF
	adc #8
	bcc not_overflow2_8	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta tako22_y
	sta tako24_y
not_overflow2_8:
	sta tako22_x
	sta tako24_x

skip_tako1:


;End:
	rts

.endproc	; TakoDrawDma7

; 描画
.proc	TakoDrawDma6
	; アニメパターン
	;REG0 = (p_pat == 0) ? #$20 : #0;

	ldx #$02
	lda p_pat
	bne	Pat1
	ldx #0
Pat1:
	stx REG0

; 生存タイル
	clc
	lda #$8B     ; 
	adc REG0
	sta tako1_t2
	clc
	lda #$8C     ;
	adc REG0
	sta tako2_t2
	clc
	lda #$9B     ; 
	adc REG0
	sta tako3_t2
	clc
	lda #$9C     ; 
	adc REG0
	sta tako4_t2


; 生存確認準備
	lda #1
	sta tako_alive_flag_current	; フラグ参照現在位置

; Y座標は更新必須
	clc			; キャリーフラグOFF
	lda tako0_pos_y
	adc #7
	sta tako1_y2
	sta tako2_y2

	clc			; キャリーフラグOFF
	lda tako0_pos_y
	adc #15
	sta tako3_y2
	sta tako4_y2

; Y座標以外は非表示時スキップ

	; 生存しているか
	lda tako_alive_flag
	and tako_alive_flag_current
	beq skip_tako0		; 存在していない

	; 存在していれば、ワールド座標からウィンドウ座標に変換
	sec
	lda tako0_world_pos_x_low
	sbc field_scroll_x_low
	sta tako0_window_pos_x


	lda tako0_window_pos_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta tako1_x2
	sta tako3_x2

	lda tako0_window_pos_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	clc			; キャリーフラグOFF
	adc #8
	bcc not_overflow_8	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #232	; 画面外
	sta tako2_y2
	sta tako4_y2
not_overflow_8:
	sta tako2_x2
	sta tako4_x2

skip_tako0:

; タイル
	;REG0 = (p_pat == 0) ? #$20 : #0;

	ldx #$02
	lda p_pat
	bne	skip_pat2
	ldx #0
skip_pat2:
	stx REG0

	lda tako01_status
	cmp #1
	beq drown_tail2
	cmp #2
	beq splash1_tail2
	cmp #3
	beq splash2_tail2
; 生存タイル
	clc
	lda #$8B     ; 
	adc REG0
	sta tako21_t2
	clc
	lda #$8C
	adc REG0
	sta tako22_t2
	clc
	lda #$9B
	adc REG0
	sta tako23_t2
	clc
	lda #$9C
	adc REG0
	sta tako24_t2
	
	jmp break_tile2
; 溺れタイル
drown_tail2:
	clc
	lda #$87     ; 
	adc REG0
	sta tako21_t2
	clc
	lda #$88
	adc REG0
	sta tako22_t2
	clc
	lda #$97
	adc REG0
	sta tako24_t2

	lda #$03	; ブランク
	sta tako23_t2

	jmp break_tile2

; 水しぶき1タイル
splash1_tail2:
	lda #$89     ; 
	sta tako21_t2
	lda #$8A
	sta tako22_t2
	lda #$99
	sta tako24_t2

	lda #$03	; ブランク
	sta tako3_t2

	jmp break_tile2

; 水しぶき2タイル
splash2_tail2:
	lda #$A9     ; 
	sta tako21_t2
	lda #$AA
	sta tako22_t2
	lda #$B9
	sta tako24_t2

	lda #$03	; ブランク
	sta tako23_t2

	jmp break_tile2

break_tile2:
; Y座標は更新必須

	clc			; キャリーフラグOFF
	lda tako1_pos_y
	adc #7
	sta tako21_y2
	sta tako22_y2

	clc			; キャリーフラグOFF
	lda tako1_pos_y
	adc #15
	sta tako23_y2
	sta tako24_y2

; Y座標以外は非表示時スキップ

	; 生存しているか
	asl tako_alive_flag_current	; 左シフト
	lda tako_alive_flag
	and tako_alive_flag_current
	beq skip_tako1		; 存在していない

	; 存在していれば、ワールド座標からウィンドウ座標に変換
	sec
	lda tako1_world_pos_x_low
	sbc field_scroll_x_low
	sta tako1_window_pos_x

	lda tako1_window_pos_x
	sta tako21_x2
	sta tako23_x2

	lda tako1_window_pos_x
	clc			; キャリーフラグOFF
	adc #8
	bcc not_overflow2_8	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #232	; 画面外
	sta tako22_y2
	sta tako24_y2
not_overflow2_8:
	sta tako22_x2
	sta tako24_x2

skip_tako1:


;End:
	rts

.endproc	; TakoDrawDma6

; タコとオブジェクトとのあたり判定
.proc tako_collision_object
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
	lda tako0_pos_y,x ;player_y
	sta player_y_top_for_collision		; あたり判定用上Y座標（Y座標）
	clc
	adc #15
	sta player_y_bottom_for_collision	; あたり判定用下Y座標（Y座標+15）

	lda tako0_world_pos_x_hi,x ;player_x_up
	sta player_x_left_hi_for_collision	; あたり判定用左X座標上位（X座標）
	lda tako0_world_pos_x_low,x ;player_x_low
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
.endproc	; tako_collision_object

.proc Tako_SetAttribute
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
	sta tako1_s
	sta tako2_s
	sta tako3_s
	sta tako4_s
	sta tako1_s2
	sta tako2_s2
	sta tako3_s2
	sta tako4_s2
	
	jmp break
tako2:
	lda REG0
	sta tako21_s
	sta tako22_s
	sta tako23_s
	sta tako24_s
	sta tako21_s2
	sta tako22_s2
	sta tako23_s2
	sta tako24_s2

break:
	rts
.endproc	; Tako_SetSplashAttribute
