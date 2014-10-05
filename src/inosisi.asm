.proc	InosisiInit
	lda #200
	sta inosisi_x
	lda #207
	sta inosisi_y
	rts
.endproc

; �X�V
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


; �`��
.proc	InosisiDraw
	; �A�j���p�^�[��
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

	sec			; �L�����[�t���OON
	lda inosisi_y
	sbc #16
	sta $2004   ; Y���W�����W�X�^�ɃX�g�A����
	clc
	lda #$84     ; 
	adc REG0
	sta $2004   ; 0���X�g�A����0�Ԃ̃X�v���C�g���w�肷��
	lda #%00000001     ; 0(10�i��)��A�Ƀ��[�h
	sta $2004   ; ���]��D�揇�ʂ͑��삵�Ȃ��̂ŁA�ēx$00���X�g�A����
	sec			; �L�����[�t���OON
	lda inosisi_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sbc scrool_x;
	sta $2004   ; X���W�����W�X�^�ɃX�g�A����

	sec			; �L�����[�t���OON
	lda inosisi_y
	sbc #16
	sta $2004   ; Y���W�����W�X�^�ɃX�g�A����
	clc
	lda #$85     ; 21��A�Ƀ��[�h
	adc REG0
	sta $2004   ; 0���X�g�A����0�Ԃ̃X�v���C�g���w�肷��
	lda #%00000001     ; 0(10�i��)��A�Ƀ��[�h
	sta $2004   ; ���]��D�揇�ʂ͑��삵�Ȃ��̂ŁA�ēx$00���X�g�A����
	sec			; �L�����[�t���OON
	lda inosisi_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sbc scrool_x;
	clc			; �L�����[�t���OOFF
	adc #8
	sta $2004   ; X���W�����W�X�^�ɃX�g�A����

	sec			; �L�����[�t���OON
	lda inosisi_y
	sbc #16
	sta $2004   ; Y���W�����W�X�^�ɃX�g�A����
	clc
	lda #$86     ; 21��A�Ƀ��[�h
	adc REG0
	sta $2004   ; 0���X�g�A����0�Ԃ̃X�v���C�g���w�肷��
	lda #%00000001     ; 0(10�i��)��A�Ƀ��[�h
	sta $2004   ; ���]��D�揇�ʂ͑��삵�Ȃ��̂ŁA�ēx$00���X�g�A����
	sec			; �L�����[�t���OON
	lda inosisi_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sbc scrool_x;
	clc			; �L�����[�t���OOFF
	adc #16
	sta $2004   ; X���W�����W�X�^�ɃX�g�A����

	sec			; �L�����[�t���OON
	lda inosisi_y
	sbc #16
	sta $2004   ; Y���W�����W�X�^�ɃX�g�A����
	clc
	lda #$87     ; 21��A�Ƀ��[�h
	adc REG0
	sta $2004   ; 0���X�g�A����0�Ԃ̃X�v���C�g���w�肷��
	lda #%00000001     ; 0(10�i��)��A�Ƀ��[�h
	sta $2004   ; ���]��D�揇�ʂ͑��삵�Ȃ��̂ŁA�ēx$00���X�g�A����
	sec			; �L�����[�t���OON
	lda inosisi_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sbc scrool_x;
	clc			; �L�����[�t���OOFF
	adc #24
	sta $2004   ; X���W�����W�X�^�ɃX�g�A����

	sec			; �L�����[�t���OON
	lda inosisi_y
	sbc #8
	sta $2004   ; Y���W�����W�X�^�ɃX�g�A����
	clc
	lda #$94     ; 21��A�Ƀ��[�h
	adc REG0
	sta $2004   ; 0���X�g�A����0�Ԃ̃X�v���C�g���w�肷��
	lda #%00000001     ; 0(10�i��)��A�Ƀ��[�h
	sta $2004   ; ���]��D�揇�ʂ͑��삵�Ȃ��̂ŁA�ēx$00���X�g�A����
	sec			; �L�����[�t���OON
	lda inosisi_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sbc scrool_x;
	sta $2004   ; X���W�����W�X�^�ɃX�g�A����

	sec			; �L�����[�t���OON
	lda inosisi_y
	sbc #8
	sta $2004   ; Y���W�����W�X�^�ɃX�g�A����
	clc
	lda #$95     ; 21��A�Ƀ��[�h
	adc REG0
	sta $2004   ; 0���X�g�A����0�Ԃ̃X�v���C�g���w�肷��
	lda #%00000001     ; 0(10�i��)��A�Ƀ��[�h
	sta $2004   ; ���]��D�揇�ʂ͑��삵�Ȃ��̂ŁA�ēx$00���X�g�A����
	sec			; �L�����[�t���OON
	lda inosisi_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sbc scrool_x;
	clc			; �L�����[�t���OOFF
	adc #8
	sta $2004   ; X���W�����W�X�^�ɃX�g�A����

	sec			; �L�����[�t���OON
	lda inosisi_y
	sbc #8
	sta $2004   ; Y���W�����W�X�^�ɃX�g�A����
	clc
	lda #$96     ; 21��A�Ƀ��[�h
	adc REG0
	sta $2004   ; 0���X�g�A����0�Ԃ̃X�v���C�g���w�肷��
	lda #%00000001     ; 0(10�i��)��A�Ƀ��[�h
	sta $2004   ; ���]��D�揇�ʂ͑��삵�Ȃ��̂ŁA�ēx$00���X�g�A����
	sec			; �L�����[�t���OON
	lda inosisi_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sbc scrool_x;
	clc			; �L�����[�t���OOFF
	adc #16
	sta $2004   ; X���W�����W�X�^�ɃX�g�A����

	sec			; �L�����[�t���OON
	lda inosisi_y
	sbc #8
	clc
	sta $2004   ; Y���W�����W�X�^�ɃX�g�A����
	lda #$97     ; 21��A�Ƀ��[�h
	sta $2004   ; 0���X�g�A����0�Ԃ̃X�v���C�g���w�肷��
	adc REG0
	lda #%00000000     ; 0(10�i��)��A�Ƀ��[�h
	sta $2004   ; ���]��D�揇�ʂ͑��삵�Ȃ��̂ŁA�ēx$00���X�g�A����
	sec			; �L�����[�t���OON
	lda inosisi_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sbc scrool_x;
	clc			; �L�����[�t���OOFF
	adc #24
	sta $2004   ; X���W�����W�X�^�ɃX�g�A����


;End:
	rts

.endproc

