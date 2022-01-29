.proc	BossInit
	lda #0
	sta boss_world_pos_x_low
	sta boss_world_pos_x_hi
	sta boss_pos_y
	sta boss_window_pos_x
	sta boss_status
	sta boss_update_step
	sta boss_alive_flag
	lda #224	; 画面外;#184
	sta boss_pos_y
	sta boss_pos_y
	
	rts
.endproc

; 登場
.proc appear_boss
	; パレットを変更する
	lda #10
	sta palette_change_state

	; 画面右端
	lda enemy_pos_x_hi
	sta boss_world_pos_x_hi
	lda enemy_pos_x_low
	sta boss_world_pos_x_low
	lda enemy_pos_y
	sta boss_pos_y
	
	; 色々初期化
	lda #0
	sta boss_status
	sta boss_update_step

	; タイル番号の設定
	lda #$99
	sta boss_index1_t
	sta boss_index1_t2
	lda #$9A
	sta boss_index2_t
	sta boss_index2_t2
	lda #$9B
	sta boss_index3_t
	sta boss_index3_t2
	lda #$9C
	sta boss_index4_t
	sta boss_index4_t2
	lda #$9D
	sta boss_index5_t
	sta boss_index5_t2
	lda #$9E
	sta boss_index6_t
	sta boss_index6_t2
	lda #$9F
	sta boss_index7_t
	sta boss_index7_t2
	lda #$A9
	sta boss_index8_t
	sta boss_index8_t2
	lda #$AA
	sta boss_index9_t
	sta boss_index9_t2
	lda #$AB
	sta boss_index10_t
	sta boss_index10_t2
	lda #$AC
	sta boss_index11_t
	sta boss_index11_t2
	lda #$AD
	sta boss_index12_t
	sta boss_index12_t2
	lda #$AE
	sta boss_index13_t
	sta boss_index13_t2
	lda #$AF
	sta boss_index14_t
	sta boss_index14_t2
	lda #$B9
	sta boss_index15_t
	sta boss_index15_t2
	lda #$BA
	sta boss_index16_t
	sta boss_index16_t2
	lda #$BB
	sta boss_index17_t
	sta boss_index17_t2
	lda #$BC
	sta boss_index18_t
	sta boss_index18_t2
	lda #$BD
	sta boss_index19_t
	sta boss_index19_t2
	lda #$BE
	sta boss_index20_t
	sta boss_index20_t2
	lda #$BF
	sta boss_index21_t
	sta boss_index21_t2
	lda #$C9
	sta boss_index22_t
	sta boss_index22_t2
	lda #$CA
	sta boss_index23_t
	sta boss_index23_t2
	lda #$CB
	sta boss_index24_t
	sta boss_index24_t2
	lda #$CC
	sta boss_index25_t
	sta boss_index25_t2
	lda #$CD
	sta boss_index26_t
	sta boss_index26_t2
	lda #$CE
	sta boss_index27_t
	sta boss_index27_t2
	lda #$DB
	sta boss_index28_t
	sta boss_index28_t2
	lda #$DC
	sta boss_index29_t
	sta boss_index29_t2
	lda #$DD
	sta boss_index30_t
	sta boss_index30_t2
	lda #$DE
	sta boss_index31_t
	sta boss_index31_t2
	lda #$EA
	sta boss_index32_t
	sta boss_index32_t2
	lda #$EB
	sta boss_index33_t
	sta boss_index33_t2
	lda #$EC
	sta boss_index34_t
	sta boss_index34_t2
	lda #$ED
	sta boss_index35_t
	sta boss_index35_t2
	lda #$EE
	sta boss_index36_t
	sta boss_index36_t2
	lda #$EF
	sta boss_index37_t
	sta boss_index37_t2
	lda #$FA
	sta boss_index38_t
	sta boss_index38_t2
	lda #$FB
	sta boss_index39_t
	sta boss_index39_t2
	lda #$FC
	sta boss_index40_t
	sta boss_index40_t2
	lda #$FD
	sta boss_index41_t
	sta boss_index41_t2
	lda #$FE
	sta boss_index42_t
	sta boss_index42_t2
	lda #$FF
	sta boss_index43_t
	sta boss_index43_t2

	; 属性
		; 属性は変わらないことはない
	lda #%00000001     ; 0(10進数)をAにロード
	sta boss_index1_s
	sta boss_index2_s
	sta boss_index5_s
	sta boss_index6_s
	sta boss_index7_s
	sta boss_index1_s2
	sta boss_index2_s2
	sta boss_index5_s2
	sta boss_index6_s2
	sta boss_index7_s2
	sta boss_index8_s
	sta boss_index9_s
	sta boss_index8_s2
	sta boss_index9_s2
	sta boss_index10_s
	sta boss_index11_s
	sta boss_index10_s2
	sta boss_index11_s2
	sta boss_index12_s
	sta boss_index13_s
	sta boss_index14_s
	sta boss_index12_s2
	sta boss_index13_s2
	sta boss_index14_s2
	sta boss_index15_s
	sta boss_index16_s
	sta boss_index17_s
	sta boss_index18_s
	sta boss_index19_s
	sta boss_index20_s
	sta boss_index21_s
	sta boss_index15_s2
	sta boss_index16_s2
	sta boss_index17_s2
	sta boss_index18_s2
	sta boss_index19_s2
	sta boss_index20_s2
	sta boss_index21_s2
	sta boss_index22_s
	sta boss_index23_s
	sta boss_index24_s
	sta boss_index25_s
	sta boss_index26_s
	sta boss_index27_s
	sta boss_index28_s
	sta boss_index22_s2
	sta boss_index23_s2
	sta boss_index24_s2
	sta boss_index25_s2
	sta boss_index26_s2
	sta boss_index27_s2
	sta boss_index28_s2
	sta boss_index29_s
	sta boss_index32_s
	sta boss_index29_s2
	sta boss_index32_s2
	sta boss_index33_s
	sta boss_index33_s2
	sta boss_index34_s
	sta boss_index34_s2
	sta boss_index35_s
	sta boss_index35_s2
	sta boss_index38_s
	sta boss_index39_s
	sta boss_index40_s
	sta boss_index38_s2
	sta boss_index39_s2
	sta boss_index40_s2
	sta boss_index41_s
	sta boss_index41_s2

	lda #%00000011     ; 0(10進数)をAにロード
	sta boss_index3_s
	sta boss_index4_s
	sta boss_index3_s2
	sta boss_index4_s2
	sta boss_index30_s
	sta boss_index31_s
	sta boss_index30_s2
	sta boss_index31_s2
	sta boss_index36_s
	sta boss_index37_s
	sta boss_index36_s2
	sta boss_index37_s2

	lda #%00000010     ; 0(10進数)をAにロード
	sta boss_index42_s
	sta boss_index43_s
	sta boss_index42_s2
	sta boss_index43_s2


	
	; フラグを立てる
	clc
	lda #1
	sta boss_alive_flag

	rts
