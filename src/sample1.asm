;  #10 10進数値
; #$10 16進数値
;  $10 16進アドレス

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
	sta p_pat		; プレイヤーの描画パターンを0で初期化
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
	; 横ブロック数
	lda #2
	sta draw_bg_w
	; 縦ブロック数
	lda #2
	sta draw_bg_h

	;sta $2007		; 左上テスト

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
	; 横ブロック数
	lda #2
	sta draw_bg_w
	; 縦ブロック数
	lda #2
	sta draw_bg_h

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
	lda #$27
	sta $2006
	lda #$40
	sta $2006
	lda #$03
	sta $2007
	lda #$04
	sta $2007
	lda #$27
	sta $2006
	lda #$60
	sta $2006
	lda #$13
	sta $2007
	lda #$14
	sta $2007
	lda #$27
	sta $2006
	lda #$80
	sta $2006
	lda #$05
	sta $2007
	lda #$06
	sta $2007

	lda #$27
	sta $2006
	lda #$F0
	sta $2006
	lda #%00010001
	sta $2007

	lda #$27
	sta $2006
	lda #$F8
	sta $2006
	lda #%00010001
	sta $2007

; スクロール設定
	lda	#$00
	sta	$2005
	sta	$2005

; スクリーンオン
	lda	#%10001000	; VBlank割り込みあり
;	lda	#%00001000
	sta	$2000
	lda	#%00011110
	sta	$2001

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; メインループ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mainloop:
vblank_wait:
		lda	$2002
		and	#%10000000
		beq	vblank_wait

;	lda #$20
;	sta $2006
;	lda scrool_x
;	sta $2006
;	lda #$05
;	sta $2007

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
	; 横ブロック数
	lda #2
	sta draw_bg_w
	; 縦ブロック数
	lda #2
	sta draw_bg_h

	jsr DrawMapChip

		
	;ゲームメイン処理
	;更新
	;lda player_x
	;sec						; キャリーフラグON
	;sbc #128
	;sta scrool_x
	;lda	player_x; scrool_x	; Xのスクロール値をロード
	lda scrool_x
	sta	$2005		; X方向スクロール
	lda	#0		; Yは固定
	sta	$2005

	;inc scrool_x
	;inc scrool_y

	lda	spd_vec
	cmp	#0
	bne	AddSpdSkip
	jsr	AddSpd
AddSpdSkip:
	lda	spd_vec
	cmp	#0
	beq	SubSpdSkip
	jsr	SubSpd
SubSpdSkip:
	
	;clc			; キャリーフラグクリア
	;lda	player_y
	;sbc	spd_y		; 速度分増加
	;sta	player_y

	jsr	sprite_update	; スプライト更新

	; 描画

	; 画面外背景の描画
	;jsr draw_bg

;	lda	0
;	sta	REG0
	lda #$00   ; $00(スプライトRAMのアドレスは8ビット長)をAにロード
	sta $2003  ; AのスプライトRAMのアドレスをストア

;	jsr change_palette1	; パレット差し替え
	jsr	sprite_draw	; スプライト描画関数
;	lda	1
;	sta	REG0
;	jsr change_palette2
	jsr	sprite_draw2	; スプライト描画関数
		
	;lda #20
	;sta multiplicand
	;lda #20
	;sta multiplier
	;jsr Multi

	lda	#%10001000	; VBlank割り込みあり
	sta	$2000

		;VBLANK終了待ち
vblank_in_wait:
		lda	$2002
		and	#%10000000
		bne	vblank_in_wait
	jmp	mainloop
.endproc

; VBlank割り込み
.proc	VBlank
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

	; field_scrool_x を 16で割った数が現在描画するべきBG
	lda field_scrool_x_up
	sta map_chip_index_up
	lda field_scrool_x_low
	sta map_chip_index_low
	; 16で割る
	clc
	lsr field_scrool_x_up	; 上位は右シフト
	ror field_scrool_x_low	; 下位は右ローテート
	lsr field_scrool_x_up	; 上位は右シフト
	ror field_scrool_x_low	; 下位は右ローテート
	lsr field_scrool_x_up	; 上位は右シフト
	ror field_scrool_x_low	; 下位は右ローテート
	lsr field_scrool_x_up	; 上位は右シフト
	ror field_scrool_x_low	; 下位は右ローテート

	; bg_already_drawがその値に達していなければ描画
	sec
	lda bg_already_draw;
	sbc field_scrool_x_low
	bne skip 

	; bg_already_drawを13倍(x16-(x2 + x1))したところがスタート

	; 16倍
	lda #0
	sta map_chip_offset16_up
	lda bg_already_draw
	sta map_chip_offset16_low
	clc
	asl map_chip_offset16_up		; 下位は左シフト
	rol map_chip_offset16_low		; 上位は左ローテート
	asl map_chip_offset16_up		; 下位は左シフト
	rol map_chip_offset16_low		; 上位は左ローテート
	asl map_chip_offset16_up		; 下位は左シフト
	rol map_chip_offset16_low		; 上位は左ローテート
	asl map_chip_offset16_up		; 下位は左シフト
	rol map_chip_offset16_low		; 上位は左ローテート

	; 2倍
	lda #0
	sta map_chip_offset3_up
	lda bg_already_draw
	sta map_chip_offset3_low
	clc
	asl map_chip_offset3_up		; 下位は左シフト
	rol map_chip_offset3_low		; 上位は左ローテート

	; 自分を加える
	clc
	lda map_chip_offset3_low
	adc bg_already_draw
	sta map_chip_offset3_low
	lda map_chip_offset3_up
	adc #0
	sta map_chip_offset3_up

	; x16 - x3
	lda #0
	sta map_chip_offset_up
	sta map_chip_offset_low
	sec
	lda map_chip_offset16_low
	adc map_chip_offset3_low
	sta map_chip_offset_low
	lda map_chip_offset16_up
	adc map_chip_offset3_up
	sta map_chip_offset_up

	clc
	lda map_chip
	adc map_chip_offset_low
	sta map_chip_offset_start

