

;  #10 10�i���l
; #$10 16�i���l
;  $10 16�i�A�h���X
; #%00000000 2�i��

.setcpu		"6502"
.autoimport	on

.include "define.asm"
.include "player.asm"
.include "inosisi.asm"
.include "tako.asm"
.include "tako_haba.asm"
.include "tamanegi.asm"
.include "TamanegiFire.asm"
.include "Habatan.asm"
.include "HabatanFire.asm"
.include "Item.asm"
.include "utility.asm"
.include "sound.asm"

.include "scene_title.asm"
.include "scene_introduction.asm"
.include "scene_maingame_ready.asm"
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
	lda #$00
	sta $2000
	sta $2001

;counter_hit: .byte 1
;DoubleRAM: .word 2
;
;lda	counter_hit
;asl	a
;tax
;lda	Table_hit, x
;sta	DoubleRAM
;lda	Table_hit +1,x
;sta	DoubleRAM +1
;jmp  (DoubleRAM)
;
;Table_hit:
; .word hit0
; .word hit1
; .word hit2
; .word hit3
; .word hit4


	lda #0			; �^�C�g��
	sta scene_type	; �V�[��
	lda #0
	sta scene_update_step	; �V�[�����X�e�b�v

	lda #0
	sta key_state_on
	sta key_state_push


	lda #0
	sta debug_var


	; �T�E���h
	lda #0
	sta bgm_type
	sta scene_maingame_init
	sta se_type
	sta se_kukei_step
	sta se_kukei_count
	sta se_kukei_wait_frame

; ��`�g
;	lda $4015		; �T�E���h���W�X�^
;	ora #%00000001	; ��`�g�`�����l���P��L���ɂ���
;	sta $4015
;
;	lda #%10111111	; Duty��E���������E���������E������
;	sta $4000	; ��`�g�`�����l���P���䃌�W�X�^�P
;	lda #%00000100	; ���g��(����8�r�b�g)
;	sta $4002	; ��`�g�`�����l���P���g�����W�X�^�P
;	lda #%11111011	; �Đ����ԁE���g��(���3�r�b�g)
;	sta $4003	; ��`�g�`�����l���P���g�����W�X�^�Q
;	lda $4015	; �T�E���h���W�X�^
;	ora #%00000010	; ��`�g�`�����l���Q��L���ɂ���
;	sta $4015
;
;	lda #%00000000	; ��`�g�`�����l����L���ɂ���
;	sta $4015
;
;	lda $4015		; �T�E���h���W�X�^
;	ora #%00000001	; ��`�g�`�����l���P��L���ɂ���
;	sta $4015
;
;	lda #%10111111
;	sta $4000		; ��`�g�`�����l���P���䃌�W�X�^�P
;
;	lda #%10101011
;	sta $4001		; ��`�g�`�����l���P���䃌�W�X�^�Q
;	lda #0		; ���V�т�X���W�����Ă݂�
;	sta $4002		; ��`�g�`�����l���P���g�����W�X�^�P
;
;	lda #%11111011
;	sta $4003		; ��`�g�`�����l���P���g�����W�X�^�Q

; �O�p�g
;	lda #%00000100	; 
;	sta $4015
;
;	lda #%10000001	; �J�E���^�g�p�E����
;	sta $4008	; �O�p�g�`�����l�����䃌�W�X�^
;
;	lda #%00000100	; ���g��(����8�r�b�g)
;	sta $400A	; �O�p�g�`�����l���P���g�����W�X�^�P
;
;	lda #%00001011	; �Đ����ԁE���g��(���3�r�b�g)
;	sta $400B	; �O�p�g�`�����l���P���g�����W�X�^�Q
;
;	lda #%00000100	; 
;	sta $4015

; �m�C�Y
;	lda #%00001000	; 
;	sta $4015
;
;	lda #%11101111	; ���g�p�E���������E���������E������
;	sta $400C	; �m�C�Y���䃌�W�X�^
;
;	lda #%00000001	; �����^�C�v�E���g�p�E�g��
;	sta $400E	; �m�C�Y���g�����W�X�^�P
;	lda #%11111011	; �Đ����ԁE���g�p
;	sta $400F	; �m�C�Y���g�����W�X�^�Q

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

	jmp break
cmd_test2:
	; test2�̏���

	jmp break
cmd_test3:
	; test3�̏���

	jmp break


break:

; �X�N���[���I��
	lda #%00001100	; VBlank���荞�݂Ȃ��A�X�v���C�g��1�AVRAM������32byte
	sta $2000

; �X�N���[���ݒ�
	lda	#$00
	sta	$2005
	sta	$2005

; ���荞�݊J�n
	lda #%10001100	; VBlank���荞�݂���@VRAM������32byte
	sta $2000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ���C�����[�v
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mainloop:

vblank_wait:
	lda	$2002
	and	#%10000000
	beq	vblank_wait

	inc loop_count

; �f�o�b�O
	lda #$20
	sta $2006
	lda #$00
	sta $2006
	clc
	lda debug_var
	adc #$30
	sta $2007

	lda scene_type
	cmp #0
	beq case_title
	cmp #1
	beq case_introduction
	cmp #2
	beq case_maingame_ready
	cmp #3
	beq case_maingame
	cmp #4
	beq case_gameover

case_title:
	jsr scene_title
	jmp scene_break;
case_introduction:
	jsr scene_introduction
	jmp scene_break;
case_maingame_ready:
	jsr scene_maingame_ready
	jmp scene_break
case_maingame:
	jsr scene_maingame
	jmp scene_break;
case_gameover:
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

.proc ChangePaletteBgState

	lda REG0
	cmp #$c9
	bne skip

	lda #1
	sta palette_bg_change_state

	skip:
	rts
.endproc	; ChangePaletteBgState

; ��ʊOBG�`��
.proc draw_bg_name_table

	; scroll_count_8dot��0�̎��`��
	lda scroll_count_8dot
	cmp #0
	bne skip;

	; bg_already_draw�����̒l�ɒB���Ă��Ȃ���Ε`��
	sec
	lda bg_already_draw;
	sbc scroll_count_8dot_count

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
	sta REG0
	jsr ChangePaletteBgState

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

	lda scroll_count_32dot
	cmp #0
	bne skip

	; bg_already_draw_attribute�����̒l�ɒB���Ă��Ȃ���ΐݒ�
	sec
	lda bg_already_draw_attribute;
	sbc scroll_count_32dot_count
	beq not_skip
	jmp skip
not_skip:

; �`��
	lda #1
	sta draw_bg_y
	lda bg_already_draw_attribute_pos
	sta draw_bg_x

	; 1�x�������W����A�h���X�����߂�
	; draw_bg_x(in)
	; draw_bg_y(in)
	; attribute_pos_adress_hi(out)
	; attribute_pos_adress_low(out)
	jsr CalcAttributeAdressFromCoord

	ldy #6	; 7��
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

	; �}�b�v�`�b�v�̋N�_��7���炷
	clc
	lda map_table_attribute_low
	adc #7
	sta map_table_attribute_low
	lda map_table_attribute_hi
	adc #0
	sta map_table_attribute_hi

skip:

	rts
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
	; attribute_pos_adress_hi
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
	sta attribute_pos_adress_hi
	lda conv_coord_bit_low
	sta attribute_pos_adress_low

	rts
.endproc

	; �����f�[�^
X_Pos_Init:   .byte 20       ; X���W�����l
Y_Pos_Init:   .byte 40       ; Y���W�����l

; �p���b�g�e�[�u��
palette1:
	.byte	$21, $23, $38, $30	; �X�v���C�g�F1		�v���C���[
	.byte	$0f, $07, $16, $0d	; �X�v���C�g�F2		�C�m�V�V
	.byte	$0f, $30, $16, $0e	; �X�v���C�g�F3		�^�R
	.byte	$0f, $26, $38, $0f	; �X�v���C�g�F4		�͂΃^��
	.byte	$0f, $16, $1A, $0e	; �X�v���C�g�F5		�^�}�l�M
	.byte	$0f, $16, $07, $05	; �X�v���C�g�F6		�^�}�l�M���A�^�R�Ă��A�͂΃^����
	.byte	$0f, $39, $00, $0f	; �X�v���C�g�F7		����
	.byte	$0f, $39, $2a, $0a	; �X�v���C�g�F8		����
palette_sake_get:
	.byte	$0f, $3a, $30, $2b	; �����Q�b�g��
	.byte	$0f, $3a, $30, $2b	; ����Q�b�g��
palette2:
	.byte	$0f, $00, $10, $20
	.byte	$0f, $00, $10, $20
paletteIno:
palettes_bg:
	.byte	$0f, $0f, $00, $10	; bg�F1
	.byte	$0f, $0f, $12, $30	; bg�F2
	.byte	$0f, $0f, $0f, $30	; bg�F3
	.byte	$21, $0a, $1a, $2a	; bg�F4
palette_bg_title:
	.byte	$0f, $23, $21, $27	; �^�C�g���pbg�F1 �I�����W
	.byte	$0f, $23, $21, $30	; �^�C�g���pbg�F2 ��
	.byte	$0f, $23, $21, $0f	; �^�C�g���pbg�F3 ��
	.byte	$21, $0a, $1a, $2a	; �^�C�g���pbg�F4
palette_bg_introduction:
	.byte	$0f, $0f, $0f, $30	; �^�C�g���pbg�F ��
palette_bg_kirin:
	.byte	$21, $17, $07, $0f	; �L�����p

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

string_life:
	.byte	"LIFE"
string_score:
	.byte	"SCORE"
string_time:
	.byte	"TIME"
string_zero_score:
	.byte	"000000"
string_first_time:
	.byte	"400"

string_player_game:
	.byte	"1 PLAYER GAME"

string_kobe_imamoe:
	.byte	"KOBE IMAMOE 2011"

string_push_start:
	.byte	"PUSH START KEY"

string_level_1:
	.byte	"LEVEL 1"

string_player_1:
	.byte	"PLAYER 1"

string_life_1:
	.byte	"LIFE-"

.include "map_chip.asm"


; �G�̓o��ʒu���e�[�u��
; x�ʒu��ʁAx���W���ʁAy�ʒu�A�G�̃^�C�v
; $00:�C�m�V�V�A$01:�^�R�A$02:�^�}�l�M�A$03:�͂΃^��
; $04:�͂΃^�R�A$05:�� 78�A$06:�^�}�l�M2
map_enemy_info:
	.byte	$01, $e2, $b8, $00	; �C�m�V�V

	.byte	$02, $1a, $b8, $01	; �^�R
	.byte	$02, $32, $b8, $01	; �^�R
	.byte	$02, $57, $b0, $02	; �^�}�l�M
	.byte	$02, $b2, $88, $05	; �A�C�e��
	.byte	$02, $e2, $b8, $00	; �C�m�V�V
	.byte	$02, $f2, $b8, $00	; �C�m�V�V

	.byte	$03, $32, $88, $05	; �A�C�e��

	.byte	$03, $f7, $b0, $02	; �^�}�l�M
	.byte	$04, $52, $b8, $03	; �͂΃^��
	.byte	$04, $c2, $b8, $04	; �͂΃^�R

	.byte	$05, $12, $a8, $06	; �^�}�l�M2
	.byte	$05, $92, $b8, $00	; �C�m�V�V
	.byte	$05, $e2, $b8, $00	; �C�m�V�V

	.byte	$ff, $ff, $ff, $00	; �Ō�̃_�~�[

; BGM���e�[�u��
bgm_introduction_kukei:
	;     4000 4001 4002 4003 ���t���[���҂�
	.byte $5F, $00, $5E, $b0, $14	; ���c�@�c�[
	.byte $5F, $00, $70, $b0, $9	; �V�a�@�g
	.byte $00, $00, $00, $00, $1
	.byte $5F, $00, $70, $b0, $9	; �V�a�@�g
	.byte $00, $00, $00, $00, $1
	.byte $5F, $00, $70, $b0, $14	; �V�a�@�c�[
	.byte $5F, $00, $8E, $b0, $9	; ���`�@�g
	.byte $00, $00, $00, $00, $1
	.byte $5F, $00, $8E, $b0, $9	; ���`�@�g
	.byte $00, $00, $00, $00, $1

	.byte $5F, $00, $A9, $b0, $14	; �~�d�@�c�[
	.byte $5F, $00, $8E, $b0, $9	; �\�f�@�g
	.byte $00, $00, $00, $00, $1
	.byte $5F, $00, $8E, $b0, $9	; �\�f�@�g
	.byte $00, $00, $00, $00, $1
	.byte $5F, $00, $7E, $b0, $14	; ���`�@�c�[
	.byte $5F, $00, $70, $b0, $9	; �V�a�@�g
	.byte $00, $00, $00, $00, $1

	
bgm_introduction_sankaku:
	;     4008 400A 400B ���t���[���҂�
	.byte $81, $D5, $00, $13	; �h�b
	.byte $80, $00, $00, $1
	.byte $81, $D5, $00, $13	; �h�b
	.byte $80, $00, $00, $1
	.byte $81, $D5, $00, $13	; �h�b
	.byte $80, $00, $00, $1
	.byte $81, $D5, $00, $13	; �h�b
	.byte $80, $00, $00, $1
	.byte $81, $BD, $00, $13	; ���c
	.byte $80, $00, $00, $1
	.byte $81, $BD, $00, $13	; ���c
	.byte $80, $00, $00, $1
	.byte $81, $D5, $00, $13	; ���c
	.byte $80, $00, $00, $1
	.byte $81, $D5, $00, $9	; �h�b
	.byte $80, $00, $00, $1

; SE���e�[�u��
se_jump_kukei:
	;     4000 4001 4002 4003 ���t���[���҂�
	.byte $5F, $00, $7E, $b0, $3	; ���`
	.byte $9F, $AC, $D5, $B0, $10	; �V�a
	.byte $00, $00, $00, $00, $1

se_fire_noise:
	;     400C 400E 400F ���t���[���҂�
	.byte $1F, $0F, $B0, $20
	.byte $00, $00, $00, $1

se_item_kukei:
	;     4000 4001 4002 4003 ���t���[���҂�
	.byte $CF, $8A, $FD, $B0, $10	; �Ⴂ���`
	.byte $00, $00, $00, $00, $1

.segment "VECINFO"
	.word	VBlank
	.word	Reset
	.word	$0000

; �p�^�[���e�[�u��
.segment "CHARS"
	.incbin	"character.chr"
