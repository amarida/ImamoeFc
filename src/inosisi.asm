.proc	InosisiInit
	lda #200
	sta inosisi_x
	lda #207
	sta inosisi_y
	rts
.endproc

; 更新
.proc	InosisiUpdate
	dec inosisi_x

	sec
	lda scrool_x;
	sbc inosisi_x
	bne End 

	clc
	lda scrool_x
	adc #255
	sta inosisi_x

End:
	rts
.endproc


; 描画
.proc	InosisiDraw
	; アニメパターン
	lda	#1
	cmp	p_pat
	beq	Pat1
	lda	#0
	cmp	p_pat
	beq	Pat2
Pat1:
	lda #$0
	sta REG0
	jmp Continue
Pat2:
	lda #$20
	sta REG0
	;jmp Continue
Continue:

	sec			; キャリーフラグON
	lda inosisi_y
	sbc #16
	sta $2004   ; Y座標をレジスタにストアする
	clc
	lda #$84     ; 
	adc REG0
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda #%00000001     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	sec			; キャリーフラグON
	lda inosisi_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sbc scrool_x;
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda inosisi_y
	sbc #16
	sta $2004   ; Y座標をレジスタにストアする
	clc
	lda #$85     ; 21をAにロード
	adc REG0
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda #%00000001     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	sec			; キャリーフラグON
	lda inosisi_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sbc scrool_x;
	clc			; キャリーフラグOFF
	adc #8
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda inosisi_y
	sbc #16
	sta $2004   ; Y座標をレジスタにストアする
	clc
	lda #$86     ; 21をAにロード
	adc REG0
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda #%00000001     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	sec			; キャリーフラグON
	lda inosisi_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sbc scrool_x;
	clc			; キャリーフラグOFF
	adc #16
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda inosisi_y
	sbc #16
	sta $2004   ; Y座標をレジスタにストアする
	clc
	lda #$87     ; 21をAにロード
	adc REG0
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda #%00000001     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	sec			; キャリーフラグON
	lda inosisi_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sbc scrool_x;
	clc			; キャリーフラグOFF
	adc #24
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda inosisi_y
	sbc #8
	sta $2004   ; Y座標をレジスタにストアする
	clc
	lda #$94     ; 21をAにロード
	adc REG0
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda #%00000001     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	sec			; キャリーフラグON
	lda inosisi_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sbc scrool_x;
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda inosisi_y
	sbc #8
	sta $2004   ; Y座標をレジスタにストアする
	clc
	lda #$95     ; 21をAにロード
	adc REG0
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda #%00000001     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	sec			; キャリーフラグON
	lda inosisi_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sbc scrool_x;
	clc			; キャリーフラグOFF
	adc #8
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda inosisi_y
	sbc #8
	sta $2004   ; Y座標をレジスタにストアする
	clc
	lda #$96     ; 21をAにロード
	adc REG0
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda #%00000001     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	sec			; キャリーフラグON
	lda inosisi_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sbc scrool_x;
	clc			; キャリーフラグOFF
	adc #16
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda inosisi_y
	sbc #8
	clc
	sta $2004   ; Y座標をレジスタにストアする
	lda #$97     ; 21をAにロード
	sta $2004   ; 0をストアして0番のスプライトを指定する
	adc REG0
	lda #%00000000     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	sec			; キャリーフラグON
	lda inosisi_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sbc scrool_x;
	clc			; キャリーフラグOFF
	adc #24
	sta $2004   ; X座標をレジスタにストアする


;End:
	rts

.endproc

