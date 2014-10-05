.proc	PlayerInit
	lda #0
	sta chr_lr
	rts
.endproc

; A
.proc	PlayerJump
	; �W�����v���Ȃ甲����
	lda	#1
	cmp	is_jump
	beq	End
	;inc	player_y

	; �W�����v�t���OON
	lda	#1
	sta	is_jump

	; ���x�ƕ������Z�b�g
	lda	#10
	sta	spd_y

	;lda	#1
	;sta	spd_vec

End:
	rts
.endproc

; ��ړ�
.proc	PlayerMoveUp
	;dec player_y;
	rts
.endproc

; ���ړ�
.proc	PlayerMoveDown
	;inc player_y;
	rts
.endproc

; ���ړ�
.proc	PlayerMoveLeft
	sec					; �L�����[�t���OON
	lda	player_x_low	; ����
	sbc	#1
	sta	player_x_low

	lda	player_x_up		; ���
	sbc	#0
	sta	player_x_up

	; ��ʂ�0�����ʂ�127�ȉ�
	lda #0
	cmp player_x_up
	bne no_skip
	
	;sec
	;lda player_x_low
	;sbc #127
	clc
	lda player_x_low
	asl	; ���V�t�g
	bcs no_skip

	jmp skip
no_skip:

	; �X�N���[�����
	sec
	lda scrool_x
	sbc #1
	sta scrool_x

	; �t�B�[���h�X�N���[�����
	sec
	lda field_scrool_x_low
	sbc #1
	sta field_scrool_x_low
	

skip:

;	dec player_x;
	lda #1
	sta chr_lr
	rts
.endproc

; �E�ړ�
.proc	PlayerMoveRight
	clc					; �L�����[�t���OOFF
	lda	player_x_low	; ����
	adc	#1
	sta	player_x_low

	lda	player_x_up		; ���
	adc	#0
	sta	player_x_up

	; ��ʂ�0�����ʂ�127�ȉ�
	lda #0
	cmp player_x_up
	bne no_skip
	
	;sec
	;lda player_x_low
	;sbc #127
	clc
	lda player_x_low
	asl	; ���V�t�g
	bcs no_skip

	jmp skip
no_skip:

	; �X�N���[�����
	clc
	lda scrool_x
	adc #1
	sta scrool_x

	clc
	lda field_scrool_x_low
	adc #1
	sta field_scrool_x_low

skip:

;	inc player_x;
	lda #0
	sta chr_lr
	rts
.endproc

; �X�V
.proc	PlayerUpdate
	; �W�����v���m�F
	lda	#1
	cmp	is_jump
	bne	End
	; �W�����v������
	jsr	PlayerUpdateJump

End:
	rts
.endproc

; �W�����v������
.proc	PlayerUpdateJump
	; �������̈����Z
	sec			; �L�����[�t���OOFF
	lda	player_y+1	; ����������A�Ƀ��[�h���܂�
	sbc	spd_y+1		; ���Z
	sta	player_y+1	; A���烁�����ɃX�g�A���܂�

	; �������̈����Z
	lda	player_y
	sbc	spd_y
	sta	player_y

	; ���x�̌���
	; �������̌���
	sec			; �L�����[�t���OON
	lda	spd_y+1
	sbc	#$80
	sta	spd_y+1
	; �������̌���
	lda	spd_y
	sbc	#$0
	sta	spd_y

	; �W�����v�I������A�n�ʂ̈ʒu
	lda	FIELD_HEIGHT
	sbc	player_y
	bpl	End			; �l�K�e�B�u�t���O���N���A����Ă��鎞

	; �W�����v�t���O�𗎂Ƃ�
	lda	#0
	sta	is_jump
	lda FIELD_HEIGHT
	sta player_y

End:

	rts
.endproc

; �`��
.proc	player_draw
	; �A�j���p�^�[��
	lda	#1
	cmp	p_pat
	beq	Pat1
	lda	#0
	cmp	p_pat
	beq	Pat2
Pat1:
	lda #0
	sta REG0
	jmp Continue
Pat2:
	lda #2
	sta REG0
	jmp Continue
Continue:

	; �W�����v��
	lda #0
	cmp is_jump
	beq ContinueJmp
	lda #$40
	sta REG0
ContinueJmp:

	; �t�B�[���h�v���C���[�ʒu - �t�B�[���h�X�N���[���ʒu
	sec
	lda player_x_low
	sbc field_scrool_x_low
	sta window_player_x_low
	;lda player_x_up
	;sbc field_scrool_x_up
	;sta window_player_x_up
	sec
	lda window_player_x_low
	sbc #8
	sta window_player_x_low8

	; ���E����
	lda #0
	cmp chr_lr
	beq Right
	bne Left
Right:
	lda #%00000000
	sta REG1
	lda window_player_x_low8;#120
	sta REG2
	lda window_player_x_low;#128
	sta REG3
	jmp ContinueLR
Left:
	lda #%01000000
	sta REG1
	lda window_player_x_low;#128
	sta REG2
	lda window_player_x_low8;#120
	sta REG3
	jmp ContinueLR
ContinueLR:


	sec			; �L�����[�t���OON
	lda player_y
	sbc #32
	sta $2004   ; Y���W�����W�X�^�ɃX�g�A����
	clc
	lda #$80     ; 21��A�Ƀ��[�h
	adc REG0
	sta $2004   ; 0���X�g�A����0�Ԃ̃X�v���C�g���w�肷��
	lda REG1;#%00000000     ; 0(10�i��)��A�Ƀ��[�h
	sta $2004   ; ���]��D�揇�ʂ͑��삵�Ȃ��̂ŁA�ēx$00���X�g�A����
	lda REG2; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta $2004   ; X���W�����W�X�^�ɃX�g�A����

	sec			; �L�����[�t���OON
	lda player_y
	sbc #32
	sta $2004   ; Y���W�����W�X�^�ɃX�g�A����
	clc
	lda #$81     ; 21��A�Ƀ��[�h
	adc REG0
	sta $2004   ; 0���X�g�A����0�Ԃ̃X�v���C�g���w�肷��
	lda REG1     ; 0(10�i��)��A�Ƀ��[�h
	sta $2004   ; ���]��D�揇�ʂ͑��삵�Ȃ��̂ŁA�ēx$00���X�g�A����
	lda REG3; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta $2004   ; X���W�����W�X�^�ɃX�g�A����

	sec			; �L�����[�t���OON
	lda player_y
	sbc #24
	sta $2004   ; Y���W�����W�X�^�ɃX�g�A����
	clc
	lda #$90     ; 21��A�Ƀ��[�h
	adc REG0
	sta $2004   ; 0���X�g�A����0�Ԃ̃X�v���C�g���w�肷��
	lda REG1     ; 0(10�i��)��A�Ƀ��[�h
	sta $2004   ; ���]��D�揇�ʂ͑��삵�Ȃ��̂ŁA�ēx$00���X�g�A����
	lda REG2; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta $2004   ; X���W�����W�X�^�ɃX�g�A����

	sec			; �L�����[�t���OON
	lda player_y
	sbc #24
	sta $2004   ; Y���W�����W�X�^�ɃX�g�A����
	clc
	lda #$91     ; 21��A�Ƀ��[�h
	adc REG0
	sta $2004   ; 0���X�g�A����0�Ԃ̃X�v���C�g���w�肷��
	lda REG1     ; 0(10�i��)��A�Ƀ��[�h
	sta $2004   ; ���]��D�揇�ʂ͑��삵�Ȃ��̂ŁA�ēx$00���X�g�A����
	lda REG3; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta $2004   ; X���W�����W�X�^�ɃX�g�A����

	sec			; �L�����[�t���OON
	lda player_y
	sbc #16
	sta $2004   ; Y���W�����W�X�^�ɃX�g�A����
	clc
	lda #$A0     ; 21��A�Ƀ��[�h
	adc REG0
	sta $2004   ; 0���X�g�A����0�Ԃ̃X�v���C�g���w�肷��
	lda REG1     ; 0(10�i��)��A�Ƀ��[�h
	sta $2004   ; ���]��D�揇�ʂ͑��삵�Ȃ��̂ŁA�ēx$00���X�g�A����
	lda REG2; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta $2004   ; X���W�����W�X�^�ɃX�g�A����

	sec			; �L�����[�t���OON
	lda player_y
	sbc #16
	sta $2004   ; Y���W�����W�X�^�ɃX�g�A����
	clc
	lda #$A1     ; 21��A�Ƀ��[�h
	adc REG0
	sta $2004   ; 0���X�g�A����0�Ԃ̃X�v���C�g���w�肷��
	lda REG1     ; 0(10�i��)��A�Ƀ��[�h
	sta $2004   ; ���]��D�揇�ʂ͑��삵�Ȃ��̂ŁA�ēx$00���X�g�A����
	lda REG3; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta $2004   ; X���W�����W�X�^�ɃX�g�A����

	sec			; �L�����[�t���OON
	lda player_y
	sbc #8
	sta $2004   ; Y���W�����W�X�^�ɃX�g�A����
	clc
	lda #$B0     ; 21��A�Ƀ��[�h
	adc REG0
	sta $2004   ; 0���X�g�A����0�Ԃ̃X�v���C�g���w�肷��
	lda REG1     ; 0(10�i��)��A�Ƀ��[�h
	sta $2004   ; ���]��D�揇�ʂ͑��삵�Ȃ��̂ŁA�ēx$00���X�g�A����
	lda REG2; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta $2004   ; X���W�����W�X�^�ɃX�g�A����

	sec			; �L�����[�t���OON
	lda player_y
	sbc #8
	clc
	sta $2004   ; Y���W�����W�X�^�ɃX�g�A����
	lda #$B1     ; 21��A�Ƀ��[�h
	adc REG0
	sta $2004   ; 0���X�g�A����0�Ԃ̃X�v���C�g���w�肷��
	lda REG1     ; 0(10�i��)��A�Ƀ��[�h
	sta $2004   ; ���]��D�揇�ʂ͑��삵�Ȃ��̂ŁA�ēx$00���X�g�A����
	lda REG3; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta $2004   ; X���W�����W�X�^�ɃX�g�A����

	inc pat_change_frame
	lda	#10
	cmp pat_change_frame
	beq change_pat

;End:
	rts

.endproc

; �p�^�[���؂�ւ�
.proc	change_pat
	; p_pat��0,1���]
	sec			; �L�����[�t���OON
	lda	#1
	sbc p_pat
	sta p_pat

	lda	#0
	sta	pat_change_frame

	rts
.endproc
