.proc	Habatan_Init
	lda #0
	sta habatan_alive_flag
	sta habatan_world_pos_x_low
	sta habatan_world_pos_x_hi
	sta habatan_pos_y
	sta habatan_window_pos_x
	sta habatan_status
	; 属性は変わらない
	lda #%00000000     ; 0(10進数)をAにロード
	sta habatan01_s
	sta habatan08_s
	sta habatan09_s
	lda #%00000011
	sta habatan02_s
	sta habatan03_s
	sta habatan04_s
	sta habatan05_s
	sta habatan06_s
	sta habatan07_s
	sta habatan10_s
	sta habatan11_s
	sta habatan12_s

	rts
.endproc

; 登場
.proc appear_habatan

	; 空いているか
	lda habatan_alive_flag
	beq set_habatan
	; ここまで来たら空きはないのでスキップ
	jmp skip_habatan

set_habatan:
	
	; 色々初期化
	lda #0
	sta habatan_status

	; 初期表示位置
	sec
	lda player_x_low
	sbc #124
	sta habatan_world_pos_x_low
	lda player_x_up
	sbc #0
	sta habatan_world_pos_x_hi

	lda #100
	sta habatan_pos_y

	; パレット4をはばタン
	lda #3
	sta palette_change_state

	; 属性は変わらない
	lda #%00000000     ; 0(10進数)をAにロード
	sta habatan01_s
	sta habatan08_s
	sta habatan09_s
	sta habatan01_s2
	sta habatan08_s2
	sta habatan09_s2
	lda #%00000011
	sta habatan02_s
	sta habatan03_s
	sta habatan04_s
	sta habatan05_s
	sta habatan06_s
	sta habatan07_s
	sta habatan10_s
	sta habatan11_s
	sta habatan12_s
	sta habatan02_s2
	sta habatan03_s2
	sta habatan04_s2
	sta habatan05_s2
	sta habatan06_s2
	sta habatan07_s2
	sta habatan10_s2
	sta habatan11_s2
	sta habatan12_s2

	; フラグを立てる
	lda #1
	sta habatan_alive_flag

skip_habatan:
	; スキップ
	rts
.endproc	; appear_habatan

; はばタンクリア
.proc Habatan_Clear

	; 生存フラグの確認
	lda habatan_alive_flag
	bne not_skip_clear		; 存在している
	jmp skip_clear
	not_skip_clear:

	lda #0
	sta habatan01_y
	sta habatan01_t
	sta habatan01_s
	sta habatan01_x
	sta habatan02_y
	sta habatan02_t
	sta habatan02_s
	sta habatan02_x
	sta habatan03_y
	sta habatan03_t
	sta habatan03_s
	sta habatan03_x
	sta habatan04_y
	sta habatan04_t
	sta habatan04_s
	sta habatan04_x
	sta habatan05_y
	sta habatan05_t
	sta habatan05_s
	sta habatan05_x
	sta habatan06_y
	sta habatan06_t
	sta habatan06_s
	sta habatan06_x
	sta habatan07_y
	sta habatan07_t
	sta habatan07_s
	sta habatan07_x
	sta habatan08_y
	sta habatan08_t
	sta habatan08_s
	sta habatan08_x
	sta habatan09_y
	sta habatan09_t
	sta habatan09_s
	sta habatan09_x
	sta habatan10_y
	sta habatan10_t
	sta habatan10_s
	sta habatan10_x
	sta habatan11_y
	sta habatan11_t
	sta habatan11_s
	sta habatan11_x
	sta habatan12_y
	sta habatan12_t
	sta habatan12_s
	sta habatan12_x
	sta habatan01_y2
	sta habatan01_t2
	sta habatan01_s2
	sta habatan01_x2
	sta habatan02_y2
	sta habatan02_t2
	sta habatan02_s2
	sta habatan02_x2
	sta habatan03_y2
	sta habatan03_t2
	sta habatan03_s2
	sta habatan03_x2
	sta habatan04_y2
	sta habatan04_t2
	sta habatan04_s2
	sta habatan04_x2
	sta habatan05_y2
	sta habatan05_t2
	sta habatan05_s2
	sta habatan05_x2
	sta habatan06_y2
	sta habatan06_t2
	sta habatan06_s2
	sta habatan06_x2
	sta habatan07_y2
	sta habatan07_t2
	sta habatan07_s2
	sta habatan07_x2
	sta habatan08_y2
	sta habatan08_t2
	sta habatan08_s2
	sta habatan08_x2
	sta habatan09_y2
	sta habatan09_t2
	sta habatan09_s2
	sta habatan09_x2
	sta habatan10_y2
	sta habatan10_t2
	sta habatan10_s2
	sta habatan10_x2
	sta habatan11_y2
	sta habatan11_t2
	sta habatan11_s2
	sta habatan11_x2
	sta habatan12_y2
	sta habatan12_t2
	sta habatan12_s2
	sta habatan12_x2

	lda #0
	sta habatan_world_pos_x_low
	sta habatan_world_pos_x_hi
	sta habatan_pos_y
	
	; 生存フラグを落とす
	lda #0
	sta habatan_alive_flag

