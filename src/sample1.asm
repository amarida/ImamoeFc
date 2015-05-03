

;  #10 10進数値
; #$10 16進数値
;  $10 16進アドレス
; #%00000000 2進数

.setcpu		"6502"
.autoimport	on

.include "define.asm"
.include "player.asm"
.include "inosisi.asm"
.include "utility.asm"





; iNESヘッダ
.segment "HEADER"
	.byte	$4E, $45, $53, $1A	; "NES" Header
	.byte	$02			; PRG-BANKS
	.byte	$01			; CHR-BANKS
	.byte	$01			; 垂直ミラーVertical Mirror
	.byte	$00			; 
	.byte	$00, $00, $00, $00	; 
	.byte	$00, $00, $00, $00	; 

;.segment "STARTUP"
;	.byte	$AA

.segment "STARTUP"
; リセット割り込み
.proc	Reset
	sei			; IRQ割り込みを禁止します。
;	ldx	#$ff		; メモリからXにロードします。
;	txs			; XをSへコピーします。

; スクリーンオフ
	lda	#$00
	sta	$2000
	sta	$2001

; 初期位置
	lda	#128		; 128(10進)
	sta	player_x_low
	lda	#0			; 0(10進)
	sta	player_x_up
	lda	#207		; 112(10進)
	sta	player_y

	lda #207
	sta FIELD_HEIGHT	; 地面の高さ

	lda #0
	sta p_pat		; プレイヤーの描画パターンを0で初期化
	lda #10
	sta pat_change_frame;	パターン切り替えフレーム

	jsr PlayerInit	; プレイヤー初期化
	jsr InosisiInit	; イノシシ初期化

	; マップチップ位置初期設定
	lda #< map_chip
	sta map_table_outside_screen_low
	lda #> map_chip
	sta map_table_outside_screen_hi

	lda #< map_chip_attribute
	sta map_table_attribute_low
	lda #> map_chip_attribute
	sta map_table_attribute_hi

; パレットテーブルへ転送(BG用のみ転送)
	lda	#$3f
	sta	$2006
	lda	#$00
	sta	$2006
	ldx	#$00
	ldy	#$16
copypal:
	lda	palettes_bg, x
	sta	$2007
	inx				; Xをインクリメントする
	dey				; Yをデクリメントする
	bne	copypal

; パレットテーブルへ転送(MAP用のみ転送)
	lda	#$3f
	sta	$2006
	lda	#$10
	sta	$2006
	ldx	#$00
	ldy	#$8
copypal2:
	lda	palette1, x
	sta	$2007
	inx
	dey
	bne	copypal2

; ネームテーブルへ転送
	lda #1
	sta current_draw_display_no
	lda	#%00001000	; VBlank割り込みなし、スプライトが1、
	sta	$2000

; スクリーンオン
	lda	#%00001100	; VBlank割り込みなし、スプライトが1、VRAM増加量32byte
;	lda	#%00001000
	sta	$2000

; スクロール設定
	lda	#$00
	sta	$2005
	sta	$2005


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
	lda (map_table_outside_screen_low), y
	sta $2007

	dey
	bpl	draw_loop	; ネガティブフラグがクリアされている時にブランチ

	; 描画したら bg_already_draw をincする
	inc bg_already_draw
	inc bg_already_draw_pos

	; マップチップの起点を25ずらす
	clc
	lda map_table_outside_screen_low
	adc #25
	sta map_table_outside_screen_low
	lda map_table_outside_screen_hi
	adc #0
	sta map_table_outside_screen_hi

	dex
	bpl loop_first_x


	lda #0
	sta bg_already_draw_pos
	sta bg_already_draw

; 初期背景属性テーブル ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldx #7	; 8個
loop_attribute_first_x:
; 描画
	lda #0
	sta offset_y_attribute
	sta draw_bg_y
	lda bg_already_draw_attribute_pos
	sta draw_bg_x

	; 1度だけ座標からアドレスを求める
	; draw_bg_x(in)
	; draw_bg_y(in)
	; attribute_pos_adress_up(out)
	; attribute_pos_adress_low(out)
	jsr CalcAttributeAdressFromCoord

	ldy #7
attribute_loop:

	lda attribute_pos_adress_up
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	lda #0
	sta current_draw_display_no

	lda	#%00011110
