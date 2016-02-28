.proc Sound_PlayFukimodoshi

; 矩形波
	lda $4015		; サウンドレジスタ
	ora #%00000010	; 矩形波チャンネル２を有効にする
	sta $4015

; bit7-6: Dutyサイクル(positive/negative)
; 00: 2/14
; 01: 4/12
; 10: 8/ 8
; 11:12/ 4
; bit5: エンベロープDecayループ/長さカウンタ無効(1:ループ,0:無効)
; bit4: エンベロープDecay無効(1:無効,0:有効)減衰するしない
; bit3-0: ボリューム/Decayレート、減衰率

	lda #%10011000
	sta $4004		; 矩形波チャンネル２制御レジスタ１

; 矩形波チャンネル１制御レジスタ２
; bit7: スイープ有効(0:無効,1:有効)
; bit6-4: スイープレート、変化の速さ。大きほど遅く、小さいほど速い。
; bit3: スイープ方向(1:decrease,0:increase)1なら尻上がり、0なら尻下がり。
; bit2-0: スイープ右シフト値。音の変化量を指定します。

	lda #%10001111
	sta $4005		; 矩形波チャンネル２制御レジスタ２

; bit7-0:チャンネルで使う周波数の下位8bitをセットする。

	lda #%11000000	; 
	sta $4006		; 矩形波チャンネル２周波数レジスタ１

;bit7-3: 音の長さ
;bit2-0: 周波数の上位3bit

	lda #%10011000
	sta $4007		; 矩形波チャンネル２周波数レジスタ２


	rts
.endproc

.proc Sound_PlayJump

	lda $4015		; サウンドレジスタ
	ora #%00000010	; 矩形波チャンネル２を有効にする
	sta $4015

	lda #1
	sta se_type
	
	lda #0
	sta se_kukei_step

	rts
.endproc

.proc PlayBgmIntroduction

	lda #1
	sta bgm_type
	
	lda $4015		; サウンドレジスタ
	ora #%00000101	; 矩形波チャンネル１を有効にする
	sta $4015

	lda #0
	sta bgm_kukei_step
	sta bgm_sankaku_step
	
	rts
.endproc

.proc UpdateSe
lda se_type
sta debug_var

	lda se_type
	cmp #0
	beq case_none
	cmp #1
	beq case_jump
	jmp end
	
case_none:
	jmp break
case_jump:
	jsr UpdateSeJumpKukei
	jmp break
	
break:
	
end:
	rts
.endproc

.proc UpdateSeJumpKukei

	lda se_kukei_step
	cmp #0
	beq case_init
	cmp #1
	beq case_play
	cmp #2
	beq case_wait
	
case_init:

	lda #< se_jump_kukei 
	sta se_jump_address_low
	lda #> se_jump_kukei 
	sta se_jump_address_hi
	
	lda #0
	sta se_kukei_count

	inc se_kukei_step
	
	jmp break
	
case_play:

	ldy #0

	lda (se_jump_address_low), y 
	sta $4004
	
	iny

	lda (se_jump_address_low), y 
	sta $4005
	
	iny
		
	lda (se_jump_address_low), y 
	sta $4006
	
	iny
	
	lda (se_jump_address_low), y 
	sta $4007

	iny

	lda (se_jump_address_low), y 
	sta se_kukei_wait_frame

	iny
	
	clc
	lda se_jump_address_low
	adc #5
	sta se_jump_address_low
	lda se_jump_address_hi
	adc #0
	sta se_jump_address_hi
	
	inc se_kukei_count

	inc se_kukei_step
	
	jmp break
	
case_wait:

	dec se_kukei_wait_frame
	lda se_kukei_wait_frame
	cmp #0
	bne break
	lda se_kukei_count
	cmp #3
	beq case_loop_end
	
	case_next:
	lda #1
	sta se_kukei_step
	jmp break
	case_loop_end:
	lda #0
	sta se_type
	jmp break
	
