

;  #10 10進数値
; #$10 16進数値
;  $10 16進アドレス
; #%00000000 2進数

.setcpu		"6502"
.autoimport	on

.include "define.asm"
.include "player.asm"
.include "inosisi.asm"
.include "tako.asm"
.include "tako_haba.asm"
.include "tamanegi.asm"
.include "TamanegiFire.asm"
.include "Habatan.asm"
.include "HabatanFire.asm"
.include "Item.asm"
.include "utility.asm"
.include "sound.asm"

.include "scene_title.asm"
.include "scene_introduction.asm"
.include "scene_maingame_ready.asm"
.include "scene_maingame.asm"
.include "scene_gameover.asm"
.include "defineDMA.asm"

; iNESヘッダ
.segment "HEADER"
	.byte	$4E, $45, $53, $1A	; "NES" Header
	.byte	$02			; PRG-BANKS
	.byte	$01			; CHR-BANKS
	.byte	$01			; 垂直ミラーVertical Mirror
	.byte	$00			; 
	.byte	$00, $00, $00, $00	; 
	.byte	$00, $00, $00, $00	; 

.segment "STARTUP"
; リセット割り込み
.org $8000
.proc	Reset
	sei			; IRQ割り込みを禁止します。
;	ldx	#$ff		; メモリからXにロードします。
;	txs			; XをSへコピーします。

; スクリーンオフ
	lda #$00
	sta $2000
	sta $2001

;counter_hit: .byte 1
;DoubleRAM: .word 2
;
;lda	counter_hit
;asl	a
;tax
;lda	Table_hit, x
;sta	DoubleRAM
;lda	Table_hit +1,x
;sta	DoubleRAM +1
;jmp  (DoubleRAM)
;
;Table_hit:
; .word hit0
; .word hit1
; .word hit2
; .word hit3
; .word hit4


	lda #0			; タイトル
	sta scene_type	; シーン
	lda #0
	sta scene_update_step	; シーン内ステップ

	lda #0
	sta key_state_on
	sta key_state_push


	lda #0
	sta debug_var


	; サウンド
	lda #0
	sta bgm_type
	sta scene_maingame_init
	sta se_type
	sta se_kukei_step
	sta se_kukei_count
	sta se_kukei_wait_frame

; 矩形波
;	lda $4015		; サウンドレジスタ
;	ora #%00000001	; 矩形波チャンネル１を有効にする
;	sta $4015
;
;	lda #%10111111	; Duty比・長さ無効・減衰無効・減衰率
;	sta $4000	; 矩形波チャンネル１制御レジスタ１
;	lda #%00000100	; 周波数(下位8ビット)
;	sta $4002	; 矩形波チャンネル１周波数レジスタ１
;	lda #%11111011	; 再生時間・周波数(上位3ビット)
;	sta $4003	; 矩形波チャンネル１周波数レジスタ２
;	lda $4015	; サウンドレジスタ
;	ora #%00000010	; 矩形波チャンネル２を有効にする
;	sta $4015
;
;	lda #%00000000	; 矩形波チャンネルを有効にする
;	sta $4015
;
;	lda $4015		; サウンドレジスタ
;	ora #%00000001	; 矩形波チャンネル１を有効にする
;	sta $4015
;
;	lda #%10111111
;	sta $4000		; 矩形波チャンネル１制御レジスタ１
;
;	lda #%10101011
;	sta $4001		; 矩形波チャンネル１制御レジスタ２
;	lda #0		; お遊びでX座標を入れてみる
;	sta $4002		; 矩形波チャンネル１周波数レジスタ１
;
;	lda #%11111011
;	sta $4003		; 矩形波チャンネル１周波数レジスタ２

; 三角波
;	lda #%00000100	; 
;	sta $4015
;
;	lda #%10000001	; カウンタ使用・長さ
;	sta $4008	; 三角波チャンネル制御レジスタ
;
;	lda #%00000100	; 周波数(下位8ビット)
;	sta $400A	; 三角波チャンネル１周波数レジスタ１
;
;	lda #%00001011	; 再生時間・周波数(上位3ビット)
;	sta $400B	; 三角波チャンネル１周波数レジスタ２
;
;	lda #%00000100	; 
;	sta $4015

