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
	sta char_12_type01_s
	sta char_12_type08_s
	sta char_12_type09_s
	lda #%00000011
	sta char_12_type02_s
	sta char_12_type03_s
	sta char_12_type04_s
	sta char_12_type05_s
	sta char_12_type06_s
	sta char_12_type07_s
	sta char_12_type10_s
	sta char_12_type11_s

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
	lda player_x_hi
	sbc #0
	sta habatan_world_pos_x_hi

	lda #100
	sta habatan_pos_y

	; パレット4をはばタン
	lda #3
	sta palette_change_state

	; 属性は変わらない
	lda #%00000000     ; 0(10進数)をAにロード
	sta char_12_type01_s
	sta char_12_type08_s
	sta char_12_type09_s
	sta char_12_type01_s2
	sta char_12_type08_s2
	sta char_12_type09_s2
	lda #%00000011
	sta char_12_type02_s
	sta char_12_type03_s
	sta char_12_type04_s
	sta char_12_type05_s
	sta char_12_type06_s
	sta char_12_type07_s
	sta char_12_type10_s
	sta char_12_type11_s
	sta char_12_type02_s2
	sta char_12_type03_s2
	sta char_12_type04_s2
	sta char_12_type05_s2
	sta char_12_type06_s2
	sta char_12_type07_s2
	sta char_12_type10_s2
	sta char_12_type11_s2

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
	sta char_12_type01_y
	sta char_12_type01_t
	sta char_12_type01_s
	sta char_12_type01_x
	sta char_12_type02_y
	sta char_12_type02_t
	sta char_12_type02_s
	sta char_12_type02_x
	sta char_12_type03_y
	sta char_12_type03_t
	sta char_12_type03_s
	sta char_12_type03_x
	sta char_12_type04_y
	sta char_12_type04_t
	sta char_12_type04_s
	sta char_12_type04_x
	sta char_12_type05_y
	sta char_12_type05_t
	sta char_12_type05_s
	sta char_12_type05_x
	sta char_12_type06_y
	sta char_12_type06_t
	sta char_12_type06_s
	sta char_12_type06_x
	sta char_12_type07_y
	sta char_12_type07_t
	sta char_12_type07_s
	sta char_12_type07_x
	sta char_12_type08_y
	sta char_12_type08_t
	sta char_12_type08_s
	sta char_12_type08_x
	sta char_12_type09_y
	sta char_12_type09_t
	sta char_12_type09_s
	sta char_12_type09_x
	sta char_12_type10_y
	sta char_12_type10_t
	sta char_12_type10_s
	sta char_12_type10_x
	sta char_12_type11_y
	sta char_12_type11_t
	sta char_12_type11_s
	sta char_12_type11_x
	sta char_12_type01_y2
	sta char_12_type01_t2
	sta char_12_type01_s2
	sta char_12_type01_x2
	sta char_12_type02_y2
	sta char_12_type02_t2
	sta char_12_type02_s2
	sta char_12_type02_x2
	sta char_12_type03_y2
	sta char_12_type03_t2
	sta char_12_type03_s2
	sta char_12_type03_x2
	sta char_12_type04_y2
	sta char_12_type04_t2
	sta char_12_type04_s2
	sta char_12_type04_x2
	sta char_12_type05_y2
	sta char_12_type05_t2
	sta char_12_type05_s2
	sta char_12_type05_x2
	sta char_12_type06_y2
	sta char_12_type06_t2
	sta char_12_type06_s2
	sta char_12_type06_x2
	sta char_12_type07_y2
	sta char_12_type07_t2
	sta char_12_type07_s2
	sta char_12_type07_x2
	sta char_12_type08_y2
	sta char_12_type08_t2
	sta char_12_type08_s2
	sta char_12_type08_x2
	sta char_12_type09_y2
	sta char_12_type09_t2
	sta char_12_type09_s2
	sta char_12_type09_x2
	sta char_12_type10_y2
	sta char_12_type10_t2
	sta char_12_type10_s2
	sta char_12_type10_x2
	sta char_12_type11_y2
	sta char_12_type11_t2
	sta char_12_type11_s2
	sta char_12_type11_x2

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
	lda field_scroll_x_hi
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
	adc #2
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
	sta habatan_wait_low
	lda #1
	sta habatan_wait_hi
	
	next_skip:

	rts
.endproc	; Habatan_UpdateApproach

; 通常更新
.proc	Habatan_UpdateNormal

	; プレイヤに追従
	lda player_x_hi
	sta habatan_world_pos_x_hi
	lda player_x_low
	sta habatan_world_pos_x_low
	
	sec
	lda player_y
	sbc #24
	sta habatan_pos_y
	
	dec habatan_wait_low
	lda habatan_wait_low
	bne next_skip

	lda habatan_wait_hi
	beq next

	dec habatan_wait_hi
	lda #255
	sta habatan_wait_low
	jmp next_skip
	
	next:
	lda #2
	sta habatan_status
	next_skip:

	rts
.endproc	; Habatan_UpdateNormal

