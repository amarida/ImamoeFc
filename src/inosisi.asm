.proc	InosisiInit
	lda #0
	sta inosisi0_world_pos_x_low
	sta inosisi1_world_pos_x_low
	sta inosisi0_world_pos_x_hi
	sta inosisi1_world_pos_x_hi
	sta inosisi00_status
	sta inosisi01_status
	;sta inosisi00_wait
	;sta inosisi01_wait
	sta inosisi00_update_dead_step
	sta inosisi01_update_dead_step
	lda #224	; 画面外;#184
	sta inosisi0_pos_y
	sta inosisi1_pos_y
	; 属性は変わらないことはない
	lda #%00000001     ; 0(10進数)をAにロード
	sta char_6type1_s
	sta char_6type2_s
	sta char_6type3_s
	sta char_6type4_s
	sta char_6type5_s
	sta char_6type6_s
	sta char_6type21_s
	sta char_6type22_s
	sta char_6type23_s
	sta char_6type24_s
	sta char_6type25_s
	sta char_6type26_s
	sta char_6type1_s2
	sta char_6type2_s2
	sta char_6type3_s2
	sta char_6type4_s2
	sta char_6type5_s2
	sta char_6type6_s2
	sta char_6type21_s2
	sta char_6type22_s2
	sta char_6type23_s2
	sta char_6type24_s2
	sta char_6type25_s2
	sta char_6type26_s2

	rts
.endproc

; 登場
.proc appear_inosisi

	; 0ならnormal,1ならback
	lda #4
	sta palette_change_state
	lda REG0
	beq skip_9
	lda #9
	sta palette_change_state
	skip_9:

	; 空いているイノシシを探す

;	lda #1
;	sta inosisi_alive_flag_current	; フラグ参照現在位置
;	ldx #0
;loop_x:
;	; 空いているか
;	lda inosisi_alive_flag
;	and inosisi_alive_flag_current
;	beq set_inosisi
;	
;	; 次
;	asl inosisi_alive_flag_current
;	inx
;	cpx inosisi_max_count	; ループ最大数
;	bne loop_x				; ループ
;
;	; ここまで来たら空きはないのでスキップ
;	jmp skip_inosisi

	ldx enemy_dma_area
	lda enemy_dma_area
	clc
	adc #1
	sta inosisi_alive_flag_current

set_inosisi:
	lda REG0
	beq skip_zero

	; 左から出てくるので250引いた値にする
	sec
	lda enemy_pos_x_low
	sbc #250
	sta enemy_pos_x_low
	lda enemy_pos_x_hi
	sbc #0
	sta enemy_pos_x_hi

	skip_zero:

	; 空いているイノシシに情報をセットする
	lda enemy_pos_x_hi
	sta inosisi0_world_pos_x_hi,x
	lda enemy_pos_x_low
	sta inosisi0_world_pos_x_low,x
	lda enemy_pos_y
	sta inosisi0_pos_y,x
	
	; イノシシタイプ
	; x(REG1)：何体目、REG0：種別（0前から、1後ろから）
	; 00 00 00 00
	;       ↑ ↑
	;		｜	`-- 1体目の種別(01,前から 10後ろから)
	;		 `----- 2体目の種別(01,前から 10後ろから)
	txa
	sta REG1	;(n体目)
	asl			; aを2倍
	sta REG2	;(左シフト数)
	
	lda #1
	ldy REG2

	; (n体目ｘ2bit)左シフト
	loop_y:
	dey
	bmi break_loop_y	; ネガティブフラグがセットされているときブランチ
	asl
	jmp loop_y
	break_loop_y:

	pha			; Aをスタックにプッシュします
	lda REG0
	beq skip_last_asl 
	pla			; Aをポップします
	asl			; 後ろだから左シフト
	jmp do_last_asl
	skip_last_asl:
	pla			; Aをポップします
	do_last_asl:
	
	ora inosisi_type_flag
	sta inosisi_type_flag
	
	; 色々初期化
	lda #0
	sta inosisi00_status,x
	sta inosisi00_update_dead_step,x

	lda REG0
	sta REG1

	;
	; REG0 = (REG1 == 0) ? #%00000001 : #%01000001;
	; 左右反転かつパレット3
	lda #%01000010
	sta REG0

	lda REG1
	bne ContinueLR

	; 反転なしかつパレット2
	lda #%00000001
	sta REG0

