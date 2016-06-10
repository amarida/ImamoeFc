.proc scene_maingame

	jsr confirm_appear_enemy
	jsr change_palette_table

	; 画面外背景の描画
	jsr draw_bg_name_table	; ネームテーブル
	jsr draw_bg_attribute	; 属性テーブル
	jsr DrawStatus

	lda $2002		; スクロール値クリア
	lda #$00
	sta $2005		; X方向スクロール
	lda #$00		; Y方向固定
	sta $2005


;	jsr	sprite_draw2	; スプライト描画関数(色替えテスト表示)

	lda loop_count
	and #%00000001
	bne player_dma7
	beq player_dma6
player_dma7:
	jsr	player_draw_dma7		; プレイヤー描画関数
	jsr InosisiDrawDma7			; イノシシ描画関数
	jsr TakoDrawDma7			; タコ描画関数
	jsr TakoHaba_DrawDma7		; タコ描画関数
	jsr TamanegiDrawDma7		; タマネギ描画関数
	jsr TamanegiFire_DrawDma7	; タマネギファイアーマスク
	jsr HabatanDrawDma7			; はばタン描画
	jsr HabatanFire_DrawDma7	; はばタンファイアー描画
	jsr Item_DrawDma7			; 酒描画
	jmp player_dma_break
player_dma6:
	jsr	player_draw_dma6		; プレイヤー描画関数
	jsr InosisiDrawDma6			; イノシシ描画関数
	jsr TakoDrawDma6			; タコ描画関数
	jsr TakoHaba_DrawDma6		; タコ描画関数
	jsr TamanegiDrawDma6		; タマネギ描画関数
	jsr TamanegiFire_DrawDma6	; タマネギファイアーマスク
	jsr HabatanDrawDma6			; はばタン描画
	jsr HabatanFire_DrawDma6	; はばタンファイアー描画
	jsr Item_DrawDma6			; 酒描画
	jmp player_dma_break
player_dma_break:
	
	lda loop_count
	and #%00000001
	bne dma7
	beq dma6
dma7:
	; スプライト描画(DMAを利用)
	lda #$7  ; スプライトデータは$0700番地からなので、7をロードする。
	sta $4014 ; スプライトDMAレジスタにAをストアして、スプライトデータをDMA転送する
	jmp dma_break
dma6:
	lda #$6  ; スプライトデータは$0600番地からなので、6をロードする。
	sta $4014 ; スプライトDMAレジスタにAをストアして、スプライトデータをDMA転送する
	jmp dma_break
dma_break:

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

	; スクロール位置更新
	lda $2002		; スクロール値クリア
	lda scroll_x
	sta	$2005		; X方向スクロール
	lda	#0		; Yは固定
	sta	$2005

	clc
	lda #%10001100	; VBlank割り込みあり
	adc current_draw_display_no	; 画面０か１
	sta $2000
	
	jsr	Update	; 更新

	rts
.endproc

.proc waitScan			; 何もせず待つ
	ldx #167	;#167
waitScanSub:
	dex
	bne waitScanSub
	rts
.endproc

; 更新
.proc	Update
	lda scene_maingame_init
	bne first_skip
	lda #1
	sta scene_maingame_init
	jsr PlayBgmIntroduction

first_skip:
	inc loop_count

	inc timer_count

	; キー入力
	; 初期化
	lda #$01
	sta $4016
	lda #$00
	sta $4016

	; 前回の状態を格納
	lda key_state_on
	sta key_state_on_old

	lda #0
	sta key_state_on

	; A,B,SELECT,START,UP,DOWN,LEFT,RIGHTの順番
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
	lda $4016	; 上
	and #1
	beq SkipKeyUp
	jsr PlayerMoveUp
SkipKeyUp:
	lda $4016	; 下
	and #1
	beq SkipKeyDown
	jsr PlayerMoveDown
SkipKeyDown:
	lda $4016	; 左
	and #1
	beq SkipKeyLeft
	jsr PlayerMoveLeft
