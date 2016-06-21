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

	lda #< map_chip_game_over
	sta map_table_screen_low
	lda #> map_chip_game_over
	sta map_table_screen_hi

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
	lda (map_table_screen_low), y
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

	rts
.endproc