ContinueLR:

	jsr Inosisi_SetAttribute

	; フラグを立てる
	clc
	lda inosisi_alive_flag
	adc inosisi_alive_flag_current
	sta inosisi_alive_flag

skip_inosisi:
	; スキップ
	rts
.endproc	; appear_inosisi

; イノシシクリア
.proc Inosisi_Clear

	; xの0,1でどちらを消すか判断する
	ldy #0
	lda #%00000001
	sta REG0
	txa ; XをAへコピー
	beq not_set24
	ldy #24
	lda #%00000010
	sta REG0
	not_set24:
	
	; 生存フラグの確認
	lda inosisi_alive_flag
	and REG0
	bne not_skip_clear		; 存在している
	jmp skip_clear
	not_skip_clear:

	; char_6typeX_y,t,s,xを0埋めする処理
	; Xが0ならchar_6type1_y（#$074C）(DMA7)とchar_6type1_y2(DMA6)を使う
	; Xが1ならchar_6type21_yとchar_6type21_y2を使う
	lda #< char_6type1_y
	sta REG5;(low)
	lda #> char_6type1_y
	sta REG6;(hi)
	lda #< char_6type1_y2
	sta REG3;(low)
	lda #> char_6type1_y2
	sta REG4;(hi)
	cpx #0
	beq skip_2taime
	lda #< char_6type21_y
	sta REG5;(low)
	lda #> char_6type21_y
	sta REG6;(hi)
	lda #< char_6type21_y2
	sta REG3;(low)
	lda #> char_6type21_y2
	sta REG4;(hi)
	skip_2taime:

	ldy #0
	lda #0
	clear_loop_y:
	sta (REG5),y
	sta (REG3),y
	iny
	cpy #24
	bne clear_loop_y

	lda #0
	sta inosisi0_world_pos_x_low,x
	sta inosisi0_world_pos_x_hi,x
	sta inosisi0_pos_y,x
	
;	cpx #0
;	lda #232	; 画面外
;	sta char_6type1_y
;	sta char_6type2_y
;	sta char_6type3_y
;	sta char_6type4_y
;	sta char_6type5_y
;	sta char_6type6_y
;	sta char_6type1_y2
;	sta char_6type2_y2
;	sta char_6type3_y2
;	sta char_6type4_y2
;	sta char_6type5_y2
;	sta char_6type6_y2




	; 生存フラグを落とす
	lda inosisi_alive_flag
	eor REG0
	sta inosisi_alive_flag

	; イノシシタイプ（前からか後ろからの）を落とす
	; x(REG1)：何体目、REG0：種別（0前から、1後ろから）
	; 00 00 00 00
	;       ↑  ↑
	;		｜	`-- 1体目の種別(01,前から 10後ろから)
	;		 `----- 2体目の種別(01,前から 10後ろから)
	txa
	sta REG1	;(n体目)
	asl			; aを2倍
	sta REG2	;(左シフト数)
	
	lda #1
	ldy REG2

	; (n体目ｘ2bit)左シフト
	loop_y:
	dey
	bmi break_loop_y	; ネガティブフラグがセットされているときブランチ
	asl
	jmp loop_y
	break_loop_y:

	pha			; Aをスタックにプッシュします
	and inosisi_type_flag	; AとのANDが0なら後ろ、AとのANDが0以外なら前
	bne skip_last_asl 
	pla			; Aをポップします
	asl			; 後ろだから左シフト
	jmp do_last_asl
	skip_last_asl:
	pla			; Aをポップします
	do_last_asl:

	; aには下ろすフラグが立ってる
	; 反転させて下ろすフラグ以外を立てる
	eor #%11111111
	and inosisi_type_flag
	sta inosisi_type_flag

skip_clear:

	rts
.endproc ; TamanegiFire_Clear

; 更新
.proc	InosisiUpdate
	lda is_dead
	bne skip_inosisi

	; そもそも一体も居ない
	lda inosisi_alive_flag
	beq skip_inosisi

	lda #1
	sta inosisi_alive_flag_current	; フラグ参照現在位置
	ldx #0