SkipKeyLeft:
	lda $4016	; 右
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
	jsr	TakoUpdate
	jsr	TakoHaba_Update
	jsr	TamanegiUpdate
	jsr TamanegiFire_Update
	jsr HabatanUpdate
	jsr HabatanFire_Update
	jsr Item_Update

;	jsr confirm_appear_enemy

	lda bgm_type
	beq skip_bgm
	jsr UpdateBgm
	skip_bgm:

	lda se_type
	beq skip_se
	jsr UpdateSe
	skip_se:

	jsr UpdateTimer
	jsr ConvertTimerBinaryToBCD
	jsr ConvertScoreBinaryToBCD

	rts	; サブルーチンから復帰します。
.endproc

; タイマー更新
.proc UpdateTimer

	lda is_dead
	bne skip

	lda timer_count
	cmp #24
	bne skip
	lda #0
	sta timer_count



	sec
	lda timer_b0
	sbc #1
	sta timer_b0
	lda timer_b1
	sbc #0
	sta timer_b1

break:
	lda timer_b0
	bne skip
	lda timer_b1
	bne skip

	jsr PlayerDead	; プレイヤー死亡

skip:
	rts
.endproc	; UpdateTimer

; 敵登場確認
.proc confirm_appear_enemy
	; スクロール位置が達していたら
	; 敵を登場させて、登場済みフラグを立てる

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
	; 上位の比較で達しているか
	sec
	lda field_scroll_x_up_tmp
	sbc enemy_pos_x_hi
	bcc appear_skip	; キャリーフラグがクリア（超過）されている場合

	iny
	lda (map_enemy_info_address_low), y
	sta enemy_pos_x_low
	; 下位の比較で達しているか
	sec
	lda field_scroll_x_low_tmp
	sbc enemy_pos_x_low
	bcc appear_skip	; キャリーフラグがクリア（超過）されている場合

	iny
	lda (map_enemy_info_address_low), y
	sta enemy_pos_y
	iny
	lda (map_enemy_info_address_low), y
	sta enemy_type

	; 敵キャラクターの登場
	jsr appear_enemy

	; アドレスは4ずらす
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

; 敵キャラクターの登場
.proc appear_enemy
;enemy_pos_x_low						= $C2
;enemy_pos_x_hi						= $C3
;enemy_pos_y							= $C4
;enemy_type							= $C5

	lda enemy_type
	cmp #0
	beq case_inosisi
	cmp #1
	beq case_tako
	cmp #2
	beq case_tamanegi
	cmp #3
	beq case_habatan
	cmp #4
	beq case_habatako
	cmp #5
	beq case_item

case_inosisi:
	jsr appear_inosisi
	jmp break
case_tako:
	jsr appear_tako
	jmp break
case_tamanegi:
	jsr appear_tamanegi
	jmp break
case_habatan:
	jsr appear_habatan
	jmp break
case_habatako:
	jsr appear_tako_haba
	jmp break
case_item:
	jsr Item_Appear
	jmp break

break:
	
	rts
.endproc

; ステータス情報の描画
.proc DrawStatus

;	clc
;	adc current_draw_display_no	; 画面０か１
;	lda #%10001000	; VRAM増加量1byte
;	sta $2000

	; タイム
	lda #$20
	sta $2006
	lda #$7C
	sta $2006
	lda timer_bcd1
	and #%00001111
	clc
	adc #$30
	sta $2007

	lda #$20
	sta $2006
	lda #$7D
	sta $2006
	lda timer_bcd0
	lsr
	lsr
	lsr
	lsr
	clc
	adc #$30
	sta $2007

	lda #$20
	sta $2006
	lda #$7E
	sta $2006
	lda timer_bcd0
	and #%00001111
	clc
	adc #$30
	sta $2007

;	clc
;	lda #%10001100	; VRAM増加量32byte
;	adc current_draw_display_no	; 画面０か１
;	sta $2000

