.proc	TamanegiInit
	lda #0
	sta tamanegi0_world_pos_x_low
	sta tamanegi1_world_pos_x_low
	sta tamanegi0_world_pos_x_hi
	sta tamanegi1_world_pos_x_hi
	sta tamanegi00_status
	sta tamanegi01_status
	sta tamanegi00_wait
	sta tamanegi01_wait
	sta tamanegi00_update_dead_step
	sta tamanegi01_update_dead_step
	lda #224	; ��ʊO;#184
	sta tamanegi0_pos_y
	sta tamanegi1_pos_y
	; �����͕ς��Ȃ�
	lda #%00000001     ; 0(10�i��)��A�Ƀ��[�h
	sta tamanegi1_s
	sta tamanegi2_s
	sta tamanegi3_s
	sta tamanegi4_s
	sta tamanegi21_s
	sta tamanegi22_s
	sta tamanegi23_s
	sta tamanegi24_s
	sta tamanegi1_s2
	sta tamanegi2_s2
	sta tamanegi3_s2
	sta tamanegi4_s2
	sta tamanegi21_s2
	sta tamanegi22_s2
	sta tamanegi23_s2
	sta tamanegi24_s2

	rts
.endproc

; �o��
.proc appear_tamanegi
	clc
	adc current_draw_display_no	; ��ʂO���P
	lda #%10001000	; VRAM������1byte
	sta $2000

; �p���b�g2���^�}�l�M�F�ɂ���
	lda	#$3f
	sta	$2006
	lda	#$14
	sta	$2006
	ldx	#$10
	ldy	#4
copypal2_test:
	lda	palette1, x
	sta $2007
	inx
	dey
	bne	copypal2_test

	clc
	lda #%10001100	; VRAM������32byte
	adc current_draw_display_no	; ��ʂO���P
	sta $2000

	; �󂢂Ă���^�}�l�M��T��

	lda #1
	sta tamanegi_alive_flag_current	; �t���O�Q�ƌ��݈ʒu
	ldx #0
loop_x:
	; �󂢂Ă��邩
	lda tamanegi_alive_flag
	and tamanegi_alive_flag_current
	beq set_tamanegi
	
	; ��
	asl tamanegi_alive_flag_current
	inx
	cpx tamanegi_max_count	; ���[�v�ő吔
	bne loop_x				; ���[�v

	; �����܂ŗ�����󂫂͂Ȃ��̂ŃX�L�b�v
	jmp skip_tamanegi

set_tamanegi:
	; �󂢂Ă���^�}�l�M�ɏ����Z�b�g����
	lda enemy_pos_x_hi
	sta tamanegi0_world_pos_x_hi,x
	lda enemy_pos_x_low
	sta tamanegi0_world_pos_x_low,x
	lda enemy_pos_y
	sta tamanegi0_pos_y,x
	
	; �F�X������

	lda #0
	sta tamanegi00_status,x
	sta tamanegi00_update_dead_step,x
	; �^�}�l�M������ʏ�ɕς���
	lda #%00000001	; �p���b�g2���g�p
	sta REG0
	lda #%01000001	; �p���b�g2���g�p
	sta REG1
	jsr Tamanegi_SetAttribute

	; �t���O�𗧂Ă�
	clc
	lda tamanegi_alive_flag
	adc tamanegi_alive_flag_current
	sta tamanegi_alive_flag

skip_tamanegi:
	; �X�L�b�v
	rts
.endproc	; appear_tamanegi

; �X�V
.proc	TamanegiUpdate
	lda is_dead
	bne skip_tamanegi

	; ����������̂����Ȃ�
	lda tamanegi_alive_flag
	beq skip_tamanegi

	lda #1
	sta tamanegi_alive_flag_current	; �t���O�Q�ƌ��݈ʒu
	ldx #0
