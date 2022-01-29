.proc Scene_Debug
	; �r������n�߂�e�X�g�p
	lda #6;#$7
	sta player_x_hi
	sta field_scroll_x_hi
	; 15�� �A�h���X��60���炷; 18�� �A�h���X��72���炷
	clc
	lda map_enemy_info_address_low
	adc #60 ;#72
	sta map_enemy_info_address_low
	lda map_enemy_info_address_hi
	adc #0
	sta map_enemy_info_address_hi

	; �}�b�v�`�b�v�̋N�_(NameTable)��6�y�[�W�A25*32*6 4800���炷
	  ; �}�b�v�`�b�v�̋N�_(NameTable)��7�y�[�W�A25*32*7 5600���炷
	clc
	lda map_table_screen_low
	adc #192 ; #224
	sta map_table_screen_low
	lda map_table_screen_hi
	adc #18 ; #21
	sta map_table_screen_hi

	; �}�b�v�`�b�v�̋N�_(����)��6�y�[�W�A7*8*6 336���炷
	  ; �}�b�v�`�b�v�̋N�_(����)��7�y�[�W�A7*8*7 392���炷
	clc
	lda map_table_attribute_low
	adc #80 ; #136
	sta map_table_attribute_low
	lda map_table_attribute_hi
	adc #1
	sta map_table_attribute_hi

	; �p�^�[�����r��
	lda #3
	sta palette_bg_change_state
	jsr change_palette_bg_table
	; �p�^�[�����C
	lda #5
	sta palette_bg_change_state
	jsr change_palette_bg_table

	rts
.endproc

.proc scene_maingame_ready

; �p���b�g�e�[�u���֓]��(BG�p�̂ݓ]��)
	lda	#$3f
	sta	$2006
	lda	#$00
	sta	$2006
	ldx	#$00
	ldy	#$16
copypal:
	lda	palettes_bg, x
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

	; �����F��ɕύX
	lda	#$3f
	sta	$2006
	lda	#$10
	sta	$2006
	lda	#$21
	sta $2007

	lda #%00001100	; VBlank���荞�݂Ȃ��A�X�v���C�g��1�AVRAM������32byte
	sta $2000
	lda	#%00000110
	sta	$2001

	; �����ʒu
	lda	#128		; 128(10�i)
	sta	player_x_low
	lda	#0			; 0(10�i)
	sta	player_x_hi
	lda	#168		; (10�i)
	sta	player_y

	lda #168
	sta FIELD_HEIGHT	; �n�ʂ̍���

	lda #0
	sta p_pat		; �v���C���[�̕`��p�^�[����0�ŏ�����
	lda #10
	sta pat_change_frame;	�p�^�[���؂�ւ��t���[��

	jsr PlayerInit			; �v���C���[������
	jsr InosisiInit			; �C�m�V�V������
	jsr TakoInit			; �^�R������
	jsr TamanegiInit		; �^�}�l�M������
	jsr TamanegiFire_Init	; �^�}�l�M�t�@�C�A�[������
	jsr BossInit			; �{�X������
	
	lda #0
	sta inosisi_alive_flag	; �����C�m�V�V�t���O
	sta tako_alive_flag		; �����^�R�t���O
	sta tamanegi_alive_flag	; �����^�}�l�M�t���O
	sta tako_haba_alive_flag; �����͂΃^�R�t���O
	lda #2
	sta inosisi_max_count	; �ő哯���o�ꐔ�C�m�V�V
	sta tako_max_count		; �ő哯���o�ꐔ�^�R
	sta tamanegi_max_count	; �ő哯���o�ꐔ�^�}�l�M
	sta fire_max_count		; �ő哯���o�ꐔ�^�}�l�M�t�@�C�A�[

	; �G���擪�A�h���X
	lda #< map_enemy_info
	sta map_enemy_info_address_low
	lda #> map_enemy_info
	sta map_enemy_info_address_hi

	lda #0
	sta scroll_count_32dot

	lda #7
	sta scroll_count_8dot
	lda #$FF
	sta scroll_count_8dot_count

	lda #0
	sta timer_count
	
	lda #0
	sta bg_already_draw_attribute_pos

	jsr TamanegiFire_AllClear	; �^�}�l�M�t�@�C�A�[�N���A
	
	lda #0
	sta palette_change_state
	sta bg_already_draw
	sta bg_already_draw_pos

	; �^�C�}�[�����l(400)
	lda #%00000001
	sta timer_b1
	lda #%10010000
	sta timer_b0

	; �X�R�A�����l(0)
	lda #0
	sta score_b1
	lda #0
	sta score_b0

	; �����v���C���[���x
	lda #0
	sta REG0
	lda #1
	sta REG1
	jsr Player_SetSpeed
	
	lda #1
	sta player_speed_hi_or_low

	; �X�v���C�g0�Ԃ̏��
	lda #23
	sta spriteZero_y
	sta spriteZero_y2
	lda #01
	sta spriteZero_t
	sta spriteZero_t2
	lda #0
	sta spriteZero_s
	sta spriteZero_s2
	lda #48
	sta spriteZero_x
	sta spriteZero_x2

	; �}�b�v�`�b�v�ʒu�����ݒ�
	lda #< map_chip
	sta map_table_screen_low
	lda #> map_chip
	sta map_table_screen_hi

	lda #< map_chip_attribute
	sta map_table_attribute_low
	lda #> map_chip_attribute
	sta map_table_attribute_hi

	lda #1
	sta current_draw_display_no
	
	; �f�o�b�O
	;jsr Scene_Debug

; �����w�i�l�[���e�[�u�� ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

; �����w�i�����e�[�u�� ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldx #7	; ��8��
loop_attribute_first_x:
; �`��
	lda #1	; 1����n�߂�
	sta draw_bg_y
	lda bg_already_draw_attribute_pos
	sta draw_bg_x

	; 1�x�������W����A�h���X�����߂�
	; draw_bg_x(in)
	; draw_bg_y(in)
	; attribute_pos_adress_hi(out)
	; attribute_pos_adress_low(out)
	jsr CalcAttributeAdressFromCoord

	ldy #6	; �c7��
attribute_loop:

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
	; �}�C�i�X����Ȃ���΃��[�v����
	dey
	bpl	attribute_loop

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

	; �}�b�v�`�b�v�̋N�_��7���炷
	clc
	lda map_table_attribute_low
	adc #7
	sta map_table_attribute_low
	lda map_table_attribute_hi
	adc #0
	sta map_table_attribute_hi


	dex
	bpl loop_attribute_first_x


	lda #0
	sta bg_already_draw_attribute_pos
	sta bg_already_draw_attribute
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	lda #%00001000	; VBlank���荞�݂Ȃ��A�X�v���C�g��1�AVRAM������1byte
	sta $2000

	; ��ʏ㕔�̌Œ���̕`��Ƒ����ݒ�
	jsr SetStatusNameAttribute

; ���X�^�X�N���[���p(BG)
	lda #2
	sta draw_bg_y	; Y���W�i�u���b�N�j
	lda #6	; X���W�i�u���b�N�j
	sta draw_bg_x	; X���W�i�u���b�N�j
	jsr SetPosition

	lda #$10
	sta $2007

	lda #0
	sta current_draw_display_no

	lda	#%00011110
	sta	$2001
	
; �X�N���[���ݒ�
	lda	#$00
	sta	$2005
	sta	$2005

; ���荞�݊J�n
	lda #%10001100	; VBlank���荞�݂���@VRAM������32byte
	;lda #%00001100	; VBlank���荞�݂Ȃ��@VRAM������32byte
	sta $2000
	
	; ���̃V�[��
	lda #3					; ���C��
	sta scene_type			; �V�[��
	lda #0
	sta scene_update_step	; �V�[�����X�e�b�v

	rts
.endproc	; scene_maingame_ready