rts
	; スコア
	lda #$20
	sta $2006
	lda #$70
	sta $2006
	lda score_bcd2
	lsr
	lsr
	lsr
	lsr
	adc #$30
	sta $2007

	lda #$20
	sta $2006
	lda #$71
	sta $2006
	lda score_bcd2
	and #%00001111
	adc #$30
	sta $2007

	rts
.endproc

; 固定ステータス情報の描画BG
.proc SetStatusNameAttribute

	; 属性
	lda #$23
	sta $2006
	lda #$C0
	sta $2006
	lda #$AA
	sta $2007
	sta $2007
	sta $2007
	sta $2007
	sta $2007
	sta $2007
	sta $2007
	sta $2007

	; ネームテーブル
	; LIFE
	lda #$20
	sta $2006
	lda #$61
	sta $2006
	ldx #0
life_loop_x:
	lda string_life, x
	sta $2007
	inx
	cpx #4
	bne life_loop_x

	; SCORE
	lda #$20
	sta $2006
	lda #$6A
	sta $2006
	ldx #0
score_loop_x:
	lda string_score, x
	sta $2007
	inx
	cpx #5
	bne score_loop_x

	; TIME
	lda #$20
	sta $2006
	lda #$77
	sta $2006
	ldx #0
time_loop_x:
	lda string_time, x
	sta $2007
	inx
	cpx #4
	bne time_loop_x

	; SCORE zero
	lda #$20
	sta $2006
	lda #$70
	sta $2006
	ldx #0
score_loop_zero_x:
	lda string_zero_score, x
	sta $2007
	inx
	cpx #6
	bne score_loop_zero_x

	; TIME 255
	lda #$20
	sta $2006
	lda #$7C
	sta $2006
	ldx #0
time_loop_first_x:
	lda string_first_time, x
	sta $2007
	inx
	cpx #3
	bne time_loop_first_x

	rts
.endproc

; スコアのBCDへの変換
.proc ConvertScoreBinaryToBCD

	lda score_b0
	sta REG1
	lda score_b1
	sta REG2

	lda #0
	sta score_bcd0
	sta score_bcd1
	sta score_bcd2

	ldy #16

loop_bcd:

	clc
	lda score_bcd0
	adc #3
	sta REG0
	and #%00001000
	beq skip_bcd0low	; 0ならスキップ
	lda REG0
	sta score_bcd0		; 3加えた値を設定
skip_bcd0low:

	lda score_bcd0
	adc #%00110000
	sta REG0
	and #%10000000
	beq skip_bcd0hi		; 0ならスキップ
	lda REG0
	sta score_bcd0		; #%00110000加えた値を設定
skip_bcd0hi:

	lda score_bcd1
	adc #3
	sta REG0
	and #%00001000
	beq skip_bcd1low	; 0ならスキップ
	lda REG0
	sta score_bcd1			; 3加えた値を設定
skip_bcd1low:

	lda score_bcd1
	adc #%00110000
	sta REG0
	and #%10000000
	beq skip_bcd1hi		; 0ならスキップ
	lda REG0
	sta score_bcd1			; #%00110000加えた値を設定
skip_bcd1hi:

	lda score_bcd2
	adc #3
	sta REG0
	and #%00001000
	beq skip_bcd2low	; 0ならスキップ
	lda REG0
	sta score_bcd2			; 3加えた値を設定
skip_bcd2low:

	lda score_bcd2
	adc #%00110000
	sta REG0
	and #%10000000
	beq skip_bcd2hi		; 0ならスキップ
	lda REG0
	sta score_bcd2			; #%00110000加えた値を設定
skip_bcd2hi:
	
	clc
	rol score_b0
	rol score_b1
	rol score_bcd0
	rol score_bcd1
	rol score_bcd2

	dey
	bne loop_bcd

	lda REG1
	sta score_b0
	lda REG2
	sta score_b1

	rts
.endproc