.endproc	; appear_boss

; ボスクリア
.proc Boss_Clear
	lda #0
	sta boss_index1_y
	sta boss_index1_t
	sta boss_index1_s
	sta boss_index1_x
	sta boss_index2_y
	sta boss_index2_t
	sta boss_index2_s
	sta boss_index2_x
	sta boss_index3_y
	sta boss_index3_t
	sta boss_index3_s
	sta boss_index3_x
	sta boss_index4_y
	sta boss_index4_t
	sta boss_index4_s
	sta boss_index4_x
	sta boss_index5_y
	sta boss_index5_t
	sta boss_index5_s
	sta boss_index5_x
	sta boss_index6_y
	sta boss_index6_t
	sta boss_index6_s
	sta boss_index6_x
	sta boss_index7_y
	sta boss_index7_t
	sta boss_index7_s
	sta boss_index7_x
	sta boss_index8_y
	sta boss_index8_t
	sta boss_index8_s
	sta boss_index8_x
	sta boss_index9_y
	sta boss_index9_t
	sta boss_index9_s
	sta boss_index9_x
	sta boss_index10_y
	sta boss_index10_t
	sta boss_index10_s
	sta boss_index10_x
	sta boss_index11_y
	sta boss_index11_t
	sta boss_index11_s
	sta boss_index11_x
	sta boss_index12_y
	sta boss_index12_t
	sta boss_index12_s
	sta boss_index12_x
	sta boss_index13_y
	sta boss_index13_t
	sta boss_index13_s
	sta boss_index13_x
	sta boss_index14_y
	sta boss_index14_t
	sta boss_index14_s
	sta boss_index14_x
	sta boss_index15_y
	sta boss_index15_t
	sta boss_index15_s
	sta boss_index15_x
	sta boss_index16_y
	sta boss_index16_t
	sta boss_index16_s
	sta boss_index16_x
	sta boss_index17_y
	sta boss_index17_t
	sta boss_index17_s
	sta boss_index17_x
	sta boss_index18_y
	sta boss_index18_t
	sta boss_index18_s
	sta boss_index18_x
	sta boss_index19_y
	sta boss_index19_t
	sta boss_index19_s
	sta boss_index19_x
	sta boss_index20_y
	sta boss_index20_t
	sta boss_index20_s
	sta boss_index20_x
	sta boss_index21_y
	sta boss_index21_t
	sta boss_index21_s
	sta boss_index21_x
	sta boss_index22_y
	sta boss_index22_t
	sta boss_index22_s
	sta boss_index22_x
	sta boss_index23_y
	sta boss_index23_t
	sta boss_index23_s
	sta boss_index23_x
	sta boss_index24_y
	sta boss_index24_t
	sta boss_index24_s
	sta boss_index24_x
	sta boss_index25_y
	sta boss_index25_t
	sta boss_index25_s
	sta boss_index25_x
	sta boss_index26_y
	sta boss_index26_t
	sta boss_index26_s
	sta boss_index26_x
	sta boss_index27_y
	sta boss_index27_t
	sta boss_index27_s
	sta boss_index27_x
	sta boss_index28_y
	sta boss_index28_t
	sta boss_index28_s
	sta boss_index28_x
	sta boss_index29_y
	sta boss_index29_t
	sta boss_index29_s
	sta boss_index29_x
	sta boss_index30_y
	sta boss_index30_t
	sta boss_index30_s
	sta boss_index30_x
	sta boss_index31_y
	sta boss_index31_t
	sta boss_index31_s
	sta boss_index31_x
	sta boss_index32_y
	sta boss_index32_t
	sta boss_index32_s
	sta boss_index32_x
	sta boss_index33_y
	sta boss_index33_t
	sta boss_index33_s
	sta boss_index33_x
	sta boss_index34_y
	sta boss_index34_t
	sta boss_index34_s
	sta boss_index34_x
	sta boss_index35_y
	sta boss_index35_t
	sta boss_index35_s
	sta boss_index35_x
	sta boss_index36_y
	sta boss_index36_t
	sta boss_index36_s
	sta boss_index36_x
	sta boss_index37_y
	sta boss_index37_t
	sta boss_index37_s
	sta boss_index37_x
	sta boss_index38_y
	sta boss_index38_t
	sta boss_index38_s
	sta boss_index38_x
	sta boss_index39_y
	sta boss_index39_t
	sta boss_index39_s
	sta boss_index39_x
	sta boss_index40_y
	sta boss_index40_t
	sta boss_index40_s
	sta boss_index40_x
	sta boss_index41_y
	sta boss_index41_t
	sta boss_index41_s
	sta boss_index41_x
	sta boss_index42_y
	sta boss_index42_t
	sta boss_index42_s
	sta boss_index42_x
	sta boss_index43_y
	sta boss_index43_t
	sta boss_index43_s
	sta boss_index43_x
	sta boss_index1_y2
	sta boss_index1_t2
	sta boss_index1_s2
	sta boss_index1_x2
	sta boss_index2_y2
	sta boss_index2_t2
	sta boss_index2_s2
	sta boss_index2_x2
	sta boss_index3_y2
	sta boss_index3_t2
	sta boss_index3_s2
	sta boss_index3_x2
	sta boss_index4_y2
	sta boss_index4_t2
	sta boss_index4_s2
	sta boss_index4_x2
	sta boss_index5_y2
	sta boss_index5_t2
	sta boss_index5_s2
	sta boss_index5_x2
	sta boss_index6_y2
	sta boss_index6_t2
	sta boss_index6_s2
	sta boss_index6_x2
	sta boss_index7_y2
	sta boss_index7_t2
	sta boss_index7_s2
	sta boss_index7_x2
	sta boss_index8_y2
	sta boss_index8_t2
	sta boss_index8_s2
	sta boss_index8_x2
	sta boss_index9_y2
	sta boss_index9_t2
	sta boss_index9_s2
	sta boss_index9_x2
	sta boss_index10_y2
	sta boss_index10_t2
	sta boss_index10_s2
	sta boss_index10_x2
	sta boss_index11_y2
	sta boss_index11_t2
	sta boss_index11_s2
	sta boss_index11_x2
	sta boss_index12_y2
	sta boss_index12_t2
	sta boss_index12_s2
	sta boss_index12_x2
	sta boss_index13_y2
	sta boss_index13_t2
	sta boss_index13_s2
	sta boss_index13_x2
	sta boss_index14_y2
	sta boss_index14_t2
	sta boss_index14_s2
	sta boss_index14_x2
	sta boss_index15_y2
	sta boss_index15_t2
	sta boss_index15_s2
	sta boss_index15_x2
	sta boss_index16_y2
	sta boss_index16_t2
	sta boss_index16_s2
	sta boss_index16_x2
	sta boss_index17_y2
	sta boss_index17_t2
	sta boss_index17_s2
	sta boss_index17_x2
	sta boss_index18_y2
	sta boss_index18_t2
	sta boss_index18_s2
	sta boss_index18_x2
	sta boss_index19_y2
	sta boss_index19_t2
	sta boss_index19_s2
	sta boss_index19_x2
	sta boss_index20_y2
	sta boss_index20_t2
	sta boss_index20_s2
	sta boss_index20_x2
	sta boss_index21_y2
	sta boss_index21_t2
	sta boss_index21_s2
	sta boss_index21_x2
	sta boss_index22_y2
	sta boss_index22_t2
	sta boss_index22_s2
	sta boss_index22_x2
	sta boss_index23_y2
	sta boss_index23_t2
	sta boss_index23_s2
	sta boss_index23_x2
	sta boss_index24_y2
	sta boss_index24_t2
	sta boss_index24_s2
	sta boss_index24_x2
	sta boss_index25_y2
	sta boss_index25_t2
	sta boss_index25_s2
	sta boss_index25_x2
	sta boss_index26_y2
	sta boss_index26_t2
	sta boss_index26_s2
	sta boss_index26_x2
	sta boss_index27_y2
	sta boss_index27_t2
	sta boss_index27_s2
	sta boss_index27_x2
	sta boss_index28_y2
	sta boss_index28_t2
	sta boss_index28_s2
	sta boss_index28_x2
	sta boss_index29_y2
	sta boss_index29_t2
	sta boss_index29_s2
	sta boss_index29_x2
	sta boss_index30_y2
	sta boss_index30_t2
	sta boss_index30_s2
	sta boss_index30_x2
	sta boss_index31_y2
	sta boss_index31_t2
	sta boss_index31_s2
	sta boss_index31_x2
	sta boss_index32_y2
	sta boss_index32_t2
	sta boss_index32_s2
	sta boss_index32_x2
	sta boss_index33_y2
	sta boss_index33_t2
	sta boss_index33_s2
	sta boss_index33_x2
	sta boss_index34_y2
	sta boss_index34_t2
	sta boss_index34_s2
	sta boss_index34_x2
	sta boss_index35_y2
	sta boss_index35_t2
	sta boss_index35_s2
	sta boss_index35_x2
	sta boss_index36_y2
	sta boss_index36_t2
	sta boss_index36_s2
	sta boss_index36_x2
	sta boss_index37_y2
	sta boss_index37_t2
	sta boss_index37_s2
	sta boss_index37_x2
	sta boss_index38_y2
	sta boss_index38_t2
	sta boss_index38_s2
	sta boss_index38_x2
	sta boss_index39_y2
	sta boss_index39_t2
	sta boss_index39_s2
	sta boss_index39_x2
	sta boss_index40_y2
	sta boss_index40_t2
	sta boss_index40_s2
	sta boss_index40_x2
	sta boss_index41_y2
	sta boss_index41_t2
	sta boss_index41_s2
	sta boss_index41_x2
	sta boss_index42_y2
	sta boss_index42_t2
	sta boss_index42_s2
	sta boss_index42_x2
	sta boss_index43_y2
	sta boss_index43_t2
	sta boss_index43_s2
	sta boss_index43_x2

	lda #0
	sta boss_world_pos_x_low
	sta boss_world_pos_x_hi
	sta boss_pos_y
	sta boss_alive_flag

	rts
