.proc	PlayerInit
	lda #0
	sta chr_lr
	sta is_dead
	sta update_dead_step
	sta player_draw_status
	sta item_count
	rts
.endproc

; A
.proc	PlayerJump
	; ジャンプ中なら抜ける
	lda is_jump
	bne	End
	lda is_dead
	bne End

	; ジャンプフラグON
	lda	#1
	sta	is_jump

	; ジャンプ
	lda #1
	sta player_draw_status

	; 速度と方向をセット
	lda	#6;#10
	sta	spd_y

	lda	#1		; 速度上方向
	sta	spd_vec

	jsr Sound_PlayJump
End:
	rts
.endproc

; B
.proc	PlayerAttack
	
	; はばタンが居ればファイアー
	lda habatan_alive_flag
	beq skip_haba_fire
	lda habatan_status
	cmp #1
	bne skip_haba_fire
	jsr HabatanFire_Appear
	jsr Sound_PlayFire

	jmp exit

	skip_haba_fire:
	
	; それ以外は吹き戻し
	; 攻撃
	lda #2
	sta player_draw_status
	lda #0
	sta attack_frame
	; 吹き戻しSE
	jsr Sound_PlayFukimodoshi

exit:
	rts
.endproc

; 上移動
.proc	PlayerMoveUp
	rts
.endproc

; 下移動
.proc	PlayerMoveDown
	rts
.endproc

; 左移動
.proc	PlayerMoveLeft
	lda is_dead
	bne skip

	; 画面の左端なら左移動しない
	sec
	lda player_x_low
	sbc field_scroll_x_low
;	sbc #9
;	bcc skip; キャリーフラグがクリアされている時
	beq skip; ゼロフラグが立っていないときスキップ

	sec					; キャリーフラグON
	lda player_x_decimal
	sbc player_spd_decimal
	sta player_x_decimal
	lda	player_x_low	; 下位
	sbc	player_spd_low
	sta	player_x_low

	lda	player_x_hi		; 上位
	sbc	#0
	sta	player_x_hi

	lda #1
	sta chr_lr

	; あたり判定
	jsr collision_object
	lda obj_collision_result
	beq skip

	clc
	lda player_x_low
	adc #1
	sta player_x_low
	lda player_x_hi
	adc #0
	sta player_x_hi
skip:

	rts
.endproc

; 右移動
.proc	PlayerMoveRight
	lda is_dead
	beq skip_skip
	jmp skip
	skip_skip:

	lda habatan_fire_alive_flag
	beq skip_skip2
	jmp skip
	skip_skip2:

	clc					; キャリーフラグOFF
	lda player_x_decimal
	adc player_spd_decimal
	sta player_x_decimal
	lda	player_x_low	; 下位
	adc	player_spd_low
	sta	player_x_low

	lda	player_x_hi		; 上位
	adc	#0
	sta	player_x_hi

	; あたり判定
	jsr collision_object
	lda obj_collision_result
	beq roll_skip

	sec
	lda player_x_low
	sbc #1
	sta player_x_low
	lda player_x_hi
	sbc #0
	sta player_x_hi
	jmp skip
roll_skip:

	; スクロール座標とキャラクタ座標の差が
	; 127以下はスクロール座標を更新しない
	sec
	lda player_x_low
	sbc field_scroll_x_low
	sec
	sbc #127
	bcc skip	; キャリーフラグがクリアされている時

	; スクロール情報
	clc
	lda scroll_x
	adc #1
	sta scroll_x

	inc scroll_count_8dot
	lda scroll_count_8dot
	cmp #8
	bne skip_scroll_count_8dot_off
	lda #0
	sta scroll_count_8dot
	inc scroll_count_8dot_count	
skip_scroll_count_8dot_off:

	inc scroll_count_32dot
	lda scroll_count_32dot
	cmp #32
	bne skip_scroll_count_32dot_off
	lda #0
	sta scroll_count_32dot
	inc scroll_count_32dot_count
skip_scroll_count_32dot_off:

	; スクロール情報の更新
	clc
	lda field_scroll_x_low
	adc #1
	sta field_scroll_x_low

	bcc eor_skip
	lda #%00000001
	eor current_draw_display_no
	sta current_draw_display_no
eor_skip:

	lda field_scroll_x_hi
	adc #0
	sta field_scroll_x_hi

skip:

;	inc player_x;
	lda #0
	sta chr_lr
	rts
.endproc

.proc	PlayerDead
	; 死亡フラグON
	lda	#1
	sta	is_dead

	; ジャンプフラグOFF
	lda #0
	sta is_jump

	; 死亡
	lda #4
	sta player_draw_status

	rts
.endproc

; 更新
.proc	Player_Update
	; 死亡中
	;	ステップ
	;	止まる
	;	上に飛ぶ
	; ジャンプ中
	; ジャンプ中じゃない処理

	; 上記にかかわらず通る処理


	; 死亡中の処理
	lda is_dead
	beq skip_dead
	jsr Player_UpdateDead
skip_dead:

	; ジャンプ中確認
	lda	is_jump
	beq	skip_jump
	; ジャンプ中処理
	jsr	Player_UpdateJump
skip_jump:

	; ジャンプ中じゃない
	lda	is_jump
	bne	skip_not_jump
	lda is_dead
	bne skip_not_jump
	; 重力
	clc
	lda #1
	adc player_y
	sta player_y
	; あたり判定処理
	jsr collision_object

	; あたり判定フラグ
	lda obj_collision_result
	beq roll_skip
	; 当たった処理

	; ジャンプ中なら通常
	lda is_jump
	beq skip_nomal
	lda #0
	sta player_draw_status
skip_nomal:

	; 小数部は0
	lda #0
	sta player_y+1

	;下の処理
	sec
	lda player_y
	and #%11111000
	sta player_y
	; ジャンプフラグを落とす
	lda is_jump
	beq skip_jump_off
	lda	#0
	sta	is_jump