loop_x:
	; 生存しているか
	lda inosisi_alive_flag
	and inosisi_alive_flag_current
	beq next_update		; 存在していない
	; 存在している

	; 状態
	lda inosisi00_status,x
	cmp #0
	beq case_normal
	jmp case_dead	;	(1〜3)

; 通常
case_normal:
	jsr Inosisi_UpdateNormal
	jmp break;

; 死亡
case_dead:
	jsr Inosisi_UpdateDead
	jmp break;

break:

	cpx #0
	beq case_0
	cpx #1
	beq case_1

	case_0:
	lda inosisi_type_flag
	and #%00000001
	bne move_from_front
	jmp move_from_back

	case_1:
	lda inosisi_type_flag
	and #%00000100
	bne move_from_front
	jmp move_from_back

	move_from_front:

	; 左画面外判定
	sec
	lda field_scroll_x_hi
	sbc inosisi0_world_pos_x_hi,x
	bcc skip_dead1
	sec
	lda field_scroll_x_low
	sbc inosisi0_world_pos_x_low,x
	bcc skip_dead1
	; 左画面外処理
	jsr Inosisi_Clear

skip_dead1:

	jmp move_end

	move_from_back:
	; 右画面外判定
	sec
	lda inosisi0_world_pos_x_hi,x
	sbc field_scroll_x_hi
	bcc skip_dead2
	sec
	lda inosisi0_world_pos_x_low,x
	sbc field_scroll_x_low
	sbc #245
	bcc skip_dead2
	; 右画面外処理
	jsr Inosisi_Clear

skip_dead2:

	jmp move_end

	move_end:




next_update:
	; 次
	asl inosisi_alive_flag_current
	inx
	cpx inosisi_max_count	; ループ最大数
	bne loop_x				; ループ

skip_inosisi:
	rts
.endproc	; InosisiUpdate

; 通常更新
.proc	Inosisi_UpdateNormal
	; 重力
	clc
	lda #4
	adc inosisi0_pos_y,x
	sta inosisi0_pos_y,x

	; あたり判定
	jsr inosisi_collision_object
	; 溺れる判定
	lda obj_collision_sea
	beq skip_sea
	lda #1
	sta inosisi00_status,x
skip_sea:
	
	lda obj_collision_result
	beq roll_skip
	; 当たった処理


	;下の処理
	sec
	lda inosisi0_pos_y,x
	and #%11111000
	sta inosisi0_pos_y,x
	; 落下中フラグを立てる
;	lda	#0
;	sta	is_jump
	
roll_skip:

	cpx #0
	beq case_0
	cpx #1
	beq case_1

	case_0:
	lda inosisi_type_flag
	and #%00000001
	bne move_from_front
	jmp move_from_back

	case_1:
	lda inosisi_type_flag
	and #%00000100
	bne move_from_front
	jmp move_from_back

	move_from_front:
	; 左移動
	sec
	lda inosisi0_world_pos_x_low,x
	sbc #2
	sta inosisi0_world_pos_x_low,x
	lda inosisi0_world_pos_x_hi,x
	sbc #0
	sta inosisi0_world_pos_x_hi,x

	jmp move_end

	move_from_back:
	; 右移動
	clc
	lda inosisi0_world_pos_x_low,x
	adc #2
	sta inosisi0_world_pos_x_low,x
	lda inosisi0_world_pos_x_hi,x
	adc #0
	sta inosisi0_world_pos_x_hi,x

	jmp move_end

	move_end:

	rts
.endproc	; Inosisi_UpdateNormal

; 溺れる更新
.proc	Inosisi_UpdateDead

	lda inosisi00_update_dead_step,x
	cmp #0
	beq case_init
	cmp #1
	beq case_drown_wait
	cmp #2
	beq case_splash1_wait
	cmp #3
	beq case_splash2_wait
	cmp #4
	beq case_release

	jmp break;

case_init:
	; 処理0
	lda #25
	sta inosisi00_wait,x

	inc inosisi00_update_dead_step,x
	jmp break;

case_drown_wait:
	; 溺れ
	dec inosisi00_wait,x
	bne break
	inc inosisi00_update_dead_step,x
	lda #15
	sta inosisi00_wait,x
	lda #2
	sta inosisi00_status,x
	; イノシシ属性を水しぶきに変える
	lda #%00000000
	sta REG0
	jsr Inosisi_SetAttribute
	jmp break