; ノイズ
;	lda #%00001000	; 
;	sta $4015
;
;	lda #%11101111	; 未使用・長さ無効・減衰無効・減衰率
;	sta $400C	; ノイズ制御レジスタ
;
;	lda #%00000001	; 乱数タイプ・未使用・波長
;	sta $400E	; ノイズ周波数レジスタ１
;	lda #%11111011	; 再生時間・未使用
;	sta $400F	; ノイズ周波数レジスタ２

	lda #< command_jt
	sta test_address_low
	lda #> command_jt
	sta test_address_hi

	ldx #4
command_jmp:
	lda	command_jt+1,X		;: A ← ｢ジャンプテーブル ( RTS で飛ぶので、目的のアドレス-1 にしている )｣の上位ﾊﾞｲﾄ.X
	pha				;: Push A
	lda	command_jt+0,X		;: A ← ｢ジャンプテーブル ( RTS で飛ぶので、目的のアドレス-1 にしている )｣の下位ﾊﾞｲﾄ.X
	pha				;: Push A
check_end:
	rts				;: サブルーチンから復帰

command_jt: ; ジャンプテーブル ( RTS で飛ぶので、目的のアドレス-1 にしている )
	.word	cmd_test1-1	; "IF"
	.word	cmd_test2-1	; "IF"
	.word	cmd_test3-1	; "IF"

;	jsr map_table_screen_hi
jmp break;
cmd_test1:
	; test1の処理

	jmp break
cmd_test2:
	; test2の処理

	jmp break
cmd_test3:
	; test3の処理

	jmp break


break:

; スクリーンオン
	lda #%00001100	; VBlank割り込みなし、スプライトが1、VRAM増加量32byte
	sta $2000

; スクロール設定
	lda	#$00
	sta	$2005
	sta	$2005

; 割り込み開始
	lda #%10001100	; VBlank割り込みあり　VRAM増加量32byte
	sta $2000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; メインループ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mainloop:

vblank_wait:
	lda	$2002
	and	#%10000000
	beq	vblank_wait

	inc loop_count

; デバッグ
	lda #$20
	sta $2006
	lda #$00
	sta $2006
	clc
	lda debug_var
	adc #$30
	sta $2007

	lda scene_type
	cmp #0
	beq case_title
	cmp #1
	beq case_introduction
	cmp #2
	beq case_maingame_ready
	cmp #3
	beq case_maingame
	cmp #4
	beq case_gameover

case_title:
	jsr scene_title
	jmp scene_break;
case_introduction:
	jsr scene_introduction
	jmp scene_break;
case_maingame_ready:
	jsr scene_maingame_ready
	jmp scene_break
case_maingame:
	jsr scene_maingame
	jmp scene_break;
case_gameover:
	jsr scene_gameover
	jmp scene_break;
scene_break:

		;VBLANK終了待ち
;vblank_in_wait:
;		lda	$2002
;		and	#%10000000
;		bne	vblank_in_wait
	jmp	mainloop
.endproc

; VBlank割り込み
.proc	VBlank

	inc vblank_count

	rti			; 割り込みから復帰命令
.endproc

.proc ChangePaletteBgState

	lda REG0
	cmp #$c9
	bne skip

	lda #1
	sta palette_bg_change_state

	skip:
	rts
.endproc	; ChangePaletteBgState

; 画面外BG描画
.proc draw_bg_name_table

	; scroll_count_8dotが0の時描画
	lda scroll_count_8dot
	cmp #0
	bne skip;

	; bg_already_drawがその値に達していなければ描画
	sec
	lda bg_already_draw;
	sbc scroll_count_8dot_count

	beq not_skip
	jmp skip
not_skip:

; 描画
	lda #3
	sta draw_bg_y	; Y座標
	lda bg_already_draw_pos
	sta draw_bg_x	; X座標（ブロック）
	jsr SetPosition

	ldy #24