skip_clear:

	rts
.endproc ; Habatan_Clear

; 更新
.proc	HabatanUpdate
	lda is_dead
	bne skip_update

	; 居ない
	lda habatan_alive_flag
	beq skip_update

	; 存在している
	
	lda habatan_status
	cmp #0
	beq case_approach
	cmp #1
	beq case_normal
	cmp #2
	beq case_leave
	
case_approach:
	jsr Habatan_UpdateApproach
	jmp break
	
case_normal:
	jsr Habatan_UpdateNormal
	jmp break
	
case_leave:
	jsr Habatan_UpdateLeave
	jmp break

break:


	; 画面外判定
	sec
	lda field_scroll_x_up
	sbc habatan_world_pos_x_hi
	bcc skip_dead
	sec
	lda field_scroll_x_low
	sbc habatan_world_pos_x_low
	bcc skip_dead

	; 画面外処理
	jsr Habatan_Clear

skip_dead:

skip_update:
	rts
.endproc	; Habatan_Clear

; 近づく更新
.proc Habatan_UpdateApproach

	; 右移動
	clc
	lda habatan_world_pos_x_low
	adc #1
	sta habatan_world_pos_x_low
	lda habatan_world_pos_x_hi
	adc #0
	sta habatan_world_pos_x_hi
	
	sec
	lda window_player_x_low
	sbc habatan_window_pos_x
	bcs next_skip	; キャリーフラグがセットされている場合スキップ

	lda #1
	sta habatan_status
	lda #255
	sta habatan_wait
	
	next_skip:

	rts
.endproc	; Habatan_UpdateApproach

; 通常更新
.proc	Habatan_UpdateNormal

	; プレイヤに追従
	lda player_x_up
	sta habatan_world_pos_x_hi
	lda player_x_low
	sta habatan_world_pos_x_low
	
	sec
	lda player_y
	sbc #32
	sta habatan_pos_y
	
	dec habatan_wait
	lda habatan_wait
	bne next_skip
	
	lda #2
	sta habatan_status
	next_skip:

	rts
.endproc	; Habatan_UpdateNormal

; 退場更新
.proc	Habatan_UpdateLeave

	jsr Habatan_Clear
	
	rts
.endproc	; Habatan_UpdateLeave

; 描画
.proc	HabatanDrawDma7

	; 居ない
	lda habatan_alive_flag
	bne not_skip_draw
	jmp skip_draw
not_skip_draw:

	; アニメパターン
	;REG0 = (p_pat == 0) ? #$00 : #$05;

	lda p_pat
	beq set_pat0
	bne set_pat1
	
set_pat0:
	lda #$00
	sta REG0
	jmp break_pat
set_pat1:
	lda #$05
	sta REG0
	jmp break_pat
	
break_pat:

; 生存タイル
	; 1列目
	clc
	lda #$42
	adc REG0
	sta habatan01_t
	clc
	lda #$43
	adc REG0
	sta habatan02_t
	clc
	lda #$44
	adc REG0
	sta habatan03_t
	; 2列目
	clc
	lda #$51
	adc REG0
	sta habatan04_t
	clc
	lda #$52
	adc REG0
	sta habatan05_t
	clc
	lda #$53
	adc REG0
	sta habatan06_t
	clc
	lda #$54
	adc REG0
	sta habatan07_t
	; 3列目
	clc
	lda #$60
	adc REG0
	sta habatan08_t
	clc
	lda #$61
	adc REG0
	sta habatan09_t
	clc
	lda #$62
	adc REG0
	sta habatan10_t
	clc
	lda #$63
	adc REG0
	sta habatan11_t
	clc
	lda #$64
	adc REG0
	sta habatan12_t

