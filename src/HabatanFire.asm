.include "macro.asm"

.proc	HabatanFire_Init
	jsr HabatanFire_Clear
	
	rts
.endproc

; はばタンファイアークリア
.proc HabatanFire_Clear
	
	; 生存フラグの確認
	lda habatan_fire_alive_flag
	bne not_skip_clear				; 存在している
	jmp skip_clear
	not_skip_clear:

	lda #0
	sta haba_fire1_y
	sta haba_fire1_t
	sta haba_fire1_s
	sta haba_fire1_x
	sta haba_fire2_y
	sta haba_fire2_t
	sta haba_fire2_s
	sta haba_fire2_x
	sta haba_fire3_y
	sta haba_fire3_t
	sta haba_fire3_s
	sta haba_fire3_x
	sta haba_fire4_y
	sta haba_fire4_t
	sta haba_fire4_s
	sta haba_fire4_x
	sta haba_fire5_y
	sta haba_fire5_t
	sta haba_fire5_s
	sta haba_fire5_x
	sta haba_fire6_y
	sta haba_fire6_t
	sta haba_fire6_s
	sta haba_fire6_x
	sta haba_fire7_y
	sta haba_fire7_t
	sta haba_fire7_s
	sta haba_fire7_x
	sta haba_fire8_y
	sta haba_fire8_t
	sta haba_fire8_s
	sta haba_fire8_x
	sta haba_fire9_y
	sta haba_fire9_t
	sta haba_fire9_s
	sta haba_fire9_x
	sta haba_fire1_y2
	sta haba_fire1_t2
	sta haba_fire1_s2
	sta haba_fire1_x2
	sta haba_fire2_y2
	sta haba_fire2_t2
	sta haba_fire2_s2
	sta haba_fire2_x2
	sta haba_fire3_y2
	sta haba_fire3_t2
	sta haba_fire3_s2
	sta haba_fire3_x2
	sta haba_fire4_y2
	sta haba_fire4_t2
	sta haba_fire4_s2
	sta haba_fire4_x2
	sta haba_fire5_y2
	sta haba_fire5_t2
	sta haba_fire5_s2
	sta haba_fire5_x2
	sta haba_fire6_y2
	sta haba_fire6_t2
	sta haba_fire6_s2
	sta haba_fire6_x2
	sta haba_fire7_y2
	sta haba_fire7_t2
	sta haba_fire7_s2
	sta haba_fire7_x2
	sta haba_fire8_y2
	sta haba_fire8_t2
	sta haba_fire8_s2
	sta haba_fire8_x2
	sta haba_fire9_y2
	sta haba_fire9_t2
	sta haba_fire9_s2
	sta haba_fire9_x2
	
	; 生存フラグを落とす
	lda #0
	sta habatan_fire_alive_flag

skip_clear:

	rts
.endproc ; HabatanFire_Clear

;;;;; 登場 ;;;;;
.proc HabatanFire_Appear

	; 空いているか
	lda habatan_fire_alive_flag
	beq set_fire
	
	; ここまで来たら空きはないのでスキップ
	jmp skip_fire

set_fire:

	ldy #0
	txa
	beq skip_set24
	ldy #24
	skip_set24:
	
	; タイル番号
	lda #$4A
	sta haba_fire1_t
	lda #$4B
	sta haba_fire2_t
	lda #$00
	sta haba_fire3_t
	lda #$00
	sta haba_fire4_t
	lda #$5A
	sta haba_fire5_t
	lda #$5B
	sta haba_fire6_t
	lda #$00
	sta haba_fire7_t
	lda #$00
	sta haba_fire8_t
	
	; 属性
	; パレット3を使う
	lda #%00000010
	sta haba_fire1_s
	sta haba_fire2_s
	sta haba_fire3_s
	sta haba_fire4_s
	sta haba_fire5_s
	sta haba_fire6_s
	sta haba_fire7_s
	sta haba_fire8_s
	sta haba_fire9_s
	sta haba_fire1_s2
	sta haba_fire2_s2
	sta haba_fire3_s2
	sta haba_fire4_s2
	sta haba_fire5_s2
	sta haba_fire6_s2
	sta haba_fire7_s2
	sta haba_fire8_s2
	sta haba_fire9_s2
	
	lda #0
	sta habatan_fire_status
	
	lda #10
	sta habatan_fire_wait

	; ワールド座標ははばタンを流用

	; 生存フラグを立てる
	lda #1
	sta habatan_fire_alive_flag

	; パレット3を炎
	lda #2
	sta palette_change_state