draw_loop:
	lda (map_table_screen_low), y
	sta $2007
	sta REG0
	jsr ChangePaletteBgState

	dey	; 25個
	bpl	draw_loop

	; 描画したら bg_already_draw をincする
	inc bg_already_draw
	inc bg_already_draw_pos
	sec
	lda bg_already_draw_pos
	sbc #32
	bcc skip_reset;
	lda #0
	sta bg_already_draw_pos
skip_reset:
	

	; マップチップの起点を25ずらす
	clc
	lda map_table_screen_low
	adc #25
	sta map_table_screen_low
	lda map_table_screen_hi
	adc #0
	sta map_table_screen_hi

skip:

	rts
.endproc

; 画面外BG属性設定
.proc draw_bg_attribute

	lda scroll_count_32dot
	cmp #0
	bne skip

	; bg_already_draw_attributeがその値に達していなければ設定
	sec
	lda bg_already_draw_attribute;
	sbc scroll_count_32dot_count
	beq not_skip
	jmp skip
not_skip:

; 描画
	lda #1
	sta draw_bg_y
	lda bg_already_draw_attribute_pos
	sta draw_bg_x

	; 1度だけ座標からアドレスを求める
	; draw_bg_x(in)
	; draw_bg_y(in)
	; attribute_pos_adress_hi(out)
	; attribute_pos_adress_low(out)
	jsr CalcAttributeAdressFromCoord

	ldy #6	; 7個
draw_loop:

	lda attribute_pos_adress_hi
	sta $2006
	lda attribute_pos_adress_low
	sta $2006
	lda (map_table_attribute_low), y
	sta $2007


	lda attribute_pos_adress_low
	clc
	adc #$8
	sta attribute_pos_adress_low
	; マイナスじゃなければループする
	;iny
	dey
;	cpy #0
	bpl	draw_loop


	; 描画したら bg_already_draw_attribute をincする
	inc bg_already_draw_attribute
	inc bg_already_draw_attribute_pos
	sec
	lda bg_already_draw_attribute_pos
	sbc #8
	bcc skip_reset;
	lda #0
	sta bg_already_draw_attribute_pos
skip_reset:

	; マップチップの起点を7ずらす
	clc
	lda map_table_attribute_low
	adc #7
	sta map_table_attribute_low
	lda map_table_attribute_hi
	adc #0
	sta map_table_attribute_hi

skip:

	rts
.endproc

.proc	sprite_draw2

	sec			; キャリーフラグON
	lda player_y
	sbc #64
	sta $2004   ; Y座標をレジスタにストアする
	lda #$82     ; 21をAにロード
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda #%000000001;#%00000000     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	lda #136; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda player_y
	sbc #64
	sta $2004   ; Y座標をレジスタにストアする
	lda #$83     ; 21をAにロード
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda #%000000001;#%00000000     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	lda #144; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda player_y
	sbc #8
	sta $2004   ; Y座標をレジスタにストアする
	lda #$92     ; 21をAにロード
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda #%000000001;#%00000000     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	lda #136; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda player_y
	sbc #8
	sta $2004   ; Y座標をレジスタにストアする
	lda #$93     ; 21をAにロード
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda #%000000001;#%00000000     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	lda #144; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda player_y
	sbc #48
	sta $2004   ; Y座標をレジスタにストアする
	lda #$A2     ; 21をAにロード
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda #%000000001;#%00000000     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	lda #136; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda player_y
	sbc #48
	sta $2004   ; Y座標をレジスタにストアする
	lda #$A3     ; 21をAにロード
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda #%000000001;#%00000000     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	lda #144; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda player_y
	sbc #40
	sta $2004   ; Y座標をレジスタにストアする
	lda #$B2     ; 21をAにロード
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda #%000000001;#%00000000     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	lda #136; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda player_y
	sbc #40
	sta $2004   ; Y座標をレジスタにストアする
	lda #$B3     ; 21をAにロード
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda #%000000001;#%00000000     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	lda #144; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta $2004   ; X座標をレジスタにストアする

	sec			; キャリーフラグON
	lda player_y
	sbc #8
	sta $2004   ; Y座標をレジスタにストアする
	lda #$30     ; 21をAにロード
	sta $2004   ; 0をストアして0番のスプライトを指定する
	lda #%000000000;#%00000000     ; 0(10進数)をAにロード
	sta $2004   ; 反転や優先順位は操作しないので、再度$00をストアする
	lda #112; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta $2004   ; X座標をレジスタにストアする

	rts	; サブルーチンから復帰します。
