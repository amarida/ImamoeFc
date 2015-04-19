.proc	PlayerInit
	lda #0
	sta chr_lr
	rts
.endproc

; A
.proc	PlayerJump
	; �W�����v���Ȃ甲����
	;lda	#1
	;cmp	is_jump
	lda is_jump
	bne	End
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

	; ��ʂ̍��[�Ȃ獶�ړ����Ȃ�
	sec
	lda player_x_low
	sbc field_scrool_x_low
	sbc #9
	bcc skip; �L�����[�t���O���N���A����Ă��鎞

	sec					; �L�����[�t���OON
	lda	player_x_low	; ����
	sbc	#1
	sta	player_x_low

	lda	player_x_up		; ���
	sbc	#0
	sta	player_x_up

	lda #1
	sta chr_lr

skip:

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

	; �X�N���[�����W�ƃL�����N�^���W�̍���
	; 127�ȉ��̓X�N���[�����W���X�V���Ȃ�
	sec
	lda player_x_low
	sbc field_scrool_x_low
	sec
	sbc #127
	bcc skip	; �L�����[�t���O���N���A����Ă��鎞

	; ��ʂ�0�����ʂ�127�ȉ�
	;lda #0
	;cmp player_x_up
;	lda player_x_up
;	bne no_skip
	
	;sec
	;lda player_x_low
	;sbc #127
;	clc
;	lda player_x_low
;	asl	; ���V�t�g
;	bcs no_skip

;	jmp skip
;no_skip:

	; �X�N���[�����
	clc
	lda scrool_x
	adc #1
	sta scrool_x

	clc
	lda field_scrool_x_low
	adc #1
	sta field_scrool_x_low

	bcc eor_skip
	lda #%00000001
	eor current_draw_display_no
	sta current_draw_display_no
eor_skip:

	lda field_scrool_x_up
	adc #0
	sta field_scrool_x_up

skip:

;	inc player_x;
	lda #0
	sta chr_lr
	rts
.endproc

; �X�V
.proc	PlayerUpdate
	; �W�����v���m�F
;	lda	#1
;	cmp	is_jump
;	bne	End
	lda	is_jump
	beq	End
	; �W�����v������
	jsr	PlayerUpdateJump

End:
	rts
.endproc

; �W�����v������
.proc	PlayerUpdateJump
	; �������̈����Z
	sec			; �L�����[�t���OON
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

	; �v���C���[�̈ʒu��n�ʂɍ��킹��
	lda FIELD_HEIGHT
	sta player_y

End:

	rts
.endproc

; �`��
.proc	player_draw
	;REG0 = (p_pat == 0) ? 2 : 0;

	ldx #2
	lda p_pat
	bne	Pat1
	ldx #0
Pat1:
	stx REG0


	; REG0 = (is_jump == 0) ? #$40 : #0;
	; �W�����v��
	ldx #$40
	lda is_jump
	bne ContinueJmp
	ldx REG0
ContinueJmp:
	stx REG0

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

	; REG1 = (chr_lr == 0) ? #%00000000 : #%01000000;
	; REG2 = (chr_lr == 0) ? window_player_x_low8 : window_player_x_low;
	; REG3 = (chr_lr == 0) ? window_player_x_low : window_player_x_low8;
	; ���E����
	lda #%01000000
	sta REG1
	lda window_player_x_low
	sta REG2
	lda window_player_x_low8
	sta REG3

	lda chr_lr
	bne ContinueLR

	lda #%00000000
	sta REG1
	lda window_player_x_low8
	sta REG2
	lda window_player_x_low
	sta REG3

ContinueLR:


	sec			; �L�����[�t���OON
	lda player_y
	sbc #32
	sta player1_y;
	sta player2_y;
	clc
	lda #$80     ; 21��A�Ƀ��[�h
	adc REG0
	sta player1_t
	lda REG1;#%00000000     ; 0(10�i��)��A�Ƀ��[�h
	sta player1_s
	sta player2_s
	sta player3_s
	sta player4_s
	sta player5_s
	sta player6_s
	sta player7_s
	sta player8_s
	lda REG2; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta player1_x
	sta player3_x
	sta player5_x
	sta player7_x

	clc
	lda #$81     ; 21��A�Ƀ��[�h
	adc REG0
	sta player2_t
	lda REG3; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta player2_x
	sta player4_x
	sta player6_x
	sta player8_x

	sec			; �L�����[�t���OON
	lda player_y
	sbc #24
	sta player3_y;
	sta player4_y;
	clc
	lda #$90     ; 21��A�Ƀ��[�h
	adc REG0
	sta player3_t

	clc
	lda #$91     ; 21��A�Ƀ��[�h
	adc REG0
	sta player4_t

	sec			; �L�����[�t���OON
	lda player_y
	sbc #16
	sta player5_y;
	sta player6_y;
	clc
	lda #$A0     ; 21��A�Ƀ��[�h
	adc REG0
	sta player5_t

	clc
	lda #$A1     ; 21��A�Ƀ��[�h
	adc REG0
	sta player6_t

	sec			; �L�����[�t���OON
	lda player_y
	sbc #8
	sta player7_y;
	sta player8_y;
	clc
	lda #$B0     ; 21��A�Ƀ��[�h
	adc REG0
	sta player7_t

	clc
	lda #$B1     ; 21��A�Ƀ��[�h
	adc REG0
	sta player8_t
	lda REG1     ; 0(10�i��)��A�Ƀ��[�h
	sta player8_s

	dec pat_change_frame
	;lda	#10
	;cmp pat_change_frame
	lda pat_change_frame
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

	lda	#10
	sta	pat_change_frame

	rts
.endproc

; �����蔻��
.proc collision

	rts
.endproc