skip_fire:


	rts
.endproc	; HabatanFire_Appear

;;;;; 更新 ;;;;;
.proc	HabatanFire_Update
	lda is_dead
	beq not_skip_update1
	jmp skip_update
	not_skip_update1:

	; 居ない
	lda habatan_fire_alive_flag
	bne not_skip_update2
	jmp skip_update
	not_skip_update2:

	; 存在している
	
	; 状態　
	lda habatan_fire_status
	cmp #0
	beq step_1
	cmp #1
	beq step_2
	cmp #2
	beq step_3
	
step_1:
	dec habatan_fire_wait
	lda habatan_fire_wait
	bne case_break
	lda #10
	sta habatan_fire_wait
	lda #1
	sta habatan_fire_status
	jmp case_break
step_2:
	dec habatan_fire_wait
	lda habatan_fire_wait
	bne case_break
	lda #10
	sta habatan_fire_wait
	lda #2
	sta habatan_fire_status
	jmp case_break
step_3:
	dec habatan_fire_wait
	lda habatan_fire_wait
	bne case_break
	
	jsr HabatanFire_Clear
	
	jmp case_break

case_break:

	;;;;; 敵との当たり判定
	; タマネギ
	lda #1
	sta tamanegi_alive_flag_current	; フラグ参照現在位置
	ldx #0
loop_tamanegi:
	; 生存しているか
	lda tamanegi_alive_flag
	and tamanegi_alive_flag_current
	beq next_tamanegi		; 存在していない
	; 既に燃えているか
	lda tamanegi00_status,x
	cmp #3
	beq next_tamanegi		; 既に燃えている

	; 存在している
	jsr HabatanFire_CollisionTamanegi
	lda char_collision_result
	beq skip_tamanegi_fire
	; タマネギ燃える
	lda #3
	sta tamanegi00_status,x
	lda #0
	sta tamanegi00_update_step,x
	AddScore #100

	skip_tamanegi_fire:
	next_tamanegi:
	; 次
	asl tamanegi_alive_flag_current
	inx
	cpx tamanegi_max_count	; ループ最大数
	bne loop_tamanegi		; ループ

	; タコ
	lda #1
	sta tako_alive_flag_current
	ldx #0
loop_tako:
	lda tako_haba_alive_flag
	and tako_alive_flag_current
	beq next_tako
	; 既に燃えているか
	lda tako00_status,x
	cmp #1
	beq next_tako		; 既に燃えている
	jsr HabatanFire_CollisionTakoHaba
	lda char_collision_result
	beq skip_tako_haba_fire
	; タコ燃える
	lda #1
	sta tako00_status,x
	AddScore #150

	skip_tako_haba_fire:

	next_tako:
	asl tako_alive_flag_current
	inx
	cpx tako_max_count
	bne loop_tako

skip_update:
	rts
.endproc	; HabatanFire_Update


