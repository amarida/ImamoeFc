.proc	TamanegiFire_Init
	jsr TamanegiFire_AllClear
	
	rts
.endproc

; �^�}�l�M�t�@�C�A�[�S�N���A
.proc TamanegiFire_AllClear

	ldx #0
	jsr TamanegiFire_Clear
	ldx #1
	jsr TamanegiFire_Clear
	
	rts
.endproc	; TamanegiFire_AllClear

; �^�}�l�M�t�@�C�A�[�N���A
.proc TamanegiFire_Clear

	; x��0,1�łǂ�������������f����
	ldy #0
	lda #%00000001
	sta REG0
	txa
	beq not_set24
	ldy #24
	lda #%00000010
	sta REG0
	not_set24:
	
	; �����t���O�̊m�F
	lda fire_alive_flag
	and REG0
	bne not_skip_clear		; ���݂��Ă���
	jmp skip_clear
	not_skip_clear:

	lda #0
	sta char_6type1_y,y
	sta char_6type1_t,y
	sta char_6type1_s,y
	sta char_6type1_x,y
	sta char_6type2_y,y
	sta char_6type2_t,y
	sta char_6type2_s,y
	sta char_6type2_x,y
	sta char_6type3_y,y
	sta char_6type3_t,y
	sta char_6type3_s,y
	sta char_6type3_x,y
	sta char_6type4_y,y
	sta char_6type4_t,y
	sta char_6type4_s,y
	sta char_6type4_x,y
	sta char_6type5_y,y
	sta char_6type5_t,y
	sta char_6type5_s,y
	sta char_6type5_x,y
	sta char_6type6_y,y
	sta char_6type6_t,y
	sta char_6type6_s,y
	sta char_6type6_x,y
	sta char_6type1_y2,y
	sta char_6type1_t2,y
	sta char_6type1_s2,y
	sta char_6type1_x2,y
	sta char_6type2_y2,y
	sta char_6type2_t2,y
	sta char_6type2_s2,y
	sta char_6type2_x2,y
	sta char_6type3_y2,y
	sta char_6type3_t2,y
	sta char_6type3_s2,y
	sta char_6type3_x2,y
	sta char_6type4_y2,y
	sta char_6type4_t2,y
	sta char_6type4_s2,y
	sta char_6type4_x2,y
	sta char_6type5_y2,y
	sta char_6type5_t2,y
	sta char_6type5_s2,y
	sta char_6type5_x2,y
	sta char_6type6_y2,y
	sta char_6type6_t2,y
	sta char_6type6_s2,y
	sta char_6type6_x2,y

	lda #0
	sta fire0_world_x_low,x
	sta fire0_world_x_hi,x
	sta fire0_y,x
	
	; �����t���O�𗎂Ƃ�
	lda fire_alive_flag
	eor REG0
	sta fire_alive_flag

skip_clear:

	rts
.endproc ; TamanegiFire_Clear

;;;;; �o�� ;;;;;
.proc TamanegiFire_Appear

	lda #1
	sta fire_alive_flag_current	; �t���O�Q�ƌ��݈ʒu
	ldx #0
loop_x:
	; �󂢂Ă��邩
	lda fire_alive_flag
	and fire_alive_flag_current
	beq set_fire
	
	; ��
	asl fire_alive_flag_current
	inx
	cpx fire_max_count		; ���[�v�ő吔
	bne loop_x				; ���[�v

	; �����܂ŗ�����󂫂͂Ȃ��̂ŃX�L�b�v
	jmp skip_fire

set_fire:

	ldy #0
	txa
	beq skip_set24
	ldy #24
	skip_set24:
	
	; �^�C���ԍ�
	lda #$D4
	sta char_6type1_t,y
	sta char_6type1_t2,y
	lda #$D5
	sta char_6type2_t,y
	sta char_6type2_t2,y
	lda #$E4
	sta char_6type3_t,y
	sta char_6type3_t2,y
	lda #$E5
	sta char_6type4_t,y
	sta char_6type4_t2,y
	lda #$F4
	sta char_6type5_t,y
	sta char_6type5_t2,y
	lda #$F5
	sta char_6type6_t,y
	sta char_6type6_t2,y
	; ����
	lda #%00000010
	sta char_6type1_s,y
	sta char_6type2_s,y
	sta char_6type3_s,y
	sta char_6type4_s,y
	sta char_6type5_s,y
	sta char_6type6_s,y
	sta char_6type1_s2,y
	sta char_6type2_s2,y
	sta char_6type3_s2,y
	sta char_6type4_s2,y
	sta char_6type5_s2,y
	sta char_6type6_s2,y

	; �^�}�l�M���̈ʒu��ێ�����
	lda tamanegi0_world_pos_x_low,x
	sta fire0_world_x_low,x
	lda tamanegi0_world_pos_x_hi,x
	sta fire0_world_x_hi,x

	; 8�s�N�Z����
	sec
	lda tamanegi0_pos_y,x
	sbc #8
	sta fire0_y,x

	; �����t���O�𗧂Ă�
	clc
	lda fire_alive_flag
	adc fire_alive_flag_current
	sta fire_alive_flag

skip_fire:

	; �p���b�g3����
	lda #2
	sta palette_change_state

	rts
.endproc	; TamanegiFire_Appear

;;;;; �X�V ;;;;;
.proc	TamanegiFire_Update
	lda is_dead
	bne skip_update

	; ����������̂����Ȃ�
	lda fire_alive_flag
	beq skip_update

	lda #1
	sta fire_alive_flag_current	; �t���O�Q�ƌ��݈ʒu
	ldx #0
loop_x:
	; �������Ă��邩
	lda fire_alive_flag
	and fire_alive_flag_current
	beq next_update		; ���݂��Ă��Ȃ�
	; ���݂��Ă���
	
	; �Ή�����^�}�l�M�̏�ԁ@
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
	jmp case_break
step_burst1:
	jmp case_break
step_burst2:
	jmp case_break
step_burst3:
	jmp case_break
step_next:
	jmp case_break

case_break:

next_update:
	; ��
	asl fire_alive_flag_current
	inx
	cpx fire_max_count		; ���[�v�ő吔
	bne loop_x				; ���[�v

skip_update:
	rts
.endproc	; TamanegiFire_Update


; �`��
.proc	TamanegiFire_DrawDma7

	ldx #0
	
	lda #1
	sta fire_alive_flag_current	; �t���O�Q�ƌ��݈ʒu

loop_x:
	; �������Ă��邩
	lda fire_alive_flag
	and fire_alive_flag_current
	bne not_skip_draw		; ���݂��Ă�
	jmp skip_draw
	not_skip_draw:

	ldy #0
	txa		; x��a�ɃR�s�[
	beq skip_set24
	ldy #24	; x��0�Ȃ�y��0�Ax��1�Ȃ�y��24
	skip_set24:

	; ���݂��Ă���΁A���[���h���W����E�B���h�E���W�ɕϊ�
	sec
	lda fire0_world_x_low,x
	sbc field_scroll_x_low
	sta fire0_window_x,x

	lda fire0_window_x,x
	sta char_6type1_x,y
	sta char_6type3_x,y
	sta char_6type5_x,y

	lda fire0_window_x,x
	clc			; �L�����[�t���OOFF
	adc #8
	sta char_6type2_x,y
	sta char_6type4_x,y
	sta char_6type6_x,y
	
	clc
	lda fire0_y,x
	adc #7
	sta char_6type1_y,y
	sta char_6type2_y,y
	clc
	adc #8
	sta char_6type3_y,y
	sta char_6type4_y,y
	adc #8
	sta char_6type5_y,y
	sta char_6type6_y,y
	
	; �Ή�����^�}�l�M�̏�ԁ@
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
	jmp case_break

step_burst1:
	; �^�C���ԍ�
	lda #$D4
	sta char_6type1_t,y
	lda #$D5
	sta char_6type2_t,y
	lda #$E4
	sta char_6type3_t,y
	lda #$E5
	sta char_6type4_t,y
	lda #$F4
	sta char_6type5_t,y
	lda #$F5
	sta char_6type6_t,y
	jmp case_break
	
step_burst2:
	; �^�C���ԍ�
	lda #$D6
	sta char_6type1_t,y
	lda #$D7
	sta char_6type2_t,y
	lda #$E6
	sta char_6type3_t,y
	lda #$E7
	sta char_6type4_t,y
	lda #$F6
	sta char_6type5_t,y
	lda #$F7
	sta char_6type6_t,y
	jmp case_break

step_burst3:
	; �^�C���ԍ�
	lda #$D8
	sta char_6type1_t,y
	lda #$D9
	sta char_6type2_t,y
	lda #$E8
	sta char_6type3_t,y
	lda #$E9
	sta char_6type4_t,y
	lda #$F8
	sta char_6type5_t,y
	lda #$F9
	sta char_6type6_t,y
	jmp case_break

step_next:
	jmp case_break

case_break:

skip_draw:

	; ��
	asl fire_alive_flag_current
	inx
	cpx fire_max_count	; ���[�v�ő吔
	beq skip_loop_x				; ���[�v
	jmp loop_x
	skip_loop_x:

	rts

.endproc	; TamanegiFire_DrawDma7

; �`��
.proc	TamanegiFire_DrawDma6

	ldx #0
	
	lda #1
	sta fire_alive_flag_current	; �t���O�Q�ƌ��݈ʒu

loop_x:
	; �������Ă��邩
	lda fire_alive_flag
	and fire_alive_flag_current
	bne not_skip_draw		; ���݂��Ă�
	jmp skip_draw
	not_skip_draw:

	ldy #0
	txa		; x��a�ɃR�s�[
	beq skip_set24
	ldy #24	; x��0�Ȃ�y��0�Ax��1�Ȃ�y��24
	skip_set24:

	; ���݂��Ă���΁A���[���h���W����E�B���h�E���W�ɕϊ�
	sec
	lda fire0_world_x_low,x
	sbc field_scroll_x_low
	sta fire0_window_x,x

	lda fire0_window_x,x
	sta char_6type1_x2,y
	sta char_6type3_x2,y
	sta char_6type5_x2,y

	lda fire0_window_x,x
	clc			; �L�����[�t���OOFF
	adc #8
	sta char_6type2_x2,y
	sta char_6type4_x2,y
	sta char_6type6_x2,y
	
	clc
	lda fire0_y,x
	adc #7
	sta char_6type1_y2,y
	sta char_6type2_y2,y
	clc
	adc #8
	sta char_6type3_y2,y
	sta char_6type4_y2,y
	adc #8
	sta char_6type5_y2,y
	sta char_6type6_y2,y
		
	; �Ή�����^�}�l�M�̏�ԁ@
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
	jmp case_break

step_burst1:
	; �^�C���ԍ�
	lda #$D4
	sta char_6type1_t2,y
	lda #$D5
	sta char_6type2_t2,y
	lda #$E4
	sta char_6type3_t2,y
	lda #$E5
	sta char_6type4_t2,y
	lda #$F4
	sta char_6type5_t2,y
	lda #$F5
	sta char_6type6_t2,y
	jmp case_break
	
step_burst2:
	; �^�C���ԍ�
	lda #$D6
	sta char_6type1_t2,y
	lda #$D7
	sta char_6type2_t2,y
	lda #$E6
	sta char_6type3_t2,y
	lda #$E7
	sta char_6type4_t2,y
	lda #$F6
	sta char_6type5_t2,y
	lda #$F7
	sta char_6type6_t2,y
	jmp case_break

step_burst3:
	; �^�C���ԍ�
	lda #$D8
	sta char_6type1_t2,y
	lda #$D9
	sta char_6type2_t2,y
	lda #$E8
	sta char_6type3_t2,y
	lda #$E9
	sta char_6type4_t2,y
	lda #$F8
	sta char_6type5_t2,y
	lda #$F9
	sta char_6type6_t2,y
	jmp case_break

step_next:
	jmp case_break

case_break:

skip_draw:

	; ��
	asl fire_alive_flag_current
	inx
	cpx fire_max_count	; ���[�v�ő吔
	beq skip_loop_x				; ���[�v
	jmp loop_x
	skip_loop_x:

	rts

.endproc	; TamanegiFire_DrawDma6