case_splash1_wait:
	; 水しぶき1
	dec inosisi00_wait,x
	bne break
	inc inosisi00_update_dead_step,x
	lda #15
	sta inosisi00_wait,x
	lda #3
	sta inosisi00_status,x
	jmp break;

case_splash2_wait:
	; 水しぶき2
	dec inosisi00_wait,x
	bne break
	inc inosisi00_update_dead_step,x
	jmp break;

case_release:
	jsr Inosisi_Clear
;	lda inosisi_alive_flag
;	eor inosisi_alive_flag_current
;	sta inosisi_alive_flag
;	lda #224	; 画面外
;	sta inosisi0_pos_y,x

	inc inosisi00_update_dead_step,x
	jmp break;

break:

	rts
.endproc	; Inosisi_UpdateDead


; 描画
.proc	InosisiDrawDma7

	ldx #0
	
	lda #1
	sta inosisi_alive_flag_current	; フラグ参照現在位置
	
loop_x:
	; 生存しているか
	lda inosisi_alive_flag
	and inosisi_alive_flag_current
	bne not_skip_draw		; 存在してる
	jmp skip_draw
	not_skip_draw:

	ldy #0
	txa		; xをaにコピー
	beq skip_set24
	ldy #24	; xが0ならyは0、xが1ならyは24
	skip_set24:

	; アニメパターン
	;REG0 = (p_pat == 0) ? #$20 : #0;

	lda p_pat
	beq set_pat0
	bne set_pat1
	
set_pat0:
	lda #$00
	sta REG0
	jmp break_pat
set_pat1:
	lda #$20
	sta REG0
	jmp break_pat
	
break_pat:

	lda inosisi00_status,x
	cmp #0
	beq nomal_tail
	cmp #1
	beq drown_tail
	cmp #2
	beq splash1_tail
	cmp #3
	beq splash2_tail
	
nomal_tail:

	jsr Inosisi_SetNomalTail
	
	jmp break_tile
; 溺れタイル
drown_tail:
	clc
	lda #$87     ; 
	adc REG0
	sta char_6type1_t,y
	clc
	lda #$88
	adc REG0
	sta char_6type2_t,y
	clc
	lda #$97
	adc REG0
	sta char_6type4_t,y
	clc
	lda #$98
	adc REG0
	sta char_6type5_t,y

	lda #$00	; ブランク
	sta char_6type3_t,y
	sta char_6type6_t,y

	jmp break_tile
; 水しぶき1タイル
splash1_tail:
	lda #$0E     ; 
	sta char_6type1_t,y
	lda #$0F
	sta char_6type2_t,y
	lda #$1E
	sta char_6type4_t,y
	lda #$1F
	sta char_6type5_t,y

	lda #$00	; ブランク
	sta char_6type3_t,y
	sta char_6type6_t,y

	jmp break_tile

; 水しぶき2タイル
splash2_tail:
	lda #$2E     ; 
	sta char_6type1_t,y
	lda #$2F
	sta char_6type2_t,y
	lda #$3E
	sta char_6type4_t,y
	lda #$3F
	sta char_6type5_t,y

	lda #$00	; ブランク
	sta char_6type3_t,y
	sta char_6type6_t,y

	jmp break_tile

break_tile:

; Y座標
	clc			; キャリーフラグOFF
	lda inosisi0_pos_y,x
	adc #7
	sta char_6type1_y,y
	sta char_6type2_y,y
	sta char_6type3_y,y

	clc			; キャリーフラグOFF
	lda inosisi0_pos_y,x
	adc #15
	sta char_6type4_y,y
	sta char_6type5_y,y
	sta char_6type6_y,y

; X座標

	; 存在していれば、ワールド座標からウィンドウ座標に変換
	sec
	lda inosisi0_world_pos_x_low,x
	sbc field_scroll_x_low
	sta inosisi0_window_pos_x,x

	lda inosisi0_window_pos_x,x
	sta char_6type1_x,y
	sta char_6type4_x,y

	lda inosisi0_window_pos_x,x
	clc			; キャリーフラグOFF
	adc #8
	bcc not_overflow_8	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta char_6type2_y,y
	sta char_6type5_y,y