; 描画

	ldy #13

draw_loop:

	lda	map_chip_offset_start, y
	sta draw_bg_tile	; タイル番号
	; bg_already_draw * 2 + 32
	lda bg_already_draw
	asl
	clc
	adc #32
	sta draw_bg_x	; X座標
	sec
	tya	; YをAへコピーします。
	sbc #13
	sta draw_bg_y
	asl draw_bg_y	; Y座標
	lda #2
	sta draw_bg_w	; 横ブロック数
	sta draw_bg_h	; 縦ブロック数
	jsr DrawMapChip
	
	dey
	bcs	draw_loop

	; 描画したら bg_already_draw をincする
	inc bg_already_draw

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

.proc DrawMapChip
	; draw_bg_tile	タイル番号
	; draw_bg_x	X座標
	; draw_bg_y	Y座標
	; draw_bg_w	横ブロック数
	; draw_bg_h	縦ブロック数

	lda #0			; Y初期化
	sta draw_loop_y
loop_y:
	lda #0			; X初期化
	sta draw_loop_x
loop_x:
	clc
	lda draw_loop_x	
	adc draw_bg_x
	sta conv_coord_bit_x
	clc
	lda draw_loop_y
	adc draw_bg_y
	sta conv_coord_bit_y
;;;;;↓ 座標をアドレス空間に変換 ;;;;;
	;jsr ConvertCoordToBit
	; y * 32
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

	; + x
;	lda multi_ans_low
;	adc conv_coord_bit_x
;	sta multi_ans_low
	
	; 画面１か画面２か
	lda #$20
	sta draw_bg_display

;jmp noset24
	clc
;	lda conv_coord_bit_x
	asl				; 左シフト
	lsr				; 右シフト
	asl				; 左シフト
	lsr				; 右シフト
;	bcs set24
	asl	; 左シフト
;	bcs set24
	asl	; 左シフト
;	bcs set24
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

; タイル番号
	; y * 16
	;lda #0
	;sta multi_ans_low
	;lda draw_loop_y
	;sta multiplicand
	;lda #16
	;sta multiplier
	;jsr Multi
	; draw_loop_yを左シフト4回
	lda draw_loop_y

	asl	; 左シフト
	asl	; 左シフト
	asl	; 左シフト
	asl	; 左シフト

	sta multi_ans_low

;	lda draw_loop_y
;	cmp #0
;	beq no_plus
;	lda multi_ans_low
;	clc
;	adc #16
;	sta multi_ans_low
;no_plus:

	; + y
	clc
	lda draw_bg_tile
	adc multi_ans_low

	; + x
	clc
	adc draw_loop_x
	;lda draw_bg_tile

	sta $2007
	
	inc draw_loop_x
	lda draw_loop_x
	cmp draw_bg_w
	bne loop_x

	inc draw_loop_y
	lda draw_loop_y
	cmp draw_bg_h
	bne	loop_y

	rts
.endproc

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

; マップチップ
map_chip:
;	.byte 	$03, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;	.byte 	$01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;	.byte 	$01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;	.byte 	$01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;	.byte 	$01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;	.byte 	$01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;	.byte 	$01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;	.byte 	$01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;	.byte 	$01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;	.byte 	$01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;	.byte 	$01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;	.byte 	$01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;	.byte 	$01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;	.byte 	$01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;	.byte 	$01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;	.byte 	$01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

	.byte 	$01, $01, $00, $00, $00, $07, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $00, $00, $00, $00, $07, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $01, $00, $00, $00, $07, $00, $00, $00, $00, $00, $00, $00

.segment "VECINFO"
	.word	VBlank
	.word	Reset
	.word	$0000

; パターンテーブル
.segment "CHARS"
	.incbin	"character.chr"