skip_jump_off:



	lda #0
	sta spd_y
	sta spd_y+1
	jmp not_jump_exit
	
roll_skip:
	; 戻さない＝自由落下開始
	lda #1
	sta is_jump
	; ジャンプ
	lda #1
	sta player_draw_status

	; 速度と方向をセット
	lda	#0
	sta	spd_y
	sta spd_y+1

	lda	#0		; 速度下方向
	sta	spd_vec

not_jump_exit:
skip_not_jump:

	; その他の必ず通る処理

	; 速度変化更新
	jsr Player_UpdateSpeed

	lda player_draw_status
	cmp #0	; 通常
	beq case_nomal
	cmp #1	; ジャンプ
	beq case_jump
	cmp #2	; 攻撃中1
	beq case_attack1
	cmp #3	; 攻撃中2
	beq case_attack2
	cmp #4	; 死亡
	beq case_dead
	jmp break_status

case_nomal:
	jmp break_status
case_jump:
	jmp break_status
case_attack1:
	inc attack_frame
	lda attack_frame
	cmp #10
	bne break_status
	lda #3
	sta player_draw_status
	jmp break_status
case_attack2:
	inc attack_frame
	lda attack_frame
	cmp #20
	bne break_status
	lda #0
	sta player_draw_status
	jmp break_status
case_dead:

break_status:

	; 海あたりフラグ
	lda obj_collision_sea
	beq skip_first_sea_hit
	lda is_dead					; 死亡フラグ
	bne skip_first_sea_hit
	; 海あたりかつ生きている場合
	; 初回処理と死亡フラグを立てる
	jsr PlayerDead
	
skip_first_sea_hit:


	; 敵とのあたり判定
	jsr collision_char
	lda is_dead					; 死亡フラグ
	eor #1						; is_deadを反転
	and char_collision_result	; あたり判定とand
	; あたりかつ生きている場合
	; 初回処理と死亡フラグを立てる
	beq skip_first_hit
	jsr PlayerDead
	
skip_first_hit:

	; アイテム当たり判定
	jsr collision_item
	lda char_collision_result
	beq not_get
	jsr Item_GetAction
	not_get:

	rts
.endproc

; ジャンプ中処理
.proc	Player_UpdateJump
	lda spd_vec
	; 0なら足し算へ
	beq tashizan
	;; 引き算 begin
	; 小数部の引き算
	sec			; キャリーフラグON
	lda	player_y+1	; メモリからAにロードします
	sbc	spd_y+1		; 減算
	sta	player_y+1	; Aからメモリにストアします

	; 実数部の引き算
	lda	player_y
	sbc	spd_y
	sta	player_y

	; 速度の減算
	; 小数部の減速
	sec			; キャリーフラグON
	lda	spd_y+1
	sbc	#$40
	sta	spd_y+1
	; 実数部の減速
	lda	spd_y
	sbc	#$0
	sta	spd_y
	; 実数部がマイナスになったら
	bpl	skip_negative_proc; ネガティブフラグがクリアされている
	; 速度がマイナスになったので、速度方向を下にする
	lda #0
	sta spd_vec
	sta spd_y
	sta spd_y+1

skip_negative_proc:

	jmp skip_tashizan
	;; 引き算 end

	;; 足し算
tashizan:
	; 小数部の足し算
	clc			; キャリーフラグOFF
	lda	player_y+1	; メモリからAにロードします
	adc	spd_y+1		; 加算
	sta	player_y+1	; Aからメモリにストアします

	; 実数部の足し算
	lda	player_y
	adc	spd_y
	sta	player_y

	; 速度も足し算
	; 小数部の加算
	clc			; キャリーフラグOFF
	lda	spd_y+1
	adc	#$40
	sta	spd_y+1
	; 実数部の加算
	lda	spd_y
	adc	#$0
	sta	spd_y

	; 速度の上限を8とする
	lda spd_y
	cmp #8
	bne skip_an_upper_limit
	lda #8
	sta spd_y
	lda #0
	sta spd_y+1
skip_an_upper_limit:

skip_tashizan:

	; あたり判定
	jsr collision_object
	lda obj_collision_result
	;lda #0
	beq roll_skip
	; 上で当たったら、8の余剰を切り捨てて7加える、速度を0にする
	; 下で当たったら、8の余剰を切り捨てて1引く、速度を0にする

	; 小数部は0
	lda #0
	sta player_y+1

	; 上で当たったか、下で当たったか
	lda obj_collision_pos
	beq shita
	;上の処理
	clc
	lda player_y
	and #%11111000
	adc #8
	sta player_y
	jmp end
shita:
	;下の処理
	sec
	lda player_y
	and #%11111000
	sta player_y
	; ジャンプフラグを落とす
	lda	#0
	sta	is_jump

	; 通常
	lda #0
	sta player_draw_status
end:
	lda #0
	sta spd_y
	sta spd_y+1
	
roll_skip:

	; 死んでたら224で止める
	lda is_dead
	cmp #1
	bne dead_stop_skip
	sec
	lda #224
	sbc player_y
	bcs dead_stop_skip	; キャリーフラグセットされている
	lda #224
	sta player_y
dead_stop_skip:

	rts
.endproc

; 死亡時更新
.proc	Player_UpdateDead
;	enum {
;		step_init,
;		step_stop,
;		step_jump,
;		step_wait,
;	};
;	switch(m_step) {
;	case step_init:
;		m_step++;
;		break;
;	case step_stop:
;		m_step++;
;		break;
;	case step_jump:
;		m_step++;
;		break;
;	case step_wait:
;		m_step++;
;		break;
;	}

	lda update_dead_step
	cmp #0
	beq case_init
	cmp #1
	beq case_stop
	cmp #2
	beq case_jump
	cmp #3
	beq case_wait

case_init:
	; 処理0
	inc update_dead_step
	jmp break;
