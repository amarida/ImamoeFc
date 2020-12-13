.proc	TakoHabaInit
	lda #0
	sta tako0_world_pos_x_low
	sta tako1_world_pos_x_low
	sta tako0_world_pos_x_hi
	sta tako1_world_pos_x_hi
	sta tako00_status
	sta tako01_status
	lda #224	; ��ʊO;#184
	sta tako0_pos_y
	sta tako1_pos_y

	rts
.endproc

; �o��
.proc appear_tako_haba
	; �󂢂Ă���^�R��T��

	lda #1
	sta tako_alive_flag_current	; �t���O�Q�ƌ��݈ʒu
	ldx #0
loop_x:
	; �󂢂Ă��邩
	lda tako_haba_alive_flag
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
	; �^�R������ʏ�ɕς���
	lda #%00000001	; �p���b�g2���g�p
	sta REG0
	jsr TakoHaba_SetAttribute

	; �t���O�𗧂Ă�
	clc
	lda tako_haba_alive_flag
	adc tako_alive_flag_current
	sta tako_haba_alive_flag

	; �p���b�g2���^�R
	lda #5
	sta palette_change_state

skip_tako:
	; �X�L�b�v
	rts
.endproc	; appear_tako_haba

; �^�R�͂΃N���A
.proc TakoHaba_Clear

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
	lda tako_haba_alive_flag
	and REG0
	bne not_skip_clear		; ���݂��Ă���
	jmp skip_clear
	not_skip_clear:

	lda #0
	sta char4_p1_index1_y,y
	sta char4_p1_index1_t,y
	sta char4_p1_index1_s,y
	sta char4_p1_index1_x,y
	sta char4_p1_index2_y,y
	sta char4_p1_index2_t,y
	sta char4_p1_index2_s,y
	sta char4_p1_index2_x,y
	sta char4_p1_index3_y,y
	sta char4_p1_index3_t,y
	sta char4_p1_index3_s,y
	sta char4_p1_index3_x,y
	sta char4_p1_index4_y,y
	sta char4_p1_index4_t,y
	sta char4_p1_index4_s,y
	sta char4_p1_index4_x,y
	sta char4_p1_index1_y2,y
	sta char4_p1_index1_t2,y
	sta char4_p1_index1_s2,y
	sta char4_p1_index1_x2,y
	sta char4_p1_index2_y2,y
	sta char4_p1_index2_t2,y
	sta char4_p1_index2_s2,y
	sta char4_p1_index2_x2,y
	sta char4_p1_index3_y2,y
	sta char4_p1_index3_t2,y
	sta char4_p1_index3_s2,y
	sta char4_p1_index3_x2,y
	sta char4_p1_index4_y2,y
	sta char4_p1_index4_t2,y
	sta char4_p1_index4_s2,y
	sta char4_p1_index4_x2,y

	lda #0
	sta tako0_world_pos_x_low,x
	sta tako0_world_pos_x_hi,x
	sta tako0_pos_y,x
	
	; �����t���O�𗎂Ƃ�
	lda tako_haba_alive_flag
	eor REG0
	sta tako_haba_alive_flag

skip_clear:

	rts
.endproc ; TakoHaba_Clear


; �X�V
.proc	TakoHaba_Update
	lda is_dead
	bne skip_tako

	; ����������̂����Ȃ�
	lda tako_haba_alive_flag
	beq skip_tako

	lda #1
	sta tako_alive_flag_current	; �t���O�Q�ƌ��݈ʒu
	ldx #0
loop_x:
	; �������Ă��邩
	lda tako_haba_alive_flag
	and tako_alive_flag_current
	beq next_update		; ���݂��Ă��Ȃ�
	; ���݂��Ă���

	jsr TakoHaba_UpdateNormal

	; ��ʊO����
	sec
	lda field_scroll_x_hi
	sbc tako0_world_pos_x_hi,x
	bcc skip_dead
	sec
	lda field_scroll_x_low
	sbc tako0_world_pos_x_low,x
	bcc skip_dead
	; ��ʊO����
	jsr TakoHaba_Clear

skip_dead:

