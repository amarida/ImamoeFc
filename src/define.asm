REG0										= $00	; 汎用0
REG1										= $01	; 汎用1
REG2										= $02	; 汎用2
REG3										= $03	; 汎用3
REG4										= $04	; 汎用4
REG5										= $05	; 汎用5
REG6										= $06	; 汎用6
scroll_x									= $07	; 
scroll_y									= $08	; 
loop_x										= $09
loop_y										= $0A
pos											= $0B
player_draw_status							= $0C	; 描画タイプ…0:通常、1:ジャンプ、2:攻撃中1、3:攻撃中2、4:死亡
attack_frame								= $0D	; 攻撃フレーム
count_y										= $0E
player_x_low								= $0F	; プレイヤ位置X（下位）上位はplayer_x_up
player_x_decimal							= $10	; プレイヤ位置X（小数部）
player_y									= $11	; プレイヤ位置Y（+1は小数部）
; 小数部									= $12	
screen_x									= $13	; スクリーン位置
spd_y										= $14	; Y方向速度（+1は小数部）
; 小数部									= $15
spd_vec										= $16	; 速度方向（0下方向、1上方向）
is_jump										= $17
p_pat										= $18 ; プレイヤ描画パターン
pat_change_frame							= $19
chr_lr										= $1A	; キャラクタ左右フラグ
FIELD_HEIGHT								= $1B	; 地面の高さ
multiplicand								= $1C	; 被乗数（かけられる数）
multiplier									= $1D	; 乗数（かける数）
multi_ans_up								= $1E	; 乗算結果　上位ビット