case_stop:
	; 処理1
	lda #30
	sta wait_frame
	inc update_dead_step
	jmp break;
case_jump:
	; 処理2
	dec wait_frame
	bne break
	lda #1
	sta is_jump

	; 速度と方向をセット
	lda	#6;#10
	sta	spd_y

	lda	#1		; 速度上方向
	sta	spd_vec
	inc update_dead_step
	jmp break;
case_wait:
	; 処理3
	sec
	lda #224
	cmp player_y
	bne break
	lda #4					; ゲームオーバー
	sta scene_type			; シーン
	lda #0
	sta scene_update_step	; シーン内ステップ

	inc update_dead_step
	jmp break;

break:



	rts
.endproc

.proc player_draw_dma7_attack1
	ldx #2
	stx REG0
	; 吹き戻し
	clc			; キャリーフラグOFF
	lda player_y
	adc #21
	sta playerFuki1_y
	sta playerFuki2_y
	lda #$0C
	sta playerFuki1_t
	lda #$0D
	sta playerFuki2_t

	lda chr_lr
	cmp #0
	beq case_attack1_right
	cmp #1
	beq case_attack1_left

case_attack1_right:
	lda #%00000000
	sta playerFuki1_s
	sta playerFuki2_s
	clc			; キャリーフラグOFF
	lda window_player_x_low
	adc #12
	sta playerFuki1_x
	clc			; キャリーフラグOFF
	lda window_player_x_low
	adc #20
	sta playerFuki2_x

	jmp break_fuki_attack1
case_attack1_left:
	lda #%01000000
	sta playerFuki1_s
	sta playerFuki2_s
	sec			; キャリーフラグON
	lda window_player_x_low
	sbc #4
	sta playerFuki1_x
	sec			; キャリーフラグON
	lda window_player_x_low
	sbc #12
	sta playerFuki2_x

	jmp break_fuki_attack1

break_fuki_attack1:


	rts
.endproc

.proc player_draw_dma7_attack2
	ldx #0
	stx REG0
	; 吹き戻し
	clc			; キャリーフラグOFF
	lda player_y
	adc #21
	sta playerFuki1_y
	lda #232	; 画面外
	sta playerFuki2_y
	lda #$1D
	sta playerFuki1_t

	lda chr_lr
	cmp #0
	beq case_attack2_right
	cmp #1
	beq case_attack2_left

case_attack2_right:
	lda #%00000000
	sta playerFuki1_s
;	sta playerFuki2_s
	clc			; キャリーフラグOFF
	lda window_player_x_low
	adc #12
	sta playerFuki1_x
	jmp break_fuki_attack2
case_attack2_left:
	lda #%01000000
	sta playerFuki1_s
;	sta playerFuki2_s
	sec			; キャリーフラグON
	lda window_player_x_low
	sbc #4
	sta playerFuki1_x

	jmp break_fuki_attack2

break_fuki_attack2:

	rts
.endproc	; player_draw_dma7_attack2


; 描画
.proc	player_draw_dma7
	; フィールドプレイヤー位置 - フィールドスクロール位置
	sec
	lda player_x_low
	sbc field_scroll_x_low
	sta window_player_x_low

	clc
	lda window_player_x_low
	adc #8
	sta window_player_x_low8

	;						右向き			左向き
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


	lda #232	; 画面外
	sta playerFuki1_y
	sta playerFuki2_y


	lda player_draw_status
	cmp #0	; 通常
	beq case_nomal
	cmp #1	; ジャンプ
	beq case_jump
	cmp #2	; 攻撃中1
	beq case_attack1
	cmp #3	; 攻撃中2
	beq case_attack2
	cmp #4	; 死亡
	beq case_dead

; 通常
case_nomal:
	;REG0 = (p_pat == 0) ? 2 : 0;
	ldx #2
	lda p_pat
	bne	Pat1
	ldx #0
Pat1:
	stx REG0

	jmp break

; ジャンプ
case_jump:
	ldx #$40
	stx REG0

	jmp break

; 攻撃中1
case_attack1:
	jsr player_draw_dma7_attack1

	jmp break

; 攻撃中2
case_attack2:
	jsr player_draw_dma7_attack2

	jmp break

; 死亡
case_dead:
	ldx #$42
	stx REG0

	jmp break
break:




	clc			; キャリーフラグOFF
	lda player_y
	adc #7
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

	lda REG3; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta player1_x
	sta player3_x
	sta player5_x
	sta player7_x

	clc
	lda #$81     ; 21をAにロード
	adc REG0
	sta player2_t
	lda REG2; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta player2_x
	sta player4_x
	sta player6_x
	sta player8_x

	clc			; キャリーフラグOFF
	lda player_y
	adc #15
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

	clc			; キャリーフラグOFF
	lda player_y
	adc #23
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

	clc			; キャリーフラグOFF
	lda player_y
	adc #31
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

	dec pat_change_frame
	;lda	#10
	;cmp pat_change_frame
	lda pat_change_frame
	bne change_pat_skip
	jsr change_pat

change_pat_skip:
;End:
	rts

.endproc

.proc player_draw_dma6_attack1
	ldx #2
	stx REG0
	; 吹き戻し
	clc			; キャリーフラグOFF
	lda player_y
	adc #21
	sta playerFuki1_y2
	sta playerFuki2_y2
	lda #$0C
	sta playerFuki1_t2
	lda #$0D
	sta playerFuki2_t2

	lda chr_lr
	cmp #0
	beq case_attack1_right
	cmp #1
	beq case_attack1_left

case_attack1_right:
	lda #%00000000
	sta playerFuki1_s2
	sta playerFuki2_s2
	clc			; キャリーフラグOFF
	lda window_player_x_low
	adc #12
	sta playerFuki1_x2
	clc			; キャリーフラグOFF
	lda window_player_x_low
	adc #20
	sta playerFuki2_x2

	jmp break_fuki_attack1
