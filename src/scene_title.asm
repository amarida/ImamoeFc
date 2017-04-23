.proc scene_title

	lda scene_update_step
	cmp #0
	beq case_init
	cmp #1
	beq case_fill
	cmp #2
	beq case_fill_wait
	cmp #3
	beq case_enable
	cmp #4
	beq case_wait

; 初期化
case_init:
	jsr scene_title_init

	jmp case_break

; 描画
case_fill:

	; 属性テーブル変更
	jsr SetupAttributeTitle

	; ネームテーブルをタイトルにする
	jsr FillTitleNametable

	lda #2
	sta wait_frame
	inc scene_update_step
	jmp case_break
	
; 描画待ち
case_fill_wait:
	dec wait_frame
	lda wait_frame
	bne skip_next
	; 有効にする
	inc scene_update_step
	skip_next:
	jmp case_break

; 有効にする
case_enable:
	; 割り込みON　増加値1byte
	lda #%10001000
	;     |||||||`- 
	;     ||||||`-- メインスクリーンアドレス 00
	;     |||||`--- VRAMアクセス時のアドレス増加値ベース 1byte
	;     ||||`---- スプライト用キャラクタテーブル 1
	;     |||`----- BG用キャラクタテーブルベース 0
	;     ||`------ スプライトサイズ 8x8
	;     |`------- PPU選択 マスター
	;     `-------- VBlank時にNMI割込を発生 ON
	sta $2000

	; スプライトとBGを表示
	lda	#%00011110
	sta	$2001

	inc scene_update_step

	jmp case_break
	
; キー入力待ち
case_wait:
	jsr UpdateMessageToggle
	jsr UpdateInputKey
	lda key_state_push
	and #%00001000		; START
	beq case_break

	lda #1			; イントロダクション
	sta scene_type	; シーン
	lda #0
	sta scene_update_step

	jmp case_break



case_break:

	; スクロール位置更新
	lda #0
	sta	$2005		; X方向スクロール
	lda	#0		; Yは固定
	sta	$2005

	rts
.endproc

.proc scene_title_init

	; バンクをタイトルバンクにする
	lda	#1
	sta	$8000

	; 割り込みOFF　増加値1byte
	lda #%00001000
	;     |||||||`- 
	;     ||||||`-- メインスクリーンアドレス 00
	;     |||||`--- VRAMアクセス時のアドレス増加値ベース 0:1byte
	;     ||||`---- スプライト用キャラクタテーブル 1
	;     |||`----- BG用キャラクタテーブルベース 0
	;     ||`------ スプライトサイズ 0:8x8
	;     |`------- PPU選択 0:マスター
	;     `-------- VBlank時にNMI割込を発生 0:OFF
	sta $2000
	; スプライトとBGを消す
	lda	#%00000110
	;     |||||||`- 色指定 0:カラー
	;     ||||||`-- 画面左端8ピクセルのBGを表示 1:表示
	;     |||||`--- 画面左端8ピクセルのスプライトを表示 1:表示
	;     ||||`---- BGの表示 0:OFF
	;     |||`----- スプライトの表示 0:OFF
	;     ||`------ 青色を強調 0:OFF
	;     |`------- 緑色を強調 0:OFF
	;     `-------- 赤色を強調 0:OFF
	sta	$2001

	; カレント画面を1にする
	lda #1
	sta current_draw_display_no
	
	; パレットテーブルへ転送(BG用のみ転送)
	lda	#$3f
	sta	$2006
	lda	#$00
	sta	$2006
	ldx	#$00
	ldy	#16
	copypal:
	lda	palette_bg_title, x
	sta $2007
	inx				; Xをインクリメントする
	dey				; Yをデクリメントする
	bne	copypal

	; パレットテーブルへ転送(MAP用のみ転送)
	lda	#$3f
	sta	$2006
	lda	#$10
	sta	$2006
	ldx	#$00
	ldy	#16
	copypal2:
	lda	palette1, x
	sta $2007
	inx
	dey
	bne	copypal2
	inc scene_update_step

	; 透明色を濃い青に変更
	lda	#$3f
	sta	$2006
	lda	#$10
	sta	$2006
	lda	#$23
	sta $2007

	rts
.endproc

; ネームテーブルをタイトルにする
.proc FillTitleNametable

	; まず塗りつぶし
	lda #0
	sta draw_bg_x
	sta draw_bg_y
	jsr SetPosition
	lda #$3e

	ldy #0
	loop_fill_y:
	ldx #0
	loop_fill_x:
	sta $2007
	inx
	cpx #32
	bne loop_fill_x
	iny
	cpy #28
	bne loop_fill_y

	; 一番上
	lda #5
	sta draw_bg_x
	lda #5
	sta draw_bg_y
	jsr SetPosition
	lda #$09
	sta $2007

	ldx #10
	loop_top_x:
	lda #$0e
	sta $2007
	lda #$3f
	sta $2007
	dex
	bne loop_top_x

	lda #$0a
	sta $2007

	; 真ん中全部
	lda #6
	sta REG0

	ldy #15
	loop_middle_y:

	lda #5
	sta draw_bg_x
	lda REG0
	sta draw_bg_y
	jsr SetPosition
	lda #$1e
	sta $2007

	ldx #10
	loop_middle_x:
	lda #$3f
	sta $2007
	lda #$3f
	sta $2007
	dex
	bne loop_middle_x

	lda #$0f
	sta $2007

	inc REG0
	dey
	bne loop_middle_y

	; 一番下
	lda #5
	sta draw_bg_x
	lda #21
	sta draw_bg_y
	jsr SetPosition
	lda #$19
	sta $2007

	ldx #10
	loop_bottom_x:
	lda #$1f
	sta $2007
	lda #$3f
	sta $2007
	dex
	bne loop_bottom_x

	lda #$1a
	sta $2007

	; ロゴ
	lda #< map_chip_nametable_title_logo
	sta map_table_screen_low
	lda #> map_chip_nametable_title_logo
	sta map_table_screen_hi

	lda #7
	sta REG0

	ldx #5	; 5行

