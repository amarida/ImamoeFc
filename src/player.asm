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
	jsr collision
	lda collision_result
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
	clc					; �L�����[�t���OOFF
	lda	player_x_low	; ����
	adc	#1
	sta	player_x_low

	lda	player_x_up		; ���
	adc	#0
	sta	player_x_up

	; �����蔻��
	jsr collision
	lda collision_result
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
	sbc field_scrool_x_low
	sec
	sbc #127
	bcc skip	; �L�����[�t���O���N���A����Ă��鎞

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
	; �����蔻��
	jsr collision
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

	; �����蔻��
	jsr collision
	lda collision_result
	;lda #0
	beq roll_skip
	; ����������A���W��߂��A���x��0�ɂ���
	clc			; 
	lda	player_y+1	; ����������A�Ƀ��[�h���܂�
	adc	spd_y+1		; 
	sta	player_y+1	; A���烁�����ɃX�g�A���܂�
	lda	player_y
	adc	spd_y
	sta	player_y

	lda #0
	sta spd_y
	sta spd_y+1
	
roll_skip:


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
	;adc #0
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
	adc #8
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
	adc #16
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
	adc #24
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
	; TODO:	����̍��͍����̍��𗬗p����
	;		�E���̉��͍����̉��𗬗p����
	;		�E��͍���̏�ƉE���̉E�𗬗p����
	; �����蔻��p��4�����i�[
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

	; 28�������
	sec
	lda #28
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

	; collision_result��߂�l�Ƃ��Ďg�p����
	; 0�Ȃ�false
	; 1�Ȃ�true
	lda #0
	sta collision_result
	lda map_table_char_pos_value
	beq skip0
	lda #1
	sta collision_result
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

	; 28�������
	sec
	lda #28
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

	; collision_result��߂�l�Ƃ��Ďg�p����
	; 0�Ȃ�false
	; 1�Ȃ�true
	lda #0
	sta collision_result
	lda map_table_char_pos_value
	beq skip1
	lda #1
	sta collision_result
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

	; 28�������
	sec
	lda #28
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

	; collision_result��߂�l�Ƃ��Ďg�p����
	; 0�Ȃ�false
	; 1�Ȃ�true
	lda #0
	sta collision_result
	lda map_table_char_pos_value
	beq skip2
	lda #1
	sta collision_result
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

	; 28�������
	sec
	lda #28
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
	sta collision_result
	lda map_table_char_pos_value
	beq skip3
	lda #1
	sta collision_result
	rts
skip3:






;	ldy #1
;	lda (map_table_char_pos_offset_low), y
;	sta map_table_char_pos_value
;	; collision_result��߂�l�Ƃ��Ďg�p����
;	; 0�Ȃ�false
;	; 1�Ȃ�true
;	lda #0
;	sta collision_result
;	lda map_table_char_pos_value
;	beq skip1
;	lda #1
;	sta collision_result
;	rts
;skip1:


;	ldy #2
;	lda (map_table_char_pos_offset_low), y
;	sta map_table_char_pos_value
;	; collision_result��߂�l�Ƃ��Ďg�p����
;	; 0�Ȃ�false
;	; 1�Ȃ�true
;	lda #0
;	sta collision_result
;	lda map_table_char_pos_value
;	beq skip2
;	lda #1
;	sta collision_result
;	rts
;skip2:


;	ldy #3
;	lda (map_table_char_pos_offset_low), y
;	sta map_table_char_pos_value
;	; collision_result��߂�l�Ƃ��Ďg�p����
;	; 0�Ȃ�false
;	; 1�Ȃ�true
;	lda #0
;	sta collision_result
;	lda map_table_char_pos_value
;	beq skip3
;	lda #1
;	sta collision_result
;	rts
;skip3:

;	ldy #50
;	lda (map_table_char_pos_offset_low), y
;	sta map_table_char_pos_value
;	; collision_result��߂�l�Ƃ��Ďg�p����
;	; 0�Ȃ�false
;	; 1�Ȃ�true
;	lda #0
;	sta collision_result
;	lda map_table_char_pos_value
;	beq skip4
;	lda #1
;	sta collision_result
;	rts
;skip4:

;	ldy #51
;	lda (map_table_char_pos_offset_low), y
;	sta map_table_char_pos_value
;	; collision_result��߂�l�Ƃ��Ďg�p����
;	; 0�Ȃ�false
;	; 1�Ȃ�true
;	lda #0
;	sta collision_result
;	lda map_table_char_pos_value
;	beq skip5
;	lda #1
;	sta collision_result
;	rts
;skip5:

;	ldy #52
;	lda (map_table_char_pos_offset_low), y
;	sta map_table_char_pos_value
;	; collision_result��߂�l�Ƃ��Ďg�p����
;	; 0�Ȃ�false
;	; 1�Ȃ�true
;	lda #0
;	sta collision_result
;	lda map_table_char_pos_value
;	beq skip6
;	lda #1
;	sta collision_result
;	rts
;skip6:

;	ldy #53
;	lda (map_table_char_pos_offset_low), y
;	sta map_table_char_pos_value
;	; collision_result��߂�l�Ƃ��Ďg�p����
;	; 0�Ȃ�false
;	; 1�Ȃ�true
;	lda #0
;	sta collision_result
;	lda map_table_char_pos_value
;	beq skip7
;	lda #1
;	sta collision_result
;	rts
;skip7:

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
