.proc scene_introduction

	lda scene_update_step
	cmp #0
	beq case_init
	cmp #1
	beq case_fill
	cmp #2
	beq case_fill_wait
	cmp #3
	beq case_enable
	cmp #4
	beq case_wait

; 初期化
case_init:
	jsr scene_introduction_init

	jmp case_break

; 描画
case_fill:

	; 属性テーブル変更
	jsr SetupAttributeIntroduction

	; ネームテーブルをイントロダクションにする
	jsr FillIntroductionNametable

	; 顔アイコン
	lda #$00
	sta $2003
	lda #135
	sta $2004	;y
	lda #$01
	sta $2004	;t
	lda #0
	sta $2004	;s
	lda #130
	sta $2004	;x
	

	lda #2
	sta wait_frame
	inc scene_update_step
	jmp case_break
	
; 描画待ち
case_fill_wait:
	dec wait_frame
	lda wait_frame
	bne skip_next
	; 有効にする
	inc scene_update_step
	skip_next:
	jmp case_break

; 有効にする
case_enable:
	; 割り込みON　増加値1byte
	lda #%10001000
	;     |||||||`- 
	;     ||||||`-- メインスクリーンアドレス 00
	;     |||||`--- VRAMアクセス時のアドレス増加値ベース 1byte
	;     ||||`---- スプライト用キャラクタテーブル 1
	;     |||`----- BG用キャラクタテーブルベース 0
	;     ||`------ スプライトサイズ 8x8
	;     |`------- PPU選択 マスター
	;     `-------- VBlank時にNMI割込を発生 ON
	sta $2000

	; スプライトとBGを表示
	lda	#%00011110
	sta	$2001

	lda #120
	sta wait_frame

	inc scene_update_step

	jmp case_break
	
; キー入力待ち
case_wait:
	dec wait_frame
	lda wait_frame
	bne case_break
	lda #2			; メイン準備
	sta scene_type	; シーン
	lda #0
	sta scene_update_step


	jmp case_break



case_break:

	; スクロール位置更新
	lda #0
	sta	$2005		; X方向スクロール
	lda	#0		; Yは固定
	sta	$2005

	rts
.endproc

.proc scene_introduction_init

	; 割り込みOFF　増加値1byte
	lda #%00001000
	;     |||||||`- 
	;     ||||||`-- メインスクリーンアドレス 00
	;     |||||`--- VRAMアクセス時のアドレス増加値ベース 1byte
	;     ||||`---- スプライト用キャラクタテーブル 1
	;     |||`----- BG用キャラクタテーブルベース 0
	;     ||`------ スプライトサイズ 8x8
	;     |`------- PPU選択 マスター
	;     `-------- VBlank時にNMI割込を発生 OFF
	sta $2000
	; スプライトとBGを消す
	lda	#%00000110
	sta	$2001

	; カレント画面を1にする
	lda #1
	sta current_draw_display_no
	
	; パレットテーブルへ転送(BG用のみ転送)
	lda	#$3f
	sta	$2006
	lda	#$00
	sta	$2006
	ldx	#$00
	ldy	#4
	copypal:
	lda	palette_bg_introduction, x
	sta $2007
	inx				; Xをインクリメントする
	dey				; Yをデクリメントする
	bne	copypal

	; パレットテーブルへ転送(MAP用のみ転送)
	lda	#$3f
	sta	$2006
	lda	#$10
	sta	$2006
	ldx	#$00
	ldy	#16
	copypal2:
	lda	palette1, x
	sta $2007
	inx
	dey
	bne	copypal2
	inc scene_update_step

	; 透明色を黒に変更
	lda	#$3f
	sta	$2006
	lda	#$10
	sta	$2006
	lda	#$0f
	sta $2007

	rts
.endproc

; ネームテーブルをイントロダクションにする
.proc FillIntroductionNametable

	; まず塗りつぶし
	lda #0
	sta draw_bg_x
	sta draw_bg_y
	jsr SetPosition
	lda #$00

	ldy #0
	loop_fill_y:
	ldx #0
	loop_fill_x:
	sta $2007
	inx
	cpx #32
	bne loop_fill_x
	iny
	cpy #28
	bne loop_fill_y

	; LEVEL
	lda #11
	sta draw_bg_x
	lda #10
	sta draw_bg_y
	jsr SetPosition

	ldx #0
	loop_level_x:
	lda string_level_1, x
	sta $2007
	inx
	cpx #7
	bne loop_level_x
	
	; PLAYER
	lda #10
	sta draw_bg_x
	lda #14
	sta draw_bg_y
	jsr SetPosition

	ldx #0
	loop_player_x:
	lda string_player_1, x
	sta $2007
	inx
	cpx #8
	bne loop_player_x

	; LIFE
	lda #11
	sta draw_bg_x
	lda #16
	sta draw_bg_y
	jsr SetPosition

	ldx #0
	loop_life_x:
	lda string_life_1, x
	sta $2007
	inx
	cpx #5
	bne loop_life_x

	rts
.endproc


; イントロダクション用属性テーブルに変更
.proc SetupAttributeIntroduction

	; 全部
	lda #0
	sta draw_bg_x
	lda #0
	sta draw_bg_y

	; 1度だけ座標からアドレスを求める
	; draw_bg_x(in)
	; draw_bg_y(in)
	; attribute_pos_adress_hi(out)
	; attribute_pos_adress_low(out)
	jsr CalcAttributeAdressFromCoord

	lda attribute_pos_adress_hi
	sta $2006
	lda attribute_pos_adress_low
	sta $2006
	ldx #0

draw_loop:
	lda #$00
	sta $2007

	inx
	cpx #64
	bne draw_loop

	rts
.endproc