.endproc ; Boss_Clear

; 更新
.proc	BossUpdate
	;lda is_dead
	;bne skip_boss

	; 存在しているか
	lda boss_alive_flag
	cmp #0
	beq skip_boss

	; 状態
	lda boss_status	; ボス状態(0:停止、1:火吹き、2:くるくる、3:退場)

	cmp #0
	beq case_stop
	cmp #1
	beq case_fire
	cmp #2
	beq case_roll
	cmp #3
	beq case_leave

case_stop:
	jmp break
case_fire:
	jsr Boss_UpdateFire
	jmp break
case_roll:
	jmp break
case_leave:
	jmp break

	;cmp #0
	;beq case_normal
	;jmp case_dead	;	(1～3)

; 通常
case_normal:
	jsr Boss_UpdateNormal
	jmp break;


break:


skip_boss:
	rts
.endproc	; BossUpdate

; 火吹き更新
.proc Boss_UpdateFire	
	lda boss_update_step

	cmp #0
	beq case_init
	cmp #1
	beq case_init2
	cmp #2
	beq case_fire
	cmp #3
	beq case_fire_wait

case_init:
	; 横にする
	;lda $2000
	;and #%11111011
	;sta $2000
	inc boss_update_step
	jmp case_break

case_init2:
	inc boss_update_step
	jsr Boss_SetFire
	jmp case_break