.endproc

.proc SetPosition
	; draw_bg_x	X座標
	; draw_bg_y	Y座標

	lda draw_bg_x	
	sta conv_coord_bit_x
	lda draw_bg_y
	sta conv_coord_bit_y
;;;;;↓ 座標をアドレス空間に変換 ;;;;;
	;jsr ConvertCoordToBit
	; y * 32 ; Y座標を一つ下にずらすとX方向に32動かしたこと
	lda #0
	sta multi_ans_up
	sta multi_ans_low
	lda conv_coord_bit_y
	sta multi_ans_low

	; 32倍
	clc
	asl multi_ans_low		; 下位は左シフト
	rol multi_ans_up		; 上位は左ローテート

	asl multi_ans_low
	rol multi_ans_up

	asl multi_ans_low
	rol multi_ans_up

	asl multi_ans_low
	rol multi_ans_up

	asl multi_ans_low
	rol multi_ans_up

	
	; 画面１か画面２か
	lda #$24
	sta draw_bg_display

	lda current_draw_display_no
	beq set_skip
	lda #$20
	sta draw_bg_display

set_skip:

jmp noset24
	clc
	lda conv_coord_bit_x
	asl	; 左シフト
	asl	; 左シフト
	bcs set24
	jmp noset24
	
set24:
;	lda #$24
;	sta draw_bg_display
;	sec
;	lda conv_coord_bit_x;
;	sbc #32;
;	sta conv_coord_bit_x
noset24:

	; + x
	lda multi_ans_low
	adc conv_coord_bit_x
	sta multi_ans_low

	; 下位＋下位
	clc
	lda multi_ans_low
	adc #$20
	sta conv_coord_bit_low
	; 上位＋上位
	lda multi_ans_up
	adc draw_bg_display;#$20
	sta conv_coord_bit_up
;;;;;↑ 座標をアドレス空間に変換 ;;;;;

	lda conv_coord_bit_up
	sta $2006
	lda conv_coord_bit_low
	sta $2006

	rts
.endproc

.proc CalcAttributeAdressFromCoord
	; draw_bg_x	X座標(0,0)-(7,7)
	; draw_bg_y	Y座標
	; attribute_pos_adress_hi
	; attribute_pos_adress_low
	lda draw_bg_x
	sta conv_coord_bit_x
	lda draw_bg_y
	sta conv_coord_bit_y
;;;;;↓ 座標をアドレス空間に変換 ;;;;;
	;jsr ConvertCoordToBit
	; y * 8 ; Y座標を一つ下にずらすとX方向に8動かしたこと
	lda #0
	sta multi_ans_up
	sta multi_ans_low

	lda conv_coord_bit_y
	sta multi_ans_low

	; 8倍
	clc
	asl multi_ans_low		; 下位は左シフト
	rol multi_ans_up		; 上位は左ローテート

	asl multi_ans_low
	rol multi_ans_up

	asl multi_ans_low
	rol multi_ans_up
	
	; 画面１か画面２か
	lda #$27
	sta draw_bg_display

	lda current_draw_display_no
	beq set_skip
	lda #$23
	sta draw_bg_display

set_skip:


jmp noset24
	clc
	lda conv_coord_bit_x
	asl	; 左シフト
	asl	; 左シフト
	bcs set24
	jmp noset24
	
