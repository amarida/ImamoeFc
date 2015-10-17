.proc scene_maingame
	; 描画

	; 画面外背景の描画
	jsr draw_bg				; ネームテーブル
	jsr draw_bg_attribute	; 属性テーブル
	
;skip_end_draw:


;	lda	0
;	sta	REG0
	lda #$00   ; $00(スプライトRAMのアドレスは8ビット長)をAにロード
	sta $2003  ; AのスプライトRAMのアドレスをストア

;	lda #00
;	sta $2004		;Y
;	lda #01
;	sta $2004		;番号
;	lda #0
;	sta $2004
;	lda #8
;	sta $2004		;X

	;jsr	sprite_draw	; スプライト描画関数
	lda loop_count
	and #%00000001
	bne player_dma7
	beq player_dma6
player_dma7:
	jsr	player_draw_dma7	; プレイヤー描画関数
	jsr InosisiDrawDma7	; イノシシ描画関数
	jmp player_dma_break
player_dma6:
	jsr	player_draw_dma6	; プレイヤー描画関数
	jsr InosisiDrawDma6	; イノシシ描画関数
	jmp player_dma_break
player_dma_break:


	jsr	sprite_draw2	; スプライト描画関数(色替えテスト表示)

	; スクロール位置更新
	lda scroll_x
	sta	$2005		; X方向スクロール
	lda	#0		; Yは固定
	sta	$2005
	
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
	lda #$6  ; スプライトデータは$0700番地からなので、7をロードする。
	sta $4014 ; スプライトDMAレジスタにAをストアして、スプライトデータをDMA転送する
	jmp dma_break
dma_break:

	clc
	lda	#%10001100	; VBlank割り込みあり
	adc current_draw_display_no	; 画面０か１
	sta	$2000
	
	jsr	Update	; 更新

	rts
.endproc

; 更新
.proc	Update
	; キー入力
	inc loop_count;
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

	jsr confirm_appear_enemy

	rts	; サブルーチンから復帰します。
.endproc

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
	jsr appear_inosisi
	
	rts
.endproc

