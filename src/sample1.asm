

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
	ldx	#$ff		; メモリからXにロードします。
	txs			; XをSへコピーします。

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
	sta current_draw_display_no ; 現在の描画画面番号

	lda #0
	sta p_pat		; プレイヤーの描画パターンを0で初期化
	lda #10
	sta pat_change_frame;	パターン切り替えフレーム

	jsr PlayerInit	; プレイヤー初期化
	jsr InosisiInit	; イノシシ初期化

;	; $2000のネームテーブルに生成する
;	lda #$20
;	sta $2006
;	lda #$00
;	sta $2006
;
;	lda #$00        ; 0番(真っ黒)
;	ldy #$00    	; Yレジスタ初期化
;loadNametable1:
;	ldx Star_Tbl, y				; Starテーブルの値をXに読み込む
;loadNametable2:
;	sta $2007				; $2007に属性の値を読み込む
;	dex					; X減算
;	bne loadNametable2	; まだ0でないならばループして黒を出力する
;	; 1番か2番のキャラをYの値から交互に取得
;	tya					; Y→A
;	and #1					; A AND 1
;	adc #1					; Aに1加算して1か2に
;	sta $2007				; $2007に属性の値を読み込む
;	lda #$00        ; 0番(真っ黒)
;	iny					; Y加算
;	cpy #20					; 20回(星テーブルの数)ループする
;	bne loadNametable1

	lda #< map_chip
	sta map_table_low
	lda #> map_chip
	sta map_table_hi

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

; ネームテーブルへ転送(画面の中央付近)
	; タイル番号
	lda #$21
	sta draw_bg_tile
	; X座標
	lda #2
	sta draw_bg_x
	; Y座標
	lda #2
	sta draw_bg_y

	;sta $2007		; 左上テスト

	jsr SetPosition
	jsr DrawMapChip

	; タイル番号
	lda #$41
	sta draw_bg_tile
	; X座標
	lda #2
	sta draw_bg_x
	; Y座標
	lda #4
	sta draw_bg_y

	;jsr DrawMapChip

	lda	#$23; #$21	; aレジスタに%21の値をロード
	sta	$2006		; %2006にaレジスタ($21)の値をストア
	lda	#$40; #$c9	; aレジスタに%c9の値をロード
	sta	$2006		; %2006にaレジスタ($c9)の値をストア
	; あわせて%21c9の値を$2006にストアなる
	ldx	#$00
;	ldy	#$0d		; 13文字表示
	ldy	#$04		; 4文字表示


	ldy	#4		; 14(10進)BGの表示列
	sty	loop_y

loopTo_y:
	ldy	#$10		; (16進)
	sty	loop_x
	ldy	#$00
	sty	diff

;奇数偶数行判定
	ldx	loop_y
kisugusu:
	ldy	diff
	cpy	#$01		; Yとメモリの比較
	bne	kisu		; 一致しない
	dey
	dey
kisu:
	iny
	sty	diff
	dex
	bne kisugusu
	
	

loopTo_x:
	ldy	#$00
	sty	pos
	ldy	#$2
	sty	len
copymap:
	ldy	pos
	lda	string1, y	; メモリからAにロードします。
	clc
	adc	diff
	adc	diff
	adc	diff
	adc	diff
	adc	diff
	adc	diff
	adc	diff
	adc	diff
	adc	diff
	adc	diff
	adc	diff
	adc	diff
	adc	diff
	adc	diff
	adc	diff
	adc	diff
	sta	$2007		; Aからメモリにストアします
	iny			; Yインクリメント
	sty	pos		; Yからメモリにストアします。
	ldy	len
	dey			; Yデクリメント
	sty	len
	bne	copymap		; ゼロフラグがクリアされている時にブランチします。

	ldy	loop_x		; メモリからYにロードします。
	dey
	sty	loop_x
	bne	loopTo_x

	ldy	loop_y
	dey
	sty	loop_y
	bne	loopTo_y

	; 海
;	lda #$27
;	sta $2006
;	lda #$40
;	sta $2006
;	lda #$03
;	sta $2007
;	lda #$04
;	sta $2007
;	lda #$27
;	sta $2006
;	lda #$60
;	sta $2006
;	lda #$13
;	sta $2007
;	lda #$14
;	sta $2007
;	lda #$27
;	sta $2006
;	lda #$80
;	sta $2006
;	lda #$05
;	sta $2007
;	lda #$06
;	sta $2007
;
;	lda #$27
;	sta $2006
;	lda #$F0
;	sta $2006
;	lda #%00010001
;	sta $2007
;
;	lda #$27
;	sta $2006
;	lda #$F8
;	sta $2006
;	lda #%00010001
;	sta $2007

; スクロール設定
	lda	#$00
	sta	$2005
	sta	$2005

; スクリーンオン
	lda	#%10001100	; VBlank割り込みあり
;	lda	#%00001000
	sta	$2000
	lda	#%00011110
	sta	$2001

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


	; 描画

	; 画面外背景の描画
	jsr draw_bg
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

	; bg_already_drawを13倍(x16-(x2 + x1))したところがスタート
	; bg_already_drawを26倍(x16+x8+x2)したところがスタート
	;				TODO : 32倍にして、使わないところは使わないようにする

