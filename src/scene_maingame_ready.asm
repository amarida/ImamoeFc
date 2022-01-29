.proc Scene_Debug
	; 途中から始めるテスト用
	lda #6;#$7
	sta player_x_hi
	sta field_scroll_x_hi
	; 15個 アドレスは60ずらす; 18個 アドレスは72ずらす
	clc
	lda map_enemy_info_address_low
	adc #60 ;#72
	sta map_enemy_info_address_low
	lda map_enemy_info_address_hi
	adc #0
	sta map_enemy_info_address_hi

	; マップチップの起点(NameTable)を6ページ、25*32*6 4800ずらす
	  ; マップチップの起点(NameTable)を7ページ、25*32*7 5600ずらす
	clc
	lda map_table_screen_low
	adc #192 ; #224
	sta map_table_screen_low
	lda map_table_screen_hi
	adc #18 ; #21
	sta map_table_screen_hi

	; マップチップの起点(属性)を6ページ、7*8*6 336ずらす
	  ; マップチップの起点(属性)を7ページ、7*8*7 392ずらす
	clc
	lda map_table_attribute_low
	adc #80 ; #136
	sta map_table_attribute_low
	lda map_table_attribute_hi
	adc #1
	sta map_table_attribute_hi

	; パターンをビル
	lda #3
	sta palette_bg_change_state
	jsr change_palette_bg_table
	; パターンを海
	lda #5
	sta palette_bg_change_state
	jsr change_palette_bg_table

	rts
.endproc

.proc scene_maingame_ready

; パレットテーブルへ転送(BG用のみ転送)
	lda	#$3f
	sta	$2006
	lda	#$00
	sta	$2006
	ldx	#$00
	ldy	#$16
copypal:
	lda	palettes_bg, x
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

	; 透明色を青に変更
	lda	#$3f
	sta	$2006
	lda	#$10
	sta	$2006
	lda	#$21
	sta $2007

	lda #%00001100	; VBlank割り込みなし、スプライトが1、VRAM増加量32byte
	sta $2000
	lda	#%00000110
	sta	$2001

	; 初期位置
	lda	#128		; 128(10進)
	sta	player_x_low
	lda	#0			; 0(10進)
	sta	player_x_hi
	lda	#168		; (10進)
	sta	player_y

	lda #168
	sta FIELD_HEIGHT	; 地面の高さ

	lda #0
	sta p_pat		; プレイヤーの描画パターンを0で初期化
	lda #10
	sta pat_change_frame;	パターン切り替えフレーム

	jsr PlayerInit			; プレイヤー初期化
	jsr InosisiInit			; イノシシ初期化
	jsr TakoInit			; タコ初期化
	jsr TamanegiInit		; タマネギ初期化
	jsr TamanegiFire_Init	; タマネギファイアー初期化
	jsr BossInit			; ボス初期化
	
	lda #0
	sta inosisi_alive_flag	; 生存イノシシフラグ
	sta tako_alive_flag		; 生存タコフラグ
	sta tamanegi_alive_flag	; 生存タマネギフラグ
	sta tako_haba_alive_flag; 生存はばタコフラグ
	lda #2
	sta inosisi_max_count	; 最大同時登場数イノシシ
	sta tako_max_count		; 最大同時登場数タコ
	sta tamanegi_max_count	; 最大同時登場数タマネギ
	sta fire_max_count		; 最大同時登場数タマネギファイアー

	; 敵情報先頭アドレス
	lda #< map_enemy_info
	sta map_enemy_info_address_low
	lda #> map_enemy_info
	sta map_enemy_info_address_hi

	lda #0
	sta scroll_count_32dot

	lda #7
	sta scroll_count_8dot
	lda #$FF
	sta scroll_count_8dot_count

	lda #0
	sta timer_count
	
	lda #0
	sta bg_already_draw_attribute_pos

	jsr TamanegiFire_AllClear	; タマネギファイアークリア
	
	lda #0
	sta palette_change_state
	sta bg_already_draw
	sta bg_already_draw_pos

	; タイマー初期値(400)
	lda #%00000001
	sta timer_b1
	lda #%10010000
	sta timer_b0

	; スコア初期値(0)
	lda #0
	sta score_b1
	lda #0
	sta score_b0

	; 初期プレイヤー速度
	lda #0
	sta REG0
	lda #1
	sta REG1
	jsr Player_SetSpeed
	
	lda #1
	sta player_speed_hi_or_low

	; スプライト0番の情報
	lda #23
	sta spriteZero_y
	sta spriteZero_y2
	lda #01
	sta spriteZero_t
	sta spriteZero_t2
	lda #0
	sta spriteZero_s
	sta spriteZero_s2
	lda #48
	sta spriteZero_x
	sta spriteZero_x2

	; マップチップ位置初期設定
	lda #< map_chip
	sta map_table_screen_low
	lda #> map_chip
	sta map_table_screen_hi

	lda #< map_chip_attribute
	sta map_table_attribute_low
	lda #> map_chip_attribute
	sta map_table_attribute_hi

	lda #1
	sta current_draw_display_no
	
	; デバッグ
	;jsr Scene_Debug