case_attack1_left:
	lda #%01000000
	sta playerFuki1_s2
	sta playerFuki2_s2
	sec			; キャリーフラグON
	lda window_player_x_low
	sbc #4
	sta playerFuki1_x2
	sec			; キャリーフラグON
	lda window_player_x_low
	sbc #12
	sta playerFuki2_x2

	jmp break_fuki_attack1

break_fuki_attack1:


	rts
.endproc	; player_draw_dma6_attack1

.proc player_draw_dma6_attack2
	ldx #0
	stx REG0
	; 吹き戻し
	clc			; キャリーフラグOFF
	lda player_y
	adc #21
	sta playerFuki1_y2
	lda #232	; 画面外
	sta playerFuki2_y2
	lda #$1D
	sta playerFuki1_t2

	lda chr_lr
	cmp #0
	beq case_attack2_right
	cmp #1
	beq case_attack2_left

case_attack2_right:
	lda #%00000000
	sta playerFuki1_s2
;	sta playerFuki2_s2
	clc			; キャリーフラグOFF
	lda window_player_x_low
	adc #12
	sta playerFuki1_x2
	jmp break_fuki_attack2
case_attack2_left:
	lda #%01000000
	sta playerFuki1_s2
;	sta playerFuki2_s2
	sec			; キャリーフラグON
	lda window_player_x_low
	sbc #4
	sta playerFuki1_x2

	jmp break_fuki_attack2

break_fuki_attack2:

	rts
.endproc	; player_draw_dma6_attack2


; 描画
.proc	player_draw_dma6

	; フィールドプレイヤー位置 - フィールドスクロール位置
	sec
	lda player_x_low
	sbc field_scroll_x_low
	sta window_player_x_low

	clc
	lda window_player_x_low
	adc #8
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

	lda #232	; 画面外
	sta playerFuki1_y2
	sta playerFuki2_y2


	lda player_draw_status
	cmp #0	; 通常
	beq case_nomal
	cmp #1	; ジャンプ
	beq case_jump
	cmp #2	; 攻撃中1
	beq case_attack1
	cmp #3	; 攻撃中2
	beq case_attack2
	cmp #4	; 死亡
	beq case_dead

; 通常
case_nomal:
	;REG0 = (p_pat == 0) ? 2 : 0;
	ldx #2
	lda p_pat
	bne	Pat1
	ldx #0
Pat1:
	stx REG0

	jmp break

; ジャンプ
case_jump:
	ldx #$40
	stx REG0

	jmp break

; 攻撃中
case_attack1:
	jsr player_draw_dma6_attack1

	jmp break

; 攻撃中
case_attack2:
	jsr player_draw_dma6_attack2

	jmp break

; 死亡
case_dead:
	ldx #$42
	stx REG0

	jmp break

break:


	clc			; キャリーフラグOFF
	lda player_y
	adc #7
	sta player1_y2;
	sta player2_y2;
	clc
	lda #$80     ; 21をAにロード
	adc REG0
	sta player1_t2
	lda REG1;#%00000000     ; 0(10進数)をAにロード
	sta player1_s2
	sta player2_s2
	sta player3_s2
	sta player4_s2
	sta player5_s2
	sta player6_s2
	sta player7_s2
	sta player8_s2

	lda REG3; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta player1_x2
	sta player3_x2
	sta player5_x2
	sta player7_x2

	clc
	lda #$81     ; 21をAにロード
	adc REG0
	sta player2_t2
	lda REG2; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta player2_x2
	sta player4_x2
	sta player6_x2
	sta player8_x2

	clc			; キャリーフラグOFF
	lda player_y
	adc #15
	sta player3_y2;
	sta player4_y2;
	clc
	lda #$90     ; 21をAにロード
	adc REG0
	sta player3_t2

	clc
	lda #$91     ; 21をAにロード
	adc REG0
	sta player4_t2

	clc			; キャリーフラグOFF
	lda player_y
	adc #23
	sta player5_y2;
	sta player6_y2;
	clc
	lda #$A0     ; 21をAにロード
	adc REG0
	sta player5_t2

	clc
	lda #$A1     ; 21をAにロード
	adc REG0
	sta player6_t2

	clc			; キャリーフラグOFF
	lda player_y
	adc #31
	sta player7_y2;
	sta player8_y2;
	clc
	lda #$B0     ; 21をAにロード
	adc REG0
	sta player7_t2

	clc
	lda #$B1     ; 21をAにロード
	adc REG0
	sta player8_t2


	dec pat_change_frame
	;lda	#10
	;cmp pat_change_frame
	lda pat_change_frame
	bne change_pat_skip
	jsr change_pat

change_pat_skip:

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

; オブジェクトとのあたり判定
.proc collision_object
	; 死亡中は判定しない
	lda is_dead
	beq skip_return
	lda #0
	sta obj_collision_result
	rts