;	lda	#%00000000
	sta	$2001

; スクロール設定
	lda	#$00
	sta	$2005
	sta	$2005

; 割り込み開始
	lda	#%10001100	; VBlank割り込みあり　VRAM増加量32byte
	sta	$2000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; メインループ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mainloop:
;	jmp	mainloop

vblank_wait:
	lda	$2002
	and	#%10000000
	beq	vblank_wait

	lda test_toggle_update
	beq test_toggle_jmp
	lda #0
	sta test_toggle_update
	;jmp not_toggle_jmp
test_toggle_jmp:
	lda #1
	sta test_toggle_update

	; タイル番号
	lda #$01
	sta draw_bg_tile

	lda scrool_x
	and #1
	bne skip	; ゼロフラグがクリアされている時
	lda #$03
	sta draw_bg_tile
skip:
	; X座標
	lda #10
	sta draw_bg_x
	; Y座標
	lda #20
	sta draw_bg_y

	jsr SetPosition
	jsr DrawMapChip


	; X座標
	lda #5
	sta draw_bg_x
	; Y座標
	lda #0
	sta draw_bg_y
	jsr SetPosition

	; タイル番号
	lda #$30
	sta draw_bg_tile


	; 描画

	; 画面外背景の描画
	jsr draw_bg				; ネームテーブル
;	lda #$27
;	sta $2006
;	lda #$c0
;	sta $2006
	jsr draw_bg_attribute	; 属性テーブル


;	lda	0
;	sta	REG0
	lda #$00   ; $00(スプライトRAMのアドレスは8ビット長)をAにロード
	sta $2003  ; AのスプライトRAMのアドレスをストア

;	jsr change_palette1	; パレット差し替え
	;jsr	sprite_draw	; スプライト描画関数
	jsr	player_draw	; プレイヤー描画関数
	jsr InosisiDraw	; イノシシ描画関数
;	lda	1
;	sta	REG0
;	jsr change_palette2
	;jsr	sprite_draw2	; スプライト描画関数(色替えテスト表示)

	; スクロール位置更新
	lda scrool_x
	sta	$2005		; X方向スクロール
	lda	#0		; Yは固定
	sta	$2005
	
	; スプライト描画(DMAを利用)
	lda #$7  ; スプライトデータは$0700番地からなので、7をロードする。
	sta $4014 ; スプライトDMAレジスタにAをストアして、スプライトデータをDMA転送する

;	lda	spd_vec
;	cmp	#0
;	bne	AddSpdSkip
;	jsr	AddSpd
;AddSpdSkip:
;	lda	spd_vec
;	cmp	#0
;	beq	SubSpdSkip
;	jsr	SubSpd
;SubSpdSkip:

	clc
	lda	#%10001100	; VBlank割り込みあり
	adc current_draw_display_no	; 画面０か１
	sta	$2000
	
	jsr	sprite_update	; スプライト更新

not_toggle_jmp:

		;VBLANK終了待ち
;vblank_in_wait:
;		lda	$2002
;		and	#%10000000
;		bne	vblank_in_wait
	jmp	mainloop
.endproc

; VBlank割り込み
.proc	VBlank

	inc vblank_count
	rti			; 割り込みから復帰命令


	; タイル番号
	lda #$01
	sta draw_bg_tile

	lda scrool_x
	and #1
	bne skip
	lda #$03
	sta draw_bg_tile
skip:
	; X座標
	lda #10
	sta draw_bg_x
	; Y座標
	lda #20
	sta draw_bg_y

	jsr SetPosition
	jsr DrawMapChip


	; X座標
	lda #5
	sta draw_bg_x
	; Y座標
	lda #0
	sta draw_bg_y
	jsr SetPosition

	; タイル番号
	lda #$30
	sta draw_bg_tile

;	lda	spd_vec
;	cmp	#0
;	bne	AddSpdSkip
;	jsr	AddSpd
;AddSpdSkip:
;	lda	spd_vec
;	cmp	#0
;	beq	SubSpdSkip
;	jsr	SubSpd
;SubSpdSkip:
	
	jsr	sprite_update	; スプライト更新

	; 描画

	; 画面外背景の描画
	jsr draw_bg				; ネームテーブル


