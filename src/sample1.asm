

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





; iNES�w�b�_
.segment "HEADER"
	.byte	$4E, $45, $53, $1A	; "NES" Header
	.byte	$02			; PRG-BANKS
	.byte	$01			; CHR-BANKS
	.byte	$01			; �����~���[Vertical Mirror
	.byte	$00			; 
	.byte	$00, $00, $00, $00	; 
	.byte	$00, $00, $00, $00	; 

;.segment "STARTUP"
;	.byte	$AA

.segment "STARTUP"
; ���Z�b�g���荞��
.proc	Reset
	sei			; IRQ���荞�݂��֎~���܂��B
	ldx	#$ff		; ����������X�Ƀ��[�h���܂��B
	txs			; X��S�փR�s�[���܂��B

; �X�N���[���I�t
	lda	#$00
	sta	$2000
	sta	$2001

; �����ʒu
	lda	#128		; 128(10�i)
	sta	player_x_low
	lda	#0			; 0(10�i)
	sta	player_x_up
	lda	#207		; 112(10�i)
	sta	player_y
	lda #207
	sta FIELD_HEIGHT	; �n�ʂ̍���

	lda #0
	sta current_draw_display_no ; ���݂̕`���ʔԍ�

	lda #0
	sta p_pat		; �v���C���[�̕`��p�^�[����0�ŏ�����
	lda #10
	sta pat_change_frame;	�p�^�[���؂�ւ��t���[��

	jsr PlayerInit	; �v���C���[������
	jsr InosisiInit	; �C�m�V�V������

;	; $2000�̃l�[���e�[�u���ɐ�������
;	lda #$20
;	sta $2006
;	lda #$00
;	sta $2006
;
;	lda #$00        ; 0��(�^����)
;	ldy #$00    	; Y���W�X�^������
;loadNametable1:
;	ldx Star_Tbl, y				; Star�e�[�u���̒l��X�ɓǂݍ���
;loadNametable2:
;	sta $2007				; $2007�ɑ����̒l��ǂݍ���
;	dex					; X���Z
;	bne loadNametable2	; �܂�0�łȂ��Ȃ�΃��[�v���č����o�͂���
;	; 1�Ԃ�2�Ԃ̃L������Y�̒l������݂Ɏ擾
;	tya					; Y��A
;	and #1					; A AND 1
;	adc #1					; A��1���Z����1��2��
;	sta $2007				; $2007�ɑ����̒l��ǂݍ���
;	lda #$00        ; 0��(�^����)
;	iny					; Y���Z
;	cpy #20					; 20��(���e�[�u���̐�)���[�v����
;	bne loadNametable1

	lda #< map_chip
	sta map_table_low
	lda #> map_chip
	sta map_table_hi

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
	sta	$2007
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
	sta	$2007
	inx
	dey
	bne	copypal2

; �l�[���e�[�u���֓]��(��ʂ̒����t��)
	; �^�C���ԍ�
	lda #$21
	sta draw_bg_tile
	; X���W
	lda #2
	sta draw_bg_x
	; Y���W
	lda #2
	sta draw_bg_y

	;sta $2007		; ����e�X�g

	jsr SetPosition
	jsr DrawMapChip

	; �^�C���ԍ�
	lda #$41
	sta draw_bg_tile
	; X���W
	lda #2
	sta draw_bg_x
	; Y���W
	lda #4
	sta draw_bg_y

	;jsr DrawMapChip

	lda	#$23; #$21	; a���W�X�^��%21�̒l�����[�h
	sta	$2006		; %2006��a���W�X�^($21)�̒l���X�g�A
	lda	#$40; #$c9	; a���W�X�^��%c9�̒l�����[�h
	sta	$2006		; %2006��a���W�X�^($c9)�̒l���X�g�A
	; ���킹��%21c9�̒l��$2006�ɃX�g�A�Ȃ�
	ldx	#$00
;	ldy	#$0d		; 13�����\��
	ldy	#$04		; 4�����\��


	ldy	#4		; 14(10�i)BG�̕\����
	sty	loop_y

loopTo_y:
	ldy	#$10		; (16�i)
	sty	loop_x
	ldy	#$00
	sty	diff

;������s����
	ldx	loop_y
kisugusu:
	ldy	diff
	cpy	#$01		; Y�ƃ������̔�r
	bne	kisu		; ��v���Ȃ�
	dey
	dey
kisu:
	iny
	sty	diff
	dex
	bne kisugusu
	
	

loopTo_x:
	ldy	#$00
	sty	pos
	ldy	#$2
	sty	len
copymap:
	ldy	pos
	lda	string1, y	; ����������A�Ƀ��[�h���܂��B
	clc
	adc	diff
	adc	diff
	adc	diff
	adc	diff
	adc	diff
	adc	diff
	adc	diff
	adc	diff
	adc	diff
	adc	diff
	adc	diff
	adc	diff
	adc	diff
	adc	diff
	adc	diff
	adc	diff
	sta	$2007		; A���烁�����ɃX�g�A���܂�
	iny			; Y�C���N�������g
	sty	pos		; Y���烁�����ɃX�g�A���܂��B
	ldy	len
	dey			; Y�f�N�������g
	sty	len
	bne	copymap		; �[���t���O���N���A����Ă��鎞�Ƀu�����`���܂��B

	ldy	loop_x		; ����������Y�Ƀ��[�h���܂��B
	dey
	sty	loop_x
	bne	loopTo_x

	ldy	loop_y
	dey
	sty	loop_y
	bne	loopTo_y

	; �C
;	lda #$27
;	sta $2006
;	lda #$40
;	sta $2006
;	lda #$03
;	sta $2007
;	lda #$04
;	sta $2007
;	lda #$27
;	sta $2006
;	lda #$60
;	sta $2006
;	lda #$13
;	sta $2007
;	lda #$14
;	sta $2007
;	lda #$27
;	sta $2006
;	lda #$80
;	sta $2006
;	lda #$05
;	sta $2007
;	lda #$06
;	sta $2007
;
;	lda #$27
;	sta $2006
;	lda #$F0
;	sta $2006
;	lda #%00010001
;	sta $2007
;
;	lda #$27
;	sta $2006
;	lda #$F8
;	sta $2006
;	lda #%00010001
;	sta $2007

; �X�N���[���ݒ�
	lda	#$00
	sta	$2005
	sta	$2005

; �X�N���[���I��
	lda	#%10001100	; VBlank���荞�݂���
;	lda	#%00001000
	sta	$2000
	lda	#%00011110
	sta	$2001

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ���C�����[�v
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mainloop:
;	jmp	mainloop

vblank_wait:
	lda	$2002
	and	#%10000000
	beq	vblank_wait

	lda test_toggle_update
	beq test_toggle_jmp
	lda #0
	sta test_toggle_update
	;jmp not_toggle_jmp
test_toggle_jmp:
	lda #1
	sta test_toggle_update

	; �^�C���ԍ�
	lda #$01
	sta draw_bg_tile

	lda scrool_x
	and #1
	bne skip
	lda #$03
	sta draw_bg_tile
skip:
	; X���W
	lda #10
	sta draw_bg_x
	; Y���W
	lda #20
	sta draw_bg_y

	jsr SetPosition
	jsr DrawMapChip


	; X���W
	lda #5
	sta draw_bg_x
	; Y���W
	lda #0
	sta draw_bg_y
	jsr SetPosition

	; �^�C���ԍ�
	lda #$30
	sta draw_bg_tile


	; �`��

	; ��ʊO�w�i�̕`��
	jsr draw_bg
;	lda #$27
;	sta $2006
;	lda #$c0
;	sta $2006
	jsr draw_bg_attribute	; �����e�[�u��


;	lda	0
;	sta	REG0
	lda #$00   ; $00(�X�v���C�gRAM�̃A�h���X��8�r�b�g��)��A�Ƀ��[�h
	sta $2003  ; A�̃X�v���C�gRAM�̃A�h���X���X�g�A

;	jsr change_palette1	; �p���b�g�����ւ�
	;jsr	sprite_draw	; �X�v���C�g�`��֐�
	jsr	player_draw	; �v���C���[�`��֐�
	jsr InosisiDraw	; �C�m�V�V�`��֐�
;	lda	1
;	sta	REG0
;	jsr change_palette2
	;jsr	sprite_draw2	; �X�v���C�g�`��֐�(�F�ւ��e�X�g�\��)

	; �X�N���[���ʒu�X�V
	lda scrool_x
	sta	$2005		; X�����X�N���[��
	lda	#0		; Y�͌Œ�
	sta	$2005
	
	; �X�v���C�g�`��(DMA�𗘗p)
	lda #$7  ; �X�v���C�g�f�[�^��$0700�Ԓn����Ȃ̂ŁA7�����[�h����B
	sta $4014 ; �X�v���C�gDMA���W�X�^��A���X�g�A���āA�X�v���C�g�f�[�^��DMA�]������

;	lda	spd_vec
;	cmp	#0
;	bne	AddSpdSkip
;	jsr	AddSpd
;AddSpdSkip:
;	lda	spd_vec
;	cmp	#0
;	beq	SubSpdSkip
;	jsr	SubSpd
;SubSpdSkip:

	clc
	lda	#%10001100	; VBlank���荞�݂���
	adc current_draw_display_no	; ��ʂO���P
	sta	$2000
	
	jsr	sprite_update	; �X�v���C�g�X�V

not_toggle_jmp:

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


	; �^�C���ԍ�
	lda #$01
	sta draw_bg_tile

	lda scrool_x
	and #1
	bne skip
	lda #$03
	sta draw_bg_tile
skip:
	; X���W
	lda #10
	sta draw_bg_x
	; Y���W
	lda #20
	sta draw_bg_y

	jsr SetPosition
	jsr DrawMapChip


	; X���W
	lda #5
	sta draw_bg_x
	; Y���W
	lda #0
	sta draw_bg_y
	jsr SetPosition

	; �^�C���ԍ�
	lda #$30
	sta draw_bg_tile

;	lda	spd_vec
;	cmp	#0
;	bne	AddSpdSkip
;	jsr	AddSpd
;AddSpdSkip:
;	lda	spd_vec
;	cmp	#0
;	beq	SubSpdSkip
;	jsr	SubSpd
;SubSpdSkip:
	
	jsr	sprite_update	; �X�v���C�g�X�V

	; �`��

	; ��ʊO�w�i�̕`��
	jsr draw_bg				; �l�[���e�[�u��


;	lda	0
;	sta	REG0
	lda #$00   ; $00(�X�v���C�gRAM�̃A�h���X��8�r�b�g��)��A�Ƀ��[�h
	sta $2003  ; A�̃X�v���C�gRAM�̃A�h���X���X�g�A

;	jsr change_palette1	; �p���b�g�����ւ�
	;jsr	sprite_draw	; �X�v���C�g�`��֐�
	jsr	player_draw	; �v���C���[�`��֐�
	jsr InosisiDraw	; �C�m�V�V�`��֐�
;	lda	1
;	sta	REG0
;	jsr change_palette2
	;jsr	sprite_draw2	; �X�v���C�g�`��֐�(�F�ւ��e�X�g�\��)

	; �X�N���[���ʒu�X�V
	lda scrool_x
	sta	$2005		; X�����X�N���[��
	lda	#0		; Y�͌Œ�
	sta	$2005

	lda	#%10001100	; VBlank���荞�݂���
	sta	$2000

;loop:
;	jmp loop
		
	; �X�v���C�g�`��(DMA�𗘗p)
	lda #$7  ; �X�v���C�g�f�[�^��$0700�Ԓn����Ȃ̂ŁA7�����[�h����B
	sta $4014 ; �X�v���C�gDMA���W�X�^��A���X�g�A���āA�X�v���C�g�f�[�^��DMA�]������

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

; �X�v���C�g�X�V
.proc	sprite_update
	inc loop_count;
	lda #$01
	sta $4016
	lda #$00
	sta $4016

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

	jmp Nothing

Nothing:

	jsr PlayerUpdate
	jsr	InosisiUpdate

	rts	; �T�u���[�`�����畜�A���܂��B
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

	; bg_already_draw��13�{(x16-(x2 + x1))�����Ƃ��낪�X�^�[�g
	; bg_already_draw��26�{(x16+x8+x2)�����Ƃ��낪�X�^�[�g
	;				TODO : 32�{�ɂ��āA�g��Ȃ��Ƃ���͎g��Ȃ��悤�ɂ���

;	lda #1					; �e�X�g
;	sta bg_already_draw

	; 16�{
	lda #0
	sta map_chip_offset_cal16_up
	lda bg_already_draw
	sta map_chip_offset_cal16_low
	clc
;	asl map_chip_offsetcal16_up		; ���ʂ͍��V�t�g
;	rol map_chip_offset16_low		; ��ʂ͍����[�e�[�g
;	asl map_chip_offset16_up		; ���ʂ͍��V�t�g
;	rol map_chip_offset16_low		; ��ʂ͍����[�e�[�g
;	asl map_chip_offset16_up		; ���ʂ͍��V�t�g
;	rol map_chip_offset16_low		; ��ʂ͍����[�e�[�g
;	asl map_chip_offset16_up		; ���ʂ͍��V�t�g
;	rol map_chip_offset16_low		; ��ʂ͍����[�e�[�g
	lda bg_already_draw
	asl a		; ���ʂ͍��V�t�g
	asl a		; ���ʂ͍��V�t�g
	asl a		; ���ʂ͍��V�t�g
	asl a		; ���ʂ͍��V�t�g
	sta map_chip_offset_cal16_low
	lda bg_already_draw
	lsr a		; �E�փV�t�g
	lsr a
	lsr a
	lsr a
	sta map_chip_offset_cal16_up

	; 8�{
	lda #0
	sta map_chip_offset_cal8_up
	lda bg_already_draw
	sta map_chip_offset_cal8_low
	clc
;	asl map_chip_offset8_up		; ���ʂ͍��V�t�g
;	rol map_chip_offset8_low	; ��ʂ͍����[�e�[�g
;	asl map_chip_offset8_up		; ���ʂ͍��V�t�g
;	rol map_chip_offset8_low	; ��ʂ͍����[�e�[�g
;	asl map_chip_offset8_up		; ���ʂ͍��V�t�g
;	rol map_chip_offset8_low	; ��ʂ͍����[�e�[�g
	lda bg_already_draw
	asl a						; ���փV�t�g
	asl a
	asl a
	sta map_chip_offset_cal8_low
	lda bg_already_draw
	lsr a						; �E�փV�t�g
	lsr a
	lsr a
	lsr a
	lsr a
	sta map_chip_offset_cal8_up

	; 2�{
	lda #0
	sta map_chip_offset_cal2_up
	lda bg_already_draw
	sta map_chip_offset_cal2_low
	clc
;	asl map_chip_offset2_up		; ���ʂ͍��V�t�g
;	rol map_chip_offset2_low	; ��ʂ͍����[�e�[�g
	lda bg_already_draw
	asl a
	sta map_chip_offset_cal2_low
	lda bg_already_draw
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta map_chip_offset_cal2_up

	; x16 + x8 + x2
	lda #0
	sta map_chip_offset_cal_up
	sta map_chip_offset_cal_low
	clc
	lda map_chip_offset_cal8_low
	adc map_chip_offset_cal2_low
	sta map_chip_offset_cal_low
	lda map_chip_offset_cal8_up
	adc map_chip_offset_cal2_up
	sta map_chip_offset_cal_up

	clc
	lda map_chip_offset_cal16_low
	adc map_chip_offset_cal_low
	sta map_chip_offset_cal_low
	lda map_chip_offset_cal16_up
	adc map_chip_offset_cal_up
	sta map_chip_offset_cal_up

	;clc
	;lda map_chip
	;adc map_chip_offset_low
	;lda map_chip_offset_low
	;sta map_chip_offset_start

	; �Ƃ肠�������ʃr�b�g�����l����+25(������26�Ȃ̂�)����
	clc
	lda map_chip_offset_cal_low
	adc #25
	sta map_chip_offset_low
	lda map_chip_offset_cal_up
	adc #0
	sta map_chip_offset_up

; �`��

	ldy #0
	lda #3
	sta draw_bg_y	; Y���W
	lda bg_already_draw
	; bg_already_draw + 32
;	clc
;	adc #0;32				; 32�u���b�N�I�t�Z�b�g
	sta draw_bg_x	; X���W�i�u���b�N�j
;jmp skip
	jsr SetPosition
;lda #$01
;sta draw_bg_tile
;jsr DrawMapChip

	ldy #24
draw_loop:
;	sty REG0
;	sec
;	lda map_chip_offset_low
;	sbc REG0
;	sta map_chip_offset_start
	;ldy map_chip_offset_start
;	ldx map_chip_offset_start
	; lda map_chip, x
	lda (map_table_low), y
;lda	map_chip_offset_start, y
	;sta draw_bg_tile	; �^�C���ԍ�
	
	;jsr DrawMapChip
	;lda draw_bg_tile
	sta $2007



;mugen:
;jmp mugen
	
	; 26�Ɣ�r���ē������Ȃ���΃��[�v����
	;iny
	dey
;	cpy #0
	bpl	draw_loop


	; �`�悵���� bg_already_draw ��inc����
	inc bg_already_draw

	; �}�b�v�`�b�v�̋N�_��25���炷
	clc
	lda map_table_low
	adc #25
	sta map_table_low
	lda map_table_hi
	adc #0
	sta map_table_hi

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
	lda bg_already_draw_attribute
	sta draw_bg_x

	; 1�x�������W����A�h���X�����߂�
	; draw_bg_x
	; draw_bg_y
	; attribute_pos_adress_up
	; attribute_pos_adress_low
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



;mugen:
;jmp mugen
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

	jsr	player_draw	; �v���C���[�`��֐�
	jsr InosisiDraw	; �C�m�V�V�`��֐�

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
	sta	$2007
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
	sta	$2007
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

; �}�b�v�`�b�v(�l�[���e�[�u��)
map_chip: ; 26��
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

; �����e�[�u��
map_chip_attribute:
	.byte 	$05, $50, $00, $00, $00, $00, $00, $00
	.byte 	$05, $50, $00, $00, $00, $00, $00, $00
	.byte 	$05, $50, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
	.byte 	$00, $00, $00, $00, $00, $00, $00, $00
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

