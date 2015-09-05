.proc scene_gameover
	jsr DrawGameOver

	; スクロール位置更新
	lda #0
	sta	$2005		; X方向スクロール
	lda	#0		; Yは固定
	sta	$2005

	rts
.endproc