case_fire:
	; 縦にする
	;lda $2000
	;ora #%00000100
	;sta $2000


	;jsr HabatanFire_Appear
	;jsr Boss_SetFire
	;jsr Sound_PlayFire
	inc boss_update_step
	
	jmp case_break

case_fire_wait:

	jmp case_break

case_break:

	rts
.endproc	; Boss_UpdateFire

; 通常更新
.proc	Boss_UpdateNormal

	; あたり判定
	jsr boss_collision_object
	
	lda obj_collision_result
	beq roll_skip
	; 当たった処理


	
roll_skip:

	rts
.endproc	; Boss_UpdateNormal


; 描画
.proc	BossDrawDma7

	ldx #0
	
loop_x:
	; 生存しているか
	lda boss_alive_flag
	bne not_skip_draw		; 存在してる
	jmp skip_draw
	not_skip_draw:


	; アニメパターン
	;REG0 = (p_pat == 0) ? #$20 : #0;

	lda p_pat
	beq set_pat0
	bne set_pat1
	
set_pat0:
	lda #$00
	sta REG0
	jmp break_pat
set_pat1:
	lda #$00
	sta REG0
	jmp break_pat
	
break_pat:

	lda boss_status
	cmp #0
	beq nomal
	cmp #1
	beq drown_tail
	
