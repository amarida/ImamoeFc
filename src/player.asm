.proc	PlayerInit
	lda #0
	sta chr_lr
	sta is_dead
	sta update_dead_step
	rts
.endproc

; A
.proc	PlayerJump
	; �W�����v���Ȃ甲����
	lda is_jump
	bne	End
	lda is_dead
	bne End

	; �W�����v�t���OON
	lda	#1
	sta	is_jump

	; ���x�ƕ������Z�b�g
	lda	#10
	sta	spd_y

	lda	#1		; ���x�����
	sta	spd_vec

End:
	rts
.endproc

; ��ړ�
.proc	PlayerMoveUp
	rts
.endproc

; ���ړ�
.proc	PlayerMoveDown
	rts
.endproc

; ���ړ�
.proc	PlayerMoveLeft
	lda is_dead
	bne skip

	; ��ʂ̍��[�Ȃ獶�ړ����Ȃ�
	sec
	lda player_x_low
	sbc field_scroll_x_low
;	sbc #9
;	bcc skip; �L�����[�t���O���N���A����Ă��鎞
	beq skip; �[���t���O�������Ă��Ȃ��Ƃ��X�L�b�v

	sec					; �L�����[�t���OON
	lda	player_x_low	; ����
	sbc	#1
	sta	player_x_low

	lda	player_x_up		; ���
	sbc	#0
	sta	player_x_up

	lda #1
	sta chr_lr

	; �����蔻��
	jsr collision_object
	lda obj_collision_result
	beq skip

	clc
	lda player_x_low
	adc #1
	sta player_x_low
	lda player_x_up
	adc #0
	sta player_x_up
skip:

	rts
.endproc

; �E�ړ�
.proc	PlayerMoveRight
	lda is_dead
	bne skip

	clc					; �L�����[�t���OOFF
	lda	player_x_low	; ����
	adc	#1
	sta	player_x_low

	lda	player_x_up		; ���
	adc	#0
	sta	player_x_up

	; �����蔻��
	jsr collision_object
	lda obj_collision_result
	beq roll_skip

	sec
	lda player_x_low
	sbc #1
	sta player_x_low
	lda player_x_up
	sbc #0
	sta player_x_up
	jmp skip
roll_skip:

	; �X�N���[�����W�ƃL�����N�^���W�̍���
	; 127�ȉ��̓X�N���[�����W���X�V���Ȃ�
	sec
	lda player_x_low
	sbc field_scroll_x_low
	sec
	sbc #127
	bcc skip	; �L�����[�t���O���N���A����Ă��鎞

	; �X�N���[�����
	clc
	lda scroll_x
	adc #1
	sta scroll_x

;	; �X�N���[�����̍X�V�ƂƂ���
;	; �C�m�V�V���W���炷
;	sec
;	lda inosisi0_pos_x
;	sbc #1
;	sta inosisi0_pos_x
;	bne skip_inosisi_reset
;	lda #255
;	sta inosisi0_pos_x
;skip_inosisi_reset:

	clc
	lda field_scroll_x_low
	adc #1
	sta field_scroll_x_low

	bcc eor_skip
	lda #%00000001
	eor current_draw_display_no
	sta current_draw_display_no
eor_skip:

	lda field_scroll_x_up
	adc #0
	sta field_scroll_x_up

skip:

;	inc player_x;
	lda #0
	sta chr_lr
	rts
.endproc

.proc	PlayerDead
	; ���S�t���OON
	lda	#1
	sta	is_dead

	rts
.endproc

; �X�V
.proc	Player_Update
	; ���S��
	;	�X�e�b�v
	;	�~�܂�
	;	��ɔ��
	; �W�����v��
	; �W�����v������Ȃ�����

	; ��L�ɂ�����炸�ʂ鏈��


	; ���S���̏���
	lda is_dead
	beq skip_dead
	jsr Player_UpdateDead
skip_dead:

	; �W�����v���m�F
	lda	is_jump
	beq	skip_jump
	; �W�����v������
	jsr	Player_UpdateJump
skip_jump:

	; �W�����v������Ȃ�
	lda	is_jump
	bne	skip_not_jump
	lda is_dead
	bne skip_not_jump
	; �d��
	clc
	lda #1
	adc player_y
	sta player_y
	; �����蔻��
	jsr collision_object
	lda obj_collision_result
	beq roll_skip
	; ������������

	; ��������0
	lda #0
	sta player_y+1

	;���̏���
	sec
	lda player_y
	and #%11111000
	sta player_y
	; �W�����v�t���O�𗎂Ƃ�
	lda	#0
	sta	is_jump

	lda #0
	sta spd_y
	sta spd_y+1
	jmp not_jump_exit
	
roll_skip:
	; �߂��Ȃ������R�����J�n
	lda #1
	sta is_jump

	; ���x�ƕ������Z�b�g
	lda	#0
	sta	spd_y
	sta spd_y+1

	lda	#0		; ���x������
	sta	spd_vec

not_jump_exit:
skip_not_jump:

	; ���̑��̕K���ʂ鏈��


	; �G�Ƃ̂����蔻��
	jsr collision_char
	lda is_dead					; ���S�t���O
	eor #1						; is_dead�𔽓]
	and char_collision_result	; �����蔻���and
	; �����肩�����Ă���ꍇ
	; ���񏈗��Ǝ��S�t���O�𗧂Ă�
	beq skip_first_hit
	jsr PlayerDead
	
skip_first_hit:


	rts
.endproc

; �W�����v������
.proc	Player_UpdateJump
	lda spd_vec
	; 0�Ȃ瑫���Z��
	beq tashizan
	;; �����Z begin
	; �������̈����Z
	sec			; �L�����[�t���OON
	lda	player_y+1	; ����������A�Ƀ��[�h���܂�
	sbc	spd_y+1		; ���Z
	sta	player_y+1	; A���烁�����ɃX�g�A���܂�

	; �������̈����Z
	lda	player_y
	sbc	spd_y
	sta	player_y

	; ���x�̌��Z
	; �������̌���
	sec			; �L�����[�t���OON
	lda	spd_y+1
	sbc	#$80
	sta	spd_y+1
	; �������̌���
	lda	spd_y
	sbc	#$0
	sta	spd_y
	; ���������}�C�i�X�ɂȂ�����
	bpl	skip_negative_proc; �l�K�e�B�u�t���O���N���A����Ă���
	; ���x���}�C�i�X�ɂȂ����̂ŁA���x���������ɂ���
	lda #0
	sta spd_vec
	sta spd_y
	sta spd_y+1

skip_negative_proc:

	jmp skip_tashizan
	;; �����Z end

	;; �����Z
tashizan:
	; �������̑����Z
	clc			; �L�����[�t���OOFF
	lda	player_y+1	; ����������A�Ƀ��[�h���܂�
	adc	spd_y+1		; ���Z
	sta	player_y+1	; A���烁�����ɃX�g�A���܂�

	; �������̑����Z
	lda	player_y
	adc	spd_y
	sta	player_y

	; ���x�������Z
	; �������̉��Z
	clc			; �L�����[�t���OOFF
	lda	spd_y+1
	adc	#$80
	sta	spd_y+1
	; �������̉��Z
	lda	spd_y
	adc	#$0
	sta	spd_y

	; ���x�̏����8�Ƃ���
	lda spd_y
	cmp #8
	bne skip_an_upper_limit
	lda #8
	sta spd_y
	lda #0
	sta spd_y+1
skip_an_upper_limit:

skip_tashizan:

	; �����蔻��
	jsr collision_object
	lda obj_collision_result
	;lda #0
	beq roll_skip
	; ��œ���������A8�̗]���؂�̂Ă�7������A���x��0�ɂ���
	; ���œ���������A8�̗]���؂�̂Ă�1�����A���x��0�ɂ���

	; ��������0
	lda #0
	sta player_y+1

	; ��œ����������A���œ���������
	lda obj_collision_pos
	beq shita
	;��̏���
	clc
	lda player_y
	and #%11111000
	adc #8
	sta player_y
	jmp end
shita:
	;���̏���
	sec
	lda player_y
	and #%11111000
	sta player_y
	; �W�����v�t���O�𗎂Ƃ�
	lda	#0
	sta	is_jump
end:
	lda #0
	sta spd_y
	sta spd_y+1
	
roll_skip:

	; ����ł���224�Ŏ~�߂�
	lda is_dead
	cmp #1
	bne dead_stop_skip
	sec
	lda #224
	sbc player_y
	bcs dead_stop_skip	; �L�����[�t���O�Z�b�g����Ă���
	lda #224
	sta player_y
dead_stop_skip:

	rts
.endproc

; ���S���X�V
.proc	Player_UpdateDead
;	enum {
;		step_init,
;		step_stop,
;		step_jump,
;		step_wait,
;	};
;	switch(m_step) {
;	case step_init:
;		m_step++;
;		break;
;	case step_stop:
;		m_step++;
;		break;
;	case step_jump:
;		m_step++;
;		break;
;	case step_wait:
;		m_step++;
;		break;
;	}

	lda update_dead_step
	cmp #0
	beq case_init
	cmp #1
	beq case_stop
	cmp #2
	beq case_jump
	cmp #3
	beq case_wait

case_init:
	; ����0
	inc update_dead_step
	jmp break;
case_stop:
	; ����1
	lda #30
	sta wait_frame
	inc update_dead_step
	jmp break;
case_jump:
	; ����2
	dec wait_frame
	bne break
	lda #1
	sta is_jump

	; ���x�ƕ������Z�b�g
	lda	#10
	sta	spd_y

	lda	#1		; ���x�����
	sta	spd_vec
	inc update_dead_step
	jmp break;
case_wait:
	; ����3
	sec
	lda #224
	cmp player_y
	bne break
	lda #2
	sta scene_type			; �V�[��
	lda #0
	sta scene_update_step	; �V�[�����X�e�b�v

	inc update_dead_step
	jmp break;

break:



	rts
.endproc

; �`��
.proc	player_draw_dma7
	;REG0 = (p_pat == 0) ? 2 : 0;

	ldx #2
	lda p_pat
	bne	Pat1
	ldx #0
Pat1:
	stx REG0


	; REG0 = (is_jump == 1) ? #$40 : #0;
	; �W�����v��
	ldx #$40
	lda is_jump
	bne ContinueJmp
	ldx REG0
ContinueJmp:
	stx REG0

	; REG0 = (is_dead == 1) ? #$42 : #0;
	; ���S��
	ldx #$42
	lda is_dead
	bne ContinueDead
	ldx REG0
ContinueDead:
	stx REG0

	; �t�B�[���h�v���C���[�ʒu - �t�B�[���h�X�N���[���ʒu
	sec
	lda player_x_low
	sbc field_scroll_x_low
	sta window_player_x_low
	;lda player_x_up
	;sbc field_scroll_x_up
	;sta window_player_x_up
	clc
	lda window_player_x_low
	adc #8
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

	clc			; �L�����[�t���OOFF
	lda player_y
	adc #7
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

	lda REG3; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta player1_x
	sta player3_x
	sta player5_x
	sta player7_x

	clc
	lda #$81     ; 21��A�Ƀ��[�h
	adc REG0
	sta player2_t
	lda REG2; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta player2_x
	sta player4_x
	sta player6_x
	sta player8_x

	clc			; �L�����[�t���OOFF
	lda player_y
	adc #15
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

	clc			; �L�����[�t���OOFF
	lda player_y
	adc #23
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

	clc			; �L�����[�t���OOFF
	lda player_y
	adc #31
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
	bne change_pat_skip
	jsr change_pat

change_pat_skip:
;End:
	rts

.endproc
; �`��
.proc	player_draw_dma6
	;REG0 = (p_pat == 0) ? 2 : 0;

	ldx #2
	lda p_pat
	bne	Pat1
	ldx #0
Pat1:
	stx REG0


	; REG0 = (is_jump == 1) ? #$40 : #0;
	; �W�����v��
	ldx #$40
	lda is_jump
	bne ContinueJmp
	ldx REG0
ContinueJmp:
	stx REG0

	; REG0 = (is_dead == 1) ? #$42 : #0;
	; ���S��
	ldx #$42
	lda is_dead
	bne ContinueDead
	ldx REG0
ContinueDead:
	stx REG0

	; �t�B�[���h�v���C���[�ʒu - �t�B�[���h�X�N���[���ʒu
	sec
	lda player_x_low
	sbc field_scroll_x_low
	sta window_player_x_low
	;lda player_x_up
	;sbc field_scroll_x_up
	;sta window_player_x_up
	clc
	lda window_player_x_low
	adc #8
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

	clc			; �L�����[�t���OOFF
	lda player_y
	adc #7
	sta player1_y2;
	sta player2_y2;
	clc
	lda #$80     ; 21��A�Ƀ��[�h
	adc REG0
	sta player1_t2
	lda REG1;#%00000000     ; 0(10�i��)��A�Ƀ��[�h
	sta player1_s2
	sta player2_s2
	sta player3_s2
	sta player4_s2
	sta player5_s2
	sta player6_s2
	sta player7_s2
	sta player8_s2

	lda REG3; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta player1_x2
	sta player3_x2
	sta player5_x2
	sta player7_x2

	clc
	lda #$81     ; 21��A�Ƀ��[�h
	adc REG0
	sta player2_t2
	lda REG2; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta player2_x2
	sta player4_x2
	sta player6_x2
	sta player8_x2

	clc			; �L�����[�t���OOFF
	lda player_y
	adc #15
	sta player3_y2;
	sta player4_y2;
	clc
	lda #$90     ; 21��A�Ƀ��[�h
	adc REG0
	sta player3_t2

	clc
	lda #$91     ; 21��A�Ƀ��[�h
	adc REG0
	sta player4_t2

	clc			; �L�����[�t���OOFF
	lda player_y
	adc #23
	sta player5_y2;
	sta player6_y2;
	clc
	lda #$A0     ; 21��A�Ƀ��[�h
	adc REG0
	sta player5_t2

	clc
	lda #$A1     ; 21��A�Ƀ��[�h
	adc REG0
	sta player6_t2

	clc			; �L�����[�t���OOFF
	lda player_y
	adc #31
	sta player7_y2;
	sta player8_y2;
	clc
	lda #$B0     ; 21��A�Ƀ��[�h
	adc REG0
	sta player7_t2

	clc
	lda #$B1     ; 21��A�Ƀ��[�h
	adc REG0
	sta player8_t2
	lda REG1     ; 0(10�i��)��A�Ƀ��[�h
	sta player8_s2

	dec pat_change_frame
	;lda	#10
	;cmp pat_change_frame
	lda pat_change_frame
	bne change_pat_skip
	jsr change_pat

change_pat_skip:

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

; �I�u�W�F�N�g�Ƃ̂����蔻��
.proc collision_object
	; ���S���͔��肵�Ȃ�
	lda is_dead
	beq skip_return
	lda #0
	sta obj_collision_result
	rts
skip_return:

	; TODO:	����̍��͍����̍��𗬗p����
	;		�E���̉��͍����̉��𗬗p����
	;		�E��͍���̏�ƉE���̉E�𗬗p����
	; �����蔻��p��4�����i�[
	clc
	lda player_y
	sta player_y_top_for_collision		; �����蔻��p��Y���W�iY���W�j
	clc
	adc #31
	sta player_y_bottom_for_collision	; �����蔻��p��Y���W�iY���W+31�j

	lda player_x_up
	sta player_x_left_hi_for_collision	; �����蔻��p��X���W��ʁiX���W�j
	lda player_x_low
	sta player_x_left_low_for_collision	; �����蔻��p��X���W���ʁiX���W�j
	clc
	adc #15
	sta player_x_right_low_for_collision; �����蔻��p�EX���W���ʁiX���W+15�j
	lda player_x_left_hi_for_collision
	adc #0
	sta player_x_right_hi_for_collision	; �����蔻��p�EX���W��ʁiX���W+15�j


	; �v���C���[�̃t�B�[���h��̈ʒu(�����̍���)(player_x_left_low_for_collision, player_x_left_hi_for_collision)
	; �����8�Ŋ������l�i���j���A�}�b�v�`�b�v�̈ʒu
	; map_chip���������l�́AX*25
	lda player_x_left_low_for_collision
	sta map_chip_player_x_low
	lda player_x_left_hi_for_collision
	sta map_chip_player_x_hi
	; 8�Ŋ���
	clc
	lsr map_chip_player_x_hi	; ��ʂ͉E�V�t�g
	ror map_chip_player_x_low	; ���ʂ͉E���[�e�[�g
	lsr map_chip_player_x_hi	; ��ʂ͉E�V�t�g
	ror map_chip_player_x_low	; ���ʂ͉E���[�e�[�g
	lsr map_chip_player_x_hi	; ��ʂ͉E�V�t�g
	ror map_chip_player_x_low	; ���ʂ͉E���[�e�[�g
	; ���ʂ�25�{(16+8+1)����@�}�b�v�`�b�v�̋N�_���Z�o����
	; REG0��16�{��low REG1��16�{��hi�Ƃ���
	; REG2�� 8�{��low REG3�� 8�{��hi�Ƃ���
	; REG4�� 1�{��low REG5�� 1�{��hi�Ƃ���
	; 16�{
	lda map_chip_player_x_hi
	sta REG1
	lda map_chip_player_x_low
	sta REG0
	clc
	asl REG0		; ���ʂ͍��V�t�g
	rol REG1		; ��ʂ͍����[�e�[�g
	asl REG0		; ���ʂ͍��V�t�g
	rol REG1		; ��ʂ͍����[�e�[�g
	asl REG0		; ���ʂ͍��V�t�g
	rol REG1		; ��ʂ͍����[�e�[�g
	asl REG0		; ���ʂ͍��V�t�g
	rol REG1		; ��ʂ͍����[�e�[�g
	; 8�{
	lda map_chip_player_x_hi
	sta REG3
	lda map_chip_player_x_low
	sta REG2
	clc
	asl REG2		; ���ʂ͍��V�t�g
	rol REG3		; ��ʂ͍����[�e�[�g
	asl REG2		; ���ʂ͍��V�t�g
	rol REG3		; ��ʂ͍����[�e�[�g
	asl REG2		; ���ʂ͍��V�t�g
	rol REG3		; ��ʂ͍����[�e�[�g
	; 1�{
	lda map_chip_player_x_hi
	sta REG5
	lda map_chip_player_x_low
	sta REG4
	; 16�{+8�{
	clc
	lda REG0
	adc REG2
	sta map_chip_collision_index_base_low
	lda REG1
	adc REG3
	sta map_chip_collision_index_base_hi
	; (16�{+8�{) + 1�{
	clc
	lda map_chip_collision_index_base_low
	adc REG4
	sta map_chip_collision_index_base_low
	lda map_chip_collision_index_base_hi
	adc REG5
	sta map_chip_collision_index_base_hi
	; �����܂łŃL�����̍���̈�ԉ��i��ʓI�Ɂj���w���B

	; ����
	clc
	lda player_y_bottom_for_collision
	sta REG0
	lsr REG0	; �E�V�t�g
	lsr REG0	; �E�V�t�g
	lsr REG0	; �E�V�t�g	; 8�Ŋ���

	; 27�������
	sec
	lda #27
	sbc REG0
	sta REG0	; ��ԉ�����̃u���b�N��

	clc
	lda REG0
	adc map_chip_collision_index_base_low			; �L��������ʈ�ԉ�
	sta map_chip_collision_index_left_bottom_low	; �L�������L������
	lda map_chip_collision_index_base_hi
	adc #0
	sta map_chip_collision_index_left_bottom_hi

	; �L�����N�^�̍����̃u���b�N�̍���
	; ����
	; ����
	; ����
	; ����
	; �}�b�v�`�b�v�̋N�_
	lda #< map_chip
	sta map_table_char_pos_offset_low
	lda #> map_chip
	sta map_table_char_pos_offset_hi

	clc
	lda map_table_char_pos_offset_low
	adc map_chip_collision_index_left_bottom_low
	sta map_table_char_pos_offset_low
	lda map_table_char_pos_offset_hi
	adc map_chip_collision_index_left_bottom_hi
	sta map_table_char_pos_offset_hi

	ldy #0	; ���炵�I����Ă���̂�y��0
	lda (map_table_char_pos_offset_low), y
	sta map_table_char_pos_value

	; obj_collision_result��߂�l�Ƃ��Ďg�p����
	; 0�Ȃ�false
	; 1�Ȃ�true
	lda #0
	sta obj_collision_result
	lda map_table_char_pos_value
	cmp #$01
	beq hit0
	cmp #$02
	beq hit0
	cmp #$11
	beq hit0
	cmp #$12
	beq hit0
	cmp #$07
	beq hit0
	cmp #$08
	beq hit0
	cmp #$17
	beq hit0
	cmp #$18
	beq hit0
	jmp skip0
hit0:
	lda #1
	sta obj_collision_result
	lda #0	; �����蔻��0��
	sta obj_collision_pos
	rts
skip0:

	; y���W(����)��8�Ŋ��� 28���炻����Ђ�
	; map_chip_collision_index�ɂ���𑫂�

	; ����
;	clc
;	lda player_y_top_for_collision
;	sta REG0
;	lsr REG0	; �E�V�t�g
;	lsr REG0	; �E�V�t�g
;	lsr REG0	; �E�V�t�g
;
;	sec
;	lda #28
;	sbc REG0
;	sta REG0
;
;	clc
;	lda REG0
;	adc map_chip_collision_index_base_low
;	sta map_chip_collision_index_base_low
;	lda map_chip_collision_index_base_hi
;	adc #0
;	sta map_chip_collision_index_base_hi

	; �L�����N�^�̍���̃u���b�N�̍���
	; ����
	; ����
	; ����
	; ����
	; �}�b�v�`�b�v�̋N�_
	; �v���C���[�̃t�B�[���h��̈ʒu(����̍���)(player_x_left_low_for_collision, player_x_left_hi_for_collision)
	; �����8�Ŋ������l�i���j���A�}�b�v�`�b�v�̈ʒu

	; ����
	clc
	lda player_y_top_for_collision
	sta REG0
	lsr REG0	; �E�V�t�g
	lsr REG0	; �E�V�t�g
	lsr REG0	; �E�V�t�g	; 8�Ŋ���

	; 27�������
	sec
	lda #27
	sbc REG0
	sta REG0	; ��ԉ�����̃u���b�N��

	clc
	lda REG0
	adc map_chip_collision_index_base_low			; �L��������ʈ�ԉ�
	sta map_chip_collision_index_left_top_low		; �L�������L������
	lda map_chip_collision_index_base_hi
	adc #0
	sta map_chip_collision_index_left_top_hi

	lda #< map_chip
	sta map_table_char_pos_offset_low
	lda #> map_chip
	sta map_table_char_pos_offset_hi

	clc
	lda map_table_char_pos_offset_low
	adc map_chip_collision_index_left_top_low
	sta map_table_char_pos_offset_low
	lda map_table_char_pos_offset_hi
	adc map_chip_collision_index_left_top_hi
	sta map_table_char_pos_offset_hi

	ldy #0	; ���炵�I����Ă���̂�y��0
	lda (map_table_char_pos_offset_low), y
	sta map_table_char_pos_value

	; obj_collision_result��߂�l�Ƃ��Ďg�p����
	; 0�Ȃ�false
	; 1�Ȃ�true
	lda #0
	sta obj_collision_result
	lda map_table_char_pos_value
	cmp #$01
	beq hit1
	cmp #$02
	beq hit1
	cmp #$11
	beq hit1
	cmp #$12
	beq hit1
	cmp #$07
	beq hit1
	cmp #$08
	beq hit1
	cmp #$17
	beq hit1
	cmp #$18
	beq hit1
	jmp skip1
hit1:
	lda #1
	sta obj_collision_result
	lda #1	; �����蔻��1��
	sta obj_collision_pos
	rts
skip1:


	; �L�����N�^�̉E���̃u���b�N�̉E��
	; ����
	; ����
	; ����
	; ����
	; �}�b�v�`�b�v�̋N�_
	; �v���C���[�̃t�B�[���h��̈ʒu(�E���̉E��)(player_x_right_low_for_collision, player_x_right_hi_for_collision)
	; �����8�Ŋ������l�i���j���A�}�b�v�`�b�v�̈ʒu
	lda player_x_right_low_for_collision
	sta map_chip_player_x_low
	lda player_x_right_hi_for_collision
	sta map_chip_player_x_hi
	; 8�Ŋ���
	clc
	lsr map_chip_player_x_hi	; ��ʂ͉E�V�t�g
	ror map_chip_player_x_low	; ���ʂ͉E���[�e�[�g
	lsr map_chip_player_x_hi	; ��ʂ͉E�V�t�g
	ror map_chip_player_x_low	; ���ʂ͉E���[�e�[�g
	lsr map_chip_player_x_hi	; ��ʂ͉E�V�t�g
	ror map_chip_player_x_low	; ���ʂ͉E���[�e�[�g
	; ���ʂ�25�{(16+8+1)����@�}�b�v�`�b�v�̋N�_���Z�o����
	; REG0��16�{��low REG1��16�{��hi�Ƃ���
	; REG2�� 8�{��low REG3�� 8�{��hi�Ƃ���
	; REG4�� 1�{��low REG5�� 1�{��hi�Ƃ���
	; 16�{
	lda map_chip_player_x_hi
	sta REG1
	lda map_chip_player_x_low
	sta REG0
	clc
	asl REG0		; ���ʂ͍��V�t�g
	rol REG1		; ��ʂ͍����[�e�[�g
	asl REG0		; ���ʂ͍��V�t�g
	rol REG1		; ��ʂ͍����[�e�[�g
	asl REG0		; ���ʂ͍��V�t�g
	rol REG1		; ��ʂ͍����[�e�[�g
	asl REG0		; ���ʂ͍��V�t�g
	rol REG1		; ��ʂ͍����[�e�[�g
	; 8�{
	lda map_chip_player_x_hi
	sta REG3
	lda map_chip_player_x_low
	sta REG2
	clc
	asl REG2		; ���ʂ͍��V�t�g
	rol REG3		; ��ʂ͍����[�e�[�g
	asl REG2		; ���ʂ͍��V�t�g
	rol REG3		; ��ʂ͍����[�e�[�g
	asl REG2		; ���ʂ͍��V�t�g
	rol REG3		; ��ʂ͍����[�e�[�g
	; 1�{
	lda map_chip_player_x_hi
	sta REG5
	lda map_chip_player_x_low
	sta REG4
	; 16�{+8�{
	clc
	lda REG0
	adc REG2
	sta map_chip_collision_index_base_low
	lda REG1
	adc REG3
	sta map_chip_collision_index_base_hi
	; (16�{+8�{) + 1�{
	clc
	lda map_chip_collision_index_base_low
	adc REG4
	sta map_chip_collision_index_base_low
	lda map_chip_collision_index_base_hi
	adc REG5
	sta map_chip_collision_index_base_hi
	; �����܂łŃL�����̍���̈�ԉ��i��ʓI�Ɂj���w���B


	; �E��
	clc
	lda player_y_bottom_for_collision
	sta REG0
	lsr REG0	; �E�V�t�g
	lsr REG0	; �E�V�t�g
	lsr REG0	; �E�V�t�g	; 8�Ŋ���

	; 27�������
	sec
	lda #27
	sbc REG0
	sta REG0	; ��ԉ�����̃u���b�N��

	clc
	lda REG0
	adc map_chip_collision_index_base_low			; �L��������ʈ�ԉ�
	sta map_chip_collision_index_right_bottom_low		; �L�������L������
	lda map_chip_collision_index_base_hi
	adc #0
	sta map_chip_collision_index_right_bottom_hi

	lda #< map_chip
	sta map_table_char_pos_offset_low
	lda #> map_chip
	sta map_table_char_pos_offset_hi

	clc
	lda map_table_char_pos_offset_low
	adc map_chip_collision_index_right_bottom_low
	sta map_table_char_pos_offset_low
	lda map_table_char_pos_offset_hi
	adc map_chip_collision_index_right_bottom_hi
	sta map_table_char_pos_offset_hi

	ldy #0	; ���炵�I����Ă���̂�y��0
	lda (map_table_char_pos_offset_low), y
	sta map_table_char_pos_value

	; obj_collision_result��߂�l�Ƃ��Ďg�p����
	; 0�Ȃ�false
	; 1�Ȃ�true
	lda #0
	sta obj_collision_result
	lda map_table_char_pos_value
	cmp #$01
	beq hit2
	cmp #$02
	beq hit2
	cmp #$11
	beq hit2
	cmp #$12
	beq hit2
	cmp #$07
	beq hit2
	cmp #$08
	beq hit2
	cmp #$17
	beq hit2
	cmp #$18
	beq hit2
	jmp skip2
hit2:
	lda #1
	sta obj_collision_result
	lda #0	; �����蔻��0��
	sta obj_collision_pos
	rts
skip2:

	; �L�����N�^�̉E��̃u���b�N�̉E��
	; ����
	; ����
	; ����
	; ����
	; �}�b�v�`�b�v�̋N�_
	; �v���C���[�̃t�B�[���h��̈ʒu(�E��̉E��)(player_x_right_low_for_collision, player_x_right_hi_for_collision)
	; �����8�Ŋ������l�i���j���A�}�b�v�`�b�v�̈ʒu

	; �E��
	clc
	lda player_y_top_for_collision
	sta REG0
	lsr REG0	; �E�V�t�g
	lsr REG0	; �E�V�t�g
	lsr REG0	; �E�V�t�g	; 8�Ŋ���

	; 27�������
	sec
	lda #27
	sbc REG0
	sta REG0	; ��ԉ�����̃u���b�N��

	clc
	lda REG0
	adc map_chip_collision_index_base_low			; �L��������ʈ�ԉ�
	sta map_chip_collision_index_right_top_low		; �L�������L������
	lda map_chip_collision_index_base_hi
	adc #0
	sta map_chip_collision_index_right_top_hi

	lda #< map_chip
	sta map_table_char_pos_offset_low
	lda #> map_chip
	sta map_table_char_pos_offset_hi

	clc
	lda map_table_char_pos_offset_low
	adc map_chip_collision_index_right_top_low
	sta map_table_char_pos_offset_low
	lda map_table_char_pos_offset_hi
	adc map_chip_collision_index_right_top_hi
	sta map_table_char_pos_offset_hi

	ldy #0	; ���炵�I����Ă���̂�y��0
	lda (map_table_char_pos_offset_low), y
	sta map_table_char_pos_value

	; collision_result��߂�l�Ƃ��Ďg�p����
	; 0�Ȃ�false
	; 1�Ȃ�true
	lda #0
	sta obj_collision_result
	lda map_table_char_pos_value
	cmp #$01
	beq hit3
	cmp #$02
	beq hit3
	cmp #$11
	beq hit3
	cmp #$12
	beq hit3
	cmp #$07
	beq hit3
	cmp #$08
	beq hit3
	cmp #$17
	beq hit3
	cmp #$18
	beq hit3
	jmp skip3
hit3:
	lda #1
	sta obj_collision_result
	lda #1	; �����蔻��1��
	sta obj_collision_pos
	rts
skip3:


	; �v���C���[�̃E�B���h�E���ʒu(�s�N�Z������u���b�N)
	; �����8�Ŋ������l��32����������l(x)��
	; int x = 32 - window_player_x_low8 / 8
	; map_table_attribute_low����߂镪(x�̒l
	;	lda (map_table_attribute_low), y
	;diff[] 25, 50, 75, 100, 125, 150, 175, 200, 225, 250,
	;		275, 300, 325, 350, 375, 400, 425, 450 ,475, 500
	;		525, 550, 575, 600, 625, 650, 675, 700, 725, 750
	;		750, 775
	; int map[��l���̈ʒu,y] = map_table_attribute_low - diff[x]
	rts
.endproc

; �L�����Ƃ̂����蔻��
.proc collision_char
	; �v���C����X���W�ƃC�m�V�V��X���W��
	; �v���C����Y���W�ƃC�m�V�V��Y���W��
	; ��r���āA�Ƃ��ɍ��������ȉ��Ȃ�
	; ���������B
	lda #1
	sta inosisi_alive_flag_current	; �t���O�Q�ƌ��݈ʒu
	ldx #0
loop_x:
	; �������Ă��邩
	lda inosisi_alive_flag
	and inosisi_alive_flag_current
	beq next_update		; ���݂��Ă��Ȃ�

	; ���݂��Ă���
	; �v���C����X�ƃC�m�V�V��X�̑傫����
	sec
	lda window_player_x_low
	sbc inosisi0_window_pos_x,x
	bpl big_player	; �v���C���̕����傫��
	; �C�m�V�V�̕����傫��
	sec
	lda inosisi0_window_pos_x,x
	sbc window_player_x_low
big_player:
	sta REG0	; X����

	; �v���C����X�ƃC�m�V�V��Y�̑傫����
	sec
	lda player_y
	sbc inosisi0_pos_y,x
	bpl big_player_y	; �v���C���̕����傫��
	; �C�m�V�V�̕����傫��
	sec
	lda inosisi0_pos_y,x
	sbc player_y
big_player_y:
	sta REG1	; y����

	lda #0
	sta char_collision_result
	
	sec
	lda REG0
	sbc #17
	bpl	next_update	; ������16���傫��
	
	sec
	lda REG1
	sbc #17
	bpl	next_update	; ������16���傫��

	lda #1
	sta char_collision_result
	jmp exit


next_update:
	; ��
	asl inosisi_alive_flag_current
	inx
	cpx inosisi_max_count	; ���[�v�ő吔
	bne loop_x				; ���[�v
	

exit:
	rts
.endproc