set24:
;	lda #$24
;	sta draw_bg_display
;	sec
;	lda conv_coord_bit_x;
;	sbc #32;
;	sta conv_coord_bit_x
noset24:

	; + x
	lda multi_ans_low
	adc conv_coord_bit_x
	sta multi_ans_low

	; 下位＋下位
	clc
	lda multi_ans_low
	adc #$c0
	sta conv_coord_bit_low
	; 上位＋上位
	lda multi_ans_up
	adc draw_bg_display;#$27
	sta conv_coord_bit_up
;;;;;↑ 座標をアドレス空間に変換 ;;;;;

	lda conv_coord_bit_up
	sta attribute_pos_adress_hi
	lda conv_coord_bit_low
	sta attribute_pos_adress_low

	rts
.endproc

	; 初期データ
X_Pos_Init:   .byte 20       ; X座標初期値
Y_Pos_Init:   .byte 40       ; Y座標初期値

; パレットテーブル
palette1:
	.byte	$21, $23, $38, $30	; スプライト色1		プレイヤー
	.byte	$0f, $07, $16, $0d	; スプライト色2		イノシシ
	.byte	$0f, $30, $16, $0e	; スプライト色3		タコ
	.byte	$0f, $26, $38, $0f	; スプライト色4		はばタン
	.byte	$0f, $16, $1A, $0e	; スプライト色5		タマネギ
	.byte	$0f, $16, $07, $05	; スプライト色6		タマネギ炎、タコ焼き、はばタン炎
	.byte	$0f, $39, $00, $0f	; スプライト色7		酒下
	.byte	$0f, $39, $2a, $0a	; スプライト色8		酒上
palette_sake_get:
	.byte	$0f, $3a, $30, $2b	; 酒下ゲット時
	.byte	$0f, $3a, $30, $2b	; 酒上ゲット時
palette2:
	.byte	$0f, $00, $10, $20
	.byte	$0f, $00, $10, $20
paletteIno:
palettes_bg:
	.byte	$0f, $0f, $00, $10	; bg色1
	.byte	$0f, $0f, $12, $30	; bg色2
	.byte	$0f, $0f, $0f, $30	; bg色3
	.byte	$21, $0a, $1a, $2a	; bg色4
palette_bg_title:
	.byte	$0f, $23, $21, $27	; タイトル用bg色1 オレンジ
	.byte	$0f, $23, $21, $30	; タイトル用bg色2 白
	.byte	$0f, $23, $21, $0f	; タイトル用bg色3 黒
	.byte	$21, $0a, $1a, $2a	; タイトル用bg色4
palette_bg_introduction:
	.byte	$0f, $0f, $0f, $30	; タイトル用bg色 白
palette_bg_kirin:
	.byte	$21, $17, $07, $0f	; キリン用

	; 星テーブルデータ(20個)
Star_Tbl:
   .byte 60,45,35,60,90,65,45,20,90,10,30,40,65,25,65,35,50,35,40,35

; 表示文字列
string:
	.byte	"HELLO, WORLD!"
;	.byte	$01, $02, $11, $12

string1:
	.byte	$01, $02

string2:
	.byte	$11, $12

string_game_over:
	.byte	"GAME OVER"

string_life:
	.byte	"LIFE"
string_score:
	.byte	"SCORE"
string_time:
	.byte	"TIME"
string_zero_score:
	.byte	"000000"
string_first_time:
	.byte	"400"

string_player_game:
	.byte	"1 PLAYER GAME"

string_kobe_imamoe:
	.byte	"KOBE IMAMOE 2011"

string_push_start:
	.byte	"PUSH START KEY"

string_level_1:
	.byte	"LEVEL 1"

string_player_1:
	.byte	"PLAYER 1"

string_life_1:
	.byte	"LIFE-"

.include "map_chip.asm"