;	lda	0
;	sta	REG0
	lda #$00   ; $00(スプライトRAMのアドレスは8ビット長)をAにロード
	sta $2003  ; AのスプライトRAMのアドレスをストア

;	jsr change_palette1	; パレット差し替え
	;jsr	sprite_draw	; スプライト描画関数
	jsr	player_draw	; プレイヤー描画関数
	jsr InosisiDraw	; イノシシ描画関数
;	lda	1
;	sta	REG0
;	jsr change_palette2
	;jsr	sprite_draw2	; スプライト描画関数(色替えテスト表示)

	; スクロール位置更新
	lda scrool_x
	sta	$2005		; X方向スクロール
	lda	#0		; Yは固定
	sta	$2005

	lda	#%10001100	; VBlank割り込みあり
	sta	$2000

;loop:
;	jmp loop
		
	; スプライト描画(DMAを利用)
	lda #$7  ; スプライトデータは$0700番地からなので、7をロードする。
	sta $4014 ; スプライトDMAレジスタにAをストアして、スプライトデータをDMA転送する

	rti			; 割り込みから復帰命令
.endproc

.proc	AddSpd
	;inc	player_x
;	clc			; キャリーフラグクリア
;	lda	spd_y + 1	; 小数部
;	adc	#$80
;	sta	spd_y + 1

	; キャリーフラグが立ってなければ何もしない
;	bcc	End

	; それ以外は整数部に1加える
;	inc	spd_y

;End:
	rts
.endproc

.proc	SubSpd
	;dec	player_x_low
;	sec			; キャリーフラグセット
;	lda	spd_y + 1	; 小数部
;	sbc	#$80		; 引き算

	; キャリーフラグが立ってなければ何もしない
;	bcc	End

	; それ以外は整数部に1加える
;	inc	spd_y

End:
	rts
.endproc

; スプライト更新
.proc	sprite_update
	inc loop_count;
	lda #$01
	sta $4016
	lda #$00
	sta $4016

	lda $4016	; A
	and #1
	beq SkipPushA
	jsr PlayerJump
SkipPushA:
	lda $4016	; B
	lda $4016	; SELECT
	lda $4016	; START
	lda $4016	; 上
	and #1
	beq SkipKeyUp
	jsr PlayerMoveUp
SkipKeyUp:
	lda $4016	; 下
	and #1
	beq SkipKeyDown
	jsr PlayerMoveDown
SkipKeyDown:
	lda $4016	; 左
	and #1
	beq SkipKeyLeft
	jsr PlayerMoveLeft
SkipKeyLeft:
	lda $4016	; 右
	and #1
	beq SkipKeyRight
	jsr PlayerMoveRight
SkipKeyRight:

	jmp Nothing

Nothing:

	jsr PlayerUpdate
	jsr	InosisiUpdate

	rts	; サブルーチンから復帰します。
.endproc

; 画面外BG描画
.proc draw_bg

	; field_scrool_x を 8で割った数が現在描画するべきBG
	; シフトするのでテンプに一旦入れる
	lda field_scrool_x_up
	sta field_scrool_x_up_tmp
	lda field_scrool_x_low
	sta field_scrool_x_low_tmp

	lda field_scrool_x_up
	sta map_chip_index_up
	lda field_scrool_x_low
	sta map_chip_index_low
	; 8で割る
	clc
	lsr field_scrool_x_up_tmp	; 上位は右シフト
	ror field_scrool_x_low_tmp	; 下位は右ローテート
	lsr field_scrool_x_up_tmp	; 上位は右シフト
	ror field_scrool_x_low_tmp	; 下位は右ローテート
	lsr field_scrool_x_up_tmp	; 上位は右シフト
	ror field_scrool_x_low_tmp	; 下位は右ローテート

	; bg_already_drawがその値に達していなければ描画
	sec
	lda bg_already_draw;
	sbc field_scrool_x_low_tmp
	beq not_skip
	jmp skip
not_skip:

; 描画

	lda #3
	sta draw_bg_y	; Y座標
	lda bg_already_draw_pos
	sta draw_bg_x	; X座標（ブロック）
	jsr SetPosition

	ldy #24
