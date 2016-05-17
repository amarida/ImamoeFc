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
	sta tamanegi00_update_step
	sta tamanegi01_update_step
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

	; �󂢂Ă���^�}�l�M��T��
	lda #1
	sta palette_change_state

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

	; ��C�̃}�X�N��o�ꂳ����
	jsr CannonMask_Appear
	
	; �F�X������

	lda #0
	sta tamanegi00_status,x
	sta tamanegi00_update_step,x
	; �^�}�l�M������ʏ�ɕς���
	lda #%00000001	; �p���b�g2���g�p
	sta REG0
	lda #%01000001	; �p���b�g2���g�p
	sta REG1
	jsr Tamanegi_SetAttribute

	; �����t���O�𗧂Ă�
	clc
	lda tamanegi_alive_flag
	adc tamanegi_alive_flag_current
	sta tamanegi_alive_flag

skip_tamanegi:
	; �X�L�b�v
	rts
.endproc	; appear_tamanegi

;;;;; �폜 ;;;;;
.proc Tamanegi_Clear

	; x��0,1�łǂ�������������f����
	ldy #0
	lda #%00000001
	sta REG0
	txa
	beq not_set16
	ldy #16
	lda #%00000010
	sta REG0
	not_set16:
	
	; �����t���O�̊m�F
	lda tamanegi_alive_flag
	and REG0
	beq skip_clear		; ���݂��Ă��Ȃ�

	lda #0
	sta tamanegi1_y,y
	sta tamanegi1_t,y
	sta tamanegi1_s,y
	sta tamanegi1_x,y
	sta tamanegi2_y,y
	sta tamanegi2_t,y
	sta tamanegi2_s,y
	sta tamanegi2_x,y
	sta tamanegi3_y,y
	sta tamanegi3_t,y
	sta tamanegi3_s,y
	sta tamanegi3_x,y
	sta tamanegi4_y,y
	sta tamanegi4_t,y
	sta tamanegi4_s,y
	sta tamanegi4_x,y
	sta tamanegi1_y2,y
	sta tamanegi1_t2,y
	sta tamanegi1_s2,y
	sta tamanegi1_x2,y
	sta tamanegi2_y2,y
	sta tamanegi2_t2,y
	sta tamanegi2_s2,y
	sta tamanegi2_x2,y
	sta tamanegi3_y2,y
	sta tamanegi3_t2,y
	sta tamanegi3_s2,y
	sta tamanegi3_x2,y
	sta tamanegi4_y2,y
	sta tamanegi4_t2,y
	sta tamanegi4_s2,y
	sta tamanegi4_x2,y

	lda #0
	sta tamanegi0_world_pos_x_low,x
	sta tamanegi0_world_pos_x_hi,x
	sta tamanegi0_pos_y,x
	
	; �����t���O�𗎂Ƃ�
	lda tamanegi_alive_flag
	eor REG0
	sta tamanegi_alive_flag

skip_clear:

	rts
.endproc	; Tamanegi_Clear


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

	; ���
	lda tamanegi00_status,x
	cmp #0
	beq case_in_the_cannon
	cmp #1
	beq case_parabola
	cmp #2
	beq case_normal
	cmp #3
	beq case_burst

; ��C�̒�
case_in_the_cannon:
	jsr Tamanegi_UpdateInTheCannon
	jmp break;

; ������
case_parabola:
	jsr Tamanegi_UpdateParabola
	jmp break;

; �ʏ�
case_normal:
	jsr Tamanegi_UpdateNormal
	jmp break;

; ����
case_burst:
	jsr Tamanegi_UpdateBurst
	jmp break;

break:

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
	jsr Tamanegi_Clear
	;lda tamanegi_alive_flag
	;eor tamanegi_alive_flag_current
	;sta tamanegi_alive_flag
	;lda #224	; ��ʊO
	;sta tamanegi0_pos_y,x

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

