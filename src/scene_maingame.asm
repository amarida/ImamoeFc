.proc scene_maingame
	; �`��
	; �Q�[���I�[�o�[�Ȃ當�����o��
;	lda is_dead
;	beq skip_dead
;	jsr DrawGameOver
;	jmp skip_end_draw
;skip_dead:

	; ��ʊO�w�i�̕`��
	jsr draw_bg				; �l�[���e�[�u��
	jsr draw_bg_attribute	; �����e�[�u��
	
;skip_end_draw:


;	lda	0
;	sta	REG0
	lda #$00   ; $00(�X�v���C�gRAM�̃A�h���X��8�r�b�g��)��A�Ƀ��[�h
	sta $2003  ; A�̃X�v���C�gRAM�̃A�h���X���X�g�A

;	lda #00
;	sta $2004		;Y
;	lda #01
;	sta $2004		;�ԍ�
;	lda #0
;	sta $2004
;	lda #8
;	sta $2004		;X

	;jsr	sprite_draw	; �X�v���C�g�`��֐�
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


	jsr	sprite_draw2	; �X�v���C�g�`��֐�(�F�ւ��e�X�g�\��)

	; �X�N���[���ʒu�X�V
	lda scrool_x
	sta	$2005		; X�����X�N���[��
	lda	#0		; Y�͌Œ�
	sta	$2005
	
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
	lda #$6  ; �X�v���C�g�f�[�^��$0700�Ԓn����Ȃ̂ŁA7�����[�h����B
	sta $4014 ; �X�v���C�gDMA���W�X�^��A���X�g�A���āA�X�v���C�g�f�[�^��DMA�]������
	jmp dma_break
dma_break:

	clc
	lda	#%10001100	; VBlank���荞�݂���
	adc current_draw_display_no	; ��ʂO���P
	sta	$2000
	
	jsr	Update	; �X�V

	rts
.endproc