nomal:

	
	jmp break_tile
; 溺れタイル
drown_tail:


	jmp break_tile

break_tile:

	lda boss_pos_y
	sta boss_index1_y
	sta boss_index2_y
	sta boss_index3_y
	sta boss_index4_y
	sta boss_index5_y
	sta boss_index6_y
	sta boss_index7_y
	clc
	adc #8
	sta boss_index8_y
	sta boss_index9_y
	sta boss_index10_y
	sta boss_index11_y
	sta boss_index12_y
	sta boss_index13_y
	sta boss_index14_y
	clc
	adc #8
	sta boss_index15_y
	sta boss_index16_y
	sta boss_index17_y
	sta boss_index18_y
	sta boss_index19_y
	sta boss_index20_y
	sta boss_index21_y
	clc
	adc #8
	sta boss_index22_y
	sta boss_index23_y
	sta boss_index24_y
	sta boss_index25_y
	sta boss_index26_y
	sta boss_index27_y
	clc
	adc #8
	sta boss_index28_y
	sta boss_index29_y
	sta boss_index30_y
	sta boss_index31_y
	clc
	adc #8
	sta boss_index32_y
	sta boss_index33_y
	sta boss_index34_y
	sta boss_index35_y
	sta boss_index36_y
	sta boss_index37_y
	clc
	adc #8
	sta boss_index38_y
	sta boss_index39_y
	sta boss_index40_y
	sta boss_index41_y
	sta boss_index42_y
	sta boss_index43_y


	; 存在していれば、ワールド座標からウィンドウ座標に変換
	sec
	lda boss_world_pos_x_low
	sbc field_scroll_x_low
	sta boss_window_pos_x

	lda boss_window_pos_x
	sta boss_index1_x
	sta boss_index8_x
	sta boss_index15_x
	sta boss_index22_x

	lda boss_window_pos_x
	clc			; キャリーフラグOFF
	adc #8
	bcc not_overflow_8	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta boss_index2_y
	sta boss_index9_y
	sta boss_index16_y
	sta boss_index23_y
	sta boss_index32_y
	sta boss_index38_y