; タイマーのBCDへの変換
.proc ConvertTimerBinaryToBCD

	lda timer_b0
	sta REG1
	lda timer_b1
	sta REG2

	lda #0
	sta timer_bcd0
	sta timer_bcd1

	; 最初の7回はシフトのみ
	clc
	rol timer_b0
	rol timer_b1
	rol timer_bcd0
	rol timer_bcd1
	rol timer_b0
	rol timer_b1
	rol timer_bcd0
	rol timer_bcd1
	rol timer_b0
	rol timer_b1
	rol timer_bcd0
	rol timer_bcd1
	rol timer_b0
	rol timer_b1
	rol timer_bcd0
	rol timer_bcd1
	rol timer_b0
	rol timer_b1
	rol timer_bcd0
	rol timer_bcd1
	rol timer_b0
	rol timer_b1
	rol timer_bcd0
	rol timer_bcd1
	rol timer_b0
	rol timer_b1
	rol timer_bcd0
	rol timer_bcd1

	ldy #9

loop_bcd:

	clc
	lda timer_bcd0
	adc #3
	sta REG0
	and #%00001000
	beq skip_bcd0low	; 0ならスキップ
	lda REG0
	sta timer_bcd0		; 3加えた値を設定
skip_bcd0low:

	lda timer_bcd0
	adc #%00110000
	sta REG0
	and #%10000000
	beq skip_bcd0hi		; 0ならスキップ
	lda REG0
	sta timer_bcd0		; #%00110000加えた値を設定
skip_bcd0hi:

	lda timer_bcd1
	adc #3
	sta REG0
	and #%00001000
	beq skip_bcd1low	; 0ならスキップ
	lda REG0
	sta timer_bcd1			; 3加えた値を設定
skip_bcd1low:

	lda timer_bcd1
	adc #%00110000
	sta REG0
	and #%10000000
	beq skip_bcd1hi		; 0ならスキップ
	lda REG0
	sta timer_bcd1			; #%00110000加えた値を設定
skip_bcd1hi:
	
	clc
	rol timer_b0
	rol timer_b1
	rol timer_bcd0
	rol timer_bcd1

	dey
	bne loop_bcd

	lda REG1
	sta timer_b0
	lda REG2
	sta timer_b1

	rts
.endproc

; パレットテーブル変更
.proc change_palette_table

	lda palette_change_state

	cmp #0
	beq case_none
	cmp #1
	beq case_2tama
	cmp #2
	beq case_3fire
	cmp #3
	beq case_4habatan
	cmp #4
	beq case_2inosisi
	cmp #5
	beq case_2tako
	cmp #6
	beq case_3tako
	cmp #7
	beq case_34sake
	cmp #8
	beq case_34sake_get

case_none:
	jmp break
case_2tama:
	jmp change_palette_2_tamanegi
case_3fire:
	jmp change_palette_3_fire
case_4habatan:
	jmp change_palette_4_habatan
case_2inosisi:
	jmp change_palette_2_inosisi
case_2tako:
	jmp change_palette_2_tako
case_3tako:
	jmp change_palette_3_tako
case_34sake:
	jmp change_palette_34_sake
case_34sake_get:
	jmp change_palette_34_sake_get


change_palette_2_tamanegi:
; パレット2をタマネギ色にする
	clc
	adc current_draw_display_no	; 画面０か１
	lda #%10001000	; VRAM増加量1byte
	sta $2000

	lda	#$3f
	sta	$2006
	lda	#$14
	sta	$2006
	ldx	#$10
	ldy	#4
copypal_2tama:
	lda	palette1, x
	sta $2007
	inx
	dey
	bne	copypal_2tama

	clc
	lda #%10001100	; VRAM増加量32byte
	adc current_draw_display_no	; 画面０か１
	sta $2000

	jmp break

change_palette_3_fire:
	; パレット3を燃える色に変更
	clc
	adc current_draw_display_no	; 画面０か１
	lda #%10001000	; VRAM増加量1byte
	sta $2000

	lda	#$3f
	sta	$2006
	lda	#$18
	sta	$2006
	ldx	#$14
	ldy	#4