; �X�V��C�̒�
.proc	Tamanegi_UpdateInTheCannon
	; �������߂Â��Ǝ���
	; �^�}�l�M��X���W
	; �v���C���[��X���W
	sec
	lda tamanegi0_window_pos_x,x
	sbc window_player_x_low
	sec
	sbc #96
	bcs skip; �L�����[�t���O���Z�b�g����Ă���ꍇ�X�L�b�v

	; �L�����[�t���O���N���A����Ă���ꍇ�A������64����
	lda #1
	sta tamanegi00_status,x

	lda #0
	sta tamanegi00_update_step,x

skip:
	
	rts
.endproc	; Tamanegi_UpdateInTheCannon

; �X�V������
.proc	Tamanegi_UpdateParabola
	lda tamanegi00_update_step,x
	cmp #0
	beq step_init
	cmp #1
	beq step_update
	cmp #2
	beq step_next

step_init:

	; ���x��ݒ�
	lda #6
	sta tamanegi00_spd_y,x
	lda #0
	sta tamanegi00_spd_y_decimal,x

	; �����͏�
	lda #1
	sta tamanegi00_spd_vec,x

	lda #1
	sta tamanegi00_update_step,x
	jmp step_break

step_update:

	; ���ʒu�X�V
	sec
	lda tamanegi0_world_pos_x_low,x
	sbc #2
	sta tamanegi0_world_pos_x_low,x
	lda tamanegi0_world_pos_x_hi,x
	sbc #0
	sta tamanegi0_world_pos_x_hi,x

	; �㉺����
	lda tamanegi00_spd_vec,x
	cmp #0
	beq case_down
	cmp #1
	beq case_up

	case_down:
		; �ʒu�X�V
		clc
		lda tamanegi0_pos_y,x
		adc tamanegi00_spd_y,x
		sta tamanegi0_pos_y,x

		; ���x�X�V
		clc
		lda tamanegi00_spd_y_decimal,x
		adc #$70
		sta tamanegi00_spd_y_decimal,x
		lda tamanegi00_spd_y,x
		adc #0
		sta tamanegi00_spd_y,x

		; ���n����
		jsr tamanegi_collision_object
		
		lda obj_collision_result
		beq roll_skip
		; ������������

		sec
		lda tamanegi0_pos_y,x
		and #%11111000
		sta tamanegi0_pos_y,x
	
		lda #2
		sta tamanegi00_update_step,x

		roll_skip:

		jmp case_break
	case_up:
		; �c�ʒu�X�V
		sec
		lda tamanegi0_pos_y,x
		sbc tamanegi00_spd_y,x
		sta tamanegi0_pos_y,x

		; ���x�X�V
		sec
		lda tamanegi00_spd_y_decimal,x
		sbc #$70
		sta tamanegi00_spd_y_decimal,x
		lda tamanegi00_spd_y,x
		sbc #0
		sta tamanegi00_spd_y,x

		; ���x���]����
		; ���������}�C�i�X�ɂȂ�����
		bpl	skip_negative_proc; �l�K�e�B�u�t���O���N���A����Ă���
		; ���x���}�C�i�X�ɂȂ����̂ŁA���x���������ɂ���
		lda #0
		sta tamanegi00_spd_vec,x
		sta tamanegi00_spd_y,x
		sta tamanegi00_spd_y_decimal,x
		skip_negative_proc:

		jmp case_break

	case_break:

	jmp step_break

step_next:
	lda #2
	sta tamanegi00_status,x

	lda #0
	sta tamanegi00_update_step,x
	
	jsr CannonMask_Clear	; �}�X�N��C�N���A

	jmp step_break

step_break:

	rts