draw_loop:
	lda (map_table_outside_screen_low), y
	sta $2007

	dey	; 25個
	bpl	draw_loop

	; 描画したら bg_already_draw をincする
	inc bg_already_draw
	inc bg_already_draw_pos
	sec
	lda bg_already_draw_pos
	sbc #32
	bcc skip_reset;
	lda #0
	sta bg_already_draw_pos
skip_reset:
	

	; マップチップの起点を25ずらす
	clc
	lda map_table_outside_screen_low
	adc #25
	sta map_table_outside_screen_low
	lda map_table_outside_screen_hi
	adc #0
	sta map_table_outside_screen_hi

skip:

	rts
.endproc

; 画面外BG属性設定
.proc draw_bg_attribute
	; field_scrool_x を 32で割った数が現在描画するべきBG
	; シフトするのでテンプに一旦入れる
	lda field_scrool_x_up
	sta field_scrool_x_up_tmp
	lda field_scrool_x_low
	sta field_scrool_x_low_tmp

	lda field_scrool_x_up
	sta map_chip_index_up
	lda field_scrool_x_low
	sta map_chip_index_low
	; 32で割る
	clc
	lsr field_scrool_x_up_tmp	; 上位は右シフト
	ror field_scrool_x_low_tmp	; 下位は右ローテート
	lsr field_scrool_x_up_tmp	; 上位は右シフト
	ror field_scrool_x_low_tmp	; 下位は右ローテート
	lsr field_scrool_x_up_tmp	; 上位は右シフト
	ror field_scrool_x_low_tmp	; 下位は右ローテート
	lsr field_scrool_x_up_tmp	; 上位は右シフト
	ror field_scrool_x_low_tmp	; 下位は右ローテート
	lsr field_scrool_x_up_tmp	; 上位は右シフト
	ror field_scrool_x_low_tmp	; 下位は右ローテート

	; bg_already_draw_attributeがその値に達していなければ設定
	sec
	lda bg_already_draw_attribute;
	sbc field_scrool_x_low_tmp
	beq not_skip
	jmp skip
not_skip:

; 描画
	lda #0
	sta offset_y_attribute
	sta draw_bg_y
	lda bg_already_draw_attribute_pos
	sta draw_bg_x

	; 1度だけ座標からアドレスを求める
	; draw_bg_x(in)
	; draw_bg_y(in)
	; attribute_pos_adress_up(out)
	; attribute_pos_adress_low(out)
	jsr CalcAttributeAdressFromCoord

	ldy #7
draw_loop:
;	sty REG0
;	sec
;	lda map_chip_offset_low
;	sbc REG0
;	sta map_chip_offset_start
	;ldy map_chip_offset_start
;	ldx map_chip_offset_start
	; lda map_chip, x
;	lda bg_already_draw_attribute
;	sta draw_bg_x
;	sty draw_bg_y
;	jsr SetAttributePosition

;	ldy #0
;	lda offset_y_attribute
;	sta draw_bg_y	; Y座標
;	lda bg_already_draw_attribute
;	sta draw_bg_x	; X座標（ブロック）
;	jsr SetAttributePosition

	lda attribute_pos_adress_up
	sta $2006
	lda attribute_pos_adress_low
	sta $2006
	lda (map_table_attribute_low), y
;lda	map_chip_offset_start, y
	;sta draw_bg_tile	; タイル番号
	
	;jsr DrawMapChip
	;lda draw_bg_tile
	sta $2007



;mugen:
;jmp mugen
	lda attribute_pos_adress_low
	clc
	adc #$8
	sta attribute_pos_adress_low
	; マイナスじゃなければループする
	;iny
	dey
;	cpy #0
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

skip:

	rts
.endproc

; スプライト描画
.proc	sprite_draw

	jsr	player_draw	; プレイヤー描画関数
	jsr InosisiDraw	; イノシシ描画関数

	rts	; サブルーチンから復帰します。
.endproc