skip_return:

	lda #0
	sta obj_collision_sea
	; TODO:	左上の左は左下の左を流用する
	;		右下の下は左下の下を流用する
	;		右上は左上の上と右下の右を流用する
	; あたり判定用の4隅を格納
	clc
	lda player_y
	sta player_y_top_for_collision		; あたり判定用上Y座標（Y座標）
	clc
	adc #31
	sta player_y_bottom_for_collision	; あたり判定用下Y座標（Y座標+31）

	lda player_x_hi
	sta player_x_left_hi_for_collision	; あたり判定用左X座標上位（X座標）
	lda player_x_low
	sta player_x_left_low_for_collision	; あたり判定用左X座標下位（X座標）
	clc
	adc #15
	sta player_x_right_low_for_collision; あたり判定用右X座標下位（X座標+15）
	lda player_x_left_hi_for_collision
	adc #0
	sta player_x_right_hi_for_collision	; あたり判定用右X座標上位（X座標+15）


	; プレイヤーのフィールド上の位置(左下の左下)(player_x_left_low_for_collision, player_x_left_hi_for_collision)
	; それを8で割った値（ｘ）が、マップチップの位置
	; map_chipから加える値は、X*25
	lda player_x_left_low_for_collision
	sta map_chip_player_x_low
	lda player_x_left_hi_for_collision
	sta map_chip_player_x_hi
	; 8で割る
	clc
	lsr map_chip_player_x_hi	; 上位は右シフト
	ror map_chip_player_x_low	; 下位は右ローテート
	lsr map_chip_player_x_hi	; 上位は右シフト
	ror map_chip_player_x_low	; 下位は右ローテート
	lsr map_chip_player_x_hi	; 上位は右シフト
	ror map_chip_player_x_low	; 下位は右ローテート
	; 結果を25倍(16+8+1)する　マップチップの起点を算出する
	; REG0を16倍のlow REG1を16倍のhiとして
	; REG2を 8倍のlow REG3を 8倍のhiとして
	; REG4を 1倍のlow REG5を 1倍のhiとして
	; 16倍
	lda map_chip_player_x_hi
	sta REG1
	lda map_chip_player_x_low
	sta REG0
	clc
	asl REG0		; 下位は左シフト
	rol REG1		; 上位は左ローテート
	asl REG0		; 下位は左シフト
	rol REG1		; 上位は左ローテート
	asl REG0		; 下位は左シフト
	rol REG1		; 上位は左ローテート
	asl REG0		; 下位は左シフト
	rol REG1		; 上位は左ローテート
	; 8倍
	lda map_chip_player_x_hi
	sta REG3
	lda map_chip_player_x_low
	sta REG2
	clc
	asl REG2		; 下位は左シフト
	rol REG3		; 上位は左ローテート
	asl REG2		; 下位は左シフト
	rol REG3		; 上位は左ローテート
	asl REG2		; 下位は左シフト
	rol REG3		; 上位は左ローテート
	; 1倍
	lda map_chip_player_x_hi
	sta REG5
	lda map_chip_player_x_low
	sta REG4
	; 16倍+8倍
	clc
	lda REG0
	adc REG2
	sta map_chip_collision_index_base_low
	lda REG1
	adc REG3
	sta map_chip_collision_index_base_hi
	; (16倍+8倍) + 1倍
	clc
	lda map_chip_collision_index_base_low
	adc REG4
	sta map_chip_collision_index_base_low
	lda map_chip_collision_index_base_hi
	adc REG5
	sta map_chip_collision_index_base_hi
	; ここまででキャラの左列の一番下（画面的に）を指す。

	; 左下
	clc
	lda player_y_bottom_for_collision
	sta REG0
	lsr REG0	; 右シフト
	lsr REG0	; 右シフト
	lsr REG0	; 右シフト	; 8で割る

	; 27から引く
	sec
	lda #27
	sbc REG0
	sta REG0	; 一番下からのブロック数

	clc
	lda REG0
	adc map_chip_collision_index_base_low			; キャラ左画面一番下
	sta map_chip_collision_index_left_bottom_low	; キャラ左キャラ下
	lda map_chip_collision_index_base_hi
	adc #0
	sta map_chip_collision_index_left_bottom_hi

	; キャラクタの左下のブロックの左下
	; □□
	; □□
	; □□
	; ■□
	; マップチップの起点
	lda #< map_chip
	sta map_table_char_pos_offset_low
	lda #> map_chip
	sta map_table_char_pos_offset_hi

	clc
	lda map_table_char_pos_offset_low
	adc map_chip_collision_index_left_bottom_low
	sta map_table_char_pos_offset_low
	lda map_table_char_pos_offset_hi
	adc map_chip_collision_index_left_bottom_hi
	sta map_table_char_pos_offset_hi

	ldy #0	; ずらし終わっているのでyは0
	lda (map_table_char_pos_offset_low), y
	sta map_table_char_pos_value

	; obj_collision_resultを戻り値として使用する
	; 0ならfalse
	; 1ならtrue
	lda #0
	sta obj_collision_result
	lda map_table_char_pos_value
	cmp #$01
	beq hit0
	cmp #$02
	beq hit0
	cmp #$11
	beq hit0
	cmp #$12
	beq hit0
	cmp #$07
	beq hit0
	cmp #$08
	beq hit0
	cmp #$17
	beq hit0
	cmp #$18
	beq hit0
	jmp skip0
hit0:
	lda #1
	sta obj_collision_result
	lda #0	; あたり判定0番
	sta obj_collision_pos
	rts
skip0:

	lda map_table_char_pos_value
	cmp #$05
	beq hit_sea
	cmp #$06
	beq hit_sea
	jmp skip_sea
hit_sea:
	lda #1
	sta obj_collision_sea
	rts
skip_sea:

	; y座標(左上)を8で割る 28からそれをひく
	; map_chip_collision_indexにそれを足す

	; 左下