.endproc	; Tamanegi_UpdateParabola

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

	; ������x����
	sec
	lda window_player_x_low
	sbc tamanegi0_window_pos_x,x
	sta REG0
	bcc not_burst	; �L�����[�t���O�������Ă��Ȃ�
	sec
	lda #48
	sbc REG0
	bcs not_burst; �L�����[�t���O���Z�b�g����Ă���ꍇ�X�L�b�v
	
	lda #3
	sta tamanegi00_status,x
	lda #0
	sta tamanegi00_update_step,x

	not_burst:

	rts
.endproc	; Tamanegi_UpdateNormal

; �X�V����
.proc	Tamanegi_UpdateBurst
	lda tamanegi00_update_step,x
	cmp #0
	beq step_init
	cmp #1
	beq step_burst1
	cmp #2
	beq step_burst2
	cmp #3
	beq step_burst3
	cmp #4
	beq step_next

step_init:

	lda #1
	sta tamanegi00_update_step,x

	lda #15
	sta tamanegi00_wait,x

	; �΂̓o��
	jsr TamanegiFire_Appear

	jmp case_break

step_burst1:

	sec
	dec tamanegi00_wait,x
	bne case_break
	; 0�ɂȂ�����
	lda #15
	sta tamanegi00_wait,x
	lda #2
	sta tamanegi00_update_step,x

	jmp case_break

step_burst2:

	sec
	dec tamanegi00_wait,x
	bne case_break
	; 0�ɂȂ�����
	lda #10
	sta tamanegi00_wait,x
	lda #3
	sta tamanegi00_update_step,x

	jmp case_break

step_burst3:

	sec
	dec tamanegi00_wait,x
	bne case_break
	; 0�ɂȂ�����
	lda #4
	sta tamanegi00_update_step,x

	jmp case_break

step_next:
	; ���폜
	jsr TamanegiFire_Clear
	; �^�}�l�M�폜
	jsr Tamanegi_Clear

	jmp case_break

case_break:


	rts
.endproc	; Tamanegi_UpdateBurst

; �`��
.proc	TamanegiDrawDma7
	; ����������̂����Ȃ�
;	lda tamanegi_alive_flag
;	bne not_skip_tamanegi
;	jmp skip_tamanegi
;not_skip_tamanegi:

	ldx #0
	ldy #0
	
	lda #1
	sta tamanegi_alive_flag_current	; �t���O�Q�ƌ��݈ʒu

loop_x:
	txa		; x��a�ɃR�s�[
	; a��16�{
	asl		; ���V�t�g
	asl
	asl
	asl
	tay		; a��y�ɃR�s�[

	; ���
	lda tamanegi00_status,x
	cmp #0
	beq case_in_the_cannon
	cmp #1
	beq case_parabola
	cmp #2
	beq case_normal
	cmp #3
	jmp case_burst

; ��C�̒�
case_in_the_cannon:
; ������
case_parabola:
	; �ȂȂ߃^�C��
	lda #$AB
	sta tamanegi1_t,y
	lda #$AC
	sta tamanegi2_t,y
	lda #$BB
	sta tamanegi3_t,y
	lda #$BC
	sta tamanegi4_t,y
	
	; ���]�Ȃ�
	lda #%00000001
	sta tamanegi2_s,y
	sta tamanegi4_s,y

	jmp break;

; �ʏ�
case_normal:

	; �A�j���p�^�[��
	;REG0 = (p_pat == 0) ? #$0 : #1;
	;REG1 = (p_pat == 0) ? #$1 : #0;

	lda #0
	eor p_pat
	sta REG0
	eor #1
	sta REG1

	; �����^�C��
	clc
	lda #$AD     ; 
	adc REG0
	sta tamanegi1_t,y
	clc
	lda #$AD
	adc REG1
	sta tamanegi2_t,y
	clc
	lda #$BD
	adc REG0
	sta tamanegi3_t,y
	clc
	lda #$BD
	adc REG1
	sta tamanegi4_t,y
	
	; ���]����
	lda #%01000001
	sta tamanegi2_s,y
	sta tamanegi4_s,y

	jmp break;

; ����
case_burst:

	lda tamanegi00_update_step,x
	cmp #0
	beq skip_hide
	cmp #1
	beq skip_hide
	; �{�͔̂�\��
	lda #$00
	sta tamanegi1_t,y
	lda #$00
	sta tamanegi2_t,y
	lda #$00
	sta tamanegi3_t,y
	lda #$00
	sta tamanegi4_t,y

	skip_hide:
	
	jmp break

break:	

; �\���m�F����

; Y���W�͍X�V�K�{
	clc			; �L�����[�t���OOFF
	lda tamanegi0_pos_y,x
	adc #7
	sta tamanegi1_y,y
	sta tamanegi2_y,y

	clc			; �L�����[�t���OOFF
	lda tamanegi0_pos_y,x
	adc #15
	sta tamanegi3_y,y
	sta tamanegi4_y,y

; Y���W�ȊO�͔�\�����X�L�b�v
	; �������Ă��邩
	lda tamanegi_alive_flag
	and tamanegi_alive_flag_current
	beq next_draw		; ���݂��Ă��Ȃ�

	; ���݂��Ă���΁A���[���h���W����E�B���h�E���W�ɕϊ�
	sec
	lda tamanegi0_world_pos_x_low,x
	sbc field_scroll_x_low
	sta tamanegi0_window_pos_x,x

	lda tamanegi0_window_pos_x,x
	sta tamanegi1_x,y
	sta tamanegi3_x,y

	lda tamanegi0_window_pos_x,x
	clc			; �L�����[�t���OOFF
	adc #8
	bcc not_overflow_8	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #231	; ��ʊO
	sta tamanegi2_y,y
	sta tamanegi4_y,y
not_overflow_8:
	sta tamanegi2_x,y
	sta tamanegi4_x,y

next_draw:

	; ��
	asl tamanegi_alive_flag_current
	inx
	cpx tamanegi_max_count	; ���[�v�ő吔
	beq skip_loop_x				; ���[�v
	jmp loop_x
	skip_loop_x:


skip_tamanegi:

	rts

.endproc	; TamanegiDrawDma7

; �`��
.proc	TamanegiDrawDma6
	; ����������̂����Ȃ�
;	lda tamanegi_alive_flag
;	bne not_skip_tamanegi
;	jmp skip_tamanegi
;not_skip_tamanegi:

	ldx #0
	ldy #0
	
	lda #1
	sta tamanegi_alive_flag_current	; �t���O�Q�ƌ��݈ʒu

loop_x:
	txa		; x��a�ɃR�s�[
	; a��16�{
	asl		; ���V�t�g
	asl
	asl
	asl
	tay		; a��y�ɃR�s�[

	; ���
	lda tamanegi00_status,x
	cmp #0
	beq case_in_the_cannon
	cmp #1
	beq case_parabola
	cmp #2
	beq case_normal
	cmp #3
	jmp case_burst

; ��C�̒�
case_in_the_cannon:
; ������
case_parabola:
	; �ȂȂ߃^�C��
	lda #$AB
	sta tamanegi1_t2,y
	lda #$AC
	sta tamanegi2_t2,y
	lda #$BB
	sta tamanegi3_t2,y
	lda #$BC
	sta tamanegi4_t2,y
	
	; ���]�Ȃ�
	lda #%00000001
	sta tamanegi2_s2,y
	sta tamanegi4_s2,y
	
	jmp break;

; �ʏ�
case_normal:
	; �A�j���p�^�[��
	;REG0 = (p_pat == 0) ? #$0 : #1;
	;REG1 = (p_pat == 0) ? #$1 : #0;

	lda #0
	eor p_pat
	sta REG0
	eor #1
	sta REG1

	; �����^�C��
	clc
	lda #$AD     ; 
	adc REG0
	sta tamanegi1_t2,y
	clc
	lda #$AD
	adc REG1
	sta tamanegi2_t2,y
	clc
	lda #$BD
	adc REG0
	sta tamanegi3_t2,y
	clc
	lda #$BD
	adc REG1
	sta tamanegi4_t2,y
	
	; ���]����
	lda #%01000001
	sta tamanegi2_s2,y
	sta tamanegi4_s2,y

	jmp break;

; ����
case_burst:

	lda tamanegi00_update_step,x
	cmp #0
	beq skip_hide
	cmp #1
	beq skip_hide
	; �{�͔̂�\��
	lda #$00
	sta tamanegi1_t2,y
	lda #$00
	sta tamanegi2_t2,y
	lda #$00
	sta tamanegi3_t2,y
	lda #$00
	sta tamanegi4_t2,y

	skip_hide:
	
	jmp break

break:

	

; �\���m�F����

; Y���W�͍X�V�K�{
	clc			; �L�����[�t���OOFF
	lda tamanegi0_pos_y,x
	adc #7
	sta tamanegi1_y2,y
	sta tamanegi2_y2,y

	clc			; �L�����[�t���OOFF
	lda tamanegi0_pos_y,x
	adc #15
	sta tamanegi3_y2,y
	sta tamanegi4_y2,y

; Y���W�ȊO�͔�\�����X�L�b�v
	; �������Ă��邩
	lda tamanegi_alive_flag
	and tamanegi_alive_flag_current
	beq next_draw		; ���݂��Ă��Ȃ�

	; ���݂��Ă���΁A���[���h���W����E�B���h�E���W�ɕϊ�
	sec
	lda tamanegi0_world_pos_x_low,x
	sbc field_scroll_x_low
	sta tamanegi0_window_pos_x,x

	lda tamanegi0_window_pos_x,x
	sta tamanegi1_x2,y
	sta tamanegi3_x2,y

	lda tamanegi0_window_pos_x,x
	clc			; �L�����[�t���OOFF
	adc #8
	bcc not_overflow_8	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #231	; ��ʊO
	sta tamanegi2_y2,y
	sta tamanegi4_y2,y
not_overflow_8:
	sta tamanegi2_x2,y
	sta tamanegi4_x2,y

next_draw:

	; ��
	asl tamanegi_alive_flag_current
	inx
	cpx tamanegi_max_count	; ���[�v�ő吔
	beq skip_loop_x				; ���[�v
	jmp loop_x
	skip_loop_x:

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
