.proc scene_gameover

; 描画
	jsr DrawGameOver

; 更新
	lda scene_update_step
	cmp #0
	beq case_init
	cmp #1
	beq case_fill_wait
	cmp #2
	beq case_update

; 初期化処理
case_init:

	; 透明色に差し替え
	; パレットテーブルへ転送(MAP用のみ転送)
	lda	#$3f
	sta	$2006
	lda	#$10
	sta	$2006
	lda	#$0f
	sta $2007

	; カレント画面を1にする
	lda #1
	sta current_draw_display_no

	; スプライトとBGを消す
	lda	#%00000110
	sta	$2001

	; 属性テーブル変更
	jsr ChangeAttributeGameOver

	; ネームテーブル黒で塗りつぶす
	jsr FillBlackNametable

	; 待ち1フレーム
	lda #1
	sta wait_frame

	; 次のステップ
	inc scene_update_step
	jmp break;
; 塗りつぶし待ち
case_fill_wait:
	dec wait_frame
	bne break
	inc scene_update_step
	; BGを表示
	lda	#%00001110
	sta	$2001

	jmp break
; 更新処理
case_update:
	; 処理1
	lda #30
	sta wait_frame
;	inc scene_update_step
;	jmp break;

break:

	; スクロール位置更新
	lda #0
	sta	$2005		; X方向スクロール
	lda	#0		; Yは固定
	sta	$2005

	rts
.endproc

; ゲームオーバー用属性テーブルに変更
.proc ChangeAttributeGameOver
	lda #< map_chip_attribute_game_over
	sta map_table_attribute_low
	lda #> map_chip_attribute_game_over
	sta map_table_attribute_hi

	lda #0
	sta bg_already_draw_attribute_pos

;	lda #$23
;	sta attribute_pos_adress_hi
;	lda #$c0
;	sta attribute_pos_adress_low

	ldx #7	; 8個
loop_attribute_first_x:
; 描画
	lda #0
	sta draw_bg_y
	lda bg_already_draw_attribute_pos
	sta draw_bg_x

	; 1度だけ座標からアドレスを求める
	; draw_bg_x(in)
	; draw_bg_y(in)
	; attribute_pos_adress_hi(out)
	; attribute_pos_adress_low(out)
	jsr CalcAttributeAdressFromCoord

	ldy #7
	jmp draw_loop
draw_loop:
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

	dey
	bpl	draw_loop

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

; ネームテーブル黒で塗りつぶす
.proc FillBlackNametable

	lda #< map_chip_game_over
	sta map_table_screen_low
	lda #> map_chip_game_over
	sta map_table_screen_hi

	lda #0
	sta bg_already_draw_pos
; 背景ネームテーブル ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

	rts
.endproc
