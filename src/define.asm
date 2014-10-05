.define EQU	=
REG0		EQU	$00	; 汎用0
REG1		EQU	$01	; 汎用1
REG2		EQU	$02	; 汎用2
REG3		EQU	$03	; 汎用3
REG4		EQU	$04	; 汎用4
REG5		EQU	$05	; 汎用5
REG6		EQU	$06	; 汎用6
scrool_x	EQU	$07	; $00をscrool_xとして使う
scrool_y	EQU	$08	; $01をscrool_yとして使う
loop_x		EQU	$09
loop_y		EQU	$0A
pos			EQU	$0B
len			EQU	$0C
diff				EQU	$0D
count_y				EQU	$0E
player_x_low		EQU	$0F	; プレイヤ位置X（下位）
player_x_decimal	EQU	$10	; プレイヤ位置X（小数部）
player_y			EQU	$11	; プレイヤ位置Y（+1は小数部）
screen_x			EQU	$13	; スクリーン位置
spd_y				EQU	$14	; Y方向速度（+1は小数部）
spd_vec				EQU	$16	; 速度方向（0プラス、1マイナス）
is_jump				EQU	$17
p_pat				EQU $18 ; プレイヤ描画パターン
pat_change_frame	EQU	$19
chr_lr				EQU $1A	; キャラクタ左右フラグ
inosisi_x			EQU $1B	; イノシシ位置X
inosisi_y			EQU $1C	; イノシシ位置Y
FIELD_HEIGHT		EQU	$1D	; 地面の高さ
multiplicand		EQU $1E	; 被乗数（かけられる数）
multiplier			EQU $20	; 乗数（かける数）
multi_ans_up		EQU $21	; 乗算結果　上位ビット
multi_ans_low		EQU $22	; 乗算結果　下位ビット
multi_loop_cnt		EQU $23	; 乗算用ループカウンタ
conv_coord_bit_x	EQU $24	; X座標
conv_coord_bit_y	EQU $25	; Y座標
conv_coord_bit_up	EQU $26	; 上位ビット
conv_coord_bit_low	EQU $27	; 下位ビット
draw_bg_tile		EQU $28 ; タイル番号
draw_bg_x			EQU $29 ; X座標
draw_bg_y			EQU $2A ; Y座標
draw_bg_w			EQU $2B ; 横ブロック数
draw_bg_h			EQU $2C ; 縦ブロック数
draw_loop_x			EQU $2D ; ループ変数
draw_loop_y			EQU $2E ; ループ変数
bg_already_draw		EQU $2F	; BG描画済み変数
field_scrool_x_up	EQU	$30	; ゲーム内のスクロール位置上位
field_scrool_x_low	EQU	$31	; ゲーム内のスクロール位置下位
player_x_up			EQU	$32	; プレイヤ位置X上位
window_player_x_up	EQU	$33	; ウィンドウ内の位置上位
window_player_x_low	EQU	$34	; ウィンドウ内の位置下位
window_player_x_low8	EQU	$35	; ウィンドウ内の位置-8下位
map_chip_index_up	EQU $36	; マップチップインデックス上位
map_chip_index_low	EQU $37	; マップチップインデックス下位
map_chip_offset16_up	EQU $38	; マップチップオフセット
map_chip_offset16_low	EQU $39	; マップチップオフセット
map_chip_offset3_up	EQU $3A	; マップチップオフセット
map_chip_offset3_low	EQU $3B	; マップチップオフセット
map_chip_offset_up	EQU $3C	; マップチップオフセット
map_chip_offset_low	EQU $3D	; マップチップオフセット
map_chip_offset_start	EQU $3E	; マップチップオフセット
draw_bg_display		EQU	$3F	; 画面１画面２（20か24か）