; 初期背景ネームテーブル ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldx #31	; 32個
loop_first_x:
; 初期画面
	lda #3	; (0, 3)開始座標
	sta draw_bg_y	; Y座標
	lda bg_already_draw_pos
	sta draw_bg_x	; X座標（ブロック）
	jsr SetPosition

	ldy #24	; 25個

draw_loop:
	lda (map_table_screen_low), y
	sta $2007

	dey
	bpl	draw_loop	; ネガティブフラグがクリアされている時にブランチ

	; 描画したら bg_already_draw をincする
	inc bg_already_draw
	inc bg_already_draw_pos

	; マップチップの起点を25ずらす
	clc
	lda map_table_screen_low
	adc #25
	sta map_table_screen_low
	lda map_table_screen_hi
	adc #0
	sta map_table_screen_hi

	dex
	bpl loop_first_x


	lda #0
	sta bg_already_draw_pos
	sta bg_already_draw

; 初期背景属性テーブル ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldx #7	; 横8個
loop_attribute_first_x:
; 描画
	lda #1	; 1から始める
	sta draw_bg_y
	lda bg_already_draw_attribute_pos
	sta draw_bg_x

	; 1度だけ座標からアドレスを求める
	; draw_bg_x(in)
	; draw_bg_y(in)
	; attribute_pos_adress_hi(out)
	; attribute_pos_adress_low(out)
	jsr CalcAttributeAdressFromCoord

	ldy #6	; 縦7個
attribute_loop:

	lda attribute_pos_adress_hi
	sta $2006
	lda attribute_pos_adress_low
	sta $2006
	lda (map_table_attribute_low), y
	sta $2007

	lda attribute_pos_adress_low
	clc
	adc #$8
	sta attribute_pos_adress_low
	; マイナスじゃなければループする
	dey
	bpl	attribute_loop

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

	; マップチップの起点を7ずらす
	clc
	lda map_table_attribute_low
	adc #7
	sta map_table_attribute_low
	lda map_table_attribute_hi
	adc #0
	sta map_table_attribute_hi


	dex
	bpl loop_attribute_first_x


	lda #0
	sta bg_already_draw_attribute_pos
	sta bg_already_draw_attribute
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	lda #%00001000	; VBlank割り込みなし、スプライトが1、VRAM増加量1byte
	sta $2000

	; 画面上部の固定情報の描画と属性設定
	jsr SetStatusNameAttribute

; ラスタスクロール用(BG)
	lda #2
	sta draw_bg_y	; Y座標（ブロック）
	lda #6	; X座標（ブロック）
	sta draw_bg_x	; X座標（ブロック）
	jsr SetPosition

	lda #$10
	sta $2007

	lda #0
	sta current_draw_display_no

	lda	#%00011110
	sta	$2001
	
; スクロール設定
	lda	#$00
	sta	$2005
	sta	$2005

; 割り込み開始
	lda #%10001100	; VBlank割り込みあり　VRAM増加量32byte
	;lda #%00001100	; VBlank割り込みなし　VRAM増加量32byte
	sta $2000
	
	; 次のシーン
	lda #3					; メイン
	sta scene_type			; シーン
	lda #0
	sta scene_update_step	; シーン内ステップ

	rts
.endproc	; scene_maingame_ready
