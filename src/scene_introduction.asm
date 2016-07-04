.proc scene_introduction

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
	jsr scene_introduction_init

	jmp case_break

; �`��
case_fill:

	; �����e�[�u���ύX
	jsr SetupAttributeIntroduction

	; �l�[���e�[�u�����C���g���_�N�V�����ɂ���
	jsr FillIntroductionNametable

	; ��A�C�R��
	lda #$00
	sta $2003
	lda #135
	sta $2004	;y
	lda #$01
	sta $2004	;t
	lda #0
	sta $2004	;s
	lda #130
	sta $2004	;x
	

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

	lda #120
	sta wait_frame

	inc scene_update_step

	jmp case_break
	
; �L�[���͑҂�
case_wait:
	dec wait_frame
	lda wait_frame
	bne case_break
	lda #2			; ���C������
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

.proc scene_introduction_init

	; ���荞��OFF�@�����l1byte
	lda #%00001000
	;     |||||||`- 
	;     ||||||`-- ���C���X�N���[���A�h���X 00
	;     |||||`--- VRAM�A�N�Z�X���̃A�h���X�����l�x�[�X 1byte
	;     ||||`---- �X�v���C�g�p�L�����N�^�e�[�u�� 1
	;     |||`----- BG�p�L�����N�^�e�[�u���x�[�X 0
	;     ||`------ �X�v���C�g�T�C�Y 8x8
	;     |`------- PPU�I�� �}�X�^�[
	;     `-------- VBlank����NMI�����𔭐� OFF
	sta $2000
	; �X�v���C�g��BG������
	lda	#%00000110
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
	ldy	#4
	copypal:
	lda	palette_bg_introduction, x
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

	; �����F�����ɕύX
	lda	#$3f
	sta	$2006
	lda	#$10
	sta	$2006
	lda	#$0f
	sta $2007

	rts
.endproc

; �l�[���e�[�u�����C���g���_�N�V�����ɂ���
.proc FillIntroductionNametable

	; �܂��h��Ԃ�
	lda #0
	sta draw_bg_x
	sta draw_bg_y
	jsr SetPosition
	lda #$00

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

	; LEVEL
	lda #11
	sta draw_bg_x
	lda #10
	sta draw_bg_y
	jsr SetPosition

	ldx #0
	loop_level_x:
	lda string_level_1, x
	sta $2007
	inx
	cpx #7
	bne loop_level_x
	
	; PLAYER
	lda #10
	sta draw_bg_x
	lda #14
	sta draw_bg_y
	jsr SetPosition

	ldx #0
	loop_player_x:
	lda string_player_1, x
	sta $2007
	inx
	cpx #8
	bne loop_player_x

	; LIFE
	lda #11
	sta draw_bg_x
	lda #16
	sta draw_bg_y
	jsr SetPosition

	ldx #0
	loop_life_x:
	lda string_life_1, x
	sta $2007
	inx
	cpx #5
	bne loop_life_x

	rts
.endproc


; �C���g���_�N�V�����p�����e�[�u���ɕύX
.proc SetupAttributeIntroduction

	; �S��
	lda #0
	sta draw_bg_x
	lda #0
	sta draw_bg_y

	; 1�x�������W����A�h���X�����߂�
	; draw_bg_x(in)
	; draw_bg_y(in)
	; attribute_pos_adress_hi(out)
	; attribute_pos_adress_low(out)
	jsr CalcAttributeAdressFromCoord

	lda attribute_pos_adress_hi
	sta $2006
	lda attribute_pos_adress_low
	sta $2006
	ldx #0

draw_loop:
	lda #$00
	sta $2007

	inx
	cpx #64
	bne draw_loop

	rts
.endproc

