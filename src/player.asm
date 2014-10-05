.proc	PlayerInit
	lda #0
	sta chr_lr
	rts
.endproc

; A
.proc	PlayerJump
	; ジャンプ中なら抜ける
	lda	#1
	cmp	is_jump
	beq	End
	;inc	player_y

	; ジャンプフラグON
	lda	#1
	sta	is_jump

	; 速度と方向をセット
	lda	#10
	sta	spd_y

	;lda	#1
	;sta	spd_vec

End:
	rts
.endproc

; 上移動
.proc	PlayerMoveUp
	;dec player_y;
	rts
.endproc

; 下移動
.proc	PlayerMoveDown
	;inc player_y;
	rts
.endproc

; 左移動
.proc	PlayerMoveLeft
	sec					; キャリーフラグON
	lda	player_x_low	; 下位
	sbc	#1
	sta	player_x_low

	lda	player_x_up		; 上位
	sbc	#0
	sta	player_x_up

	; 上位が0かつ下位が127以下
	lda #0
	cmp player_x_up
	bne no_skip
	
	;sec
	;lda player_x_low
	;sbc #127
	clc
	lda player_x_low
	asl	; 左シフト
	bcs no_skip

	jmp skip
no_skip:

	; スクロール情報
	sec
	lda scrool_x
	sbc #1
	sta scrool_x

	; フィールドスクロール情報
	sec
	lda field_scrool_x_low
	sbc #1
	sta field_scrool_x_low
	

skip:

;	dec player_x;
	lda #1
	sta chr_lr
	rts
.endproc

; 右移動
.proc	PlayerMoveRight
	clc					; キャリーフラグOFF
	lda	player_x_low	; 下位
	adc	#1
	sta	player_x_low

	lda	player_x_up		; 上位
	adc	#0
	sta	player_x_up

	; 上位が0かつ下位が127以下
	lda #0
	cmp player_x_up
	bne no_skip
	
	;sec
	;lda player_x_low
	;sbc #127
	clc
	lda player_x_low
	asl	; 左シフト
	bcs no_skip

	jmp skip
no_skip:

	; スクロール情報
	clc
	lda scrool_x
	adc #1
	sta scrool_x

	clc
	lda field_scrool_x_low
	adc #1
	sta field_scrool_x_low

skip:

;	inc player_x;
	lda #0
	sta chr_lr
	rts
.endproc

; 更新
.proc	PlayerUpdate
	; ジャンプ中確認
	lda	#1
	cmp	is_jump
	bne	End
	; ジャンプ中処理
	jsr	PlayerUpdateJump

End:
	rts
.endproc

; ジャンプ中処理
.proc	PlayerUpdateJump
	; 小数部の引き算
	sec			; キャリーフラグOFF
	lda	player_y+1	; メモリからAにロードします
	sbc	spd_y+1		; 減算
	sta	player_y+1	; Aからメモリにストアします

	; 実数部の引き算
	lda	player_y
	sbc	spd_y
	sta	player_y

	; 速度の減速
	; 小数部の減速
	sec			; キャリーフラグON
	lda	spd_y+1
	sbc	#$80
	sta	spd_y+1
	; 実数部の減速
	lda	spd_y
	sbc	#$0
	sta	spd_y

	; ジャンプ終了判定、地面の位置
	lda	FIELD_HEIGHT
	sbc	player_y
	bpl	End			; ネガティブフラグがクリアされている時

	; ジャンプフラグを落とす
	lda	#0
	sta	is_jump
	lda FIELD_HEIGHT
	sta player_y

End:

	rts
.endproc

; 描画
.proc	player_draw
	; アニメパターン
	lda	#1
	cmp	p_pat
	beq	Pat1
	lda	#0
	cmp	p_pat
	beq	Pat2
Pat1:
	lda #0
	sta REG0
	jmp Continue
Pat2:
	lda #2
	sta REG0
	jmp Continue
Continue:

	; ジャンプ中
	lda #0
	cmp is_jump
	beq ContinueJmp
	lda #$40
	sta REG0
ContinueJmp:

	; フィールドプレイヤー位置 - フィールドスクロール位置
	sec
	lda player_x_low
	sbc field_scrool_x_low
	sta window_player_x_low
	;lda player_x_up
	;sbc field_scrool_x_up
	;sta window_player_x_up
	sec
	lda window_player_x_low
	sbc #8
	sta window_player_x_low8

	; 左右判定
	lda #0
	cmp chr_lr
	beq Right
	bne Left
Right:
	lda #%00000000
	sta REG1
	lda window_player_x_low8;#120
	sta REG2
	lda window_player_x_low;#128
	sta REG3
	jmp ContinueLR
Left:
	lda #%01000000
	sta REG1
	lda window_player_x_low;#128
	sta REG2
	lda window_player_x_low8;#120
	sta REG3
	jmp ContinueLR
ContinueLR:


	sec			; キャリーフラグON
	lda player_y
	sbc #32
	sta $2004   ; Y座標をレジスタにストアする
	clc
	lda #$80     ; 21をAにロード
	adc REG0
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda REG1;#%00000000     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	lda REG2; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda player_y
	sbc #32
	sta $2004   ; Y座標をレジスタにストアする
	clc
	lda #$81     ; 21をAにロード
	adc REG0
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda REG1     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	lda REG3; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda player_y
	sbc #24
	sta $2004   ; Y座標をレジスタにストアする
	clc
	lda #$90     ; 21をAにロード
	adc REG0
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda REG1     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	lda REG2; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda player_y
	sbc #24
	sta $2004   ; Y座標をレジスタにストアする
	clc
	lda #$91     ; 21をAにロード
	adc REG0
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda REG1     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	lda REG3; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda player_y
	sbc #16
	sta $2004   ; Y座標をレジスタにストアする
	clc
	lda #$A0     ; 21をAにロード
	adc REG0
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda REG1     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	lda REG2; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda player_y
	sbc #16
	sta $2004   ; Y座標をレジスタにストアする
	clc
	lda #$A1     ; 21をAにロード
	adc REG0
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda REG1     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	lda REG3; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda player_y
	sbc #8
	sta $2004   ; Y座標をレジスタにストアする
	clc
	lda #$B0     ; 21をAにロード
	adc REG0
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda REG1     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	lda REG2; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda player_y
	sbc #8
	clc
	sta $2004   ; Y座標をレジスタにストアする
	lda #$B1     ; 21をAにロード
	adc REG0
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda REG1     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	lda REG3; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta $2004   ; X座標をレジスタにストアする

	inc pat_change_frame
	lda	#10
	cmp pat_change_frame
	beq change_pat

;End:
	rts

.endproc

; パターン切り替え
.proc	change_pat
	; p_patの0,1反転
	sec			; キャリーフラグON
	lda	#1
	sbc p_pat
	sta p_pat

	lda	#0
	sta	pat_change_frame

	rts
.endproc