;	clc
;	lda player_y_top_for_collision
;	sta REG0
;	lsr REG0	; 右シフト
;	lsr REG0	; 右シフト
;	lsr REG0	; 右シフト
;
;	sec
;	lda #28
;	sbc REG0
;	sta REG0
;
;	clc
;	lda REG0
;	adc map_chip_collision_index_base_low
;	sta map_chip_collision_index_base_low
;	lda map_chip_collision_index_base_hi
;	adc #0
;	sta map_chip_collision_index_base_hi

	; キャラクタの左上のブロックの左上
	; ■□
	; □□
	; □□
	; □□
	; マップチップの起点
	; プレイヤーのフィールド上の位置(左上の左上)(player_x_left_low_for_collision, player_x_left_hi_for_collision)
	; それを8で割った値（ｘ）が、マップチップの位置

	; 左上
	clc
	lda player_y_top_for_collision
	sta REG0
	lsr REG0	; 右シフト
	lsr REG0	; 右シフト
	lsr REG0	; 右シフト	; 8で割る

	; 27から引く
	sec
	lda #27
	sbc REG0
	sta REG0	; 一番下からのブロック数

	clc
	lda REG0
	adc map_chip_collision_index_base_low			; キャラ左画面一番下
	sta map_chip_collision_index_left_top_low		; キャラ左キャラ上
	lda map_chip_collision_index_base_hi
	adc #0
	sta map_chip_collision_index_left_top_hi

	lda #< map_chip
	sta map_table_char_pos_offset_low
	lda #> map_chip
	sta map_table_char_pos_offset_hi

	clc
	lda map_table_char_pos_offset_low
	adc map_chip_collision_index_left_top_low
	sta map_table_char_pos_offset_low
	lda map_table_char_pos_offset_hi
	adc map_chip_collision_index_left_top_hi
	sta map_table_char_pos_offset_hi

	ldy #0	; ずらし終わっているのでyは0
	lda (map_table_char_pos_offset_low), y
	sta map_table_char_pos_value

	; obj_collision_resultを戻り値として使用する
	; 0ならfalse
	; 1ならtrue
	lda #0
	sta obj_collision_result
	lda map_table_char_pos_value
	cmp #$01
	beq hit1
	cmp #$02
	beq hit1
	cmp #$11
	beq hit1
	cmp #$12
	beq hit1
	cmp #$07
	beq hit1
	cmp #$08
	beq hit1
	cmp #$17
	beq hit1
	cmp #$18
	beq hit1
	jmp skip1
hit1:
	lda #1
	sta obj_collision_result
	lda #1	; あたり判定1番
	sta obj_collision_pos
	rts
skip1:


	; キャラクタの右下のブロックの右下
	; □□
	; □□
	; □□
	; □■
	; マップチップの起点
	; プレイヤーのフィールド上の位置(右下の右下)(player_x_right_low_for_collision, player_x_right_hi_for_collision)
	; それを8で割った値（ｘ）が、マップチップの位置
	lda player_x_right_low_for_collision
	sta map_chip_player_x_low
	lda player_x_right_hi_for_collision
	sta map_chip_player_x_hi
	; 8で割る
	clc
	lsr map_chip_player_x_hi	; 上位は右シフト
	ror map_chip_player_x_low	; 下位は右ローテート
	lsr map_chip_player_x_hi	; 上位は右シフト
	ror map_chip_player_x_low	; 下位は右ローテート
	lsr map_chip_player_x_hi	; 上位は右シフト
	ror map_chip_player_x_low	; 下位は右ローテート
	; 結果を25倍(16+8+1)する　マップチップの起点を算出する
	; REG0を16倍のlow REG1を16倍のhiとして
	; REG2を 8倍のlow REG3を 8倍のhiとして
	; REG4を 1倍のlow REG5を 1倍のhiとして
	; 16倍
	lda map_chip_player_x_hi
	sta REG1
	lda map_chip_player_x_low
	sta REG0
	clc
	asl REG0		; 下位は左シフト
	rol REG1		; 上位は左ローテート
	asl REG0		; 下位は左シフト
	rol REG1		; 上位は左ローテート
	asl REG0		; 下位は左シフト
	rol REG1		; 上位は左ローテート
	asl REG0		; 下位は左シフト
	rol REG1		; 上位は左ローテート
	; 8倍
	lda map_chip_player_x_hi
	sta REG3
	lda map_chip_player_x_low
	sta REG2
	clc
	asl REG2		; 下位は左シフト
	rol REG3		; 上位は左ローテート
	asl REG2		; 下位は左シフト
	rol REG3		; 上位は左ローテート
	asl REG2		; 下位は左シフト
	rol REG3		; 上位は左ローテート
	; 1倍
	lda map_chip_player_x_hi
	sta REG5
	lda map_chip_player_x_low
	sta REG4
	; 16倍+8倍
	clc
	lda REG0
	adc REG2
	sta map_chip_collision_index_base_low
	lda REG1
	adc REG3
	sta map_chip_collision_index_base_hi
	; (16倍+8倍) + 1倍
	clc
	lda map_chip_collision_index_base_low
	adc REG4
	sta map_chip_collision_index_base_low
	lda map_chip_collision_index_base_hi
	adc REG5
	sta map_chip_collision_index_base_hi
	; ここまででキャラの左列の一番下（画面的に）を指す。


	; 右下
	clc
	lda player_y_bottom_for_collision
	sta REG0
	lsr REG0	; 右シフト
	lsr REG0	; 右シフト
	lsr REG0	; 右シフト	; 8で割る

	; 27から引く
	sec
	lda #27
	sbc REG0
	sta REG0	; 一番下からのブロック数

	clc
	lda REG0
	adc map_chip_collision_index_base_low			; キャラ左画面一番下
	sta map_chip_collision_index_right_bottom_low		; キャラ左キャラ上
	lda map_chip_collision_index_base_hi
	adc #0
	sta map_chip_collision_index_right_bottom_hi

	lda #< map_chip
	sta map_table_char_pos_offset_low
	lda #> map_chip
	sta map_table_char_pos_offset_hi

	clc
	lda map_table_char_pos_offset_low
	adc map_chip_collision_index_right_bottom_low
	sta map_table_char_pos_offset_low
	lda map_table_char_pos_offset_hi
	adc map_chip_collision_index_right_bottom_hi
	sta map_table_char_pos_offset_hi

	ldy #0	; ずらし終わっているのでyは0
	lda (map_table_char_pos_offset_low), y
	sta map_table_char_pos_value

	; obj_collision_resultを戻り値として使用する
	; 0ならfalse
	; 1ならtrue
	lda #0
	sta obj_collision_result
	lda map_table_char_pos_value
	cmp #$01
	beq hit2
	cmp #$02
	beq hit2
	cmp #$11
	beq hit2
	cmp #$12
	beq hit2
	cmp #$07
	beq hit2
	cmp #$08
	beq hit2
	cmp #$17
	beq hit2
	cmp #$18
	beq hit2
	jmp skip2