.proc	sprite_draw2

	sec			; キャリーフラグON
	lda player_y
	sbc #64
	sta $2004   ; Y座標をレジスタにストアする
	lda #$82     ; 21をAにロード
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda #%000000001;#%00000000     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	lda #136; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda player_y
	sbc #64
	sta $2004   ; Y座標をレジスタにストアする
	lda #$83     ; 21をAにロード
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda #%000000001;#%00000000     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	lda #144; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda player_y
	sbc #8
	sta $2004   ; Y座標をレジスタにストアする
	lda #$92     ; 21をAにロード
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda #%000000001;#%00000000     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	lda #136; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda player_y
	sbc #8
	sta $2004   ; Y座標をレジスタにストアする
	lda #$93     ; 21をAにロード
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda #%000000001;#%00000000     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	lda #144; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda player_y
	sbc #48
	sta $2004   ; Y座標をレジスタにストアする
	lda #$A2     ; 21をAにロード
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda #%000000001;#%00000000     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	lda #136; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda player_y
	sbc #48
	sta $2004   ; Y座標をレジスタにストアする
	lda #$A3     ; 21をAにロード
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda #%000000001;#%00000000     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	lda #144; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda player_y
	sbc #40
	sta $2004   ; Y座標をレジスタにストアする
	lda #$B2     ; 21をAにロード
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda #%000000001;#%00000000     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	lda #136; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda player_y
	sbc #40
	sta $2004   ; Y座標をレジスタにストアする
	lda #$B3     ; 21をAにロード
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda #%000000001;#%00000000     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	lda #144; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda player_y
	sbc #8
	sta $2004   ; Y座標をレジスタにストアする
	lda #$30     ; 21をAにロード
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda #%000000000;#%00000000     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	lda #112; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta $2004   ; X座標をレジスタにストアする

	rts	; サブルーチンから復帰します。
.endproc

.proc change_palette1
; パレットテーブルへ転送(MAP用のみ転送)
	lda	#$23
	sta	$2006
	lda	#$c0
	sta	$2006
	ldx	#$00
	ldy	#$4
copypal2:
	lda	palette1, x
	sta	$2007
	inx
	dey
	bne	copypal2

	rts
.endproc

.proc change_palette2
; パレットテーブルへ転送(MAP用のみ転送)
	lda	#$23
	sta	$2006
	lda	#$c1
	sta	$2006
	ldx	#$00
	ldy	#$4
copypal2:
	lda	palette2, x
	sta	$2007
	inx
	dey
	bne	copypal2

	rts
.endproc

.proc SetPosition
	; draw_bg_x	X座標
	; draw_bg_y	Y座標

	lda draw_bg_x	
	sta conv_coord_bit_x
	lda draw_bg_y
	sta conv_coord_bit_y
;;;;;↓ 座標をアドレス空間に変換 ;;;;;
	;jsr ConvertCoordToBit
	; y * 32 ; Y座標を一つ下にずらすとX方向に32動かしたこと
	lda #0
	sta multi_ans_up
	sta multi_ans_low
	lda conv_coord_bit_y
	sta multi_ans_low

	; 32倍
	clc
	asl multi_ans_low		; 下位は左シフト
	rol multi_ans_up		; 上位は左ローテート

	asl multi_ans_low
	rol multi_ans_up

	asl multi_ans_low
	rol multi_ans_up

	asl multi_ans_low
	rol multi_ans_up

	asl multi_ans_low
	rol multi_ans_up

	
	; 画面１か画面２か
	lda #$24
	sta draw_bg_display

	lda current_draw_display_no
	beq set_skip
	lda #$20
	sta draw_bg_display

set_skip:

jmp noset24
	clc
	lda conv_coord_bit_x
	asl	; 左シフト
	asl	; 左シフト
	bcs set24
	jmp noset24
	
set24:
;	lda #$24
;	sta draw_bg_display
;	sec
;	lda conv_coord_bit_x;
;	sbc #32;
;	sta conv_coord_bit_x
noset24:

	; + x
	lda multi_ans_low
	adc conv_coord_bit_x
	sta multi_ans_low

	; 下位＋下位
	clc
	lda multi_ans_low
	adc #$20
	sta conv_coord_bit_low
	; 上位＋上位
	lda multi_ans_up
	adc draw_bg_display;#$20
	sta conv_coord_bit_up
;;;;;↑ 座標をアドレス空間に変換 ;;;;;

	lda conv_coord_bit_up
	sta $2006
	lda conv_coord_bit_low
	sta $2006

	rts
.endproc

