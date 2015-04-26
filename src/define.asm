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
bg_already_draw		EQU $2F	; BG描画済み変数（ブロック単位）
field_scrool_x_up	EQU	$30	; ゲーム内のスクロール位置上位
field_scrool_x_low	EQU	$31	; ゲーム内のスクロール位置下位
player_x_up			EQU	$32	; プレイヤ位置X上位
window_player_x_up	EQU	$33	; ウィンドウ内の位置上位
window_player_x_low	EQU	$34	; ウィンドウ内の位置下位
window_player_x_low8	EQU	$35	; ウィンドウ内の位置-8下位
map_chip_index_up	EQU $36	; マップチップインデックス上位
map_chip_index_low	EQU $37	; マップチップインデックス下位
map_chip_offset_cal16_up	EQU $38	; マップチップオフセット
map_chip_offset_cal16_low	EQU $39	; マップチップオフセット
map_chip_offset_cal8_up		EQU $3A	; マップチップオフセット
map_chip_offset_cal8_low	EQU $3B	; マップチップオフセット
map_chip_offset_cal2_up		EQU $3C	; マップチップオフセット
map_chip_offset_cal2_low	EQU $3D	; マップチップオフセット
map_chip_offset_cal_up		EQU $3E	; マップチップオフセット
map_chip_offset_cal_low		EQU $3F	; マップチップオフセット
map_chip_offset_up		EQU $40	; マップチップオフセット
map_chip_offset_low		EQU $41	; マップチップオフセット
map_chip_offset_start	EQU $42	; マップチップオフセット
draw_bg_display			EQU	$43	; 画面１画面２（20か24か）
draw_index_y			EQU $44 ; 描画時のインデックスレジストリのテンプ
field_scrool_x_up_tmp	EQU	$45	; ゲーム内のスクロール位置上位テンプ
field_scrool_x_low_tmp	EQU	$46	; ゲーム内のスクロール位置下位テンプ
loop_count				EQU $47	; ループカウント
vblank_count			EQU $48 ; VBlankのカウント
test_toggle_update		EQU $49 ; テストトグル
test_toggle_vblank		EQU $4A ; テストトグル
map_table_outside_screen_low	EQU $4B ; 
map_table_outside_screen_hi		EQU $4C ;
bg_already_draw_attribute	EQU $4D ; BG属性設定済み変数（4ブロック単位）
map_table_attribute_low		EQU $4E ; 
map_table_attribute_hi		EQU $4F ;
offset_y_attribute		EQU $50	; 属性テーブルオフセットY
attribute_pos_adress_up	EQU $51 ; 属性テーブルの位置アドレス上位
attribute_pos_adress_low	EQU $52 ; 属性テーブルの位置アドレス下位
current_draw_display_no	EQU $53 ; 現在の描画画面番号（0 or 1）
map_table_now_low			EQU $54 ; 
map_table_now_hi			EQU $55 ;
bg_already_draw_pos			EQU $56	; BG描画位置（ブロック単位）
bg_already_draw_attribute_pos	EQU $57 ; BG属性設定位置（4ブロック単位）

; スプライトDMA用$0700～$07ff
player1_y	EQU	$0700	; 
player1_t	EQU	$0701	; 
player1_s	EQU	$0702	; 
player1_x	EQU	$0703	; 
player2_y	EQU	$0704	; 
player2_t	EQU	$0705	; 
player2_s	EQU	$0706	; 
player2_x	EQU	$0707	; 
player3_y	EQU	$0708	; 
player3_t	EQU	$0709	; 
player3_s	EQU	$070A	; 
player3_x	EQU	$070B	; 
player4_y	EQU	$070C	; 
player4_t	EQU	$070D	; 
player4_s	EQU	$070E	; 
player4_x	EQU	$070F	; 
player5_y	EQU	$0710	; 
player5_t	EQU	$0711	; 
player5_s	EQU	$0712	; 
player5_x	EQU	$0713	; 
player6_y	EQU	$0714	; 
player6_t	EQU	$0715	; 
player6_s	EQU	$0716	; 
player6_x	EQU	$0717	; 
player7_y	EQU	$0718	; 
player7_t	EQU	$0719	; 
player7_s	EQU	$071A	; 
player7_x	EQU	$071B	; 
player8_y	EQU	$071C	; 
player8_t	EQU	$071D	; 
player8_s	EQU	$071E	; 
player8_x	EQU	$071F	; 
inosisi1_y	EQU	$0720	; 
inosisi1_t	EQU	$0721	; 
inosisi1_s	EQU	$0722	; 属性
inosisi1_x	EQU	$0723	; 
inosisi2_y	EQU	$0724	; 
inosisi2_t	EQU	$0725	; 
inosisi2_s	EQU	$0726	; 
inosisi2_x	EQU	$0727	; 
inosisi3_y	EQU	$0728	; 
inosisi3_t	EQU	$0729	; 
inosisi3_s	EQU	$072A	; 
inosisi3_x	EQU	$072B	; 
inosisi4_y	EQU	$072C	; 
inosisi4_t	EQU	$072D	; 
inosisi4_s	EQU	$072E	; 
inosisi4_x	EQU	$072F	; 
inosisi5_y	EQU	$0730	; 
inosisi5_t	EQU	$0731	; 
inosisi5_s	EQU	$0732	; 
inosisi5_x	EQU	$0733	; 
inosisi6_y	EQU	$0734	; 
inosisi6_t	EQU	$0735	; 
inosisi6_s	EQU	$0736	; 
inosisi6_x	EQU	$0737	; 
inosisi7_y	EQU	$0738	; 
inosisi7_t	EQU	$0739	; 
inosisi7_s	EQU	$073A	; 
inosisi7_x	EQU	$073B	; 
inosisi8_y	EQU	$073C	; 
inosisi8_t	EQU	$073D	; 
inosisi8_s	EQU	$073E	; 
inosisi8_x	EQU	$073F	; 
