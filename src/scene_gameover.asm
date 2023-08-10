.proc scene_gameover

; �`��
	jsr DrawGameOver

; �X�V
	lda scene_update_step
	cmp #0
	beq case_init
	cmp #1
	beq case_fill_wait
	cmp #2
	beq case_update

; ����������
case_init:

	; �����F�ɍ����ւ�
	; �p���b�g�e�[�u���֓]��(MAP�p�̂ݓ]��)
	lda	#$3f
	sta	$2006
	lda	#$10
	sta	$2006
	lda	#$0f
	sta $2007

	; �J�����g��ʂ�1�ɂ���
	lda #1
	sta current_draw_display_no

	; �X�v���C�g��BG������
	lda	#%00000110
	sta	$2001

	; �����e�[�u���ύX
	jsr ChangeAttributeGameOver

	; �l�[���e�[�u�����œh��Ԃ�
	jsr FillBlackNametable

	; �҂�1�t���[��
	lda #1
	sta wait_frame

	; ���̃X�e�b�v
	inc scene_update_step
	jmp break;
; �h��Ԃ��҂�
case_fill_wait:
	dec wait_frame
	bne break
	inc scene_update_step
	; BG��\��
	lda	#%00001110
	sta	$2001

	jmp break
; �X�V����
case_update:
	; ����1
	lda #30
	sta wait_frame
;	inc scene_update_step
;	jmp break;

break:

	; �X�N���[���ʒu�X�V
	lda #0
	sta	$2005		; X�����X�N���[��
	lda	#0		; Y�͌Œ�
	sta	$2005

	rts
.endproc

; �Q�[���I�[�o�[�p�����e�[�u���ɕύX
.proc ChangeAttributeGameOver
	lda #< map_chip_attribute_game_over
	sta map_table_attribute_low
	lda #> map_chip_attribute_game_over
	sta map_table_attribute_hi

	lda #0
	sta bg_already_draw_attribute_pos

;	lda #$23
;	sta attribute_pos_adress_hi
;	lda #$c0
;	sta attribute_pos_adress_low

	ldx #7	; 8��
loop_attribute_first_x:
; �`��
	lda #0
	sta draw_bg_y
	lda bg_already_draw_attribute_pos
	sta draw_bg_x

	; 1�x�������W����A�h���X�����߂�
	; draw_bg_x(in)
	; draw_bg_y(in)
	; attribute_pos_adress_hi(out)
	; attribute_pos_adress_low(out)
	jsr CalcAttributeAdressFromCoord

	ldy #7
	jmp draw_loop
draw_loop:
	lda attribute_pos_adress_hi
	sta $2006
	lda attribute_pos_adress_low
	sta $2006
	lda (map_table_attribute_low), y
	sta $2007

	lda attribute_pos_adress_low
	clc
	adc #$8
	sta attribute_pos_adress_low

	dey
	bpl	draw_loop

	; �`�悵���� bg_already_draw_attribute ��inc����
	inc bg_already_draw_attribute
	inc bg_already_draw_attribute_pos
	sec
	lda bg_already_draw_attribute_pos
	sbc #8
	bcc skip_reset;
	lda #0
	sta bg_already_draw_attribute_pos
skip_reset:
	; �}�b�v�`�b�v�̋N�_��8���炷
	clc
	lda map_table_attribute_low
	adc #8
	sta map_table_attribute_low
	lda map_table_attribute_hi
	adc #0
	sta map_table_attribute_hi


	dex
	bpl loop_attribute_first_x


	lda #0
	sta bg_already_draw_attribute_pos
	sta bg_already_draw_attribute

	rts
.endproc

; �l�[���e�[�u�����œh��Ԃ�
.proc FillBlackNametable

	;lda #< map_chip_game_over
	;sta map_table_screen_low
	;lda #> map_chip_game_over
	;sta map_table_screen_hi

	lda #0
	sta bg_already_draw_pos
; �w�i�l�[���e�[�u�� ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	ldx #31	; 32��
loop_first_x:
; �������
	lda #3	; (0, 3)�J�n���W
	sta draw_bg_y	; Y���W
	lda bg_already_draw_pos
	sta draw_bg_x	; X���W�i�u���b�N�j
	jsr SetPosition

	ldy #24	; 25��

draw_loop:
	;lda (map_table_screen_low), y
	lda #$00
	sta $2007

	dey
	bpl	draw_loop	; �l�K�e�B�u�t���O���N���A����Ă��鎞�Ƀu�����`

	; �`�悵���� bg_already_draw ��inc����
	inc bg_already_draw
	inc bg_already_draw_pos

	; �}�b�v�`�b�v�̋N�_��25���炷
	clc
	lda map_table_screen_low
	adc #25
	sta map_table_screen_low
	lda map_table_screen_hi
	adc #0
	sta map_table_screen_hi

	dex
	bpl loop_first_x


	lda #0
	sta bg_already_draw_pos
	sta bg_already_draw

	; �X�e�[�^�X����
	lda #%10001000
	sta $2000
	lda #0
	sta draw_bg_x
	lda #2
	sta draw_bg_y
	jsr SetPosition
	lda #00
	ldx #0
	loop_x:
	sta $2007
	inx
	cpx #32
	bne loop_x
	
	rts
.endproc

.proc DrawGameOver
	ldx #0
	lda #10
	sta REG0
	;current_draw_display_no ; �X�N���[����ʂ��P���Q��
	;scroll_x				; �X�N���[���ʒu
	; �X�N���[���ʒu����(8�s�N�Z��x10�u���b�N)
	; 80�s�N�Z��������
	; �L�����[�t���O����������ׂ̉��
	clc
	lda scroll_x
	adc #80
	bcs display2
	bcc display1
	
	; �L�����[�t���O�������Ȃ�����
	; 152(80+72)�s�N�Z�������ăL�����[�t���O��
	; �����Ȃ���΁A���̉�ʂ̂�
;	clc
;	lda scroll_x
;	adc #152
;	bcc display1

	; �L�����[�t���O�������Ȃ�����
	; 152(80+72)�s�N�Z�������ăL�����[�t���O��
	; ���ꍇ�A2��ʂɕ������
	; ��������ʒu
	; 255-scroll_x��8�Ŋ������l��
	; ���̉�ʂŕ\�����镶����
;	sec
;	lda #255
;	sbc scroll_x
;	sta REG1
;	clc
;	lsr REG1	; �E���[�e�[�g
;	lsr REG1	; �E���[�e�[�g
;	lsr REG1	; �E���[�e�[�g
;	
;	jmp display1and2

display1:
	; �X�N���[���ʒu���W��10������
	lda scroll_x
	sta REG1
	lsr REG1	; �E�V�t�g
	lsr REG1	; �E�V�t�g
	lsr REG1	; �E�V�t�g
	clc
	lda #10
	adc REG1
	sta REG0
	

jmp skip_ready
display2:
	; �Ȃɂ�����10����

jmp skip_ready
display1and2:

skip_ready:

	lda current_draw_display_no
	sta REG2
	lda #1
	sta current_draw_display_no

	lda #12
	sta REG0

loop_x:
	lda #12
	sta draw_bg_y	; Y���W�i�u���b�N�j
	lda REG0	; X���W�i�u���b�N�j
	sta draw_bg_x	; X���W�i�u���b�N�j
	jsr SetPosition

	lda string_game_over, x
	sta $2007

	inc REG0
	
	inx
	cpx #9
	bne loop_x

	; ��ʂP���Q�̐ݒ��߂�
	lda REG2
	sta current_draw_display_no

	rts
.endproc