hit2:
	lda #1
	sta obj_collision_result
	lda #0	; あたり判定0番
	sta obj_collision_pos
	rts
skip2:

	; キャラクタの右上のブロックの右上
	; □■
	; □□
	; □□
	; □□
	; マップチップの起点
	; プレイヤーのフィールド上の位置(右上の右上)(player_x_right_low_for_collision, player_x_right_hi_for_collision)
	; それを8で割った値（ｘ）が、マップチップの位置

	; 右上
	clc
	lda player_y_top_for_collision
	sta REG0
	lsr REG0	; 右シフト
	lsr REG0	; 右シフト
	lsr REG0	; 右シフト	; 8で割る

	; 27から引く
	sec
	lda #27
	sbc REG0
	sta REG0	; 一番下からのブロック数

	clc
	lda REG0
	adc map_chip_collision_index_base_low			; キャラ左画面一番下
	sta map_chip_collision_index_right_top_low		; キャラ左キャラ上
	lda map_chip_collision_index_base_hi
	adc #0
	sta map_chip_collision_index_right_top_hi

	lda #< map_chip
	sta map_table_char_pos_offset_low
	lda #> map_chip
	sta map_table_char_pos_offset_hi

	clc
	lda map_table_char_pos_offset_low
	adc map_chip_collision_index_right_top_low
	sta map_table_char_pos_offset_low
	lda map_table_char_pos_offset_hi
	adc map_chip_collision_index_right_top_hi
	sta map_table_char_pos_offset_hi

	ldy #0	; ずらし終わっているのでyは0
	lda (map_table_char_pos_offset_low), y
	sta map_table_char_pos_value

	; collision_resultを戻り値として使用する
	; 0ならfalse
	; 1ならtrue
	lda #0
	sta obj_collision_result
	lda map_table_char_pos_value
	cmp #$01
	beq hit3
	cmp #$02
	beq hit3
	cmp #$11
	beq hit3
	cmp #$12
	beq hit3
	cmp #$07
	beq hit3
	cmp #$08
	beq hit3
	cmp #$17
	beq hit3
	cmp #$18
	beq hit3
	jmp skip3
hit3:
	lda #1
	sta obj_collision_result
	lda #1	; あたり判定1番
	sta obj_collision_pos
	rts
