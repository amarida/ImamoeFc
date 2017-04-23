.proc scene_title

	lda scene_update_step
	cmp #0
	beq case_init
	cmp #1
	beq case_fill
	cmp #2
	beq case_fill_wait
	cmp #3
	beq case_enable
	cmp #4
	beq case_wait

; ������
case_init:
	jsr scene_title_init

	jmp case_break

; �`��
case_fill:

	; �����e�[�u���ύX
	jsr SetupAttributeTitle

	; �l�[���e�[�u�����^�C�g���ɂ���
	jsr FillTitleNametable

	lda #2
	sta wait_frame
	inc scene_update_step
	jmp case_break
	
; �`��҂�
case_fill_wait:
	dec wait_frame
	lda wait_frame
	bne skip_next
	; �L���ɂ���
	inc scene_update_step
	skip_next:
	jmp case_break

; �L���ɂ���
case_enable:
	; ���荞��ON�@�����l1byte
	lda #%10001000
	;     |||||||`- 
	;     ||||||`-- ���C���X�N���[���A�h���X 00
	;     |||||`--- VRAM�A�N�Z�X���̃A�h���X�����l�x�[�X 1byte
	;     ||||`---- �X�v���C�g�p�L�����N�^�e�[�u�� 1
	;     |||`----- BG�p�L�����N�^�e�[�u���x�[�X 0
	;     ||`------ �X�v���C�g�T�C�Y 8x8
	;     |`------- PPU�I�� �}�X�^�[
	;     `-------- VBlank����NMI�����𔭐� ON
	sta $2000

	; �X�v���C�g��BG��\��
	lda	#%00011110
	sta	$2001

	inc scene_update_step

	jmp case_break
	
; �L�[���͑҂�
case_wait:
	jsr UpdateMessageToggle
	jsr UpdateInputKey
	lda key_state_push
	and #%00001000		; START
	beq case_break

	lda #1			; �C���g���_�N�V����
	sta scene_type	; �V�[��
	lda #0
	sta scene_update_step

	jmp case_break



case_break:

	; �X�N���[���ʒu�X�V
	lda #0
	sta	$2005		; X�����X�N���[��
	lda	#0		; Y�͌Œ�
	sta	$2005

	rts
.endproc

.proc scene_title_init

	; �o���N���^�C�g���o���N�ɂ���
	lda	#1
	sta	$8000

	; ���荞��OFF�@�����l1byte
	lda #%00001000
	;     |||||||`- 
	;     ||||||`-- ���C���X�N���[���A�h���X 00
	;     |||||`--- VRAM�A�N�Z�X���̃A�h���X�����l�x�[�X 0:1byte
	;     ||||`---- �X�v���C�g�p�L�����N�^�e�[�u�� 1
	;     |||`----- BG�p�L�����N�^�e�[�u���x�[�X 0
	;     ||`------ �X�v���C�g�T�C�Y 0:8x8
	;     |`------- PPU�I�� 0:�}�X�^�[
	;     `-------- VBlank����NMI�����𔭐� 0:OFF
	sta $2000
	; �X�v���C�g��BG������
	lda	#%00000110
	;     |||||||`- �F�w�� 0:�J���[
	;     ||||||`-- ��ʍ��[8�s�N�Z����BG��\�� 1:�\��
	;     |||||`--- ��ʍ��[8�s�N�Z���̃X�v���C�g��\�� 1:�\��
	;     ||||`---- BG�̕\�� 0:OFF
	;     |||`----- �X�v���C�g�̕\�� 0:OFF
	;     ||`------ �F������ 0:OFF
	;     |`------- �ΐF������ 0:OFF
	;     `-------- �ԐF������ 0:OFF
	sta	$2001

	; �J�����g��ʂ�1�ɂ���
	lda #1
	sta current_draw_display_no
	
	; �p���b�g�e�[�u���֓]��(BG�p�̂ݓ]��)
	lda	#$3f
	sta	$2006
	lda	#$00
	sta	$2006
	ldx	#$00
	ldy	#16
	copypal:
	lda	palette_bg_title, x
	sta $2007
	inx				; X���C���N�������g����
	dey				; Y���f�N�������g����
	bne	copypal

	; �p���b�g�e�[�u���֓]��(MAP�p�̂ݓ]��)
	lda	#$3f
	sta	$2006
	lda	#$10
	sta	$2006
	ldx	#$00
	ldy	#16
	copypal2:
	lda	palette1, x
	sta $2007
	inx
	dey
	bne	copypal2
	inc scene_update_step

	; �����F��Z���ɕύX
	lda	#$3f
	sta	$2006
	lda	#$10
	sta	$2006
	lda	#$23
	sta $2007

	rts
.endproc

; �l�[���e�[�u�����^�C�g���ɂ���
.proc FillTitleNametable

	; �܂��h��Ԃ�
	lda #0
	sta draw_bg_x
	sta draw_bg_y
	jsr SetPosition
	lda #$3e

	ldy #0
	loop_fill_y:
	ldx #0
	loop_fill_x:
	sta $2007
	inx
	cpx #32
	bne loop_fill_x
	iny
	cpy #28
	bne loop_fill_y

	; ��ԏ�
	lda #5
	sta draw_bg_x
	lda #5
	sta draw_bg_y
	jsr SetPosition
	lda #$09
	sta $2007

	ldx #10
	loop_top_x:
	lda #$0e
	sta $2007
	lda #$3f
	sta $2007
	dex
	bne loop_top_x

	lda #$0a
	sta $2007

	; �^�񒆑S��
	lda #6
	sta REG0

	ldy #15
	loop_middle_y:

	lda #5
	sta draw_bg_x
	lda REG0
	sta draw_bg_y
	jsr SetPosition
	lda #$1e
	sta $2007

	ldx #10
	loop_middle_x:
	lda #$3f
	sta $2007
	lda #$3f
	sta $2007
	dex
	bne loop_middle_x

	lda #$0f
	sta $2007

	inc REG0
	dey
	bne loop_middle_y

	; ��ԉ�
	lda #5
	sta draw_bg_x
	lda #21
	sta draw_bg_y
	jsr SetPosition
	lda #$19
	sta $2007

	ldx #10
	loop_bottom_x:
	lda #$1f
	sta $2007
	lda #$3f
	sta $2007
	dex
	bne loop_bottom_x

	lda #$1a
	sta $2007

	; ���S
	lda #< map_chip_nametable_title_logo
	sta map_table_screen_low
	lda #> map_chip_nametable_title_logo
	sta map_table_screen_hi

	lda #7
	sta REG0

	ldx #5	; 5�s

loop_x:

	lda #10
	sta draw_bg_x
	lda REG0
	sta draw_bg_y
	jsr SetPosition

	ldy #0	; 13��

loop_y:

	lda (map_table_screen_low), y
	sta $2007

	iny
	tya
	cmp #13
	bne loop_y

	; �}�b�v�`�b�v�̋N�_��13���炷
	clc
	lda map_table_screen_low
	adc #13
	sta map_table_screen_low
	lda map_table_screen_hi
	adc #0
	sta map_table_screen_hi

	inc REG0
	dex
	txa
	bne loop_x
	
	; The
	lda #7
	sta draw_bg_x
	lda #9
	sta draw_bg_y
	jsr SetPosition
	lda #$0b
	sta $2007
	lda #$0c
	sta $2007
	lda #$0d
	sta $2007

	lda #7
	sta draw_bg_x
	lda #10
	sta draw_bg_y
	jsr SetPosition
	lda #$1b
	sta $2007
	lda #$1c
	sta $2007
	lda #$1d
	sta $2007

	; 1 PLAYER GAME
	lda #14
	sta draw_bg_y
	lda #10
	sta draw_bg_x
	jsr SetPosition

	ldx #0
	loop_moji_x:
	lda string_player_game, x
	sta $2007
	inx
	cpx #13
	bne loop_moji_x

	; KOBE IMAMOE
	lda #17
	sta draw_bg_y
	lda #9
	sta draw_bg_x
	jsr SetPosition

	ldx #0
	loop_copy_x:
	lda string_kobe_imamoe, x
	sta $2007
	inx
	cpx #16
	bne loop_copy_x

	; PUSH START
	jsr DrawPushStart

	rts
.endproc

.proc DrawPushStart

	; PUSH START
	lda #19
	sta draw_bg_y
	lda #9
	sta draw_bg_x
	jsr SetPosition

	ldx #0
	loop_push_x:
	lda string_push_start, x
	sta $2007
	inx
	cpx #14
	bne loop_push_x

	rts
.endproc

.proc ClearPushStart

	; PUSH START
	lda #19
	sta draw_bg_y
	lda #9
	sta draw_bg_x
	jsr SetPosition

	ldx #0
	loop_push_x:
	lda #$3f
	sta $2007
	inx
	cpx #14
	bne loop_push_x

	rts
.endproc

; �^�C�g���p�����e�[�u���ɕύX
.proc SetupAttributeTitle
	lda #< map_chip_attribute_title_logo
	sta map_table_attribute_low
	lda #> map_chip_attribute_title_logo
	sta map_table_attribute_hi

	lda #0
	sta bg_already_draw_attribute_pos

	ldx #7	; 8��
loop_attribute_first_x:
; �`��
	lda #0
	sta draw_bg_x
	lda bg_already_draw_attribute_pos
	sta draw_bg_y

	; 1�x�������W����A�h���X�����߂�
	; draw_bg_x(in)
	; draw_bg_y(in)
	; attribute_pos_adress_hi(out)
	; attribute_pos_adress_low(out)
	jsr CalcAttributeAdressFromCoord

	ldy #0

draw_loop:
	lda attribute_pos_adress_hi
	sta $2006
	lda attribute_pos_adress_low
	sta $2006
	lda (map_table_attribute_low), y
	sta $2007

	lda attribute_pos_adress_low
	clc
	adc #$1
	sta attribute_pos_adress_low

	iny
	tya
	cmp #8
	bne	draw_loop

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

.proc UpdateMessageToggle

	lda loop_count
	and #%00011111
	bne skip_change
	lda toggle
	cmp #0
	beq case_draw
	cmp #1
	beq case_clear
	
	case_draw:
	jsr DrawPushStart
	jmp case_break

	case_clear:
	jsr ClearPushStart
	jmp case_break

	case_break:

	lda toggle
	eor #1
	sta toggle

	skip_change:

	rts
.endproc