; 敵の登場位置情報テーブル
; x位置上位、x座標下位、y位置、敵のタイプ
; $00:イノシシ、$01:タコ、$02:タマネギ、$03:はばタン
; $04:はばタコ、$05:酒 78、$06:タマネギ2
map_enemy_info:
	.byte	$01, $e2, $b8, $00	; イノシシ

	.byte	$02, $1a, $b8, $01	; タコ
	.byte	$02, $32, $b8, $01	; タコ
	.byte	$02, $57, $b0, $02	; タマネギ
	.byte	$02, $b2, $88, $05	; アイテム
	.byte	$02, $e2, $b8, $00	; イノシシ
	.byte	$02, $f2, $b8, $00	; イノシシ

	.byte	$03, $32, $88, $05	; アイテム

	.byte	$03, $f7, $b0, $02	; タマネギ
	.byte	$04, $52, $b8, $03	; はばタン
	.byte	$04, $c2, $b8, $04	; はばタコ

	.byte	$05, $12, $a8, $06	; タマネギ2
	.byte	$05, $92, $b8, $00	; イノシシ
	.byte	$05, $e2, $b8, $00	; イノシシ

	.byte	$ff, $ff, $ff, $00	; 最後のダミー

; BGM情報テーブル
bgm_introduction_kukei:
	;     4000 4001 4002 4003 次フレーム待ち
	.byte $5F, $00, $5E, $b0, $14	; レＤ　ツー
	.byte $5F, $00, $70, $b0, $9	; シＢ　ト
	.byte $00, $00, $00, $00, $1
	.byte $5F, $00, $70, $b0, $9	; シＢ　ト
	.byte $00, $00, $00, $00, $1
	.byte $5F, $00, $70, $b0, $14	; シＢ　ツー
	.byte $5F, $00, $8E, $b0, $9	; ラＡ　ト
	.byte $00, $00, $00, $00, $1
	.byte $5F, $00, $8E, $b0, $9	; ラＡ　ト
	.byte $00, $00, $00, $00, $1

	.byte $5F, $00, $A9, $b0, $14	; ミＥ　ツー
	.byte $5F, $00, $8E, $b0, $9	; ソＧ　ト
	.byte $00, $00, $00, $00, $1
	.byte $5F, $00, $8E, $b0, $9	; ソＧ　ト
	.byte $00, $00, $00, $00, $1
	.byte $5F, $00, $7E, $b0, $14	; ラＡ　ツー
	.byte $5F, $00, $70, $b0, $9	; シＢ　ト
	.byte $00, $00, $00, $00, $1

	
bgm_introduction_sankaku:
	;     4008 400A 400B 次フレーム待ち
	.byte $81, $D5, $00, $13	; ドＣ
	.byte $80, $00, $00, $1
	.byte $81, $D5, $00, $13	; ドＣ
	.byte $80, $00, $00, $1
	.byte $81, $D5, $00, $13	; ドＣ
	.byte $80, $00, $00, $1
	.byte $81, $D5, $00, $13	; ドＣ
	.byte $80, $00, $00, $1
	.byte $81, $BD, $00, $13	; レＤ
	.byte $80, $00, $00, $1
	.byte $81, $BD, $00, $13	; レＤ
	.byte $80, $00, $00, $1
	.byte $81, $D5, $00, $13	; レＤ
	.byte $80, $00, $00, $1
	.byte $81, $D5, $00, $9	; ドＣ
	.byte $80, $00, $00, $1

; SE情報テーブル
se_jump_kukei:
	;     4000 4001 4002 4003 次フレーム待ち
	.byte $5F, $00, $7E, $b0, $3	; ラＡ
	.byte $9F, $AC, $D5, $B0, $10	; シＢ
	.byte $00, $00, $00, $00, $1

se_fire_noise:
	;     400C 400E 400F 次フレーム待ち
	.byte $1F, $0F, $B0, $20
	.byte $00, $00, $00, $1

se_item_kukei:
	;     4000 4001 4002 4003 次フレーム待ち
	.byte $CF, $8A, $FD, $B0, $10	; 低いラＡ
	.byte $00, $00, $00, $00, $1

.segment "VECINFO"
	.word	VBlank
	.word	Reset
	.word	$0000

; パターンテーブル
.segment "CHARS"
	.incbin	"character.chr"