break:
	


	rts
.endproc


.proc UpdateBgm

	lda bgm_type
	cmp #0
	beq case_none
	cmp #1
	beq case_introduction
	jmp end
	
case_none:
	jmp break
case_introduction:
	jsr UpdateBgmIntroductionKukei
	jsr UpdateBgmIntroductionSankaku
	jmp break
	
break:
	
end:
	rts
.endproc

.proc UpdateBgmIntroductionKukei

	lda bgm_kukei_step
	cmp #0
	beq case_init
	cmp #1
	beq case_play
	cmp #2
	beq case_wait
	
case_init:


	lda #< bgm_introduction_kukei 
	sta bgm_nomal_address_low
	lda #> bgm_introduction_kukei 
	sta bgm_nomal_address_hi
	
	lda #0
	sta bgm_kukei_count

	inc bgm_kukei_step
	
	jmp break
	
case_play:

	ldy #0

	lda (bgm_nomal_address_low), y 
	sta $4000
	
	iny

	lda (bgm_nomal_address_low), y 
	sta $4001
	
	iny
		
	lda (bgm_nomal_address_low), y 
	sta $4002
	
	iny
	
	lda (bgm_nomal_address_low), y 
	sta $4003

	iny

	lda (bgm_nomal_address_low), y 
	sta bgm_kukei_wait_frame

	iny
	
	clc
	lda bgm_nomal_address_low
	adc #5
	sta bgm_nomal_address_low
	lda bgm_nomal_address_hi
	adc #0
	sta bgm_nomal_address_hi
	
	inc bgm_kukei_count

	inc bgm_kukei_step
	
	jmp break
	
case_wait:

	dec bgm_kukei_wait_frame
	lda bgm_kukei_wait_frame
	cmp #0
	bne break
	lda bgm_kukei_count
	cmp #18
	beq case_loop_end
	
	case_next:
	lda #1
	sta bgm_kukei_step
	jmp break
	case_loop_end:
	lda #0
	sta bgm_type
	jmp break
	
break:
	


	rts
.endproc

.proc UpdateBgmIntroductionSankaku

	lda bgm_sankaku_step
	cmp #0
	beq case_init
	cmp #1
	beq case_play
	cmp #2
	beq case_wait
	jmp end
	
case_init:

	lda #< bgm_introduction_sankaku
	sta bgm_nomal_sankaku_address_low
	lda #> bgm_introduction_sankaku 
	sta bgm_nomal_sankaku_address_hi
	
	lda #0
	sta bgm_sankaku_count

	inc bgm_sankaku_step
	
	jmp break
	
case_play:
	ldy #0

	lda (bgm_nomal_sankaku_address_low), y 
	sta $4008
	
	iny

	lda (bgm_nomal_sankaku_address_low), y 
	sta $400A
	
	iny
		
	lda (bgm_nomal_sankaku_address_low), y 
	sta $400B
	
	iny

	lda (bgm_nomal_sankaku_address_low), y 
	sta bgm_sankaku_wait_frame

	iny
	
	clc
	lda bgm_nomal_sankaku_address_low
	adc #4
	sta bgm_nomal_sankaku_address_low
	lda bgm_nomal_sankaku_address_hi
	adc #0
	sta bgm_nomal_sankaku_address_hi
	
	inc bgm_sankaku_count

	inc bgm_sankaku_step
	
	jmp break
	
case_wait:
	dec bgm_sankaku_wait_frame
	lda bgm_sankaku_wait_frame
	cmp #0
	bne break
	lda bgm_sankaku_count
	cmp #16
	beq case_loop_end
	
	case_next:
	lda #1
	sta bgm_sankaku_step
	jmp break
	case_loop_end:
;	lda #0
;	sta bgm_type
	lda #3
	sta bgm_sankaku_step
	jmp break
	
break:
	

end:
	rts
.endproc
