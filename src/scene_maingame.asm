.proc scene_maingame


	; ��ʊO�w�i�̕`��
	jsr draw_bg				; �l�[���e�[�u��
	jsr draw_bg_attribute	; �����e�[�u��
	jsr DrawStatus

	lda loop_count
	and #%00000001
	bne player_dma7
	beq player_dma6
player_dma7:
	jsr	player_draw_dma7	; �v���C���[�`��֐�
	jsr InosisiDrawDma7	; �C�m�V�V�`��֐�
	jmp player_dma_break
player_dma6:
	jsr	player_draw_dma6	; �v���C���[�`��֐�
	jsr InosisiDrawDma6	; �C�m�V�V�`��֐�
	jmp player_dma_break
player_dma_break:


;	jsr	sprite_draw2	; �X�v���C�g�`��֐�(�F�ւ��e�X�g�\��)

	
	lda loop_count
	and #%00000001
	bne dma7
	beq dma6
dma7:
	; �X�v���C�g�`��(DMA�𗘗p)
	lda #$7  ; �X�v���C�g�f�[�^��$0700�Ԓn����Ȃ̂ŁA7�����[�h����B
	sta $4014 ; �X�v���C�gDMA���W�X�^��A���X�g�A���āA�X�v���C�g�f�[�^��DMA�]������
	jmp dma_break
dma6:
	lda #$6  ; �X�v���C�g�f�[�^��$0600�Ԓn����Ȃ̂ŁA6�����[�h����B
	sta $4014 ; �X�v���C�gDMA���W�X�^��A���X�g�A���āA�X�v���C�g�f�[�^��DMA�]������
	jmp dma_break
dma_break:

	lda $2002		; �X�N���[���l�N���A
	lda #$00
	sta $2005		; X�����X�N���[��
	lda #$00		; Y�����Œ�
	sta $2005

;jmp r_skip
waitZeroSpriteClear:
	lda $2002
	and #$40
	bne waitZeroSpriteClear
waitZeroSpriteHit:
	lda $2002
	and #$40
	beq waitZeroSpriteHit
r_skip:

	jsr waitScan

	; �X�N���[���ʒu�X�V
	lda $2002		; �X�N���[���l�N���A
	lda scroll_x
	sta	$2005		; X�����X�N���[��
	lda	#0		; Y�͌Œ�
	sta	$2005

	clc
	lda #%10001100	; VBlank���荞�݂���
	adc current_draw_display_no	; ��ʂO���P
	sta $2000
	
	jsr	Update	; �X�V

	rts
.endproc

.proc waitScan			; ���������҂�
	ldx #167
waitScanSub:
	dex
	bne waitScanSub
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

	lda #0
	sta key_state_on

	; A,B,SELECT,START,UP,DOWN,LEFT,RIGHT�̏���
	lda $4016	; A
	and #1
	beq SkipPushA
	lda key_state_on
	ora #%00000001
	sta key_state_on
	;jsr PlayerJump
SkipPushA:
	lda $4016	; B
	and #1
	beq SkipPusyB
	lda key_state_on
	ora #%00000010
	sta key_state_on
SkipPusyB:
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

	lda key_state_push
	and #%00000001
	bne Jump
	lda key_state_push
	and #%00000010
	bne Attack
	jmp break
	
Jump:
	jsr PlayerJump
	jmp break
Attack:
	jsr PlayerAttack
	jmp break

break:

	jsr Player_Update
	jsr	InosisiUpdate

	jsr confirm_appear_enemy

	rts	; �T�u���[�`�����畜�A���܂��B
.endproc