next_update:
	; ��
	asl tako_alive_flag_current
	inx
	cpx tako_max_count	; ���[�v�ő吔
	bne loop_x				; ���[�v

skip_tako:
	rts
.endproc	; TakoHaba_Update

; �ʏ�X�V
.proc	TakoHaba_UpdateNormal
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
	lda tako0_world_pos_x_decimal,x
	sbc #$80
	sta tako0_world_pos_x_decimal,x
	lda tako0_world_pos_x_low,x
	sbc #1
	sta tako0_world_pos_x_low,x
	lda tako0_world_pos_x_hi,x
	sbc #0
	sta tako0_world_pos_x_hi,x

	rts
.endproc	; TakoHaba_UpdateNormal

; �`��
.proc	TakoHaba_DrawDma7

	; ����������̂����Ȃ�
	lda tako_haba_alive_flag
	bne not_skip_alltako
	jmp skip_alltako
not_skip_alltako:

	ldx #0
	
	lda #1
	sta tako_alive_flag_current	; �t���O�Q�ƌ��݈ʒu
	
loop_x:
	; �������Ă��邩
	lda tako_haba_alive_flag
	and tako_alive_flag_current
	bne not_skip_draw		; ���݂��Ă�
	jmp skip_draw
	not_skip_draw:

	ldy #0
	txa		; x��a�ɃR�s�[
	beq skip_set16
	ldy #16	; x��0�Ȃ�y��0�Ax��1�Ȃ�y��16
	skip_set16:

	; �A�j���p�^�[��
	;REG0 = (p_pat == 0) ? #$00 : #$02;

	lda p_pat
	beq set_pat0
	bne set_pat1
	
set_pat0:
	lda #$00
	sta REG0
	sta REG1
	sta REG2
	jmp break_pat
set_pat1:
	lda #$04
	sta REG0
	lda #$00
	sta REG1
	lda #$02
	sta REG2
	jmp break_pat
	
break_pat:

	lda tako00_status,x
	cmp #0
	beq case_normal
	cmp #1
	beq case_fire

case_normal:
; �����^�C��
	sec
	lda #$68     ; 
	sbc REG1
	sta char4_p1_index1_t,y
	sec
	lda #$69
	sbc REG1
	sta char4_p1_index2_t,y
	sec
	lda #$78
	sbc REG0
	sta char4_p1_index3_t,y
	sec
	lda #$79
	sbc REG0
	sta char4_p1_index4_t,y

	jmp case_break

case_fire:
; �R���^�C��
	clc
	lda #$70     ; 
	adc REG2
	sta char4_p1_index1_t,y
	clc
	lda #$71
	adc REG2
	sta char4_p1_index2_t,y
	sec
	lda #$78
	sbc REG0
	sta char4_p1_index3_t,y
	sec
	lda #$79
	sbc REG0
	sta char4_p1_index4_t,y

	; �^�R������R���ɕς���
	lda #%00000010	; �p���b�g3���g�p
	sta REG0
	jsr TakoHaba_SetAttribute

	jmp case_break

case_break:

; Y���W
	clc			; �L�����[�t���OOFF
	lda tako0_pos_y,x
	adc #7
	sta char4_p1_index1_y,y
	sta char4_p1_index2_y,y

	clc			; �L�����[�t���OOFF
	lda tako0_pos_y,x
	adc #15
	sta char4_p1_index3_y,y
	sta char4_p1_index4_y,y

; X���W

	; ���݂��Ă���΁A���[���h���W����E�B���h�E���W�ɕϊ�
	sec
	lda tako0_world_pos_x_low,x
	sbc field_scroll_x_low
	sta tako0_window_pos_x,x

	lda tako0_window_pos_x,x
	sta char4_p1_index1_x,y
	sta char4_p1_index3_x,y

	lda tako0_window_pos_x,x
	clc			; �L�����[�t���OOFF
	adc #8
	bcc not_overflow_8	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #231	; ��ʊO
	sta char4_p1_index2_y,y
	sta char4_p1_index4_y,y
not_overflow_8:
	sta char4_p1_index2_x,y
	sta char4_p1_index4_x,y

skip_draw:

	; ��
	asl tako_alive_flag_current
	inx
	cpx tako_max_count	; ���[�v�ő吔
	beq skip_loop_x				; ���[�v
	jmp loop_x
	skip_loop_x:

skip_alltako:

	rts

.endproc	; TakoHaba_DrawDma7

; �`��
.proc	TakoHaba_DrawDma6
	; ����������̂����Ȃ�
	lda tako_haba_alive_flag
	bne not_skip_alltako
	jmp skip_alltako
not_skip_alltako:

	ldx #0
	
	lda #1
	sta tako_alive_flag_current	; �t���O�Q�ƌ��݈ʒu
	
loop_x:
	; �������Ă��邩
	lda tako_haba_alive_flag
	and tako_alive_flag_current
	bne not_skip_draw		; ���݂��Ă�
	jmp skip_draw
	not_skip_draw:

	ldy #0
	txa		; x��a�ɃR�s�[
	beq skip_set16
	ldy #16	; x��0�Ȃ�y��0�Ax��1�Ȃ�y��16
	skip_set16:

	; �A�j���p�^�[��
	;REG0 = (p_pat == 0) ? #$00 : #$02;

	lda p_pat
	beq set_pat0
	bne set_pat1
	
set_pat0:
	lda #$00
	sta REG0
	sta REG1
	sta REG2
	jmp break_pat
set_pat1:
	lda #$04
	sta REG0
	lda #$00
	sta REG1
	lda #$02
	sta REG2
	jmp break_pat
	
break_pat:

	lda tako00_status,x
	cmp #0
	beq case_normal
	cmp #1
	beq case_fire

case_normal:
; �����^�C��
	sec
	lda #$68     ; 
	sbc REG1
	sta char4_p1_index1_t2,y
	sec
	lda #$69
	sbc REG1
	sta char4_p1_index2_t2,y
	sec
	lda #$78
	sbc REG0
	sta char4_p1_index3_t2,y
	sec
	lda #$79
	sbc REG0
	sta char4_p1_index4_t2,y
	
	jmp case_break

case_fire:
; �R���^�C��
	clc
	lda #$70     ; 
	adc REG2
	sta char4_p1_index1_t2,y
	clc
	lda #$71
	adc REG2
	sta char4_p1_index2_t2,y
	sec
	lda #$78
	sbc REG0
	sta char4_p1_index3_t2,y
	sec
	lda #$79
	sbc REG0
	sta char4_p1_index4_t2,y

	; �^�R������R���ɕς���
	lda #%00000010	; �p���b�g3���g�p
	sta REG0
	jsr TakoHaba_SetAttribute

	jmp case_break

case_break:

; Y���W
	clc			; �L�����[�t���OOFF
	lda tako0_pos_y,x
	adc #7
	sta char4_p1_index1_y2,y
	sta char4_p1_index2_y2,y

	clc			; �L�����[�t���OOFF
	lda tako0_pos_y,x
	adc #15
	sta char4_p1_index3_y2,y
	sta char4_p1_index4_y2,y

; X���W

	; ���݂��Ă���΁A���[���h���W����E�B���h�E���W�ɕϊ�
	sec
	lda tako0_world_pos_x_low,x
	sbc field_scroll_x_low
	sta tako0_window_pos_x,x

	lda tako0_window_pos_x,x
	sta char4_p1_index1_x2,y
	sta char4_p1_index3_x2,y

	lda tako0_window_pos_x,x
	clc			; �L�����[�t���OOFF
	adc #8
	bcc not_overflow_8	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #231	; ��ʊO
	sta char4_p1_index2_y2,y
	sta char4_p1_index4_y2,y
not_overflow_8:
	sta char4_p1_index2_x2,y
	sta char4_p1_index4_x2,y

skip_draw:

	; ��
	asl tako_alive_flag_current
	inx
	cpx tako_max_count	; ���[�v�ő吔
	beq skip_loop_x				; ���[�v
	jmp loop_x
	skip_loop_x:

skip_alltako:

	rts

.endproc	; TakoHaba_DrawDma6

.proc TakoHaba_SetAttribute
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
	sta char4_p1_index1_s
	sta char4_p1_index2_s
	sta char4_p1_index3_s
	sta char4_p1_index4_s
	sta char4_p1_index1_s2
	sta char4_p1_index2_s2
	sta char4_p1_index3_s2
	sta char4_p1_index4_s2
	
	jmp break
tako2:
	lda REG0
	sta char4_p2_index1_s
	sta char4_p2_index2_s
	sta char4_p2_index3_s
	sta char4_p2_index4_s
	sta char4_p2_index1_s2
	sta char4_p2_index2_s2
	sta char4_p2_index3_s2
	sta char4_p2_index4_s2

break:
	rts
.endproc	; Tako_SetSplashAttribute