loop_x:

	lda #10
	sta draw_bg_x
	lda REG0
	sta draw_bg_y
	jsr SetPosition

	ldy #0	; 13列

loop_y:

	lda (map_table_screen_low), y
	sta $2007

	iny
	tya
	cmp #13
	bne loop_y

	; マップチップの起点を13ずらす
	clc
	lda map_table_screen_low
	adc #13
	sta map_table_screen_low
	lda map_table_screen_hi
	adc #0
	sta map_table_screen_hi

	inc REG0
	dex
	txa
	bne loop_x
	
	; The
	lda #7
	sta draw_bg_x
	lda #9
	sta draw_bg_y
	jsr SetPosition
	lda #$0b
	sta $2007
	lda #$0c
	sta $2007
	lda #$0d
	sta $2007

	lda #7
	sta draw_bg_x
	lda #10
	sta draw_bg_y
	jsr SetPosition
	lda #$1b
	sta $2007
	lda #$1c
	sta $2007
	lda #$1d
	sta $2007

	; 1 PLAYER GAME
	lda #14
	sta draw_bg_y
	lda #10
	sta draw_bg_x
	jsr SetPosition

	ldx #0
	loop_moji_x:
	lda string_player_game, x
	sta $2007
	inx
	cpx #13
	bne loop_moji_x

	; KOBE IMAMOE
	lda #17
	sta draw_bg_y
	lda #9
	sta draw_bg_x
	jsr SetPosition

	ldx #0
	loop_copy_x:
	lda string_kobe_imamoe, x
	sta $2007
	inx
	cpx #16
	bne loop_copy_x

	; PUSH START
	jsr DrawPushStart

	rts
.endproc

.proc DrawPushStart

	; PUSH START
	lda #19
	sta draw_bg_y
	lda #9
	sta draw_bg_x
	jsr SetPosition

	ldx #0
	loop_push_x:
	lda string_push_start, x
	sta $2007
	inx
	cpx #14
	bne loop_push_x

	rts
.endproc

.proc ClearPushStart

	; PUSH START
	lda #19
	sta draw_bg_y
	lda #9
	sta draw_bg_x
	jsr SetPosition

	ldx #0
	loop_push_x:
	lda #$3f
	sta $2007
	inx
	cpx #14
	bne loop_push_x

	rts
.endproc

; タイトル用属性テーブルに変更
.proc SetupAttributeTitle
	lda #< map_chip_attribute_title_logo
	sta map_table_attribute_low
	lda #> map_chip_attribute_title_logo
	sta map_table_attribute_hi

	lda #0
	sta bg_already_draw_attribute_pos

	ldx #7	; 8個
loop_attribute_first_x:
; 描画
	lda #0
	sta draw_bg_x
	lda bg_already_draw_attribute_pos
	sta draw_bg_y

	; 1度だけ座標からアドレスを求める
	; draw_bg_x(in)
	; draw_bg_y(in)
	; attribute_pos_adress_hi(out)
	; attribute_pos_adress_low(out)
	jsr CalcAttributeAdressFromCoord

	ldy #0

draw_loop:
	lda attribute_pos_adress_hi
	sta $2006
	lda attribute_pos_adress_low
	sta $2006
	lda (map_table_attribute_low), y
	sta $2007

	lda attribute_pos_adress_low
	clc
	adc #$1
	sta attribute_pos_adress_low

	iny
	tya
	cmp #8
	bne	draw_loop

	; 描画したら bg_already_draw_attribute をincする
	inc bg_already_draw_attribute
	inc bg_already_draw_attribute_pos
	sec
	lda bg_already_draw_attribute_pos
	sbc #8
	bcc skip_reset;
	lda #0
	sta bg_already_draw_attribute_pos
skip_reset:
	; マップチップの起点を8ずらす
	clc
	lda map_table_attribute_low
	adc #8
	sta map_table_attribute_low
	lda map_table_attribute_hi
	adc #0
	sta map_table_attribute_hi


	dex
	bpl loop_attribute_first_x


	lda #0
	sta bg_already_draw_attribute_pos
	sta bg_already_draw_attribute

	rts
.endproc

.proc UpdateMessageToggle

	lda loop_count
	and #%00011111
	bne skip_change
	lda toggle
	cmp #0
	beq case_draw
	cmp #1
	beq case_clear
	
	case_draw:
	jsr DrawPushStart
	jmp case_break

	case_clear:
	jsr ClearPushStart
	jmp case_break

	case_break:

	lda toggle
	eor #1
	sta toggle

	skip_change:

	rts
.endproc