; �G�o��m�F
.proc confirm_appear_enemy
	; �X�N���[���ʒu���B���Ă�����
	; �G��o�ꂳ���āA�o��ς݃t���O�𗧂Ă�

	lda field_scroll_x_up
	sta field_scroll_x_up_tmp
	lda field_scroll_x_low
	sta field_scroll_x_low_tmp

	clc
	lda field_scroll_x_low_tmp
	adc #255
	sta field_scroll_x_low_tmp
	lda field_scroll_x_up_tmp
	adc #0
	sta field_scroll_x_up_tmp

	ldy #0
	lda (map_enemy_info_address_low), y
	sta enemy_pos_x_hi
	; ��ʂ̔�r�ŒB���Ă��邩
	sec
	lda field_scroll_x_up_tmp
	sbc enemy_pos_x_hi
	bcc appear_skip	; �L�����[�t���O���N���A�i���߁j����Ă���ꍇ

	iny
	lda (map_enemy_info_address_low), y
	sta enemy_pos_x_low
	; ���ʂ̔�r�ŒB���Ă��邩
	sec
	lda field_scroll_x_low_tmp
	sbc enemy_pos_x_low
	bcc appear_skip	; �L�����[�t���O���N���A�i���߁j����Ă���ꍇ

	iny
	lda (map_enemy_info_address_low), y
	sta enemy_pos_y
	iny
	lda (map_enemy_info_address_low), y
	sta enemy_type

	; �G�L�����N�^�[�̓o��
	jsr appear_enemy

	; �A�h���X��4���炷
	clc
	lda map_enemy_info_address_low
	adc #4
	sta map_enemy_info_address_low
	lda map_enemy_info_address_hi
	adc #0
	sta map_enemy_info_address_hi

appear_skip:

	rts
.endproc

; �G�L�����N�^�[�̓o��
.proc appear_enemy
;enemy_pos_x_low						= $C2
;enemy_pos_x_hi						= $C3
;enemy_pos_y							= $C4
;enemy_type							= $C5
	jsr appear_inosisi
	
	rts
.endproc

; �X�e�[�^�X���̕`��
.proc DrawStatus

	lda current_draw_display_no
	sta REG2
	lda #1
	sta current_draw_display_no

	lda #1
	sta REG0

	lda $2000
	sta REG1
;	and #%11111011
;	sta $2000

;	lda #2
;	sta draw_bg_y	; Y���W�i�u���b�N�j
;	lda #1	; X���W�i�u���b�N�j
;	sta draw_bg_x	; X���W�i�u���b�N�j
;	jsr SetPosition
	; LIFE
	lda #$20
	sta $2006
	lda #$61
	sta $2006
	ldx #0
	lda string_life, x
	sta $2007
	lda #$20
	sta $2006
	lda #$62
	sta $2006
	inx
	lda string_life, x
	sta $2007
	lda #$20
	sta $2006
	lda #$63
	sta $2006
	inx
	lda string_life, x
	sta $2007
	lda #$20
	sta $2006
	lda #$64
	sta $2006
	inx
	lda string_life, x
	sta $2007

	; ��ʂP���Q�̐ݒ��߂�
	lda REG2
	sta current_draw_display_no

	; ���䃌�W�X�^��߂�
	lda REG1
	;sta $2000


	rts
.endproc

; �Œ�X�e�[�^�X���̕`��
.proc SetStatus

	lda current_draw_display_no
	sta REG2
	lda #1
	sta current_draw_display_no

	lda #1
	sta REG0

	lda $2000
	sta REG1

	; SCORE
	lda #$20
	sta $2006
	lda #$6A
	sta $2006
	ldx #0
	lda string_score, x
	sta $2007
	lda #$20
	sta $2006
	lda #$6B
	sta $2006
	inx
	lda string_score, x
	sta $2007
	lda #$20
	sta $2006
	lda #$6C
	sta $2006
	inx
	lda string_score, x
	sta $2007
	lda #$20
	sta $2006
	lda #$6D
	sta $2006
	inx
	lda string_score, x
	sta $2007
	lda #$20
	sta $2006
	lda #$6E
	sta $2006
	inx
	lda string_score, x
	sta $2007


	rts
.endproc
