; �����Z�֐��i65535�܂Łj
.proc	Multi
	;multiplicand	�������鐔
	;multiplier		�����鐔
	;multi_ans_up	���ʏ��
	;multi_ans_low	���ʉ���

	lda #0
	sta	multi_ans_up
	sta	multi_ans_low

	lda	multiplier		; Y�ɂ����鐔�i���[�v�񐔁j
	sta multi_loop_cnt
loop_y:

	clc				; �L�����[�t���OOFF
	lda multi_ans_low
	adc multiplicand
	sta multi_ans_low
	bcc no_countup

	lda #0
	adc multi_ans_up
	sta multi_ans_up

no_countup:

	dec multi_loop_cnt
	bne	loop_y		; �[���t���O�������Ă��Ȃ�

	rts
.endproc

; X���W�AY���W����
; �\���ʒu�̏�ʃr�b�g���ʃr�b�g���v�Z
.proc ConvertCoordToBit
	;conv_coord_bit_x		X���W
	;conv_coord_bit_y		Y���W
	;conv_coord_bit_up		��ʃr�b�g
	;conv_coord_bit_low		���ʃr�b�g

	; y * 32
	lda #0
	sta multi_ans_up
	sta multi_ans_low
	lda conv_coord_bit_y
	sta multi_ans_low

	; 32�{
	clc
	asl multi_ans_low		; ���ʂ͍��V�t�g
	rol multi_ans_up		; ��ʂ͍����[�e�[�g

	asl multi_ans_low
	rol multi_ans_up

	asl multi_ans_low
	rol multi_ans_up

	asl multi_ans_low
	rol multi_ans_up

	asl multi_ans_low
	rol multi_ans_up

	; + x
;	lda multi_ans_low
;	adc conv_coord_bit_x
;	sta multi_ans_low
	
	; ��ʂP����ʂQ��
	lda #$20
	sta draw_bg_display

;jmp noset24
	clc
;	lda conv_coord_bit_x
	asl				; ���V�t�g
	lsr				; �E�V�t�g
;	asl				; ���V�t�g
;	lsr				; �E�V�t�g
	lsr
;	bcs set24
	asl	; ���V�t�g
;	bcs set24
	asl	; ���V�t�g
;	bcs set24
	jmp noset24
	
set24:
;	lda #$24
;	sta draw_bg_display
;	sec
;	lda conv_coord_bit_x;
;	sbc #32;
;	sta conv_coord_bit_x
noset24:

	; + x
	lda multi_ans_low
	adc conv_coord_bit_x
	sta multi_ans_low

	; ���ʁ{����
	clc
	lda multi_ans_low
	adc #$20
	sta conv_coord_bit_low
	; ��ʁ{���
	lda multi_ans_up
	adc draw_bg_display;#$20
	sta conv_coord_bit_up

	rts
.endproc