multi_ans_low								= $20	; 乗算結果　下位ビット
multi_loop_cnt								= $21	; 乗算用ループカウンタ
conv_coord_bit_x							= $22	; X座標
conv_coord_bit_y							= $23	; Y座標
conv_coord_bit_up							= $24	; 上位ビット
conv_coord_bit_low							= $25	; 下位ビット
draw_bg_tile								= $26 ; タイル番号
draw_bg_x									= $27 ; X座標
draw_bg_y									= $28 ; Y座標
draw_bg_w									= $29 ; 横ブロック数
draw_bg_h									= $2A ; 縦ブロック数
draw_loop_x									= $2B ; ループ変数
draw_loop_y									= $2C ; ループ変数
bg_already_draw								= $2D	; BG描画済み変数（ブロック単位）
field_scroll_x_up							= $2E	; ゲーム内のスクロール位置上位
field_scroll_x_low							= $2F	; ゲーム内のスクロール位置下位
player_x_up									= $30	; プレイヤ位置X上位
window_player_x_up							= $31	; ウィンドウ内の位置上位
window_player_x_low							= $32	; ウィンドウ内の位置下位
window_player_x_low8						= $33	; ウィンドウ内の位置-8下位
map_chip_index_up							= $34	; マップチップインデックス上位
map_chip_index_low							= $35	; マップチップインデックス下位
map_chip_offset_cal16_up					= $36	; マップチップオフセット
map_chip_offset_cal16_low					= $37	; マップチップオフセット
map_chip_offset_cal8_up						= $38	; マップチップオフセット
map_chip_offset_cal8_low					= $39	; マップチップオフセット
map_chip_offset_cal2_up						= $3A	; マップチップオフセット
map_chip_offset_cal2_low					= $3B	; マップチップオフセット
map_chip_offset_cal_up						= $3C	; マップチップオフセット
map_chip_offset_cal_low						= $3D	; マップチップオフセット
map_chip_offset_up							= $3E	; マップチップオフセット
map_chip_offset_low							= $3F	; マップチップオフセット
map_chip_offset_start						= $40	; マップチップオフセット
draw_bg_display								= $41	; 画面１画面２（20か24か）
draw_index_y								= $42 ; 描画時のインデックスレジストリのテンプ
field_scroll_x_up_tmp						= $43	; ゲーム内のスクロール位置上位テンプ
field_scroll_x_low_tmp						= $44	; ゲーム内のスクロール位置下位テンプ
loop_count									= $45	; ループカウント
vblank_count								= $46 ; VBlankのカウント
Reserved00									= $47 ; 予約00
Reserved01									= $48 ; 予約01
map_table_screen_low						= $49 ; 
map_table_screen_hi							= $4A ;
bg_already_draw_attribute					= $4B ; BG属性設定済み変数（4ブロック単位）
map_table_attribute_low						= $4C ; 
map_table_attribute_hi						= $4D ;
offset_y_attribute							= $4E	; 属性テーブルオフセットY
attribute_pos_adress_up						= $4F ; 属性テーブルの位置アドレス上位
attribute_pos_adress_low					= $50 ; 属性テーブルの位置アドレス下位
current_draw_display_no						= $51 ; 現在の描画画面番号（0 or 1）
map_table_now_low							= $52 ; 
map_table_now_hi							= $53 ;
bg_already_draw_pos							= $54	; BG描画位置（ブロック単位）
bg_already_draw_attribute_pos				= $55 ; BG属性設定位置（4ブロック単位）
pow_two										= $56
map_diff_x_index							= $57
map_chip_player_x_low						= $58 ; あたり判定用キャラクタマップチップ座標X low
map_chip_player_x_hi						= $59 ; あたり判定用キャラクタマップチップ座標X hi
map_chip_player_y							= $5A ; あたり判定用キャラクタマップチップ座標Y
map_chip_collision_index_base_low			= $5B
map_chip_collision_index_base_hi			= $5C
map_table_char_pos_offset_low				= $5D ; 
map_table_char_pos_offset_hi				= $5E ;
map_table_char_pos_value					= $5F ;
obj_collision_result						= $60 ; オブジェクトとのあたり判定結果
player_y_top_for_collision					= $61 ;	あたり判定用上Y座標（Y座標）
player_y_bottom_for_collision				= $62 ;	あたり判定用下Y座標（Y座標+31）
player_x_left_hi_for_collision				= $63 ;	あたり判定用左X座標上位（X座標）
player_x_left_low_for_collision				= $64 ;	あたり判定用左X座標下位（X座標）
player_x_right_hi_for_collision				= $65 ;	あたり判定用右X座標上位（X座標+15）
player_x_right_low_for_collision			= $66 ;	あたり判定用右X座標下位（X座標+15）
map_chip_collision_index_left_bottom_low	= $67
map_chip_collision_index_left_bottom_hi		= $68
map_chip_collision_index_left_top_low		= $69
map_chip_collision_index_left_top_hi		= $6A
map_chip_collision_index_right_bottom_low	= $6B
map_chip_collision_index_right_bottom_hi	= $6C
map_chip_collision_index_right_top_low		= $6D
map_chip_collision_index_right_top_hi		= $6E
obj_collision_pos							= $6F	; オブジェクトとの当たった場所(上下)(0〜1)左下、左上、右下、右上
char_collision_result						= $70	; 敵キャラとのあたり判定結果
is_dead										= $71	; 死亡中
key_state_on								= $72	; 現在のキーボード状態
key_state_on_old							= $73	; 古いキーボード状態
key_state_push								= $74	; このフレームで押された状態
update_dead_step							= $75	; 死亡時更新ステップ
wait_frame									= $76	; 待つフレーム
test_address_low							= $77
test_address_hi								= $78
scene_type									= $79	; シーン（0:TITLE 1:メイン 2:ゲームオーバー）
scene_update_step							= $7A	; シーン用の更新ステップ
map_enemy_info_address_low					= $7B
map_enemy_info_address_hi					= $7C
enemy_kind									= $7D	; 敵の種類
enemy_pos_x_low								= $7E
enemy_pos_x_hi								= $7F
enemy_pos_y									= $80
enemy_type									= $81
inosisi_alive_flag							= $82	; イノシシ生きているフラグ
inosisi_max_count							= $83	; 最大同時数
inosisi_alive_flag_current					= $84	; フラグ参照現在位置
inosisi0_world_pos_x_low					= $85	; イノシシ0 WORLD座標 X軸 下位
inosisi1_world_pos_x_low					= $86	; イノシシ1 WORLD座標 X軸 下位
inosisi0_world_pos_x_hi						= $87	; イノシシ0 WORLD座標 X軸 上位
inosisi1_world_pos_x_hi						= $88	; イノシシ1 WORLD座標 X軸 上位
inosisi0_pos_y								= $89	; イノシシ0 WORLD座標 Y軸
inosisi1_pos_y								= $8A	; イノシシ1 WORLD座標 Y軸
inosisi0_window_pos_x						= $8B	; イノシシ0 WINDOW座標 X軸
inosisi1_window_pos_x						= $8C	; イノシシ1 WINDOW座標 X軸
obj_collision_sea							= $8D	; 海と当たった判定
inosisi00_status							= $8E	; イノシシ00状態(0:通常、1:溺れる、2:水しぶき1、3:水しぶき2)
inosisi01_status							= $8F	; イノシシ01状態(0:通常、1:溺れる、2:水しぶき1、3:水しぶき2)
inosisi00_wait								= $90	; イノシシ00待ち
inosisi01_wait								= $91	; イノシシ01待ち
inosisi00_update_dead_step					= $92	; イノシシ00死亡時更新処理ステップ
inosisi01_update_dead_step					= $93	; イノシシ01死亡時更新処理ステップ
scroll_count_8dot							= $94	; スクロール用カウンタ
scroll_count_8dot_count						= $95	; スクロール用カウンタ
scroll_count_32dot							= $96	; スクロール用カウンタ
scroll_count_32dot_count					= $97	; スクロール用カウンタ
timer_bcd1									= $98	; タイマーBCD用2バイト目
timer_bcd0									= $99	; タイマーBCD用1バイト目
timer_b1									= $9A	; タイマー2進数用2バイト目
timer_b0									= $9B	; タイマー2進数用1バイト目
score_bcd2									= $9C	; スコアBCD用3バイト目
score_bcd1									= $9D	; スコアBCD用2バイト目
score_bcd0									= $9E	; スコアBCD用1バイト目
score_b1									= $9F	; スコア2進数用2バイト目
score_b0									= $A0	; スコア2進数用1バイト目
count_up8									= $A1	; ループカウント
timer_count									= $A2	; タイマー用カウンタ
bgm_nomal_address_low						= $A3	;
bgm_nomal_address_hi						= $A4	;
bgm_nomal_sankaku_address_low				= $A5
bgm_nomal_sankaku_address_hi				= $A6
bgm_kukei_count								= $A7
bgm_sankaku_count							= $A8
bgm_kukei_step								= $A9
bgm_sankaku_step							= $AA
bgm_kukei_wait_frame						= $AB
bgm_sankaku_wait_frame						= $AC
bgm_type									= $AD
scene_maingame_init							= $AE
se_jump_address_low							= $AF	;
se_jump_address_hi							= $B0	;
se_type										= $B1
se_kukei_step								= $B2
se_kukei_count								= $B3
se_kukei_wait_frame							= $B4
tako_alive_flag								= $B5	; タコ生きているフラグ
tako_max_count								= $B6	; 最大同時数
tako_alive_flag_current						= $B7	; フラグ参照現在位置
tako0_world_pos_x_low						= $B8	; タコ0 WORLD座標 X軸 下位
tako1_world_pos_x_low						= $B9	; タコ1 WORLD座標 X軸 下位
tako0_world_pos_x_hi						= $BA	; タコ0 WORLD座標 X軸 上位
tako1_world_pos_x_hi						= $BB	; タコ1 WORLD座標 X軸 上位
tako0_pos_y									= $BC	; タコ0 WORLD座標 Y軸
tako1_pos_y									= $BD	; タコ1 WORLD座標 Y軸
tako0_window_pos_x							= $BE	; タコ0 WINDOW座標 X軸
tako1_window_pos_x							= $BF	; タコ1 WINDOW座標 X軸
tako00_status								= $C0	; タコ00状態(0:通常、1:溺れる、2:水しぶき1、3:水しぶき2)
tako01_status								= $C1	; タコ01状態(0:通常、1:溺れる、2:水しぶき1、3:水しぶき2)
tako00_wait									= $C2	; タコ00待ち
tako01_wait									= $C3	; タコ01待ち
tako00_update_dead_step						= $C4	; タコ00死亡時更新処理ステップ
tako01_update_dead_step						= $C5	; タコ01死亡時更新処理ステップ
tamanegi_alive_flag							= $C6	; タマネギ生きているフラグ
tamanegi_max_count							= $C7	; 最大同時数
tamanegi_alive_flag_current					= $C8	; フラグ参照現在位置
tamanegi0_world_pos_x_low					= $C9	; タマネギ0 WORLD座標 X軸 下位
tamanegi1_world_pos_x_low					= $CA	; タマネギ1 WORLD座標 X軸 下位
tamanegi0_world_pos_x_hi					= $CB	; タマネギ0 WORLD座標 X軸 上位
tamanegi1_world_pos_x_hi					= $CC	; タマネギ1 WORLD座標 X軸 上位
tamanegi0_pos_y								= $CD	; タマネギ0 WORLD座標 Y軸
tamanegi1_pos_y								= $CE	; タマネギ1 WORLD座標 Y軸
tamanegi0_window_pos_x						= $CF	; タマネギ0 WINDOW座標 X軸
tamanegi1_window_pos_x						= $D0	; タマネギ1 WINDOW座標 X軸
tamanegi00_status							= $D1	; タマネギ00状態(0:通常、1:溺れる、2:水しぶき1、3:水しぶき2)
tamanegi01_status							= $D2	; タマネギ01状態(0:通常、1:溺れる、2:水しぶき1、3:水しぶき2)
tamanegi00_wait								= $D3	; タマネギ00待ち
tamanegi01_wait								= $D4	; タマネギ01待ち
tamanegi00_update_dead_step					= $D5	; タマネギ00死亡時更新処理ステップ
tamanegi01_update_dead_step					= $D6	; タマネギ01死亡時更新処理ステップ
debug_var									= $FF	; デバッグ用
