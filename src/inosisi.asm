.proc	InosisiInit
	lda #200
	sta inosisi_x
	lda #207
	sta inosisi_y
	; 属性は変わらない
	lda #%00000001     ; 0(10進数)をAにロード
	sta inosisi1_s
	sta inosisi2_s
	sta inosisi3_s
	sta inosisi4_s
	sta inosisi5_s
	sta inosisi6_s
	sta inosisi7_s
	sta inosisi8_s

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
	;REG0 = (p_pat == 0) ? #$20 : #0;

	ldx #$20
	lda p_pat
	bne	Pat1
	ldx #0
Pat1:
	stx REG0

	sec			; キャリーフラグON
	lda inosisi_y
	sbc #16
	sta inosisi1_y
	sta inosisi2_y
	sta inosisi3_y
	sta inosisi4_y
	clc
	lda #$84     ; 
	adc REG0
	sta inosisi1_t
	sec			; キャリーフラグON
	lda inosisi_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sbc scrool_x;
	sta inosisi1_x
	sta inosisi5_x

	clc
	lda #$85     ; 21をAにロード
	adc REG0
	sta inosisi2_t
	sec			; キャリーフラグON
	lda inosisi_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sbc scrool_x;
	clc			; キャリーフラグOFF
	adc #8
	sta inosisi2_x
	sta inosisi6_x

	clc
	lda #$86     ; 21をAにロード
	adc REG0
	sta inosisi3_t
	sec			; キャリーフラグON
	lda inosisi_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sbc scrool_x;
	clc			; キャリーフラグOFF
	adc #16
	sta inosisi3_x
	sta inosisi7_x

	clc
	lda #$87     ; 21をAにロード
	adc REG0
	sta inosisi4_t
	sec			; キャリーフラグON
	lda inosisi_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sbc scrool_x;
	clc			; キャリーフラグOFF
	adc #24
	sta inosisi4_x
	sta inosisi8_x

	sec			; キャリーフラグON
	lda inosisi_y
	sbc #8
	sta inosisi5_y
	sta inosisi6_y
	sta inosisi7_y
	sta inosisi8_y
	clc
	lda #$94     ; 21をAにロード
	adc REG0
	sta inosisi5_t

	clc
	lda #$95     ; 21をAにロード
	adc REG0
	sta inosisi6_t

	clc
	lda #$96     ; 21をAにロード
	adc REG0
	sta inosisi7_t

	clc
	lda #$97     ; 21をAにロード
	adc REG0
	sta inosisi8_t


;End:
	rts

.endproc