not_overflow_8:
	sta char_6type2_x,y
	sta char_6type5_x,y

	lda inosisi0_window_pos_x,x
	clc			; キャリーフラグOFF
	adc #16
	bcc not_overflow_16	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta char_6type3_y,y
	sta char_6type6_y,y
not_overflow_16:
	sta char_6type3_x,y
	sta char_6type6_x,y

skip_draw:

	; 次
	asl inosisi_alive_flag_current
	inx
	cpx inosisi_max_count	; ループ最大数
	beq skip_loop_x				; ループ
	jmp loop_x
	skip_loop_x:

	rts

.endproc	; InosisiDrawDma7

; 描画
.proc	InosisiDrawDma6
	ldx #0
	
	lda #1
	sta inosisi_alive_flag_current	; フラグ参照現在位置
	
loop_x:
	; 生存しているか
	lda inosisi_alive_flag
	and inosisi_alive_flag_current
	bne not_skip_draw		; 存在してる
	jmp skip_draw
	not_skip_draw:

	ldy #0
	txa		; xをaにコピー
	beq skip_set24
	ldy #24	; xが0ならyは0、xが1ならyは24
	skip_set24:

	; アニメパターン
	;REG0 = (p_pat == 0) ? #$20 : #0;

	lda p_pat
	beq set_pat0
	bne set_pat1
	
set_pat0:
	lda #$00
	sta REG0
	jmp break_pat
set_pat1:
	lda #$20
	sta REG0
	jmp break_pat
	
break_pat:

	lda inosisi00_status,x
	cmp #0
	beq nomal_tail
	cmp #1
	beq drown_tail
	cmp #2
	beq splash1_tail
	cmp #3
	beq splash2_tail
	
nomal_tail:

; 生存タイル
 	jsr Inosisi_SetNomalTail
	
	jmp break_tile
; 溺れタイル
drown_tail:
	clc
	lda #$87     ; 
	adc REG0
	sta char_6type1_t2,y
	clc
	lda #$88
	adc REG0
	sta char_6type2_t2,y
	clc
	lda #$97
	adc REG0
	sta char_6type4_t2,y
	clc
	lda #$98
	adc REG0
	sta char_6type5_t2,y

	lda #$00	; ブランク
	sta char_6type3_t2,y
	sta char_6type6_t2,y

	jmp break_tile
; 水しぶき1タイル
splash1_tail:
	lda #$0E     ; 
	sta char_6type1_t2,y
	lda #$0F
	sta char_6type2_t2,y
	lda #$1E
	sta char_6type4_t2,y
	lda #$1F
	sta char_6type5_t2,y

	lda #$00	; ブランク
	sta char_6type3_t2,y
	sta char_6type6_t2,y

	jmp break_tile

; 水しぶき2タイル
splash2_tail:
	lda #$2E     ; 
	sta char_6type1_t2,y
	lda #$2F
	sta char_6type2_t2,y
	lda #$3E
	sta char_6type4_t2,y
	lda #$3F
	sta char_6type5_t2,y

	lda #$00	; ブランク
	sta char_6type3_t2,y
	sta char_6type6_t2,y

	jmp break_tile

break_tile:

; Y座標
	clc			; キャリーフラグOFF
	lda inosisi0_pos_y,x
	adc #7
	sta char_6type1_y2,y
	sta char_6type2_y2,y
	sta char_6type3_y2,y

	clc			; キャリーフラグOFF
	lda inosisi0_pos_y,x
	adc #15
	sta char_6type4_y2,y
	sta char_6type5_y2,y
	sta char_6type6_y2,y

; X座標

	; 存在していれば、ワールド座標からウィンドウ座標に変換
	sec
	lda inosisi0_world_pos_x_low,x
	sbc field_scroll_x_low
	sta inosisi0_window_pos_x,x

	lda inosisi0_window_pos_x,x
	sta char_6type1_x2,y
	sta char_6type4_x2,y

	lda inosisi0_window_pos_x,x
	clc			; キャリーフラグOFF
	adc #8
	bcc not_overflow_8	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta char_6type2_y2,y
	sta char_6type5_y2,y
not_overflow_8:
	sta char_6type2_x2,y
	sta char_6type5_x2,y

	lda inosisi0_window_pos_x,x
	clc			; キャリーフラグOFF
	adc #16
	bcc not_overflow_16	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta char_6type3_y2,y
	sta char_6type6_y2,y