;	lda #1					; テスト
;	sta bg_already_draw

	; 16倍
	lda #0
	sta map_chip_offset_cal16_up
	lda bg_already_draw
	sta map_chip_offset_cal16_low
	clc
;	asl map_chip_offsetcal16_up		; 下位は左シフト
;	rol map_chip_offset16_low		; 上位は左ローテート
;	asl map_chip_offset16_up		; 下位は左シフト
;	rol map_chip_offset16_low		; 上位は左ローテート
;	asl map_chip_offset16_up		; 下位は左シフト
;	rol map_chip_offset16_low		; 上位は左ローテート
;	asl map_chip_offset16_up		; 下位は左シフト
;	rol map_chip_offset16_low		; 上位は左ローテート
	lda bg_already_draw
	asl a		; 下位は左シフト
	asl a		; 下位は左シフト
	asl a		; 下位は左シフト
	asl a		; 下位は左シフト
	sta map_chip_offset_cal16_low
	lda bg_already_draw
	lsr a		; 右へシフト
	lsr a
	lsr a
	lsr a
	sta map_chip_offset_cal16_up

	; 8倍
	lda #0
	sta map_chip_offset_cal8_up
	lda bg_already_draw
	sta map_chip_offset_cal8_low
	clc
;	asl map_chip_offset8_up		; 下位は左シフト
;	rol map_chip_offset8_low	; 上位は左ローテート
;	asl map_chip_offset8_up		; 下位は左シフト
;	rol map_chip_offset8_low	; 上位は左ローテート
;	asl map_chip_offset8_up		; 下位は左シフト
;	rol map_chip_offset8_low	; 上位は左ローテート
	lda bg_already_draw
	asl a						; 左へシフト
	asl a
	asl a
	sta map_chip_offset_cal8_low
	lda bg_already_draw
	lsr a						; 右へシフト
	lsr a
	lsr a
	lsr a
	lsr a
	sta map_chip_offset_cal8_up

	; 2倍
	lda #0
	sta map_chip_offset_cal2_up
	lda bg_already_draw
	sta map_chip_offset_cal2_low
	clc
;	asl map_chip_offset2_up		; 下位は左シフト
;	rol map_chip_offset2_low	; 上位は左ローテート
	lda bg_already_draw
	asl a
	sta map_chip_offset_cal2_low
	lda bg_already_draw
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta map_chip_offset_cal2_up

	; x16 + x8 + x2
	lda #0
	sta map_chip_offset_cal_up
	sta map_chip_offset_cal_low
	clc
	lda map_chip_offset_cal8_low
	adc map_chip_offset_cal2_low
	sta map_chip_offset_cal_low
	lda map_chip_offset_cal8_up
	adc map_chip_offset_cal2_up
	sta map_chip_offset_cal_up

	clc
	lda map_chip_offset_cal16_low
	adc map_chip_offset_cal_low
	sta map_chip_offset_cal_low
	lda map_chip_offset_cal16_up
	adc map_chip_offset_cal_up
	sta map_chip_offset_cal_up

	;clc
	;lda map_chip
	;adc map_chip_offset_low
	;lda map_chip_offset_low
	;sta map_chip_offset_start

	; とりあえず下位ビットだけ考えて+25(長さが26なので)する
	clc
	lda map_chip_offset_cal_low
	adc #25
	sta map_chip_offset_low
	lda map_chip_offset_cal_up
	adc #0
	sta map_chip_offset_up

; 描画

	ldy #0
	lda #3
	sta draw_bg_y	; Y座標
	lda bg_already_draw
	; bg_already_draw + 32
;	clc
;	adc #0;32				; 32ブロックオフセット
	sta draw_bg_x	; X座標（ブロック）
;jmp skip
	jsr SetPosition
;lda #$01
;sta draw_bg_tile
;jsr DrawMapChip

	ldy #24
draw_loop:
;	sty REG0
;	sec
;	lda map_chip_offset_low
;	sbc REG0
;	sta map_chip_offset_start
	;ldy map_chip_offset_start
;	ldx map_chip_offset_start
	; lda map_chip, x
	lda (map_table_low), y
;lda	map_chip_offset_start, y
	;sta draw_bg_tile	; タイル番号
	
	;jsr DrawMapChip
	;lda draw_bg_tile
	sta $2007



;mugen:
;jmp mugen
	
	; 26と比較して等しくなければループする
	;iny
	dey
;	cpy #0
	bpl	draw_loop


	; 描画したら bg_already_draw をincする
	inc bg_already_draw

	; マップチップの起点を25ずらす
	clc
	lda map_table_low
	adc #25
	sta map_table_low
	lda map_table_hi
	adc #0
	sta map_table_hi

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
	lda bg_already_draw_attribute
	sta draw_bg_x

	; 1度だけ座標からアドレスを求める
	; draw_bg_x
	; draw_bg_y
	; attribute_pos_adress_up
	; attribute_pos_adress_low
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
map_chip: ; 26個
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

; 属性テーブル
map_chip_attribute:
	.byte 	$05, $50, $00, $00, $00, $00, $00, $00
	.byte 	$05, $50, $00, $00, $00, $00, $00, $00
	.byte 	$05, $50, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
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