copypal_3fire:
	lda	palette1, x
	sta $2007
	inx
	dey
	bne	copypal_3fire

	clc
	lda #%10001100	; VRAM増加量32byte
	adc current_draw_display_no	; 画面０か１
	sta $2000

	jmp break

change_palette_4_habatan:
	; パレット4をはばタン色に変更
	clc
	adc current_draw_display_no	; 画面０か１
	lda #%10001000	; VRAM増加量1byte
	sta $2000

	lda	#$3f
	sta	$2006
	lda	#$1c
	sta	$2006
	ldx	#$0c
	ldy	#4
copypal_4habatan:
	lda	palette1, x
	sta $2007
	inx
	dey
	bne	copypal_4habatan

	clc
	lda #%10001100	; VRAM増加量32byte
	adc current_draw_display_no	; 画面０か１
	sta $2000

	jmp break
	
change_palette_2_inosisi:
	; パレット2をイノシシ色に変更
	clc
	adc current_draw_display_no	; 画面０か１
	lda #%10001000	; VRAM増加量1byte
	sta $2000

	lda	#$3f
	sta	$2006
	lda	#$14
	sta	$2006
	ldx	#$4
	ldy	#4
copypal_2inosisi:
	lda	palette1, x
	sta $2007
	inx
	dey
	bne	copypal_2inosisi

	clc
	lda #%10001100	; VRAM増加量32byte
	adc current_draw_display_no	; 画面０か１
	sta $2000

	jmp break

change_palette_2_tako:
	; パレット2をタコ色に変更
	clc
	adc current_draw_display_no	; 画面０か１
	lda #%10001000	; VRAM増加量1byte
	sta $2000

	lda	#$3f
	sta	$2006
	lda	#$14
	sta	$2006
	ldx	#$8
	ldy	#4
copypal_2tako:
	lda	palette1, x
	sta $2007
	inx
	dey
	bne	copypal_2tako

	clc
	lda #%10001100	; VRAM増加量32byte
	adc current_draw_display_no	; 画面０か１
	sta $2000

	jmp break

change_palette_3_tako:
	; パレット3をタコ色に変更
	clc
	adc current_draw_display_no	; 画面０か１
	lda #%10001000	; VRAM増加量1byte
	sta $2000

	lda	#$3f
	sta	$2006
	lda	#$18
	sta	$2006
	ldx	#$8
	ldy	#4
copypal_3tako:
	lda	palette1, x
	sta $2007
	inx
	dey
	bne	copypal_3tako

	clc
	lda #%10001100	; VRAM増加量32byte
	adc current_draw_display_no	; 画面０か１
	sta $2000

	jmp break
	
change_palette_34_sake:
	; パレット3を酒下4を酒上色に変更
	clc
	adc current_draw_display_no	; 画面０か１
	lda #%10001000	; VRAM増加量1byte
	sta $2000

	lda	#$3f
	sta	$2006
	lda	#$18
	sta	$2006
	ldx	#$18
	ldy	#8
copypal_34_sake:
	lda	palette1, x
	sta $2007
	inx
	dey
	bne	copypal_34_sake

	clc
	lda #%10001100	; VRAM増加量32byte
	adc current_draw_display_no	; 画面０か１
	sta $2000

	jmp break

change_palette_34_sake_get:
	; パレット3を酒下獲得色4を酒上獲得色
	clc
	adc current_draw_display_no	; 画面０か１
	lda #%10001000	; VRAM増加量1byte
	sta $2000

	lda	#$3f
	sta	$2006
	lda	#$18
	sta	$2006
	ldx	#0
	ldy	#8
copypal_34_sake_get:
	lda	palette_sake_get, x
	sta $2007
	inx
	dey
	bne	copypal_34_sake_get

	clc
	lda #%10001100	; VRAM増加量32byte
	adc current_draw_display_no	; 画面０か１
	sta $2000

	jmp break

break:

	lda #0
	sta palette_change_state

	rts
.endproc	; change_palette_table
