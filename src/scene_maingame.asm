.proc scene_maingame
	; 描画
	; ゲームオーバーなら文字を出す
;	lda is_dead
;	beq skip_dead
;	jsr DrawGameOver
;	jmp skip_end_draw
;skip_dead:

	; 画面外背景の描画
	jsr draw_bg				; ネームテーブル
	jsr draw_bg_attribute	; 属性テーブル
	
;skip_end_draw:


;	lda	0
;	sta	REG0
	lda #$00   ; $00(スプライトRAMのアドレスは8ビット長)をAにロード
	sta $2003  ; AのスプライトRAMのアドレスをストア

;	lda #00
;	sta $2004		;Y
;	lda #01
;	sta $2004		;番号
;	lda #0
;	sta $2004
;	lda #8
;	sta $2004		;X

	jsr change_palette1	; パレット差し替え
	;jsr	sprite_draw	; スプライト描画関数
	jsr	player_draw	; プレイヤー描画関数
	jsr InosisiDraw	; イノシシ描画関数
	jsr change_palette2
	jsr	sprite_draw2	; スプライト描画関数(色替えテスト表示)

	; スクロール位置更新
	lda scrool_x
	sta	$2005		; X方向スクロール
	lda	#0		; Yは固定
	sta	$2005

	; スプライト描画(DMAを利用)
	lda #$7  ; スプライトデータは$0700番地からなので、7をロードする。
	sta $4014 ; スプライトDMAレジスタにAをストアして、スプライトデータをDMA転送する


	clc
	lda	#%10001100	; VBlank割り込みあり
	adc current_draw_display_no	; 画面０か１
	sta	$2000
	
	jsr	Update	; 更新

	rts
.endproc