; 描画
.proc	HabatanFire_DrawDma7

	; 生存しているか
	lda habatan_fire_alive_flag
	bne not_skip_draw		; 存在してる
	jmp skip_draw
	not_skip_draw:

	; 存在していれば、ウィンドウ座標ははばタンに依存
	lda habatan_window_pos_x
	clc			; キャリーフラグOFF
	adc #40
	sta haba_fire1_x
	sta haba_fire3_x

	lda habatan_window_pos_x
	clc			; キャリーフラグOFF
	adc #48
	sta haba_fire2_x
	sta haba_fire4_x
	sta haba_fire6_x

	lda habatan_window_pos_x
	clc			; キャリーフラグOFF
	adc #56
	sta haba_fire5_x
	sta haba_fire7_x
	sta haba_fire8_x

	lda habatan_window_pos_x
	clc			; キャリーフラグOFF
	adc #64
	sta haba_fire9_x
	
	clc
	lda habatan_pos_y
	adc #15
	sta haba_fire1_y
	sta haba_fire2_y
	clc
	adc #8
	sta haba_fire3_y
	sta haba_fire4_y
	sta haba_fire5_y
	clc
	adc #8
	sta haba_fire6_y
	sta haba_fire7_y
	clc
	adc #8
	sta haba_fire8_y
	sta haba_fire9_y
	
	; 状態　
	lda habatan_fire_status
	cmp #0
	beq step_1
	cmp #1
	beq step_2
	cmp #2
	beq step_3

step_1:
	; タイル番号
	lda #$4A
	sta haba_fire1_t
	lda #$4B
	sta haba_fire2_t
	lda #$5A
	sta haba_fire3_t
	lda #$5B
	sta haba_fire4_t
	lda #$00
	sta haba_fire5_t
	lda #$00
	sta haba_fire6_t
	lda #$00
	sta haba_fire7_t
	lda #$00
	sta haba_fire8_t
	lda #$00
	sta haba_fire9_t
	jmp case_break
	
step_2:
	; タイル番号
	lda #$4C
	sta haba_fire1_t
	lda #$4D
	sta haba_fire2_t
	lda #$5C
	sta haba_fire3_t
	lda #$5D
	sta haba_fire4_t
	lda #$5E
	sta haba_fire5_t
	lda #$6D
	sta haba_fire6_t
	lda #$6E
	sta haba_fire7_t
	lda #$7E
	sta haba_fire8_t
	lda #$7F
	sta haba_fire9_t
	jmp case_break

step_3:
	; タイル番号
	lda #$00
	sta haba_fire1_t
	lda #$00
	sta haba_fire2_t
	lda #$00
	sta haba_fire3_t
	lda #$00
	sta haba_fire4_t
	lda #$00
	sta haba_fire5_t
	lda #$00
	sta haba_fire6_t
	lda #$6A
	sta haba_fire7_t
	lda #$7A
	sta haba_fire8_t
	lda #$7B
	sta haba_fire9_t
	jmp case_break

case_break:

skip_draw:

	rts

.endproc	; HabatanFire_DrawDma7

; 描画
.proc	HabatanFire_DrawDma6
	; 生存しているか
	lda habatan_fire_alive_flag
	bne not_skip_draw		; 存在してる
	jmp skip_draw
	not_skip_draw:

	; 存在していれば、ウィンドウ座標ははばタンに依存
	lda habatan_window_pos_x
	clc			; キャリーフラグOFF
	adc #40
	sta haba_fire1_x2
	sta haba_fire3_x2

	lda habatan_window_pos_x
	clc			; キャリーフラグOFF
	adc #48
	sta haba_fire2_x2
	sta haba_fire4_x2
	sta haba_fire6_x2

	lda habatan_window_pos_x
	clc			; キャリーフラグOFF
	adc #56
	sta haba_fire5_x2
	sta haba_fire7_x2
	sta haba_fire8_x2

	lda habatan_window_pos_x
	clc			; キャリーフラグOFF
	adc #64
	sta haba_fire9_x2
	
	clc
	lda habatan_pos_y
	adc #15
	sta haba_fire1_y2
	sta haba_fire2_y2
	clc
	adc #8
	sta haba_fire3_y2
	sta haba_fire4_y2
	sta haba_fire5_y2
	clc
	adc #8
	sta haba_fire6_y2
	sta haba_fire7_y2
	clc
	adc #8
	sta haba_fire8_y2
	sta haba_fire9_y2
	
	; 状態　
	lda habatan_fire_status
	cmp #0
	beq step_1
	cmp #1
	beq step_2
	cmp #2
	beq step_3