loop_x:
	; �������Ă��邩
	lda tamanegi_alive_flag
	and tamanegi_alive_flag_current
	beq next_update		; ���݂��Ă��Ȃ�
	; ���݂��Ă���

	jsr Tamanegi_UpdateNormal

	; ��ʊO����
	sec
	lda field_scroll_x_up
	sbc tamanegi0_world_pos_x_hi,x
	bcc skip_dead
	sec
	lda field_scroll_x_low
	sbc tamanegi0_world_pos_x_low,x
	bcc skip_dead
	; ��ʊO����
	lda tamanegi_alive_flag
	eor tamanegi_alive_flag_current
	sta tamanegi_alive_flag
	lda #224	; ��ʊO
	sta tamanegi0_pos_y,x

skip_dead:

next_update:
	; ��
	asl tamanegi_alive_flag_current
	inx
	cpx tamanegi_max_count	; ���[�v�ő吔
	bne loop_x				; ���[�v

skip_tamanegi:
	rts
.endproc	; InosisiUpdate

; �ʏ�X�V
.proc	Tamanegi_UpdateNormal
	; �d��
	clc
	lda #2
	adc tamanegi0_pos_y,x
	sta tamanegi0_pos_y,x

	; �����蔻��
	jsr tamanegi_collision_object
	
	lda obj_collision_result
	beq roll_skip
	; ������������


	;���̏���
	sec
	lda tamanegi0_pos_y,x
	and #%11111000
	sta tamanegi0_pos_y,x
	
roll_skip:

	; ���ړ�
	sec
	lda tamanegi0_world_pos_x_low,x
	sbc #1
	sta tamanegi0_world_pos_x_low,x
	lda tamanegi0_world_pos_x_hi,x
	sbc #0
	sta tamanegi0_world_pos_x_hi,x

	rts
.endproc	; Tamanegi_UpdateNormal

; �`��
.proc	TamanegiDrawDma7
	; ����������̂����Ȃ�
;	lda tamanegi_alive_flag
;	bne not_skip_tamanegi
;	jmp skip_tamanegi
;not_skip_tamanegi:

	; �A�j���p�^�[��
	;REG0 = (p_pat == 0) ? #$1 : #0;
	;REG1 = (p_pat == 0) ? #$0 : #1;

	ldx #$01
	lda p_pat
	bne	Pat1
	ldx #0
Pat1:
	stx REG0

	ldx #$00
	lda p_pat
	bne	Pat2
	ldx #1
Pat2:
	stx REG1

; �����^�C��
	clc
	lda #$AD     ; 
	adc REG0
	sta tamanegi1_t
	clc
	lda #$AD
	adc REG1
	sta tamanegi2_t
	clc
	lda #$BD
	adc REG0
	sta tamanegi3_t
	clc
	lda #$BD
	adc REG1
	sta tamanegi4_t
	

; �\���m�F����
	lda #1
	sta tamanegi_alive_flag_current	; �t���O�Q�ƌ��݈ʒu

; Y���W�͍X�V�K�{
	clc			; �L�����[�t���OOFF
	lda tamanegi0_pos_y
	adc #7
	sta tamanegi1_y
	sta tamanegi2_y

	clc			; �L�����[�t���OOFF
	lda tamanegi0_pos_y
	adc #15
	sta tamanegi3_y
	sta tamanegi4_y

; Y���W�ȊO�͔�\�����X�L�b�v
	; �������Ă��邩
	lda tamanegi_alive_flag
	and tamanegi_alive_flag_current
	beq skip_tamanegi0		; ���݂��Ă��Ȃ�

	; ���݂��Ă���΁A���[���h���W����E�B���h�E���W�ɕϊ�
	sec
	lda tamanegi0_world_pos_x_low
	sbc field_scroll_x_low
	sta tamanegi0_window_pos_x

	lda tamanegi0_window_pos_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta tamanegi1_x
	sta tamanegi3_x

	lda tamanegi0_window_pos_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	clc			; �L�����[�t���OOFF
	adc #8
	bcc not_overflow_8	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #231	; ��ʊO
	sta tamanegi2_y
	sta tamanegi4_y
not_overflow_8:
	sta tamanegi2_x
	sta tamanegi4_x

skip_tamanegi0:

; �^�C��
	;REG0 = (p_pat == 0) ? #$20 : #0;
	;REG1 = (p_pat == 0) ? #$0 : #1;

	ldx #$01
	lda p_pat
	bne	skip_pat2
	ldx #0
skip_pat2:
	stx REG0

	ldx #$00
	lda p_pat
	bne	skip_pat22
	ldx #1
skip_pat22:
	stx REG1

; �����^�C��
	clc
	lda #$AD     ; 
	adc REG0
	sta tamanegi21_t
	clc
	lda #$AD
	adc REG1
	sta tamanegi22_t
	clc
	lda #$BD
	adc REG0
	sta tamanegi23_t
	clc
	lda #$BD
	adc REG1
	sta tamanegi24_t
	
; Y���W�͍X�V�K�{

	clc			; �L�����[�t���OOFF
	lda tamanegi1_pos_y
	adc #7
	sta tamanegi21_y
	sta tamanegi22_y

	clc			; �L�����[�t���OOFF
	lda tamanegi1_pos_y
	adc #15
	sta tamanegi23_y
	sta tamanegi24_y

; Y���W�ȊO�͔�\�����X�L�b�v

	; �������Ă��邩
	asl tamanegi_alive_flag_current	; ���V�t�g
	lda tamanegi_alive_flag
	and tamanegi_alive_flag_current
	beq skip_tamanegi1		; ���݂��Ă��Ȃ�

	; ���݂��Ă���΁A���[���h���W����E�B���h�E���W�ɕϊ�
	sec
	lda tamanegi1_world_pos_x_low
	sbc field_scroll_x_low
	sta tamanegi1_window_pos_x

	lda tamanegi1_window_pos_x
	sta tamanegi21_x
	sta tamanegi23_x

	lda tamanegi1_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #8
	bcc not_overflow2_8	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #231	; ��ʊO
	sta tamanegi22_y
	sta tamanegi24_y
not_overflow2_8:
	sta tamanegi22_x
	sta tamanegi24_x

skip_tamanegi1:

skip_tamanegi:

;End:
	rts

.endproc	; TamanegiDrawDma7

; �`��
.proc	TamanegiDrawDma6
	; ����������̂����Ȃ�
;	lda tamanegi_alive_flag
;	bne not_skip_tamanegi
;	jmp skip_tamanegi
;not_skip_tamanegi:

	; �A�j���p�^�[��
	;REG0 = (p_pat == 0) ? #$1 : #0;
	;REG1 = (p_pat == 0) ? #$0 : #1;

	ldx #$01
	lda p_pat
	bne	Pat1
	ldx #0
Pat1:
	stx REG0

	ldx #$00
	lda p_pat
	bne	Pat2
	ldx #1
Pat2:
	stx REG1

; �����^�C��
	clc
	lda #$AD     ; 
	adc REG0
	sta tamanegi1_t2
	clc
	lda #$AD     ;
	adc REG1
	sta tamanegi2_t2
	clc
	lda #$BD     ; 
	adc REG0
	sta tamanegi3_t2
	clc
	lda #$BD     ; 
	adc REG1
	sta tamanegi4_t2


; �����m�F����
	lda #1
	sta tamanegi_alive_flag_current	; �t���O�Q�ƌ��݈ʒu

; Y���W�͍X�V�K�{
	clc			; �L�����[�t���OOFF
	lda tamanegi0_pos_y
	adc #7
	sta tamanegi1_y2
	sta tamanegi2_y2

	clc			; �L�����[�t���OOFF
	lda tamanegi0_pos_y
	adc #15
	sta tamanegi3_y2
	sta tamanegi4_y2

; Y���W�ȊO�͔�\�����X�L�b�v

	; �������Ă��邩
	lda tamanegi_alive_flag
	and tamanegi_alive_flag_current
	beq skip_tamanegi0		; ���݂��Ă��Ȃ�

	; ���݂��Ă���΁A���[���h���W����E�B���h�E���W�ɕϊ�
	sec
	lda tamanegi0_world_pos_x_low
	sbc field_scroll_x_low
	sta tamanegi0_window_pos_x


	lda tamanegi0_window_pos_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta tamanegi1_x2
	sta tamanegi3_x2

	lda tamanegi0_window_pos_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	clc			; �L�����[�t���OOFF
	adc #8
	bcc not_overflow_8	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #232	; ��ʊO
	sta tamanegi2_y2
	sta tamanegi4_y2
not_overflow_8:
	sta tamanegi2_x2
	sta tamanegi4_x2

skip_tamanegi0:

; �^�C��
	;REG0 = (p_pat == 0) ? #$20 : #0;
	;REG1 = (p_pat == 0) ? #$0 : #1;

	ldx #$01
	lda p_pat
	bne	skip_pat2
	ldx #0
skip_pat2:
	stx REG0

	ldx #$00
	lda p_pat
	bne	skip_pat22
	ldx #1
skip_pat22:
	stx REG1

; �����^�C��
	clc
	lda #$AD     ; 
	adc REG0
	sta tamanegi21_t2
	clc
	lda #$AD
	adc REG1
	sta tamanegi22_t2
	clc
	lda #$BD
	adc REG0
	sta tamanegi23_t2
	clc
	lda #$BD
	adc REG1
	sta tamanegi24_t2
	
; Y���W�͍X�V�K�{

	clc			; �L�����[�t���OOFF
	lda tamanegi1_pos_y
	adc #7
	sta tamanegi21_y2
	sta tamanegi22_y2

	clc			; �L�����[�t���OOFF
	lda tamanegi1_pos_y
	adc #15
	sta tamanegi23_y2
	sta tamanegi24_y2

; Y���W�ȊO�͔�\�����X�L�b�v

	; �������Ă��邩
	asl tamanegi_alive_flag_current	; ���V�t�g
	lda tamanegi_alive_flag
	and tamanegi_alive_flag_current
	beq skip_tamanegi1		; ���݂��Ă��Ȃ�

	; ���݂��Ă���΁A���[���h���W����E�B���h�E���W�ɕϊ�
	sec
	lda tamanegi1_world_pos_x_low
	sbc field_scroll_x_low
	sta tamanegi1_window_pos_x

	lda tamanegi1_window_pos_x
	sta tamanegi21_x2
	sta tamanegi23_x2

	lda tamanegi1_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #8
	bcc not_overflow2_8	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #232	; ��ʊO
	sta tamanegi22_y2
	sta tamanegi24_y2
not_overflow2_8:
	sta tamanegi22_x2
	sta tamanegi24_x2

skip_tamanegi1:

skip_tamanegi:

;End:
	rts

.endproc	; TamanegiDrawDma6

; �^�}�l�M�ƃI�u�W�F�N�g�Ƃ̂����蔻��
.proc tamanegi_collision_object
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
	lda tamanegi0_pos_y,x ;player_y
	sta player_y_top_for_collision		; �����蔻��p��Y���W�iY���W�j
	clc
	adc #15
	sta player_y_bottom_for_collision	; �����蔻��p��Y���W�iY���W+15�j

	lda tamanegi0_world_pos_x_hi,x ;player_x_up
	sta player_x_left_hi_for_collision	; �����蔻��p��X���W��ʁiX���W�j
	lda tamanegi0_world_pos_x_low,x ;player_x_low
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
.endproc	; tamanegi_collision_object

.proc Tamanegi_SetAttribute
	; ����REG0�F����(0��1)
	; ����x�F�^�}�l�M�P���^�}�l�M�Q
	; x��0��1���ŕς��鑮���𔻒肷��
	txa
	cmp #0
	beq tamanegi1
	cmp #1
	beq tamanegi2
tamanegi1:
	lda REG0
	sta tamanegi1_s
	sta tamanegi3_s
	sta tamanegi1_s2
	sta tamanegi3_s2
	lda REG1
	sta tamanegi2_s
	sta tamanegi4_s
	sta tamanegi2_s2
	sta tamanegi4_s2
	
	jmp break
tamanegi2:
	lda REG0
	sta tamanegi21_s
	sta tamanegi23_s
	sta tamanegi21_s2
	sta tamanegi23_s2
	lda REG1
	sta tamanegi22_s
	sta tamanegi24_s
	sta tamanegi22_s2
	sta tamanegi24_s2

break:
	rts
.endproc	; Tamanegi_SetSplashAttribute
