.proc	CannonMask_Init
	jsr CannonMask_Clear
	
	rts
.endproc

; �}�X�N��C�N���A
.proc CannonMask_Clear
	lda #0
	sta cannonLeft1_y
	sta cannonLeft1_t
	sta cannonLeft1_s
	sta cannonLeft1_x
	sta cannonLeft2_y
	sta cannonLeft2_t
	sta cannonLeft2_s
	sta cannonLeft2_x
	sta cannonLeft1_y2
	sta cannonLeft1_t2
	sta cannonLeft1_s2
	sta cannonLeft1_x2
	sta cannonLeft2_y2
	sta cannonLeft2_t2
	sta cannonLeft2_s2
	sta cannonLeft2_x2

	lda #0
	sta cannon_world_x_low
	sta cannon_world_x_hi
	sta cannon_y
	
	lda #0
	sta cannon_alive_flag

	rts
.endproc ; CannonMask_Clear

; �o��
.proc CannonMask_Appear
	lda #1
	sta cannon_alive_flag
	
	; �^�C���ԍ�
	lda #$8F
	sta cannonLeft1_t
	sta cannonLeft1_t2
	lda #$9F
	sta cannonLeft2_t
	sta cannonLeft2_t2
	; ����
	lda #%00000011
	sta cannonLeft1_s
	sta cannonLeft2_s
	sta cannonLeft1_s2
	sta cannonLeft2_s2

	; ��C�̈ʒu��ێ�����
	lda enemy_pos_x_hi
	sta cannon_world_x_hi
	lda enemy_pos_x_low
	sta cannon_world_x_low
	lda enemy_pos_y
	sta cannon_y

	clc
	lda cannon_world_x_low
	adc #9
	sta cannon_world_x_low
	lda cannon_world_x_hi
	adc #0
	sta cannon_world_x_hi

	rts
.endproc	; CannonMask_Appear

; �X�V
.proc	CannonMask_Update
	lda is_dead
	bne skip_mask

	lda cannon_alive_flag
	beq skip_mask

skip_mask:
	rts
.endproc	; CannonMask_Update


; �`��
.proc	CannonMask_DrawDma7

	lda cannon_alive_flag
	bne not_skip_draw
	jmp skip_draw
not_skip_draw:

	; ���݂��Ă���΁A���[���h���W����E�B���h�E���W�ɕϊ�
	sec
	lda cannon_world_x_low
	sbc field_scroll_x_low
	sta cannonLeft1_x
	sta cannonLeft2_x
	clc
	lda cannon_y
	adc #7
	sta cannonLeft1_y
	adc #8
	sta cannonLeft2_y

	sec
	lda cannonLeft1_x
	sbc #16
	bcs not_skip	; �L�����[�t���O�������Ă���
	lda #231	; ��ʊO
	sta cannonLeft1_y
	sta cannonLeft2_y

	not_skip:

skip_draw:

;End:
	rts

.endproc	; CannonMask_DrawDma7

; �`��
.proc	CannonMask_DrawDma6

	lda cannon_alive_flag
	bne not_skip_draw
	jmp skip_draw
not_skip_draw:

	; ���݂��Ă���΁A���[���h���W����E�B���h�E���W�ɕϊ�
	sec
	lda cannon_world_x_low
	sbc field_scroll_x_low
	sta cannonLeft1_x2
	sta cannonLeft2_x2
	clc
	lda cannon_y
	adc #7
	sta cannonLeft1_y2
	adc #8
	sta cannonLeft2_y2

	sec
	lda cannonLeft1_x2
	sbc #16
	bcs not_skip	; �L�����[�t���O�������Ă���
	lda #231	; ��ʊO
	sta cannonLeft1_y2
	sta cannonLeft2_y2
	not_skip:

skip_draw:

	rts

.endproc	; CannonMask_DrawDma6
