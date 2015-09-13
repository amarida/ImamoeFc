

;  #10 10�i���l
; #$10 16�i���l
;  $10 16�i�A�h���X
; #%00000000 2�i��

.setcpu		"6502"
.autoimport	on

.include "define.asm"
.include "player.asm"
.include "inosisi.asm"
.include "utility.asm"

.include "scene_title.asm"
.include "scene_maingame.asm"
.include "scene_gameover.asm"
.include "defineDMA.asm"

; iNES�w�b�_
.segment "HEADER"
	.byte	$4E, $45, $53, $1A	; "NES" Header
	.byte	$02			; PRG-BANKS
	.byte	$01			; CHR-BANKS
	.byte	$01			; �����~���[Vertical Mirror
	.byte	$00			; 
	.byte	$00, $00, $00, $00	; 
	.byte	$00, $00, $00, $00	; 

.segment "STARTUP"
; ���Z�b�g���荞��
.org $8000
.proc	Reset
	sei			; IRQ���荞�݂��֎~���܂��B
;	ldx	#$ff		; ����������X�Ƀ��[�h���܂��B
;	txs			; X��S�փR�s�[���܂��B

; �X�N���[���I�t
	lda	#$00
	sta	$2000
	sta	$2001

; �����ʒu
	lda	#128		; 128(10�i)
	sta	player_x_low
	lda	#0			; 0(10�i)
	sta	player_x_up
	lda	#168		; (10�i)
	sta	player_y

	lda #168
	sta FIELD_HEIGHT	; �n�ʂ̍���

	lda #0
	sta p_pat		; �v���C���[�̕`��p�^�[����0�ŏ�����
	lda #10
	sta pat_change_frame;	�p�^�[���؂�ւ��t���[��

	jsr PlayerInit	; �v���C���[������
	jsr InosisiInit	; �C�m�V�V������

	lda #1			; ���C���Q�[��
	sta scene_type

	lda #0
	sta key_state_on
	sta key_state_push

	lda #4
	sta pow_two
	lda #9
	sta pow_two+1
	lda #16
	sta pow_two+2
	lda #25
	sta pow_two+3
	lda #36
	sta pow_two+4
	lda #49
	sta pow_two+5
	lda #64
	sta pow_two+6
	lda #81
	sta pow_two+7
	lda #100
	sta pow_two+8
	lda #121
	sta pow_two+9
	lda #144
	sta pow_two+10
	lda #169
	sta pow_two+11
	lda #196
	sta pow_two+12
	lda #225
	sta pow_two+13

	lda #< command_jt
	sta test_address_low
	lda #> command_jt
	sta test_address_hi

	ldx #4
command_jmp:
	lda	command_jt+1,X		;: A �� ��W�����v�e�[�u�� ( RTS �Ŕ�Ԃ̂ŁA�ړI�̃A�h���X-1 �ɂ��Ă��� )��̏���޲�.X
	pha				;: Push A
	lda	command_jt+0,X		;: A �� ��W�����v�e�[�u�� ( RTS �Ŕ�Ԃ̂ŁA�ړI�̃A�h���X-1 �ɂ��Ă��� )��̉����޲�.X
	pha				;: Push A
check_end:
	rts				;: �T�u���[�`�����畜�A

command_jt: ; �W�����v�e�[�u�� ( RTS �Ŕ�Ԃ̂ŁA�ړI�̃A�h���X-1 �ɂ��Ă��� )
	.word	cmd_test1-1	; "IF"
	.word	cmd_test2-1	; "IF"
	.word	cmd_test3-1	; "IF"

;	jsr map_table_screen_hi
jmp break;
cmd_test1:
	; test1�̏���
mugen:
jmp mugen

	jmp break
cmd_test2:
	; test2�̏���

	jmp break
cmd_test3:
	; test3�̏���

	jmp break


break:


;;;;; ���̌v�Z���ʂ̎擾���@ ;;;;;
	lda #1
	sta map_diff_x_index

	lda #< pow_two	; �A�h���X���擾
	adc map_diff_x_index	; �A�h���X���炷
	sta REG0
	lda #0
	sta REG1

	ldy #0
	clc
	lda (REG0), y

	sta REG2
;;;;; ���̌v�Z���ʂ̎擾���@ ;;;;;



	; �}�b�v�`�b�v�ʒu�����ݒ�
	lda #< map_chip
	sta map_table_screen_low
	lda #> map_chip
	sta map_table_screen_hi

	lda #< map_chip_attribute
	sta map_table_attribute_low
	lda #> map_chip_attribute
	sta map_table_attribute_hi

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
	ldy	#$8
copypal2:
	lda	palette1, x
	sta $2007
	inx
	dey
	bne	copypal2

; �l�[���e�[�u���֓]��
	lda #1
	sta current_draw_display_no
	lda	#%00001000	; VBlank���荞�݂Ȃ��A�X�v���C�g��1�A
	sta	$2000

; �X�N���[���I��
	lda	#%00001100	; VBlank���荞�݂Ȃ��A�X�v���C�g��1�AVRAM������32byte
;	lda	#%00001000
	sta	$2000

; �X�N���[���ݒ�
	lda	#$00
	sta	$2005
	sta	$2005


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
	ldx #7	; 8��
loop_attribute_first_x:
; �`��
	lda #0
	sta offset_y_attribute
	sta draw_bg_y
	lda bg_already_draw_attribute_pos
	sta draw_bg_x

	; 1�x�������W����A�h���X�����߂�
	; draw_bg_x(in)
	; draw_bg_y(in)
	; attribute_pos_adress_up(out)
	; attribute_pos_adress_low(out)
	jsr CalcAttributeAdressFromCoord

	ldy #7
attribute_loop:

	lda attribute_pos_adress_up
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	lda #0
	sta current_draw_display_no

	lda	#%00011110
;	lda	#%00000000
	sta	$2001

; �X�N���[���ݒ�
	lda	#$00
	sta	$2005
	sta	$2005

; ���荞�݊J�n
	lda	#%10001100	; VBlank���荞�݂���@VRAM������32byte
	sta	$2000




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ���C�����[�v
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mainloop:

vblank_wait:
	lda	$2002
	and	#%10000000
	beq	vblank_wait

	lda scene_type
	cmp #0
	beq case_title
	cmp #1
	beq case_maingame
	cmp #2
	beq case_gameover

case_title:
	; ����0
	jsr scene_title
	jmp scene_break;
case_maingame:
	; ����1
	jsr scene_maingame
	jmp scene_break;
case_gameover:
	; ����2
	jsr scene_gameover
	jmp scene_break;
scene_break:

		;VBLANK�I���҂�
;vblank_in_wait:
;		lda	$2002
;		and	#%10000000
;		bne	vblank_in_wait
	jmp	mainloop
.endproc

; VBlank���荞��
.proc	VBlank

	inc vblank_count
	rti			; ���荞�݂��畜�A����

.endproc

.proc	AddSpd
	;inc	player_x
;	clc			; �L�����[�t���O�N���A
;	lda	spd_y + 1	; ������
;	adc	#$80
;	sta	spd_y + 1

	; �L�����[�t���O�������ĂȂ���Ή������Ȃ�
;	bcc	End

	; ����ȊO�͐�������1������
;	inc	spd_y

;End:
	rts
.endproc

.proc	SubSpd
	;dec	player_x_low
;	sec			; �L�����[�t���O�Z�b�g
;	lda	spd_y + 1	; ������
;	sbc	#$80		; �����Z

	; �L�����[�t���O�������ĂȂ���Ή������Ȃ�
;	bcc	End

	; ����ȊO�͐�������1������
;	inc	spd_y

End:
	rts
.endproc

; �X�V
.proc	Update
	; �L�[����
	inc loop_count;
	; ������
	lda #$01
	sta $4016
	lda #$00
	sta $4016

	; �O��̏�Ԃ��i�[
	lda key_state_on
	sta key_state_on_old

	; A,B,SELECT,START,UP,DOWN,LEFT,RIGHT�̏���
	lda $4016	; A
	and #1
	beq SkipPushA
	jsr PlayerJump
SkipPushA:
	lda $4016	; B
	lda $4016	; SELECT
	lda $4016	; START
	lda $4016	; ��
	and #1
	beq SkipKeyUp
	jsr PlayerMoveUp
SkipKeyUp:
	lda $4016	; ��
	and #1
	beq SkipKeyDown
	jsr PlayerMoveDown
SkipKeyDown:
	lda $4016	; ��
	and #1
	beq SkipKeyLeft
	jsr PlayerMoveLeft
SkipKeyLeft:
	lda $4016	; �E
	and #1
	beq SkipKeyRight
	jsr PlayerMoveRight
SkipKeyRight:

	lda key_state_on
	eor key_state_on_old
	and key_state_on
	sta key_state_push

	jmp Nothing

Nothing:

	; ���������
	jsr Blink

	jsr Player_Update
	jsr	InosisiUpdate

	rts	; �T�u���[�`�����畜�A���܂��B
.endproc

; ���������
.proc Blink

	rts
.endproc

; ��ʊOBG�`��
.proc draw_bg

	; field_scrool_x �� 8�Ŋ������������ݕ`�悷��ׂ�BG
	; �V�t�g����̂Ńe���v�Ɉ�U�����
	lda field_scrool_x_up
	sta field_scrool_x_up_tmp
	lda field_scrool_x_low
	sta field_scrool_x_low_tmp

	lda field_scrool_x_up
	sta map_chip_index_up
	lda field_scrool_x_low
	sta map_chip_index_low
	; 8�Ŋ���
	clc
	lsr field_scrool_x_up_tmp	; ��ʂ͉E�V�t�g
	ror field_scrool_x_low_tmp	; ���ʂ͉E���[�e�[�g
	lsr field_scrool_x_up_tmp	; ��ʂ͉E�V�t�g
	ror field_scrool_x_low_tmp	; ���ʂ͉E���[�e�[�g
	lsr field_scrool_x_up_tmp	; ��ʂ͉E�V�t�g
	ror field_scrool_x_low_tmp	; ���ʂ͉E���[�e�[�g

	; bg_already_draw�����̒l�ɒB���Ă��Ȃ���Ε`��
	sec
	lda bg_already_draw;
	sbc field_scrool_x_low_tmp
	beq not_skip
	jmp skip
not_skip:

; �`��

	lda #3
	sta draw_bg_y	; Y���W
	lda bg_already_draw_pos
	sta draw_bg_x	; X���W�i�u���b�N�j
	jsr SetPosition

	ldy #24
draw_loop:
	lda (map_table_screen_low), y
	sta $2007

	dey	; 25��
	bpl	draw_loop

	; �`�悵���� bg_already_draw ��inc����
	inc bg_already_draw
	inc bg_already_draw_pos
	sec
	lda bg_already_draw_pos
	sbc #32
	bcc skip_reset;
	lda #0
	sta bg_already_draw_pos
skip_reset:
	

	; �}�b�v�`�b�v�̋N�_��25���炷
	clc
	lda map_table_screen_low
	adc #25
	sta map_table_screen_low
	lda map_table_screen_hi
	adc #0
	sta map_table_screen_hi

skip:

	rts
.endproc

; ��ʊOBG�����ݒ�
.proc draw_bg_attribute
	; field_scrool_x �� 32�Ŋ������������ݕ`�悷��ׂ�BG
	; �V�t�g����̂Ńe���v�Ɉ�U�����
	lda field_scrool_x_up
	sta field_scrool_x_up_tmp
	lda field_scrool_x_low
	sta field_scrool_x_low_tmp

	lda field_scrool_x_up
	sta map_chip_index_up
	lda field_scrool_x_low
	sta map_chip_index_low
	; 32�Ŋ���
	clc
	lsr field_scrool_x_up_tmp	; ��ʂ͉E�V�t�g
	ror field_scrool_x_low_tmp	; ���ʂ͉E���[�e�[�g
	lsr field_scrool_x_up_tmp	; ��ʂ͉E�V�t�g
	ror field_scrool_x_low_tmp	; ���ʂ͉E���[�e�[�g
	lsr field_scrool_x_up_tmp	; ��ʂ͉E�V�t�g
	ror field_scrool_x_low_tmp	; ���ʂ͉E���[�e�[�g
	lsr field_scrool_x_up_tmp	; ��ʂ͉E�V�t�g
	ror field_scrool_x_low_tmp	; ���ʂ͉E���[�e�[�g
	lsr field_scrool_x_up_tmp	; ��ʂ͉E�V�t�g
	ror field_scrool_x_low_tmp	; ���ʂ͉E���[�e�[�g

	; bg_already_draw_attribute�����̒l�ɒB���Ă��Ȃ���ΐݒ�
	sec
	lda bg_already_draw_attribute;
	sbc field_scrool_x_low_tmp
	beq not_skip
	jmp skip
not_skip:

; �`��
	lda #0
	sta offset_y_attribute
	sta draw_bg_y
	lda bg_already_draw_attribute_pos
	sta draw_bg_x

	; 1�x�������W����A�h���X�����߂�
	; draw_bg_x(in)
	; draw_bg_y(in)
	; attribute_pos_adress_up(out)
	; attribute_pos_adress_low(out)
	jsr CalcAttributeAdressFromCoord

	ldy #7
draw_loop:
;	sty REG0
;	sec
;	lda map_chip_offset_low
;	sbc REG0
;	sta map_chip_offset_start
	;ldy map_chip_offset_start
;	ldx map_chip_offset_start
	; lda map_chip, x
;	lda bg_already_draw_attribute
;	sta draw_bg_x
;	sty draw_bg_y
;	jsr SetAttributePosition

;	ldy #0
;	lda offset_y_attribute
;	sta draw_bg_y	; Y���W
;	lda bg_already_draw_attribute
;	sta draw_bg_x	; X���W�i�u���b�N�j
;	jsr SetAttributePosition

	lda attribute_pos_adress_up
	sta $2006
	lda attribute_pos_adress_low
	sta $2006
	lda (map_table_attribute_low), y
;lda	map_chip_offset_start, y
	;sta draw_bg_tile	; �^�C���ԍ�
	
	;jsr DrawMapChip
	;lda draw_bg_tile
	sta $2007




	lda attribute_pos_adress_low
	clc
	adc #$8
	sta attribute_pos_adress_low
	; �}�C�i�X����Ȃ���΃��[�v����
	;iny
	dey
;	cpy #0
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

skip:

	rts
.endproc

; �X�v���C�g�`��
.proc	sprite_draw

;	jsr	player_draw	; �v���C���[�`��֐�
;	jsr InosisiDraw	; �C�m�V�V�`��֐�

	rts	; �T�u���[�`�����畜�A���܂��B
.endproc

.proc	sprite_draw2

	sec			; �L�����[�t���OON
	lda player_y
	sbc #64
	sta $2004   ; Y���W�����W�X�^�ɃX�g�A����
	lda #$82     ; 21��A�Ƀ��[�h
	sta $2004   ; 0���X�g�A����0�Ԃ̃X�v���C�g���w�肷��
	lda #%000000001;#%00000000     ; 0(10�i��)��A�Ƀ��[�h
	sta $2004   ; ���]��D�揇�ʂ͑��삵�Ȃ��̂ŁA�ēx$00���X�g�A����
	lda #136; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta $2004   ; X���W�����W�X�^�ɃX�g�A����

	sec			; �L�����[�t���OON
	lda player_y
	sbc #64
	sta $2004   ; Y���W�����W�X�^�ɃX�g�A����
	lda #$83     ; 21��A�Ƀ��[�h
	sta $2004   ; 0���X�g�A����0�Ԃ̃X�v���C�g���w�肷��
	lda #%000000001;#%00000000     ; 0(10�i��)��A�Ƀ��[�h
	sta $2004   ; ���]��D�揇�ʂ͑��삵�Ȃ��̂ŁA�ēx$00���X�g�A����
	lda #144; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta $2004   ; X���W�����W�X�^�ɃX�g�A����

	sec			; �L�����[�t���OON
	lda player_y
	sbc #8
	sta $2004   ; Y���W�����W�X�^�ɃX�g�A����
	lda #$92     ; 21��A�Ƀ��[�h
	sta $2004   ; 0���X�g�A����0�Ԃ̃X�v���C�g���w�肷��
	lda #%000000001;#%00000000     ; 0(10�i��)��A�Ƀ��[�h
	sta $2004   ; ���]��D�揇�ʂ͑��삵�Ȃ��̂ŁA�ēx$00���X�g�A����
	lda #136; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta $2004   ; X���W�����W�X�^�ɃX�g�A����

	sec			; �L�����[�t���OON
	lda player_y
	sbc #8
	sta $2004   ; Y���W�����W�X�^�ɃX�g�A����
	lda #$93     ; 21��A�Ƀ��[�h
	sta $2004   ; 0���X�g�A����0�Ԃ̃X�v���C�g���w�肷��
	lda #%000000001;#%00000000     ; 0(10�i��)��A�Ƀ��[�h
	sta $2004   ; ���]��D�揇�ʂ͑��삵�Ȃ��̂ŁA�ēx$00���X�g�A����
	lda #144; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta $2004   ; X���W�����W�X�^�ɃX�g�A����

	sec			; �L�����[�t���OON
	lda player_y
	sbc #48
	sta $2004   ; Y���W�����W�X�^�ɃX�g�A����
	lda #$A2     ; 21��A�Ƀ��[�h
	sta $2004   ; 0���X�g�A����0�Ԃ̃X�v���C�g���w�肷��
	lda #%000000001;#%00000000     ; 0(10�i��)��A�Ƀ��[�h
	sta $2004   ; ���]��D�揇�ʂ͑��삵�Ȃ��̂ŁA�ēx$00���X�g�A����
	lda #136; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta $2004   ; X���W�����W�X�^�ɃX�g�A����

	sec			; �L�����[�t���OON
	lda player_y
	sbc #48
	sta $2004   ; Y���W�����W�X�^�ɃX�g�A����
	lda #$A3     ; 21��A�Ƀ��[�h
	sta $2004   ; 0���X�g�A����0�Ԃ̃X�v���C�g���w�肷��
	lda #%000000001;#%00000000     ; 0(10�i��)��A�Ƀ��[�h
	sta $2004   ; ���]��D�揇�ʂ͑��삵�Ȃ��̂ŁA�ēx$00���X�g�A����
	lda #144; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta $2004   ; X���W�����W�X�^�ɃX�g�A����

	sec			; �L�����[�t���OON
	lda player_y
	sbc #40
	sta $2004   ; Y���W�����W�X�^�ɃX�g�A����
	lda #$B2     ; 21��A�Ƀ��[�h
	sta $2004   ; 0���X�g�A����0�Ԃ̃X�v���C�g���w�肷��
	lda #%000000001;#%00000000     ; 0(10�i��)��A�Ƀ��[�h
	sta $2004   ; ���]��D�揇�ʂ͑��삵�Ȃ��̂ŁA�ēx$00���X�g�A����
	lda #136; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta $2004   ; X���W�����W�X�^�ɃX�g�A����

	sec			; �L�����[�t���OON
	lda player_y
	sbc #40
	sta $2004   ; Y���W�����W�X�^�ɃX�g�A����
	lda #$B3     ; 21��A�Ƀ��[�h
	sta $2004   ; 0���X�g�A����0�Ԃ̃X�v���C�g���w�肷��
	lda #%000000001;#%00000000     ; 0(10�i��)��A�Ƀ��[�h
	sta $2004   ; ���]��D�揇�ʂ͑��삵�Ȃ��̂ŁA�ēx$00���X�g�A����
	lda #144; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta $2004   ; X���W�����W�X�^�ɃX�g�A����

	sec			; �L�����[�t���OON
	lda player_y
	sbc #8
	sta $2004   ; Y���W�����W�X�^�ɃX�g�A����
	lda #$30     ; 21��A�Ƀ��[�h
	sta $2004   ; 0���X�g�A����0�Ԃ̃X�v���C�g���w�肷��
	lda #%000000000;#%00000000     ; 0(10�i��)��A�Ƀ��[�h
	sta $2004   ; ���]��D�揇�ʂ͑��삵�Ȃ��̂ŁA�ēx$00���X�g�A����
	lda #112; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta $2004   ; X���W�����W�X�^�ɃX�g�A����

	rts	; �T�u���[�`�����畜�A���܂��B
.endproc

.proc change_palette1
; �p���b�g�e�[�u���֓]��(MAP�p�̂ݓ]��)
	lda	#$23
	sta	$2006
	lda	#$c0
	sta	$2006
	ldx	#$00
	ldy	#$4
copypal2:
	lda	palette1, x
	sta $2007
	inx
	dey
	bne	copypal2

	rts
.endproc

.proc change_palette2
; �p���b�g�e�[�u���֓]��(MAP�p�̂ݓ]��)
	lda	#$23
	sta	$2006
	lda	#$c1
	sta	$2006
	ldx	#$00
	ldy	#$4
copypal2:
	lda	palette2, x
	sta $2007
	inx
	dey
	bne	copypal2

	rts
.endproc

.proc SetPosition
	; draw_bg_x	X���W
	; draw_bg_y	Y���W

	lda draw_bg_x	
	sta conv_coord_bit_x
	lda draw_bg_y
	sta conv_coord_bit_y
;;;;;�� ���W���A�h���X��Ԃɕϊ� ;;;;;
	;jsr ConvertCoordToBit
	; y * 32 ; Y���W������ɂ��炷��X������32������������
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

	
	; ��ʂP����ʂQ��
	lda #$24
	sta draw_bg_display

	lda current_draw_display_no
	beq set_skip
	lda #$20
	sta draw_bg_display

set_skip:

jmp noset24
	clc
	lda conv_coord_bit_x
	asl	; ���V�t�g
	asl	; ���V�t�g
	bcs set24
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
;;;;;�� ���W���A�h���X��Ԃɕϊ� ;;;;;

	lda conv_coord_bit_up
	sta $2006
	lda conv_coord_bit_low
	sta $2006

	rts
.endproc

.proc CalcAttributeAdressFromCoord
	; draw_bg_x	X���W(0,0)-(7,7)
	; draw_bg_y	Y���W
	; attribute_pos_adress_up
	; attribute_pos_adress_low
	lda draw_bg_x
	sta conv_coord_bit_x
	lda draw_bg_y
	sta conv_coord_bit_y
;;;;;�� ���W���A�h���X��Ԃɕϊ� ;;;;;
	;jsr ConvertCoordToBit
	; y * 8 ; Y���W������ɂ��炷��X������8������������
	lda #0
	sta multi_ans_up
	sta multi_ans_low

	lda conv_coord_bit_y
	sta multi_ans_low

	; 8�{
	clc
	asl multi_ans_low		; ���ʂ͍��V�t�g
	rol multi_ans_up		; ��ʂ͍����[�e�[�g

	asl multi_ans_low
	rol multi_ans_up

	asl multi_ans_low
	rol multi_ans_up
	
	; ��ʂP����ʂQ��
	lda #$27
	sta draw_bg_display

	lda current_draw_display_no
	beq set_skip
	lda #$23
	sta draw_bg_display

set_skip:


jmp noset24
	clc
	lda conv_coord_bit_x
	asl	; ���V�t�g
	asl	; ���V�t�g
	bcs set24
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
	adc #$c0
	sta conv_coord_bit_low
	; ��ʁ{���
	lda multi_ans_up
	adc draw_bg_display;#$27
	sta conv_coord_bit_up
;;;;;�� ���W���A�h���X��Ԃɕϊ� ;;;;;

	lda conv_coord_bit_up
	sta attribute_pos_adress_up
	lda conv_coord_bit_low
	sta attribute_pos_adress_low

	rts
.endproc

.proc DrawMapChip
	; draw_bg_tile	�^�C���ԍ�

	lda draw_bg_tile
	sta $2007

	rts
.endproc

.proc DrawGameOver
	ldx #0
	lda #10
	sta REG0
	;current_draw_display_no ; �X�N���[����ʂ��P���Q��
	;scrool_x				; �X�N���[���ʒu
	; �X�N���[���ʒu����(8�s�N�Z��x10�u���b�N)
	; 80�s�N�Z��������
	; �L�����[�t���O����������ׂ̉��
	clc
	lda scrool_x
	adc #80
	bcs display2
	bcc display1
	
	; �L�����[�t���O�������Ȃ�����
	; 152(80+72)�s�N�Z�������ăL�����[�t���O��
	; �����Ȃ���΁A���̉�ʂ̂�
;	clc
;	lda scrool_x
;	adc #152
;	bcc display1

	; �L�����[�t���O�������Ȃ�����
	; 152(80+72)�s�N�Z�������ăL�����[�t���O��
	; ���ꍇ�A2��ʂɕ������
	; ��������ʒu
	; 255-scrool_x��8�Ŋ������l��
	; ���̉�ʂŕ\�����镶����
;	sec
;	lda #255
;	sbc scrool_x
;	sta REG1
;	clc
;	lsr REG1	; �E���[�e�[�g
;	lsr REG1	; �E���[�e�[�g
;	lsr REG1	; �E���[�e�[�g
;	
;	jmp display1and2

display1:
	; �X�N���[���ʒu���W��10������
	lda scrool_x
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

loop_x:
	lda #10
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

	; �����f�[�^
X_Pos_Init:   .byte 20       ; X���W�����l
Y_Pos_Init:   .byte 40       ; Y���W�����l

; �p���b�g�e�[�u��
palette1:
	.byte	$21, $23, $3A, $30
	.byte	$0f, $07, $16, $0d
palette2:
	.byte	$0f, $00, $10, $20
paletteIno:
palettes_bg:
	.byte	$21, $0f, $00, $10
	.byte	$21, $0f, $12, $30
	.byte	$21, $08, $18, $28
	.byte	$21, $0a, $1a, $2a

	; ���e�[�u���f�[�^(20��)
Star_Tbl:
   .byte 60,45,35,60,90,65,45,20,90,10,30,40,65,25,65,35,50,35,40,35

; �\��������
string:
	.byte	"HELLO, WORLD!"
;	.byte	$01, $02, $11, $12

string1:
	.byte	$01, $02

string2:
	.byte	$11, $12

string_game_over:
	.byte	"GAME OVER"

; �}�b�v�`�b�v(�l�[���e�[�u��)
map_chip: ; 25��(��3��)240���C���\���Ȃ�㉺�{�P�Â�
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

	; ���������ʊO
	.byte 	$05, $13, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$06, $14, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$05, $13, $03, $00, $00, $00, $00, $00, $00, $17, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$06, $14, $04, $00, $00, $00, $00, $00, $00, $18, $08, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$05, $13, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$06, $14, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$05, $13, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$06, $14, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$05, $13, $03, $00, $00, $00, $00, $00, $00, $17, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$06, $14, $04, $00, $00, $00, $00, $00, $00, $18, $08, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$05, $13, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$06, $14, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $17, $07, $17, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $18, $08, $18, $08, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$05, $13, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$06, $14, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$05, $13, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$06, $14, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$01, $11, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$02, $12, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; �����e�[�u��
map_chip_attribute:
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00

	; ���������ʊO
	.byte 	$05, $50, $00, $00, $00, $00, $00, $00
	.byte 	$05, $50, $00, $00, $00, $00, $00, $00
	.byte 	$05, $50, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00

	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$05, $50, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00

.segment "VECINFO"
	.word	VBlank
	.word	Reset
	.word	$0000

; �p�^�[���e�[�u��
.segment "CHARS"
	.incbin	"character.chr"