not_overflow_8:
	sta boss_index2_x
	sta boss_index9_x
	sta boss_index16_x
	sta boss_index23_x
	sta boss_index32_x
	sta boss_index38_x

	lda boss_window_pos_x
	clc			; キャリーフラグOFF
	adc #16
	bcc not_overflow_16	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta boss_index3_y
	sta boss_index10_y
	sta boss_index17_y
	sta boss_index24_y
	sta boss_index28_y
	sta boss_index33_y
	sta boss_index39_y
not_overflow_16:
	sta boss_index3_x
	sta boss_index10_x
	sta boss_index17_x
	sta boss_index24_x
	sta boss_index28_x
	sta boss_index33_x
	sta boss_index39_x

	lda boss_window_pos_x
	clc			; キャリーフラグOFF
	adc #24
	bcc not_overflow_24	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta boss_index4_y
	sta boss_index11_y
	sta boss_index18_y
	sta boss_index25_y
	sta boss_index29_y
	sta boss_index34_y
	sta boss_index40_y
not_overflow_24:
	sta boss_index4_x
	sta boss_index11_x
	sta boss_index18_x
	sta boss_index25_x
	sta boss_index29_x
	sta boss_index34_x
	sta boss_index40_x

	lda boss_window_pos_x
	clc			; キャリーフラグOFF
	adc #32
	bcc not_overflow_32	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta boss_index5_y
	sta boss_index12_y
	sta boss_index19_y
	sta boss_index26_y
	sta boss_index30_y
	sta boss_index35_y
	sta boss_index41_y
not_overflow_32:
	sta boss_index5_x
	sta boss_index12_x
	sta boss_index19_x
	sta boss_index26_x
	sta boss_index30_x
	sta boss_index35_x
	sta boss_index41_x

	lda boss_window_pos_x
	clc			; キャリーフラグOFF
	adc #40
	bcc not_overflow_40	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta boss_index6_y
	sta boss_index13_y
	sta boss_index20_y
	sta boss_index27_y
	sta boss_index31_y
	sta boss_index36_y
	sta boss_index42_y
