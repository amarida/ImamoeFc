.proc	InosisiInit
	lda #200
	sta inosisi_x
	lda #184
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
	sta inosisi21_s
	sta inosisi22_s
	sta inosisi23_s
	sta inosisi24_s
	sta inosisi25_s
	sta inosisi26_s
	sta inosisi27_s
	sta inosisi28_s

	rts
.endproc

; 更新
.proc	InosisiUpdate
	lda char_collision_result
	cmp #1
	beq End

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

	clc			; キャリーフラグOFF
	lda inosisi_y
	adc #7
	sta inosisi1_y
	sta inosisi2_y
	sta inosisi3_y
	sta inosisi4_y
	sta inosisi21_y
	sta inosisi22_y
	sta inosisi23_y
	sta inosisi24_y
	clc
	lda #$84     ; 
	adc REG0
	sta inosisi1_t
	sta inosisi21_t
;	sec			; キャリーフラグON
	lda inosisi_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
;	sbc scrool_x;
	sta inosisi1_x
	sta inosisi5_x
	clc
	adc #64
	sta inosisi21_x
	sta inosisi25_x

	clc
	lda #$85     ; 21をAにロード
	adc REG0
	sta inosisi2_t
	sta inosisi22_t
;	sec			; キャリーフラグON
	lda inosisi_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
;	sbc scrool_x;
	clc			; キャリーフラグOFF
	adc #8
	sta inosisi2_x
	sta inosisi6_x
	adc #64
	sta inosisi22_x
	sta inosisi26_x

	clc
	lda #$86     ; 21をAにロード
	adc REG0
	sta inosisi3_t
	sta inosisi23_t
;	sec			; キャリーフラグON
	lda inosisi_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
;	sbc scrool_x;
	clc			; キャリーフラグOFF
	adc #16
	sta inosisi3_x
	sta inosisi7_x
	adc #64
	sta inosisi23_x
	sta inosisi27_x

	clc
	lda #$87     ; 21をAにロード
	adc REG0
	sta inosisi4_t
	sta inosisi24_t
;	sec			; キャリーフラグON
	lda inosisi_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
;	sbc scrool_x;
	clc			; キャリーフラグOFF
	adc #24
	sta inosisi4_x
	sta inosisi8_x
	adc #64
	sta inosisi24_x
	sta inosisi28_x

	clc			; キャリーフラグOFF
	lda inosisi_y
	adc #15
	sta inosisi5_y
	sta inosisi6_y
	sta inosisi7_y
	sta inosisi8_y
	sta inosisi25_y
	sta inosisi26_y
	sta inosisi27_y
	sta inosisi28_y
	clc
	lda #$94     ; 21をAにロード
	adc REG0
	sta inosisi5_t
	sta inosisi25_t

	clc
	lda #$95     ; 21をAにロード
	adc REG0
	sta inosisi6_t
	sta inosisi26_t

	clc
	lda #$96     ; 21をAにロード
	adc REG0
	sta inosisi7_t
	sta inosisi27_t

	clc
	lda #$97     ; 21をAにロード
	adc REG0
	sta inosisi8_t
	sta inosisi28_t


;End:
	rts

.endproc