skip3:


	; プレイヤーのウィンドウ内位置(ピクセルからブロック)
	; それを8で割った値を32から引いた値(x)が
	; int x = 32 - window_player_x_low8 / 8
	; map_table_attribute_lowから戻る分(xの値
	;	lda (map_table_attribute_low), y
	;diff[] 25, 50, 75, 100, 125, 150, 175, 200, 225, 250,
	;		275, 300, 325, 350, 375, 400, 425, 450 ,475, 500
	;		525, 550, 575, 600, 625, 650, 675, 700, 725, 750
	;		750, 775
	; int map[主人公の位置,y] = map_table_attribute_low - diff[x]
	rts
.endproc

; キャラとのあたり判定
.proc collision_char
	lda #0
	sta char_collision_result

	; プレイヤのX座標とイノシシのX座標と
	; プレイヤのY座標とイノシシのY座標を
	; 比較して、ともに差分が一定以下なら
	; 当たった。
	lda #1
	sta inosisi_alive_flag_current	; フラグ参照現在位置
	ldx #0
loop_x:
	; 生存しているか
	lda inosisi_alive_flag
	and inosisi_alive_flag_current
	beq next_update		; 存在していない

	; 存在している
	; プレイヤのXとイノシシのXの大きい方
	sec
	lda window_player_x_low
	sbc inosisi0_window_pos_x,x
	bpl big_player	; プレイヤの方が大きい
	; イノシシの方が大きい
	sec
	lda inosisi0_window_pos_x,x
	sbc window_player_x_low
big_player:
	sta REG0	; X差分

	; プレイヤのYとイノシシのYの大きい方
	sec
	lda player_y
	sbc inosisi0_pos_y,x
	bpl big_player_y	; プレイヤの方が大きい
	; イノシシの方が大きい
	sec
	lda inosisi0_pos_y,x
	sbc player_y
big_player_y:
	sta REG1	; y差分

	lda #0
	sta char_collision_result
	
	sec
	lda REG0
	sbc #17
	bpl	next_update	; 差分が16より大きい
	
	sec
	lda REG1
	sbc #17
	bpl	next_update	; 差分が16より大きい

	lda #1
	sta char_collision_result
	jmp exit


next_update:
	; 次
	asl inosisi_alive_flag_current
	inx
	cpx inosisi_max_count	; ループ最大数
	bne loop_x				; ループ
	

;exit:

	; REG2 ｎ個目
	; REG3 alive_flag
	lda #0
	sta REG2

loop_tako_type:
	lda tako_alive_flag
	sta REG3		; タコ生存フラグ
	lda REG2		; ｎ個目のタコ
	beq skip_alive_flag
	lda tako_haba_alive_flag
	sta REG3		; はばタコ生存フラグ
	skip_alive_flag:

	; プレイヤのX座標とタコのX座標と
	; プレイヤのY座標とタコのY座標を
	; 比較して、ともに差分が一定以下なら
	; 当たった。
	lda #1
	sta tako_alive_flag_current	; フラグ参照現在位置
	ldx #0
loop_x_tako:
	; 生存しているか
	lda REG3
	and tako_alive_flag_current
	beq next_update_tako	; 存在していない
	
	; 燃えていないか
	lda tako00_status,x
	cmp #1
	beq next_update_tako	; 燃えている

	; 存在している
	; プレイヤのXとタコのXの大きい方
	sec
	lda window_player_x_low
	sbc tako0_window_pos_x,x
	bpl big_player_tako	; プレイヤの方が大きい
	; タコの方が大きい
	sec
	lda tako0_window_pos_x,x
	sbc window_player_x_low
big_player_tako:
	sta REG0	; X差分

	; プレイヤのXとタコのYの大きい方
	sec
	lda player_y
	sbc tako0_pos_y,x
	bpl big_player_y_tako	; プレイヤの方が大きい
	; タコの方が大きい
	sec
	lda tako0_pos_y,x
	sbc player_y
big_player_y_tako:
	sta REG1	; y差分

	lda #0
	sta char_collision_result
	
	sec
	lda REG0
	sbc #17
	bpl	next_update_tako	; 差分が16より大きい
	
	sec
	lda REG1
	sbc #17
	bpl	next_update_tako	; 差分が16より大きい

	lda #1
	sta char_collision_result
	jmp exit


next_update_tako:
	; 次
	asl tako_alive_flag_current
	inx
	cpx tako_max_count	; ループ最大数
	bne loop_x_tako		; ループ
	

	inc REG2			; ｎ個目のタコ
	lda REG2
	cmp #2
	bne loop_tako_type
;exit:

	; プレイヤのX座標とタマネギのX座標と
	; プレイヤのY座標とタマネギのY座標を
	; 比較して、ともに差分が一定以下なら
	; 当たった。
	lda #1
	sta tamanegi_alive_flag_current	; フラグ参照現在位置
	ldx #0
loop_x_tamanegi:
	; 生存しているか
	lda tamanegi_alive_flag
	and tamanegi_alive_flag_current
	beq next_update_tamanegi	; 存在していない
	
	; 燃えていないか
	lda tamanegi00_status,x
	cmp #3
	beq next_update_tamanegi	; 燃えている

	; 存在している
	; プレイヤのXとタマネギのXの大きい方
	sec
	lda window_player_x_low
	sbc tamanegi0_window_pos_x,x
	bpl big_player_tamanegi	; プレイヤの方が大きい
	; タマネギの方が大きい
	sec
	lda tamanegi0_window_pos_x,x
	sbc window_player_x_low
big_player_tamanegi:
	sta REG0	; X差分

	; プレイヤのXとタマネギのYの大きい方
	sec
	lda player_y
	sbc tamanegi0_pos_y,x
	bpl big_player_y_tamanegi	; プレイヤの方が大きい
	; タマネギの方が大きい
	sec
	lda tamanegi0_pos_y,x
	sbc player_y
big_player_y_tamanegi:
	sta REG1	; y差分

	lda #0
	sta char_collision_result
	
	sec
	lda REG0
	sbc #17
	bpl	next_update_tamanegi	; 差分が16より大きい
	
	sec
	lda REG1
	sbc #17
	bpl	next_update_tamanegi	; 差分が16より大きい

	lda #1
	sta char_collision_result
	jmp exit


next_update_tamanegi:
	; 次
	asl tamanegi_alive_flag_current
	inx
	cpx tamanegi_max_count	; ループ最大数
	bne loop_x_tamanegi				; ループ
	

exit:

	rts
.endproc


; アイテムとのあたり判定
.proc collision_item
	lda #0
	sta char_collision_result

	; プレイヤのX座標とアイテムのX座標と
	; プレイヤのY座標とアイテムのY座標を
	; 比較して、ともに差分が一定以下なら
	; 当たった。

	; 生存しているか
	lda item_alive_flag
	beq exit		; 存在していない
	
	; 通常状態か
	lda item_status
	bne exit		; 通常状態ではない

	; 存在している
	; プレイヤのXとアイテムのXの大きい方
	sec
	lda window_player_x_low
	sbc item_window_pos_x
	bpl big_player	; プレイヤの方が大きい
	; アイテムの方が大きい
	sec
	lda item_window_pos_x
	sbc window_player_x_low
big_player:
	sta REG0	; X差分

	; プレイヤのYとアイテムのYの大きい方
	sec
	lda player_y
	sbc item_pos_y
	bpl big_player_y	; プレイヤの方が大きい
	; アイテムの方が大きい
	sec
	lda item_pos_y
	sbc player_y
big_player_y:
	sta REG1	; y差分

	lda #0
	sta char_collision_result
	
	sec
	lda REG0
	sbc #17
	bpl	exit	; 差分が16より大きい
	
	sec
	lda REG1
	sbc #49
	bpl	exit	; 差分が48より大きい

	lda #1	; 当たった
	sta char_collision_result
	inc item_count
	; 当たった場合とりあえず表示位置を格納する
	lda item_window_pos_x
	sta REG0
	lda item_pos_y
	sta REG1
	jsr String_Init
	jmp exit

exit:

	rts
.endproc	; collision_item

.proc Player_SetSpeed
	lda REG0
	sta player_spd_decimal
	lda REG1
	sta player_spd_low
	
	rts
.endproc	; Player_SetSpeed

; 速度変化更新
.proc Player_UpdateSpeed
	; 最初の着地時の速度変化
		; 座標が256+140から512の間
		; 速度が速い時
	; 速度変更確認(最初の着地)
	lda player_speed_hi_or_low
	beq not_speed_change
	lda player_x_hi
	cmp #1
	bne not_speed_change
	sec
	lda player_x_low
	sbc #$60
	bcc not_speed_change	; キャリーフラグがクリアされている時
	
	; 速度変更
	lda #$80
	sta REG0
	lda #0
	sta REG1
	jsr Player_SetSpeed
	lda #0	; 速度落とした
	sta player_speed_hi_or_low
	
	not_speed_change:

	; アイテム取得による速度変化
		; アイテム3つ取得したか
		; 速度が遅いとき
	lda player_speed_hi_or_low
	bne skip_speedup	; 速度が速い(1)の時は処理しない
	lda item_count
	cmp #3
	bne skip_speedup
	lda #0
	sta REG0
	lda #1
	sta REG1
	jsr Player_SetSpeed
	lda #1
	sta str_speedup_state
	lda #1	; 速度上げた
	sta player_speed_hi_or_low
	skip_speedup:
	
	rts
.endproc	; Player_UpdateSpeed