; 退場更新
.proc	Habatan_UpdateLeave

	jsr Habatan_Clear
	jsr HabatanFire_Clear
	
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
	sta char_12_type01_t
	clc
	lda #$43
	adc REG0
	sta char_12_type02_t
	clc
	lda #$44
	adc REG0
	sta char_12_type03_t
	; 2列目
	clc
	lda #$51
	adc REG0
	sta char_12_type04_t
	clc
	lda #$52
	adc REG0
	sta char_12_type05_t
	clc
	lda #$53
	adc REG0
	sta char_12_type06_t
	clc
	lda #$54
	adc REG0
	sta char_12_type07_t
	; 3列目
	clc
	lda #$60
	adc REG0
	sta char_12_type08_t
	clc
	lda #$61
	adc REG0
	sta char_12_type09_t
	clc
	lda #$62
	adc REG0
	sta char_12_type10_t
	clc
	lda #$63
	adc REG0
	sta char_12_type11_t

; Y座標
	; 1列目
	clc			; キャリーフラグOFF
	lda habatan_pos_y
	adc #7
	sta char_12_type01_y
	sta char_12_type02_y
	sta char_12_type03_y
	
	; 2列目
	clc			; キャリーフラグOFF
	lda habatan_pos_y
	adc #15
	sta char_12_type04_y
	sta char_12_type05_y
	sta char_12_type06_y
	sta char_12_type07_y
	
	; 3列目
	clc			; キャリーフラグOFF
	lda habatan_pos_y
	adc #23
	sta char_12_type08_y
	sta char_12_type09_y
	sta char_12_type10_y
	sta char_12_type11_y
	

; X座標
	; xx123
	; x4567
	; 8901x

	; 存在していれば、ワールド座標からウィンドウ座標に変換
	sec
	lda habatan_world_pos_x_low
	sbc field_scroll_x_low
	sta habatan_window_pos_x

	lda habatan_window_pos_x
	sta char_12_type08_x

	lda habatan_window_pos_x
	clc			; キャリーフラグOFF
	adc #8
	sta char_12_type04_x
	sta char_12_type09_x

	lda habatan_window_pos_x
	clc			; キャリーフラグOFF
	adc #16
	sta char_12_type01_x
	sta char_12_type05_x
	sta char_12_type10_x

	lda habatan_window_pos_x
	clc			; キャリーフラグOFF
	adc #24
	sta char_12_type02_x
	sta char_12_type06_x
	sta char_12_type11_x

	lda habatan_window_pos_x
	clc			; キャリーフラグOFF
	adc #32
	sta char_12_type03_x
	sta char_12_type07_x

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
	sta char_12_type01_t2
	clc
	lda #$43
	adc REG0
	sta char_12_type02_t2
	clc
	lda #$44
	adc REG0
	sta char_12_type03_t2
	; 2列目
	clc
	lda #$51
	adc REG0
	sta char_12_type04_t2
	clc
	lda #$52
	adc REG0
	sta char_12_type05_t2
	clc
	lda #$53
	adc REG0
	sta char_12_type06_t2
	clc
	lda #$54
	adc REG0
	sta char_12_type07_t2
	; 3列目
	clc
	lda #$60
	adc REG0
	sta char_12_type08_t2
	clc
	lda #$61
	adc REG0
	sta char_12_type09_t2
	clc
	lda #$62
	adc REG0
	sta char_12_type10_t2
	clc
	lda #$63
	adc REG0
	sta char_12_type11_t2

; Y座標
	; 1列目
	clc			; キャリーフラグOFF
	lda habatan_pos_y
	adc #7
	sta char_12_type01_y2
	sta char_12_type02_y2
	sta char_12_type03_y2
	
	; 2列目
	clc			; キャリーフラグOFF
	lda habatan_pos_y
	adc #15
	sta char_12_type04_y2
	sta char_12_type05_y2
	sta char_12_type06_y2
	sta char_12_type07_y2
	
	; 3列目
	clc			; キャリーフラグOFF
	lda habatan_pos_y
	adc #23
	sta char_12_type08_y2
	sta char_12_type09_y2
	sta char_12_type10_y2
	sta char_12_type11_y2
	

; X座標
	; xx123
	; x4567
	; 8901x

	; 存在していれば、ワールド座標からウィンドウ座標に変換
	sec
	lda habatan_world_pos_x_low
	sbc field_scroll_x_low
	sta habatan_window_pos_x

	lda habatan_window_pos_x
	sta char_12_type08_x2

	lda habatan_window_pos_x
	clc			; キャリーフラグOFF
	adc #8
	sta char_12_type04_x2
	sta char_12_type09_x2

	lda habatan_window_pos_x
	clc			; キャリーフラグOFF
	adc #16
	sta char_12_type01_x2
	sta char_12_type05_x2
	sta char_12_type10_x2

	lda habatan_window_pos_x
	clc			; キャリーフラグOFF
	adc #24
	sta char_12_type02_x2
	sta char_12_type06_x2
	sta char_12_type11_x2

	lda habatan_window_pos_x
	clc			; キャリーフラグOFF
	adc #32
	sta char_12_type03_x2
	sta char_12_type07_x2

skip_draw:

	rts

.endproc	; HabatanDrawDma6