not_overflow_16:
	sta char_6type3_x2,y
	sta char_6type6_x2,y

skip_draw:

	; 次
	asl inosisi_alive_flag_current
	inx
	cpx inosisi_max_count	; ループ最大数
	beq skip_loop_x				; ループ
	jmp loop_x
	skip_loop_x:

	rts

.endproc	; InosisiDrawDma6

; イノシシとオブジェクトとのあたり判定
.proc inosisi_collision_object
	; プレイヤが死亡中は判定しない
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
	lda inosisi0_pos_y,x
	sta player_y_top_for_collision		; あたり判定用上Y座標（Y座標）
	clc
	adc #15
	sta player_y_bottom_for_collision	; あたり判定用下Y座標（Y座標+15）

	lda inosisi0_world_pos_x_hi,x
	sta player_x_left_hi_for_collision	; あたり判定用左X座標上位（X座標）
	lda inosisi0_world_pos_x_low,x
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
	cmp #$13
	beq hit_sea
	cmp #$14
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
.endproc	; inosisi_collision_object

.proc Inosisi_SetAttribute
	; 引数REG0：属性(0:水しぶき、1:通常、2:後ろイノシシ)
	; 引数x：イノシシ１かイノシシ２
	; xが0か1かで変える属性を判定する
	txa
	cmp #0
	beq inosisi1
	cmp #1
	beq inosisi2
inosisi1:
	lda REG0
	sta char_6type1_s
	sta char_6type2_s
	sta char_6type3_s
	sta char_6type4_s
	sta char_6type5_s
	sta char_6type6_s
	sta char_6type1_s2
	sta char_6type2_s2
	sta char_6type3_s2
	sta char_6type4_s2
	sta char_6type5_s2
	sta char_6type6_s2
	
	jmp break
inosisi2:
	lda REG0
	sta char_6type21_s
	sta char_6type22_s
	sta char_6type23_s
	sta char_6type24_s
	sta char_6type25_s
	sta char_6type26_s
	sta char_6type21_s2
	sta char_6type22_s2
	sta char_6type23_s2
	sta char_6type24_s2
	sta char_6type25_s2
	sta char_6type26_s2

break:
	rts
.endproc	; Inosisi_SetSplashAttribute


.proc Inosisi_SetNomalTail

	cpx #0
	beq case_0
	cpx #1
	beq case_1

	case_0:
	lda inosisi_type_flag
	and #%00000001
	bne move_from_front
	jmp move_from_back

	case_1:
	lda inosisi_type_flag
	and #%00000100
	bne move_from_front
	jmp move_from_back

	move_from_front:
	; 生存タイル右から（左向き）
	clc
	lda #$84     ; 
	adc REG0
	sta char_6type1_t,y
	sta char_6type1_t2,y
	clc
	lda #$85
	adc REG0
	sta char_6type2_t,y
	sta char_6type2_t2,y
	clc
	lda #$86
	adc REG0
	sta char_6type3_t,y
	sta char_6type3_t2,y
	clc
	lda #$94
	adc REG0
	sta char_6type4_t,y
	sta char_6type4_t2,y
	clc
	lda #$95
	adc REG0
	sta char_6type5_t,y
	sta char_6type5_t2,y
	clc
	lda #$96
	adc REG0
	sta char_6type6_t,y
	sta char_6type6_t2,y

	jmp move_end

	move_from_back:
	; 生存タイル左から（右向き）
	clc
	lda #$86     ; 
	adc REG0
	sta char_6type1_t,y
	sta char_6type1_t2,y
	clc
	lda #$85
	adc REG0
	sta char_6type2_t,y
	sta char_6type2_t2,y
	clc
	lda #$84
	adc REG0
	sta char_6type3_t,y
	sta char_6type3_t2,y
	clc
	lda #$96
	adc REG0
	sta char_6type4_t,y
	sta char_6type4_t2,y
	clc
	lda #$95
	adc REG0
	sta char_6type5_t,y
	sta char_6type5_t2,y
	clc
	lda #$94
	adc REG0
	sta char_6type6_t,y
	sta char_6type6_t2,y


	jmp move_end

	move_end:
	rts
.endproc	; Inosisi_SetNomalTail