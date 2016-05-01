.proc	TakoInit
	lda #0
	sta tako0_world_pos_x_low
	sta tako1_world_pos_x_low
	sta tako0_world_pos_x_hi
	sta tako1_world_pos_x_hi
	sta tako00_status
	sta tako01_status
	sta tako00_wait
	sta tako01_wait
	sta tako00_update_dead_step
	sta tako01_update_dead_step
	lda #224	; ��ʊO;#184
	sta tako0_pos_y
	sta tako1_pos_y
	; �����͕ς��Ȃ�
	lda #%00000001     ; 0(10�i��)��A�Ƀ��[�h
	sta tako1_s
	sta tako2_s
	sta tako3_s
	sta tako4_s
	sta tako21_s
	sta tako22_s
	sta tako23_s
	sta tako24_s
	sta tako1_s2
	sta tako2_s2
	sta tako3_s2
	sta tako4_s2
	sta tako21_s2
	sta tako22_s2
	sta tako23_s2
	sta tako24_s2

	rts
.endproc

; �o��
.proc appear_tako
	; �󂢂Ă���^�R��T��

	lda #1
	sta tako_alive_flag_current	; �t���O�Q�ƌ��݈ʒu
	ldx #0
loop_x:
	; �󂢂Ă��邩
	lda tako_alive_flag
	and tako_alive_flag_current
	beq set_tako
	
	; ��
	asl tako_alive_flag_current
	inx
	cpx tako_max_count	; ���[�v�ő吔
	bne loop_x				; ���[�v

	; �����܂ŗ�����󂫂͂Ȃ��̂ŃX�L�b�v
	jmp skip_tako

set_tako:
	; �󂢂Ă���^�R�ɏ����Z�b�g����
	lda enemy_pos_x_hi
	sta tako0_world_pos_x_hi,x
	lda enemy_pos_x_low
	sta tako0_world_pos_x_low,x
	lda enemy_pos_y
	sta tako0_pos_y,x
	
	; �F�X������
	lda #0
	sta tako00_status,x
	sta tako00_update_dead_step,x
	; �^�R������ʏ�ɕς���
	lda #%00000010	; �p���b�g3���g�p
	sta REG0
	jsr Tako_SetAttribute

	; �t���O�𗧂Ă�
	clc
	lda tako_alive_flag
	adc tako_alive_flag_current
	sta tako_alive_flag

skip_tako:
	; �X�L�b�v
	rts
.endproc	; appear_tako

; �X�V
.proc	TakoUpdate
	lda is_dead
	bne skip_tako

	lda #1
	sta tako_alive_flag_current	; �t���O�Q�ƌ��݈ʒu
	ldx #0
loop_x:
	; �������Ă��邩
	lda tako_alive_flag
	and tako_alive_flag_current
	beq next_update		; ���݂��Ă��Ȃ�
	; ���݂��Ă���

	jsr Tako_UpdateNormal

	; ��ʊO����
	sec
	lda field_scroll_x_up
	sbc tako0_world_pos_x_hi,x
	bcc skip_dead
	sec
	lda field_scroll_x_low
	sbc tako0_world_pos_x_low,x
	bcc skip_dead
	; ��ʊO����
	lda tako_alive_flag
	eor tako_alive_flag_current
	sta tako_alive_flag
	lda #224	; ��ʊO
	sta tako0_pos_y,x

skip_dead:

next_update:
	; ��
	asl tako_alive_flag_current
	inx
	cpx tako_max_count	; ���[�v�ő吔
	bne loop_x				; ���[�v

skip_tako:
	rts
.endproc	; InosisiUpdate

; �ʏ�X�V
.proc	Tako_UpdateNormal
	; �d��
	clc
	lda #2
	adc tako0_pos_y,x
	sta tako0_pos_y,x

	; �����蔻��
	jsr tako_collision_object
	
	lda obj_collision_result
	beq roll_skip
	; ������������


	;���̏���
	sec
	lda tako0_pos_y,x
	and #%11111000
	sta tako0_pos_y,x
	
roll_skip:

	; ���ړ�
	sec
	lda tako0_world_pos_x_low,x
	sbc #1
	sta tako0_world_pos_x_low,x
	lda tako0_world_pos_x_hi,x
	sbc #0
	sta tako0_world_pos_x_hi,x

	rts
.endproc	; Tako_UpdateNormal

; �`��
.proc	TakoDrawDma7
	; �A�j���p�^�[��
	;REG0 = (p_pat == 0) ? #$20 : #0;

	ldx #$02
	lda p_pat
	bne	Pat1
	ldx #0
Pat1:
	stx REG0

; �����^�C��
	clc
	lda #$8B     ; 
	adc REG0
	sta tako1_t
	clc
	lda #$8C
	adc REG0
	sta tako2_t
	clc
	lda #$9B
	adc REG0
	sta tako3_t
	clc
	lda #$9C
	adc REG0
	sta tako4_t
	

; �\���m�F����
	lda #1
	sta tako_alive_flag_current	; �t���O�Q�ƌ��݈ʒu

; Y���W�͍X�V�K�{
	clc			; �L�����[�t���OOFF
	lda tako0_pos_y
	adc #7
	sta tako1_y
	sta tako2_y

	clc			; �L�����[�t���OOFF
	lda tako0_pos_y
	adc #15
	sta tako3_y
	sta tako4_y

; Y���W�ȊO�͔�\�����X�L�b�v

	; �������Ă��邩
	lda tako_alive_flag
	and tako_alive_flag_current
	beq skip_tako0		; ���݂��Ă��Ȃ�

	; ���݂��Ă���΁A���[���h���W����E�B���h�E���W�ɕϊ�
	sec
	lda tako0_world_pos_x_low
	sbc field_scroll_x_low
	sta tako0_window_pos_x

	lda tako0_window_pos_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta tako1_x
	sta tako3_x

	lda tako0_window_pos_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	clc			; �L�����[�t���OOFF
	adc #8
	bcc not_overflow_8	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #231	; ��ʊO
	sta tako2_y
	sta tako4_y
not_overflow_8:
	sta tako2_x
	sta tako4_x

skip_tako0:

; �^�C��
	;REG0 = (p_pat == 0) ? #$20 : #0;

	ldx #$20
	lda p_pat
	bne	skip_pat2
	ldx #0
skip_pat2:
	stx REG0

	lda tako01_status
	cmp #1
	beq drown_tail2
	cmp #2
	beq splash1_tail2
	cmp #3
	beq splash2_tail2
; �����^�C��
	clc
	lda #$84     ; 
	adc REG0
	sta tako21_t
	clc
	lda #$85
	adc REG0
	sta tako22_t
	clc
	lda #$86
	adc REG0
	sta tako23_t
	clc
	lda #$94
	adc REG0
	sta tako24_t
	
	jmp break_tile2
; �M��^�C��
drown_tail2:
	clc
	lda #$87     ; 
	adc REG0
	sta tako21_t
	clc
	lda #$88
	adc REG0
	sta tako22_t
	clc
	lda #$97
	adc REG0
	sta tako24_t

	lda #$03	; �u�����N
	sta tako23_t

	jmp break_tile2

; �����Ԃ�1�^�C��
splash1_tail2:
	lda #$89     ; 
	sta tako21_t
	lda #$8A
	sta tako22_t
	lda #$99
	sta tako24_t

	lda #$03	; �u�����N
	sta tako3_t

	jmp break_tile2

; �����Ԃ�2�^�C��
splash2_tail2:
	lda #$A9     ; 
	sta tako21_t
	lda #$AA
	sta tako22_t
	lda #$B9
	sta tako24_t

	lda #$03	; �u�����N
	sta tako23_t

	jmp break_tile2


break_tile2:

; Y���W�͍X�V�K�{

	clc			; �L�����[�t���OOFF
	lda tako1_pos_y
	adc #7
	sta tako21_y
	sta tako22_y
	sta tako23_y

	clc			; �L�����[�t���OOFF
	lda tako1_pos_y
	adc #15
	sta tako24_y

; Y���W�ȊO�͔�\�����X�L�b�v

	; �������Ă��邩
	asl tako_alive_flag_current	; ���V�t�g
	lda tako_alive_flag
	and tako_alive_flag_current
	beq skip_tako1		; ���݂��Ă��Ȃ�

	; ���݂��Ă���΁A���[���h���W����E�B���h�E���W�ɕϊ�
	sec
	lda tako1_world_pos_x_low
	sbc field_scroll_x_low
	sta tako1_window_pos_x

	lda tako1_window_pos_x
	sta tako21_x
	sta tako23_x

	lda tako1_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #8
	bcc not_overflow2_8	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #231	; ��ʊO
	sta tako22_y
	sta tako24_y
not_overflow2_8:
	sta tako22_x
	sta tako24_x

skip_tako1:


;End:
	rts

.endproc	; TakoDrawDma7

; �`��
.proc	TakoDrawDma6
	; �A�j���p�^�[��
	;REG0 = (p_pat == 0) ? #$20 : #0;

	ldx #$02
	lda p_pat
	bne	Pat1
	ldx #0
Pat1:
	stx REG0

; �����^�C��
	clc
	lda #$8B     ; 
	adc REG0
	sta tako1_t2
	clc
	lda #$8C     ;
	adc REG0
	sta tako2_t2
	clc
	lda #$9B     ; 
	adc REG0
	sta tako3_t2
	clc
	lda #$9C     ; 
	adc REG0
	sta tako4_t2


; �����m�F����
	lda #1
	sta tako_alive_flag_current	; �t���O�Q�ƌ��݈ʒu

; Y���W�͍X�V�K�{
	clc			; �L�����[�t���OOFF
	lda tako0_pos_y
	adc #7
	sta tako1_y2
	sta tako2_y2

	clc			; �L�����[�t���OOFF
	lda tako0_pos_y
	adc #15
	sta tako3_y2
	sta tako4_y2

; Y���W�ȊO�͔�\�����X�L�b�v

	; �������Ă��邩
	lda tako_alive_flag
	and tako_alive_flag_current
	beq skip_tako0		; ���݂��Ă��Ȃ�

	; ���݂��Ă���΁A���[���h���W����E�B���h�E���W�ɕϊ�
	sec
	lda tako0_world_pos_x_low
	sbc field_scroll_x_low
	sta tako0_window_pos_x


	lda tako0_window_pos_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta tako1_x2
	sta tako3_x2

	lda tako0_window_pos_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	clc			; �L�����[�t���OOFF
	adc #8
	bcc not_overflow_8	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #232	; ��ʊO
	sta tako2_y2
	sta tako4_y2
not_overflow_8:
	sta tako2_x2
	sta tako4_x2

skip_tako0:

; �^�C��
	;REG0 = (p_pat == 0) ? #$20 : #0;

	ldx #$02
	lda p_pat
	bne	skip_pat2
	ldx #0
skip_pat2:
	stx REG0

	lda tako01_status
	cmp #1
	beq drown_tail2
	cmp #2
	beq splash1_tail2
	cmp #3
	beq splash2_tail2
; �����^�C��
	clc
	lda #$8B     ; 
	adc REG0
	sta tako21_t2
	clc
	lda #$8C
	adc REG0
	sta tako22_t2
	clc
	lda #$9B
	adc REG0
	sta tako23_t2
	clc
	lda #$9C
	adc REG0
	sta tako24_t2
	
	jmp break_tile2
; �M��^�C��
drown_tail2:
	clc
	lda #$87     ; 
	adc REG0
	sta tako21_t2
	clc
	lda #$88
	adc REG0
	sta tako22_t2
	clc
	lda #$97
	adc REG0
	sta tako24_t2

	lda #$03	; �u�����N
	sta tako23_t2

	jmp break_tile2

; �����Ԃ�1�^�C��
splash1_tail2:
	lda #$89     ; 
	sta tako21_t2
	lda #$8A
	sta tako22_t2
	lda #$99
	sta tako24_t2

	lda #$03	; �u�����N
	sta tako3_t2

	jmp break_tile2

; �����Ԃ�2�^�C��
splash2_tail2:
	lda #$A9     ; 
	sta tako21_t2
	lda #$AA
	sta tako22_t2
	lda #$B9
	sta tako24_t2

	lda #$03	; �u�����N
	sta tako23_t2

	jmp break_tile2

break_tile2:
; Y���W�͍X�V�K�{

	clc			; �L�����[�t���OOFF
	lda tako1_pos_y
	adc #7
	sta tako21_y2
	sta tako22_y2

	clc			; �L�����[�t���OOFF
	lda tako1_pos_y
	adc #15
	sta tako23_y2
	sta tako24_y2

; Y���W�ȊO�͔�\�����X�L�b�v

	; �������Ă��邩
	asl tako_alive_flag_current	; ���V�t�g
	lda tako_alive_flag
	and tako_alive_flag_current
	beq skip_tako1		; ���݂��Ă��Ȃ�

	; ���݂��Ă���΁A���[���h���W����E�B���h�E���W�ɕϊ�
	sec
	lda tako1_world_pos_x_low
	sbc field_scroll_x_low
	sta tako1_window_pos_x

	lda tako1_window_pos_x
	sta tako21_x2
	sta tako23_x2

	lda tako1_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #8
	bcc not_overflow2_8	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #232	; ��ʊO
	sta tako22_y2
	sta tako24_y2
not_overflow2_8:
	sta tako22_x2
	sta tako24_x2

skip_tako1:


;End:
	rts

.endproc	; TakoDrawDma6

; �^�R�ƃI�u�W�F�N�g�Ƃ̂����蔻��
.proc tako_collision_object
	; ���S���͔��肵�Ȃ�
	lda is_dead
	beq skip_return
	lda #0
	sta obj_collision_result
	rts
skip_return:

	lda #0
	sta obj_collision_sea

	; TODO:	����̍��͍����̍��𗬗p����
	;		�E���̉��͍����̉��𗬗p����
	;		�E��͍���̏�ƉE���̉E�𗬗p����
	; �����蔻��p��4�����i�[
	clc
	lda tako0_pos_y,x ;player_y
	sta player_y_top_for_collision		; �����蔻��p��Y���W�iY���W�j
	clc
	adc #15
	sta player_y_bottom_for_collision	; �����蔻��p��Y���W�iY���W+15�j

	lda tako0_world_pos_x_hi,x ;player_x_up
	sta player_x_left_hi_for_collision	; �����蔻��p��X���W��ʁiX���W�j
	lda tako0_world_pos_x_low,x ;player_x_low
	sta player_x_left_low_for_collision	; �����蔻��p��X���W���ʁiX���W�j
	clc
	adc #23
	sta player_x_right_low_for_collision; �����蔻��p�EX���W���ʁiX���W+23�j
	lda player_x_left_hi_for_collision
	adc #0
	sta player_x_right_hi_for_collision	; �����蔻��p�EX���W��ʁiX���W+23�j


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

	lda map_table_char_pos_value
	cmp #$05
	beq hit_sea
	cmp #$06
	beq hit_sea
	jmp skip_sea
hit_sea:
	lda #1
	sta obj_collision_sea
skip_sea:

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
	sta map_chip_collision_index_right_bottom_low		; �L�����E�L������
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

	rts
.endproc	; tako_collision_object

.proc Tako_SetAttribute
	; ����REG0�F����(0��1)
	; ����x�F�^�R�P���^�R�Q
	; x��0��1���ŕς��鑮���𔻒肷��
	txa
	cmp #0
	beq tako1
	cmp #1
	beq tako2
tako1:
	lda REG0
	sta tako1_s
	sta tako2_s
	sta tako3_s
	sta tako4_s
	sta tako1_s2
	sta tako2_s2
	sta tako3_s2
	sta tako4_s2
	
	jmp break
tako2:
	lda REG0
	sta tako21_s
	sta tako22_s
	sta tako23_s
	sta tako24_s
	sta tako21_s2
	sta tako22_s2
	sta tako23_s2
	sta tako24_s2

break:
	rts
.endproc	; Tako_SetSplashAttribute