.proc CalcAttributeAdressFromCoord
	; draw_bg_x	X座標(0,0)-(7,7)
	; draw_bg_y	Y座標
	; attribute_pos_adress_up
	; attribute_pos_adress_low
	lda draw_bg_x
	sta conv_coord_bit_x
	lda draw_bg_y
	sta conv_coord_bit_y
;;;;;↓ 座標をアドレス空間に変換 ;;;;;
	;jsr ConvertCoordToBit
	; y * 8 ; Y座標を一つ下にずらすとX方向に8動かしたこと
	lda #0
	sta multi_ans_up
	sta multi_ans_low

	lda conv_coord_bit_y
	sta multi_ans_low

	; 8倍
	clc
	asl multi_ans_low		; 下位は左シフト
	rol multi_ans_up		; 上位は左ローテート

	asl multi_ans_low
	rol multi_ans_up

	asl multi_ans_low
	rol multi_ans_up
	
	; 画面１か画面２か
	lda #$27
	sta draw_bg_display

	lda current_draw_display_no
	beq set_skip
	lda #$23
	sta draw_bg_display

set_skip:


jmp noset24
	clc
	lda conv_coord_bit_x
	asl	; 左シフト
	asl	; 左シフト
	bcs set24
	jmp noset24
	
set24:
;	lda #$24
;	sta draw_bg_display
;	sec
;	lda conv_coord_bit_x;
;	sbc #32;
;	sta conv_coord_bit_x
noset24:

	; + x
	lda multi_ans_low
	adc conv_coord_bit_x
	sta multi_ans_low

	; 下位＋下位
	clc
	lda multi_ans_low
	adc #$c0
	sta conv_coord_bit_low
	; 上位＋上位
	lda multi_ans_up
	adc draw_bg_display;#$27
	sta conv_coord_bit_up
;;;;;↑ 座標をアドレス空間に変換 ;;;;;

	lda conv_coord_bit_up
	sta attribute_pos_adress_up
	lda conv_coord_bit_low
	sta attribute_pos_adress_low

	rts
.endproc

.proc DrawMapChip
	; draw_bg_tile	タイル番号

	lda draw_bg_tile
	sta $2007

	rts
.endproc

	; 初期データ
X_Pos_Init:   .byte 20       ; X座標初期値
Y_Pos_Init:   .byte 40       ; Y座標初期値

; パレットテーブル
palette1:
	.byte	$21, $23, $3A, $30
	.byte	$0f, $07, $16, $0d
palette2:
	.byte	$0f, $00, $10, $20
paletteIno:
palettes_bg:
	.byte	$21, $0f, $00, $10
	.byte	$21, $0f, $12, $30
	.byte	$21, $08, $18, $28
	.byte	$21, $0a, $1a, $2a

	; 星テーブルデータ(20個)
Star_Tbl:
   .byte 60,45,35,60,90,65,45,20,90,10,30,40,65,25,65,35,50,35,40,35

; 表示文字列
string:
	.byte	"HELLO, WORLD!"
;	.byte	$01, $02, $11, $12

string1:
	.byte	$01, $02

string2:
	.byte	$11, $12

; マップチップ(ネームテーブル)
map_chip: ; 25個
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

	; ここから画面外
	.byte 	$05, $13, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$06, $14, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$05, $13, $03, $00, $00, $00, $00, $00, $00, $17, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$06, $14, $04, $00, $00, $00, $00, $00, $00, $18, $08, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$05, $13, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$06, $14, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$05, $13, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$06, $14, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$05, $13, $03, $00, $00, $00, $00, $00, $00, $17, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$06, $14, $04, $00, $00, $00, $00, $00, $00, $18, $08, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$05, $13, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$06, $14, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $17, $07, $17, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $18, $08, $18, $08, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$05, $13, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$06, $14, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$05, $13, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$06, $14, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; 属性テーブル
map_chip_attribute:
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00

	; ここから画面外
	.byte 	$05, $50, $00, $00, $00, $00, $00, $00
	.byte 	$05, $50, $00, $00, $00, $00, $00, $00
	.byte 	$05, $50, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00

	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$05, $50, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00

.segment "VECINFO"
	.word	VBlank
	.word	Reset
	.word	$0000

; パターンテーブル
.segment "CHARS"
	.incbin	"character.chr"

