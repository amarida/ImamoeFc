.proc scene_gameover
	jsr DrawGameOver

	; �X�N���[���ʒu�X�V
	lda #0
	sta	$2005		; X�����X�N���[��
	lda	#0		; Y�͌Œ�
	sta	$2005

	rts
.endproc