; Y座標
	; 1列目
	clc			; キャリーフラグOFF
	lda habatan_pos_y
	adc #7
	sta habatan01_y
	sta habatan02_y
	sta habatan03_y
	
	; 2列目
	clc			; キャリーフラグOFF
	lda habatan_pos_y
	adc #15
	sta habatan04_y
	sta habatan05_y
	sta habatan06_y
	sta habatan07_y
	
	; 3列目
	clc			; キャリーフラグOFF
	lda habatan_pos_y
	adc #23
	sta habatan08_y
	sta habatan09_y
	sta habatan10_y
	sta habatan11_y
	sta habatan12_y
	

; X座標
	; xx123
	; x4567
	; 89012

	; 存在していれば、ワールド座標からウィンドウ座標に変換
	sec
	lda habatan_world_pos_x_low
	sbc field_scroll_x_low
	sta habatan_window_pos_x

	lda habatan_window_pos_x
	sta habatan08_x

	lda habatan_window_pos_x
	clc			; キャリーフラグOFF
	adc #8
	sta habatan04_x
	sta habatan09_x

	lda habatan_window_pos_x
	clc			; キャリーフラグOFF
	adc #16
	sta habatan01_x
	sta habatan05_x
	sta habatan10_x

	lda habatan_window_pos_x
	clc			; キャリーフラグOFF
	adc #24
	sta habatan02_x
	sta habatan06_x
	sta habatan11_x

	lda habatan_window_pos_x
	clc			; キャリーフラグOFF
	adc #32
	sta habatan03_x
	sta habatan07_x
	sta habatan12_x

skip_draw:

	rts

.endproc	; HabatanDrawDma7

; 描画
.proc	HabatanDrawDma6

	; 居ない
	lda habatan_alive_flag
	bne not_skip_draw
	jmp skip_draw
not_skip_draw:

	; アニメパターン
	;REG0 = (p_pat == 0) ? #$00 : #$05;

	lda p_pat
	beq set_pat0
	bne set_pat1
	
set_pat0:
	lda #$00
	sta REG0
	jmp break_pat
set_pat1:
	lda #$05
	sta REG0
	jmp break_pat
	
break_pat:

; 生存タイル
	; 1列目
	clc
	lda #$42
	adc REG0
	sta habatan01_t2
	clc
	lda #$43
	adc REG0
	sta habatan02_t2
	clc
	lda #$44
	adc REG0
	sta habatan03_t2
	; 2列目
	clc
	lda #$51
	adc REG0
	sta habatan04_t2
	clc
	lda #$52
	adc REG0
	sta habatan05_t2
	clc
	lda #$53
	adc REG0
	sta habatan06_t2
	clc
	lda #$54
	adc REG0
	sta habatan07_t2
	; 3列目
	clc
	lda #$60
	adc REG0
	sta habatan08_t2
	clc
	lda #$61
	adc REG0
	sta habatan09_t2
	clc
	lda #$62
	adc REG0
	sta habatan10_t2
	clc
	lda #$63
	adc REG0
	sta habatan11_t2
	clc
	lda #$64
	adc REG0
	sta habatan12_t2

; Y座標
	; 1列目
	clc			; キャリーフラグOFF
	lda habatan_pos_y
	adc #7
	sta habatan01_y2
	sta habatan02_y2
	sta habatan03_y2
	
	; 2列目
	clc			; キャリーフラグOFF
	lda habatan_pos_y
	adc #15
	sta habatan04_y2
	sta habatan05_y2
	sta habatan06_y2
	sta habatan07_y2
	
	; 3列目
	clc			; キャリーフラグOFF
	lda habatan_pos_y
	adc #23
	sta habatan08_y2
	sta habatan09_y2
	sta habatan10_y2
	sta habatan11_y2
	sta habatan12_y2
	

; X座標
	; xx123
	; x4567
	; 89012

	; 存在していれば、ワールド座標からウィンドウ座標に変換
	sec
	lda habatan_world_pos_x_low
	sbc field_scroll_x_low
	sta habatan_window_pos_x

	lda habatan_window_pos_x
	sta habatan08_x2

	lda habatan_window_pos_x
	clc			; キャリーフラグOFF
	adc #8
	sta habatan04_x2
	sta habatan09_x2

	lda habatan_window_pos_x
	clc			; キャリーフラグOFF
	adc #16
	sta habatan01_x2
	sta habatan05_x2
	sta habatan10_x2

	lda habatan_window_pos_x
	clc			; キャリーフラグOFF
	adc #24
	sta habatan02_x2
	sta habatan06_x2
	sta habatan11_x2

	lda habatan_window_pos_x
	clc			; キャリーフラグOFF
	adc #32
	sta habatan03_x2
	sta habatan07_x2
	sta habatan12_x2

skip_draw:

	rts

.endproc	; HabatanDrawDma6

