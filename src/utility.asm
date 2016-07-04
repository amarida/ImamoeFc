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

.proc UpdateInputKey

	; ������
	lda #$01
	sta $4016
	lda #$00
	sta $4016

	; �O��̏�Ԃ��i�[
	lda key_state_on
	sta key_state_on_old

	lda #0
	sta key_state_on

	; A,B,SELECT,START,UP,DOWN,LEFT,RIGHT�̏���
	lda $4016	; A
	and #1
	beq SkipPushA
	lda key_state_on
	ora #%00000001
	sta key_state_on
	SkipPushA:
	
	lda $4016	; B
	and #1
	beq SkipPushB
	lda key_state_on
	ora #%00000010
	sta key_state_on
	SkipPushB:

	lda $4016	; SELECT
	and #1
	beq SkipPushSelect
	lda key_state_on
	ora #%00000100
	sta key_state_on
	SkipPushSelect:
	
	lda $4016	; START
	and #1
	beq SkipPushStart
	lda key_state_on
	ora #%00001000
	sta key_state_on
	SkipPushStart:
	
	lda $4016	; ��
	and #1
	beq SkipPushUp
	lda key_state_on
	ora #%00010000
	sta key_state_on
	SkipPushUp:
	
	lda $4016	; ��
	and #1
	beq SkipPushDown
	lda key_state_on
	ora #%00100000
	sta key_state_on
	SkipPushDown:
	
	lda $4016	; ��
	and #1
	beq SkipPushLeft
	lda key_state_on
	ora #%01000000
	sta key_state_on
	SkipPushLeft:
	
	lda $4016	; �E
	and #1
	beq SkipPushRight
	lda key_state_on
	ora #%10000000
	sta key_state_on
	SkipPushRight:
	

	lda key_state_on
	eor key_state_on_old
	and key_state_on
	sta key_state_push

	rts
.endproc	; UpdateInputKey