not_overflow_40:
	sta boss_index6_x
	sta boss_index13_x
	sta boss_index20_x
	sta boss_index27_x
	sta boss_index31_x
	sta boss_index36_x
	sta boss_index42_x

	lda boss_window_pos_x
	clc			; キャリーフラグOFF
	adc #48
	bcc not_overflow_48	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta boss_index7_y
	sta boss_index14_y
	sta boss_index21_y
	sta boss_index37_y
	sta boss_index43_y
not_overflow_48:
	sta boss_index7_x
	sta boss_index14_x
	sta boss_index21_x
	sta boss_index37_x
	sta boss_index43_x

skip_draw:

	rts
.endproc	; BossDrawDma7

; 描画
.proc	BossDrawDma6
	ldx #0
	
loop_x:
	; 生存しているか
	lda boss_alive_flag
	bne not_skip_draw		; 存在してる
	jmp skip_draw
	not_skip_draw:


	; アニメパターン
	;REG0 = (p_pat == 0) ? #$20 : #0;

	lda p_pat
	beq set_pat0
	bne set_pat1
	
set_pat0:
	lda #$00
	sta REG0
	jmp break_pat
set_pat1:
	lda #$00
	sta REG0
	jmp break_pat
	
break_pat:

	lda boss_status
	cmp #0
	beq nomal
	cmp #1
	beq drown_tail
	
nomal:

	
	jmp break_tile
; 溺れタイル
drown_tail:


	jmp break_tile

break_tile:

	lda boss_pos_y
	sta boss_index1_y2
	sta boss_index2_y2
	sta boss_index3_y2
	sta boss_index4_y2
	sta boss_index5_y2
	sta boss_index6_y2
	sta boss_index7_y2
	clc
	adc #8
	sta boss_index8_y2
	sta boss_index9_y2
	sta boss_index10_y2
	sta boss_index11_y2
	sta boss_index12_y2
	sta boss_index13_y2
	sta boss_index14_y2
	clc
	adc #8
	sta boss_index15_y2
	sta boss_index16_y2
	sta boss_index17_y2
	sta boss_index18_y2
	sta boss_index19_y2
	sta boss_index20_y2
	sta boss_index21_y2
	clc
	adc #8
	sta boss_index22_y2
	sta boss_index23_y2
	sta boss_index24_y2
	sta boss_index25_y2
	sta boss_index26_y2
	sta boss_index27_y2
	;
	clc
	adc #8
	;
	;
	sta boss_index28_y2
	sta boss_index29_y2
	sta boss_index30_y2
	sta boss_index31_y2
	;
	clc
	adc #8
	;
	sta boss_index32_y2
	sta boss_index33_y2
	sta boss_index34_y2
	sta boss_index35_y2
	sta boss_index36_y2
	sta boss_index37_y2
	clc
	adc #8
	;
	sta boss_index38_y2
	sta boss_index39_y2
	sta boss_index40_y2
	sta boss_index41_y2
	sta boss_index42_y2
	sta boss_index43_y2


	; 存在していれば、ワールド座標からウィンドウ座標に変換
	sec
	lda boss_world_pos_x_low
	sbc field_scroll_x_low
	sta boss_window_pos_x

	lda boss_window_pos_x
	sta boss_index1_x2
	sta boss_index8_x2
	sta boss_index15_x2
	sta boss_index22_x2

	lda boss_window_pos_x
	clc			; キャリーフラグOFF
	adc #8
	bcc not_overflow_8	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta boss_index2_y2
	sta boss_index9_y2
	sta boss_index16_y2
	sta boss_index23_y2
	sta boss_index32_y2
	sta boss_index38_y2
not_overflow_8:
	sta boss_index2_x2
	sta boss_index9_x2
	sta boss_index16_x2
	sta boss_index23_x2
	sta boss_index32_x2
	sta boss_index38_x2

	lda boss_window_pos_x
	clc			; キャリーフラグOFF
	adc #16
	bcc not_overflow_16	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta boss_index3_y2
	sta boss_index10_y2
	sta boss_index17_y2
	sta boss_index24_y2
	sta boss_index28_y2
	sta boss_index33_y2
	sta boss_index39_y2
