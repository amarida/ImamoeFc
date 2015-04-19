.proc	PlayerInit
	lda #0
	sta chr_lr
	rts
.endproc

; A
.proc	PlayerJump
	; ジャンプ中なら抜ける
	;lda	#1
	;cmp	is_jump
	lda is_jump
	bne	End
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

	; 画面の左端なら左移動しない
	sec
	lda player_x_low
	sbc field_scrool_x_low
	sbc #9
	bcc skip; キャリーフラグがクリアされている時

	sec					; キャリーフラグON
	lda	player_x_low	; 下位
	sbc	#1
	sta	player_x_low

	lda	player_x_up		; 上位
	sbc	#0
	sta	player_x_up

	lda #1
	sta chr_lr

skip:

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

	; スクロール座標とキャラクタ座標の差が
	; 127以下はスクロール座標を更新しない
	sec
	lda player_x_low
	sbc field_scrool_x_low
	sec
	sbc #127
	bcc skip	; キャリーフラグがクリアされている時

	; 上位が0かつ下位が127以下
	;lda #0
	;cmp player_x_up
;	lda player_x_up
;	bne no_skip
	
	;sec
	;lda player_x_low
	;sbc #127
;	clc
;	lda player_x_low
;	asl	; 左シフト
;	bcs no_skip

;	jmp skip
;no_skip:

	; スクロール情報
	clc
	lda scrool_x
	adc #1
	sta scrool_x

	clc
	lda field_scrool_x_low
	adc #1
	sta field_scrool_x_low

	bcc eor_skip
	lda #%00000001
	eor current_draw_display_no
	sta current_draw_display_no
eor_skip:

	lda field_scrool_x_up
	adc #0
	sta field_scrool_x_up

skip:

;	inc player_x;
	lda #0
	sta chr_lr
	rts
.endproc

; 更新
.proc	PlayerUpdate
	; ジャンプ中確認
;	lda	#1
;	cmp	is_jump
;	bne	End
	lda	is_jump
	beq	End
	; ジャンプ中処理
	jsr	PlayerUpdateJump

End:
	rts
.endproc

; ジャンプ中処理
.proc	PlayerUpdateJump
	; 小数部の引き算
	sec			; キャリーフラグON
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

	; プレイヤーの位置を地面に合わせる
	lda FIELD_HEIGHT
	sta player_y

End:

	rts
.endproc

; 描画
.proc	player_draw
	;REG0 = (p_pat == 0) ? 2 : 0;

	ldx #2
	lda p_pat
	bne	Pat1
	ldx #0
Pat1:
	stx REG0


	; REG0 = (is_jump == 0) ? #$40 : #0;
	; ジャンプ中
	ldx #$40
	lda is_jump
	bne ContinueJmp
	ldx REG0
ContinueJmp:
	stx REG0

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

	; REG1 = (chr_lr == 0) ? #%00000000 : #%01000000;
	; REG2 = (chr_lr == 0) ? window_player_x_low8 : window_player_x_low;
	; REG3 = (chr_lr == 0) ? window_player_x_low : window_player_x_low8;
	; 左右判定
	lda #%01000000
	sta REG1
	lda window_player_x_low
	sta REG2
	lda window_player_x_low8
	sta REG3

	lda chr_lr
	bne ContinueLR

	lda #%00000000
	sta REG1
	lda window_player_x_low8
	sta REG2
	lda window_player_x_low
	sta REG3

ContinueLR:


	sec			; キャリーフラグON
	lda player_y
	sbc #32
	sta player1_y;
	sta player2_y;
	clc
	lda #$80     ; 21をAにロード
	adc REG0
	sta player1_t
	lda REG1;#%00000000     ; 0(10進数)をAにロード
	sta player1_s
	sta player2_s
	sta player3_s
	sta player4_s
	sta player5_s
	sta player6_s
	sta player7_s
	sta player8_s
	lda REG2; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta player1_x
	sta player3_x
	sta player5_x
	sta player7_x

	clc
	lda #$81     ; 21をAにロード
	adc REG0
	sta player2_t
	lda REG3; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta player2_x
	sta player4_x
	sta player6_x
	sta player8_x

	sec			; キャリーフラグON
	lda player_y
	sbc #24
	sta player3_y;
	sta player4_y;
	clc
	lda #$90     ; 21をAにロード
	adc REG0
	sta player3_t

	clc
	lda #$91     ; 21をAにロード
	adc REG0
	sta player4_t

	sec			; キャリーフラグON
	lda player_y
	sbc #16
	sta player5_y;
	sta player6_y;
	clc
	lda #$A0     ; 21をAにロード
	adc REG0
	sta player5_t

	clc
	lda #$A1     ; 21をAにロード
	adc REG0
	sta player6_t

	sec			; キャリーフラグON
	lda player_y
	sbc #8
	sta player7_y;
	sta player8_y;
	clc
	lda #$B0     ; 21をAにロード
	adc REG0
	sta player7_t

	clc
	lda #$B1     ; 21をAにロード
	adc REG0
	sta player8_t
	lda REG1     ; 0(10進数)をAにロード
	sta player8_s

	dec pat_change_frame
	;lda	#10
	;cmp pat_change_frame
	lda pat_change_frame
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

	lda	#10
	sta	pat_change_frame

	rts
.endproc

; あたり判定
.proc collision

	rts
.endproc