step_1:
	; タイル番号
	lda #$4A
	sta haba_fire1_t2
	lda #$4B
	sta haba_fire2_t2
	lda #$5A
	sta haba_fire3_t2
	lda #$5B
	sta haba_fire4_t2
	lda #$00
	sta haba_fire5_t2
	lda #$00
	sta haba_fire6_t2
	lda #$00
	sta haba_fire7_t2
	lda #$00
	sta haba_fire8_t2
	lda #$00
	sta haba_fire9_t2
	jmp case_break
	
step_2:
	; タイル番号
	lda #$4C
	sta haba_fire1_t2
	lda #$4D
	sta haba_fire2_t2
	lda #$5C
	sta haba_fire3_t2
	lda #$5D
	sta haba_fire4_t2
	lda #$5E
	sta haba_fire5_t2
	lda #$6D
	sta haba_fire6_t2
	lda #$6E
	sta haba_fire7_t2
	lda #$7E
	sta haba_fire8_t2
	lda #$7F
	sta haba_fire9_t2
	jmp case_break

step_3:
	; タイル番号
	lda #$00
	sta haba_fire1_t2
	lda #$00
	sta haba_fire2_t2
	lda #$00
	sta haba_fire3_t2
	lda #$00
	sta haba_fire4_t2
	lda #$00
	sta haba_fire5_t2
	lda #$00
	sta haba_fire6_t2
	lda #$6A
	sta haba_fire7_t2
	lda #$7A
	sta haba_fire8_t2
	lda #$7B
	sta haba_fire9_t2
	jmp case_break

case_break:

skip_draw:

	rts

.endproc	; HabatanFire_DrawDma6

; タマネギとの当たり判定
.proc HabatanFire_CollisionTamanegi

	; 炎のXとタマネギのXの大きい方
	clc
	lda habatan_window_pos_x
	adc #56
	sta REG2	; 炎の中心
	clc
	lda tamanegi0_window_pos_x,x
	adc #8
	sta REG3	; タマネギの中心
	
	sec
	lda REG2
	sbc REG3
	bpl big_player_x	; 炎の方が大きい
	; タマネギの方が大きい
	sec
	lda REG3
	sbc REG2
big_player_x:
	sta REG0	; X差分

	; 炎のYとタマネギのYの大きい方
	clc
	lda habatan_pos_y
	adc #24
	sta REG2	; 炎の中心
	clc
	lda tamanegi0_pos_y,x
	adc #8
	sta REG3	; タマネギの中心
	
	sec
	lda REG2
	sbc REG3
	bpl big_player_y	; 炎の方が大きい
	; タマネギの方が大きい
	sec
	lda REG3
	sbc REG2
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
	sbc #25
	bpl	next_update	; 差分が24より大きい

	lda #1
	sta char_collision_result
	jmp exit

	next_update:

exit:

	rts
.endproc	; HabatanFire_CollisionTamanegi

; はばタコとの当たり判定
.proc HabatanFire_CollisionTakoHaba

	; 炎のXとタコのXの大きい方
	clc
	lda habatan_window_pos_x
	adc #56
	sta REG2	; 炎の中心
	clc
	lda tako0_window_pos_x,x
	adc #8
	sta REG3	; タコの中心
	
	sec
	lda REG2
	sbc REG3
	bpl big_player_x	; 炎の方が大きい
	; タコの方が大きい
	sec
	lda REG3
	sbc REG2
big_player_x:
	sta REG0	; X差分

	; 炎のYとタコのYの大きい方
	clc
	lda habatan_pos_y
	adc #24
	sta REG2	; 炎の中心
	clc
	lda tako0_pos_y,x
	adc #8
	sta REG3	; タコの中心
	
	sec
	lda REG2
	sbc REG3
	bpl big_player_y	; 炎の方が大きい
	; タコの方が大きい
	sec
	lda REG3
	sbc REG2
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
	sbc #25
	bpl	next_update	; 差分が24より大きい

	lda #1
	sta char_collision_result
	jmp exit

	next_update:

exit:

	rts
.endproc	; HabatanFire_CollisionTakoHaba