not_overflow_16:
	sta boss_index3_x2
	sta boss_index10_x2
	sta boss_index17_x2
	sta boss_index24_x2
	sta boss_index28_x2
	sta boss_index33_x2
	sta boss_index39_x2

	lda boss_window_pos_x
	clc			; キャリーフラグOFF
	adc #24
	bcc not_overflow_24	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta boss_index4_y2
	sta boss_index11_y2
	sta boss_index18_y2
	sta boss_index25_y2
	sta boss_index29_y2
	sta boss_index34_y2
	sta boss_index40_y2
not_overflow_24:
	sta boss_index4_x2
	sta boss_index11_x2
	sta boss_index18_x2
	sta boss_index25_x2
	sta boss_index29_x2
	sta boss_index34_x2
	sta boss_index40_x2

	lda boss_window_pos_x
	clc			; キャリーフラグOFF
	adc #32
	bcc not_overflow_32	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta boss_index5_y2
	sta boss_index12_y2
	sta boss_index19_y2
	sta boss_index26_y2
	sta boss_index30_y2
	sta boss_index35_y2
	sta boss_index41_y2
not_overflow_32:
	sta boss_index5_x2
	sta boss_index12_x2
	sta boss_index19_x2
	sta boss_index26_x2
	sta boss_index30_x2
	sta boss_index35_x2
	sta boss_index41_x2

	lda boss_window_pos_x
	clc			; キャリーフラグOFF
	adc #40
	bcc not_overflow_40	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta boss_index6_y2
	sta boss_index13_y2
	sta boss_index20_y2
	sta boss_index27_y2
	sta boss_index31_y2
	sta boss_index36_y2
	sta boss_index42_y2
not_overflow_40:
	sta boss_index6_x2
	sta boss_index13_x2
	sta boss_index20_x2
	sta boss_index27_x2
	sta boss_index31_x2
	sta boss_index36_x2
	sta boss_index42_x2

	lda boss_window_pos_x
	clc			; キャリーフラグOFF
	adc #48
	bcc not_overflow_48	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta boss_index7_y2
	sta boss_index14_y2
	sta boss_index21_y2
	sta boss_index37_y2
	sta boss_index43_y2
not_overflow_48:
	sta boss_index7_x2
	sta boss_index14_x2
	sta boss_index21_x2
	sta boss_index37_x2
	sta boss_index43_x2


skip_draw:

	rts
.endproc	; BossDrawDma6

; ボスとオブジェクトとのあたり判定
.proc boss_collision_object
	; プレイヤが死亡中は判定しない
	lda is_dead
	beq skip_return
	lda #0
	sta obj_collision_result
	rts
skip_return:

	rts
.endproc	; boss_collision_object

.proc Boss_SetFire
	; 1 PLAYER GAME
	;lda #14
	;sta draw_bg_y
	;lda #10
	;sta draw_bg_x
	;jsr SetPosition
	
	; 横にする
	;lda $2000
	;and #%11111011
	;sta $2000

	;lda #%00001000	;
	;sta $2000

	
;1	
	lda #$21
	sta $2006
	lda #$F2
	sta $2006

	ldx #0
	loop_moji_x:
	lda image_fire_1, x
	sta $2007
	inx
	cpx #4
	bne loop_moji_x

;2
	lda #$21
	sta $2006
	lda #$F3
	sta $2006

	ldx #0
	loop_moji_x2:
	lda image_fire_2, x
	sta $2007
	inx
	cpx #4
	bne loop_moji_x2

;3
	lda #$21
	sta $2006
	lda #$F4
	sta $2006

	ldx #0
	loop_moji_x3:
	lda image_fire_3, x
	sta $2007
	inx
	cpx #4
	bne loop_moji_x3

;4
	lda #$21
	sta $2006
	lda #$F5
	sta $2006

	ldx #0
	loop_moji_x4:
	lda image_fire_4, x
	sta $2007
	inx
	cpx #4
	bne loop_moji_x4

	; 縦にする
	;lda $2000
	;ora #%00000100
	;sta $2000

	rts
.endproc ; Boss_SetFire