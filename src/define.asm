REG0										= $00	; 汎用0
REG1										= $01	; 汎用1
REG2										= $02	; 汎用2
REG3										= $03	; 汎用3
REG4										= $04	; 汎用4
REG5										= $05	; 汎用5
REG6										= $06	; 汎用6
scroll_x									= $07	; NameTableの座標（$2005に送る値）
scroll_y									= $08	; NameTableの座標（$2005に送る値）
player_draw_status							= $09	; 描画タイプ…0:通常、1:ジャンプ、2:攻撃中1、3:攻撃中2、4:死亡
attack_frame								= $0A	; 攻撃フレーム
player_x_low								= $0B	; プレイヤ位置X（下位）上位はplayer_x_hi
player_x_hi									= $0C	; プレイヤ位置X上位
player_x_decimal							= $0D	; プレイヤ位置X（小数部）
player_y									= $0E	; プレイヤ位置Y（+1は小数部）
; 小数部									= $0F	
spd_y										= $10	; Y方向速度（+1は小数部）
; 小数部									= $11
spd_vec										= $12	; 速度方向（0下方向、1上方向）
player_spd_decimal							= $13
player_spd_low								= $14
player_speed_hi_or_low						= $15	; プレイヤースピード速い
is_jump										= $16
p_pat										= $17	; プレイヤ描画パターン
pat_change_frame							= $18
chr_lr										= $19	; キャラクタ左右フラグ
FIELD_HEIGHT								= $1A	; 地面の高さ
multi_ans_up								= $1B	; 乗算結果　上位ビット
multi_ans_low								= $1C	; 乗算結果　下位ビット
conv_coord_bit_x							= $1D	; X座標
conv_coord_bit_y							= $1E	; Y座標
conv_coord_bit_up							= $1F	; 上位ビット
conv_coord_bit_low							= $20	; 下位ビット
draw_bg_x									= $21	; X座標
draw_bg_y									= $22	; Y座標
bg_already_draw								= $23	; BG描画済み変数（ブロック単位）
field_scroll_x_low							= $24	; ゲーム内のスクロール位置下位
field_scroll_x_hi							= $25	; ゲーム内のスクロール位置上位
window_player_x_low							= $26	; ウィンドウ内の位置下位
window_player_x_low8						= $27	; ウィンドウ内の位置-8下位
draw_bg_display								= $28	; 画面１画面２（20か24か）
loop_count									= $29	; ループカウント
vblank_count								= $2A	; VBlankのカウント
map_table_screen_low						= $2B	; 
map_table_screen_hi							= $2C	;
bg_already_draw_attribute					= $2D	; BG属性設定済み変数（4ブロック単位）
map_table_attribute_low						= $2E	; 
map_table_attribute_hi						= $2F	;
attribute_pos_adress_low					= $30	; 属性テーブルの位置アドレス下位
attribute_pos_adress_hi						= $31	; 属性テーブルの位置アドレス上位
current_draw_display_no						= $32	; 現在の描画画面番号（0 or 1）
map_table_now_low							= $33	; 
map_table_now_hi							= $34	;
bg_already_draw_pos							= $35	; BG描画位置（ブロック単位）
bg_already_draw_attribute_pos				= $36	; BG属性設定位置（4ブロック単位）
map_chip_player_x_low						= $37	; あたり判定用キャラクタマップチップ座標X low
map_chip_player_x_hi						= $38	; あたり判定用キャラクタマップチップ座標X hi
map_chip_collision_index_base_low			= $39
map_chip_collision_index_base_hi			= $3A
map_table_char_pos_offset_low				= $3B	; 
map_table_char_pos_offset_hi				= $3C	;
map_table_char_pos_value					= $3D	;
obj_collision_result						= $3E	; オブジェクトとのあたり判定結果
player_y_top_for_collision					= $3F	;	あたり判定用上Y座標（Y座標）
player_y_bottom_for_collision				= $40	;	あたり判定用下Y座標（Y座標+31）
player_x_left_hi_for_collision				= $41	;	あたり判定用左X座標上位（X座標）
player_x_left_low_for_collision				= $42	;	あたり判定用左X座標下位（X座標）
player_x_right_hi_for_collision				= $43	;	あたり判定用右X座標上位（X座標+15）
player_x_right_low_for_collision			= $44	;	あたり判定用右X座標下位（X座標+15）
map_chip_collision_index_left_bottom_low	= $45
map_chip_collision_index_left_bottom_hi		= $46
map_chip_collision_index_left_top_low		= $47
map_chip_collision_index_left_top_hi		= $48
map_chip_collision_index_right_bottom_low	= $49
map_chip_collision_index_right_bottom_hi	= $4A
map_chip_collision_index_right_top_low		= $4B
map_chip_collision_index_right_top_hi		= $4C
obj_collision_pos							= $4D	; オブジェクトとの当たった場所(上下)(0〜1)左下、左上、右下、右上
char_collision_result						= $4E	; 敵キャラとのあたり判定結果
is_dead										= $4F	; 死亡中
key_state_on								= $50	; 現在のキーボード状態
key_state_on_old							= $51	; 古いキーボード状態
key_state_push								= $52	; このフレームで押された状態
update_dead_step							= $53	; 死亡時更新ステップ
wait_frame									= $54	; 待つフレーム
test_address_low							= $55
test_address_hi								= $56
scene_type									= $57	; シーン（0:TITLE、1:イントロダクション、2:メイン準備、3:メイン、4:ゲームオーバー）
scene_update_step							= $58	; シーン用の更新ステップ
map_enemy_info_address_low					= $59
map_enemy_info_address_hi					= $5A
enemy_kind									= $5B	; 敵の種類
enemy_pos_x_low								= $5C
enemy_pos_x_hi								= $5D
enemy_pos_y									= $5E
enemy_type									= $5F   ; 敵キャラID＋DMA内のどこのエリアを使用するか
inosisi_alive_flag							= $60	; イノシシ生きているフラグ
inosisi_max_count							= $61	; 最大同時数
inosisi_alive_flag_current					= $62	; フラグ参照現在位置
inosisi0_world_pos_x_low					= $63	; イノシシ0 WORLD座標 X軸 下位
inosisi1_world_pos_x_low					= $64	; イノシシ1 WORLD座標 X軸 下位
inosisi0_world_pos_x_hi						= $65	; イノシシ0 WORLD座標 X軸 上位
inosisi1_world_pos_x_hi						= $66	; イノシシ1 WORLD座標 X軸 上位
inosisi0_pos_y								= $67	; イノシシ0 WORLD座標 Y軸
inosisi1_pos_y								= $68	; イノシシ1 WORLD座標 Y軸
inosisi0_window_pos_x						= $69	; イノシシ0 WINDOW座標 X軸
inosisi1_window_pos_x						= $6A	; イノシシ1 WINDOW座標 X軸
obj_collision_sea							= $6B	; 海と当たった判定
inosisi00_status							= $6C	; イノシシ00状態(0:通常、1:溺れる、2:水しぶき1、3:水しぶき2)
inosisi01_status							= $6D	; イノシシ01状態(0:通常、1:溺れる、2:水しぶき1、3:水しぶき2)
inosisi00_wait								= $6E	; イノシシ00待ち
inosisi01_wait								= $6F	; イノシシ01待ち
inosisi00_update_dead_step					= $70	; イノシシ00死亡時更新処理ステップ
inosisi01_update_dead_step					= $71	; イノシシ01死亡時更新処理ステップ
scroll_count_8dot							= $72	; スクロール用カウンタ（８で０に戻る）
scroll_count_8dot_count						= $73	; スクロール用カウンタ（scroll_count_8dotが０に戻るタイミングでカウントアップ）
scroll_count_32dot							= $74	; スクロール用カウンタ
scroll_count_32dot_count					= $75	; スクロール用カウンタ
timer_bcd1									= $76	; タイマーBCD用2バイト目
timer_bcd0									= $77	; タイマーBCD用1バイト目
timer_b1									= $78	; タイマー2進数用2バイト目
timer_b0									= $79	; タイマー2進数用1バイト目
score_bcd2									= $7A	; スコアBCD用3バイト目
score_bcd1									= $7B	; スコアBCD用2バイト目
score_bcd0									= $7C	; スコアBCD用1バイト目
score_b1									= $7D	; スコア2進数用2バイト目
score_b0									= $7E	; スコア2進数用1バイト目
count_up8									= $7F	; ループカウント
timer_count									= $80	; タイマー用カウンタ
bgm_nomal_address_low						= $81	;
bgm_nomal_address_hi						= $82	;
bgm_nomal_sankaku_address_low				= $83
bgm_nomal_sankaku_address_hi				= $84
bgm_kukei_count								= $85
bgm_sankaku_count							= $86
bgm_kukei_step								= $87
bgm_sankaku_step							= $88
bgm_kukei_wait_frame						= $89
bgm_sankaku_wait_frame						= $8A
bgm_type									= $8B
scene_maingame_init							= $8C
se_jump_address_low							= $8D	;
se_jump_address_hi							= $8E	;
se_type										= $8F
se_kukei_step								= $90
se_kukei_count								= $91
se_kukei_wait_frame							= $92
tako_alive_flag								= $93	; タコ生きているフラグ
tako_haba_alive_flag						= $94	; はばタコ生きているフラグ
tako_max_count								= $95	; 最大同時数
tako_alive_flag_current						= $96	; フラグ参照現在位置
tako0_world_pos_x_decimal					= $97	; タコ0 WORLD座標 X軸 小数部
tako1_world_pos_x_decimal					= $98	; タコ1 WORLD座標 X軸 小数部
tako0_world_pos_x_low						= $99	; タコ0 WORLD座標 X軸 下位
tako1_world_pos_x_low						= $9A	; タコ1 WORLD座標 X軸 下位
tako0_world_pos_x_hi						= $9B	; タコ0 WORLD座標 X軸 上位
tako1_world_pos_x_hi						= $9C	; タコ1 WORLD座標 X軸 上位
tako0_pos_y									= $9D	; タコ0 WORLD座標 Y軸
tako1_pos_y									= $9E	; タコ1 WORLD座標 Y軸
tako0_window_pos_x							= $9F	; タコ0 WINDOW座標 X軸
tako1_window_pos_x							= $A0	; タコ1 WINDOW座標 X軸
tako00_status								= $A1	; タコ00状態(0:通常、1:燃える)
tako01_status								= $A2	; タコ01状態(0:通常、1:燃える)
tamanegi_alive_flag							= $A3	; タマネギ生きているフラグ
tamanegi_max_count							= $A4	; 最大同時数
tamanegi_alive_flag_current					= $A5	; フラグ参照現在位置
tamanegi_type_flag1							= $A6	; タマネギタイプ 0タイプ0 1タイプ1 2タイプ2 3タイプ3
tamanegi_type_flag2							= $A7	; タマネギタイプ 2
tamanegi0_world_pos_x_decimal				= $A8	; タマネギ0 WORLD座標 X軸 小数部
tamanegi1_world_pos_x_decimal				= $A9	; タマネギ1 WORLD座標 X軸 小数部
tamanegi0_world_pos_x_low					= $AA	; タマネギ0 WORLD座標 X軸 下位
tamanegi1_world_pos_x_low					= $AB	; タマネギ1 WORLD座標 X軸 下位
tamanegi0_world_pos_x_hi					= $AC	; タマネギ0 WORLD座標 X軸 上位
tamanegi1_world_pos_x_hi					= $AD	; タマネギ1 WORLD座標 X軸 上位
tamanegi0_pos_y								= $AE	; タマネギ0 WORLD座標 Y軸
tamanegi1_pos_y								= $AF	; タマネギ1 WORLD座標 Y軸
tamanegi0_window_pos_x						= $B0	; タマネギ0 WINDOW座標 X軸
tamanegi1_window_pos_x						= $B1	; タマネギ1 WINDOW座標 X軸
tamanegi00_status							= $B2	; タマネギ00状態(0:大砲の中、1:放物線、2:通常、3:炎上、4:真下)
tamanegi01_status							= $B3	; タマネギ01状態
tamanegi00_wait								= $B4	; タマネギ00待ち
tamanegi01_wait								= $B5	; タマネギ01待ち
tamanegi00_update_step						= $B6	; タマネギ00共通内部更新ステップ
tamanegi01_update_step						= $B7	; タマネギ01共通内部更新ステップ
tamanegi00_spd_y							= $B8	; Y方向速度（+1は小数部）
tamanegi01_spd_y							= $B9	; Y方向速度（+1は小数部）
tamanegi00_spd_y_decimal					= $BA	; 小数部
tamanegi01_spd_y_decimal					= $BB	; 小数部
tamanegi00_spd_vec							= $BC	; 速度方向（0下方向、1上方向）
tamanegi01_spd_vec							= $BD	; 速度方向（0下方向、1上方向）
palette_change_state						= $BE	; パレットチェンジ用(	0:なにもしない、1:2をタマネギ、2:3を炎
fire_alive_flag								= $BF	; 炎生きているフラグ	3:4をはばタン、4:2をイノシシ、5:2をタコ
fire_max_count								= $C0	; 最大同時数			6:3をタコ、7:3を酒下4を酒上、8:酒獲得		)
fire_alive_flag_current						= $C1	; フラグ参照現在位置
fire0_world_x_low							= $C2
fire1_world_x_low							= $C3
fire0_world_x_hi							= $C4
fire1_world_x_hi							= $C5
fire0_y										= $C6
fire1_y										= $C7
fire0_window_x								= $C8
fire1_window_x								= $C9
update_result								= $CA
habatan_alive_flag							= $CB	; はばタン生きているフラグ
habatan_world_pos_x_low						= $CC	; はばタン WORLD座標 X軸 下位
habatan_world_pos_x_hi						= $CD	; はばタン WORLD座標 X軸 上位
habatan_pos_y								= $CE	; はばタン WORLD座標 Y軸
habatan_window_pos_x						= $CF	; はばタン WINDOW座標 X軸
habatan_status								= $D0	; はばタン状態(0:近づく、1:くっつく、2:退場)
habatan_wait_low							= $D1	; はばタン登場フレーム
habatan_wait_hi								= $D2	; はばタン登場フレーム
habatan_fire_alive_flag						= $D3	; はばタンファイアー存在フラグ
habatan_fire_status							= $D4	; はばタンファイアー状態(0, 1, 2)
habatan_fire_wait							= $D5	; はばタンファイアー待ち
item_alive_flag								= $D6	; アイテム存在フラグ
item_world_pos_x_low						= $D7	; アイテムワールドX座標
item_world_pos_x_hi							= $D8	; アイテムワールドX座標
item_status									= $D9	; アイテム状態（0:表示、1:点滅）
item_window_pos_x							= $DA	; アイテムウィンドウX座標
item_pos_y									= $DB	; アイテムY座標
item_wait									= $DC	; アイテム待ち
toggle										= $DD	; トグル
palette_bg_change_state						= $DE	; BGパレットチェンジ用(	0:なにもしない、1:4をキリン
firing_frame								= $DF	; 発射後フレーム
item_count									= $E0	; アイテムカウント
str_speedup_state							= $E1	; SPEEDUP文字の状態：0非表示、1表示中
str_speedup_pos_x							= $E2	; SPEEDUP文字のX座標
str_speedup_pos_y							= $E3	; SPEEDUP文字のY座標
str_speedup_frame							= $E4	; SPEEDUP文字の表示フレーム
inosisi_type_flag							= $E5	; イノシシタイプ |00 00 00 00|4体目 3 2 1|
enemy_id									= $E6   ; enemy_typeの敵キャラID
enemy_dma_area							    = $E7   ; enemy_typeのDMA内のどこのエリアを使用するか（DMA6かDMA7というわけではない）
boss_alive_flag                             = $E8   ; ボス生存フラグ
boss_world_pos_x_low			    		= $E9	; ボス WORLD座標 X軸 下位
boss_world_pos_x_hi					    	= $EA	; ボス WORLD座標 X軸 上位
boss_pos_y							    	= $EB	; ボス WORLD座標 Y軸
boss_window_pos_x					    	= $EC	; ボス WINDOW座標 X軸
boss_status							        = $ED	; ボス状態(0:停止、1:火吹き、2:くるくる、3:退場)
boss_update_step                            = $EF   ; ボスステップ状態
ppu2000                                     = $F0   ; PPU
boss_wait                                   = $F1   ; ボス汎用待ち
boss_move_type                              = $F2   ; ボス移動方向
button_alive_flag							= $F3	; ボタン存在フラグ
boss_window_pos_col_x                       = $F4   ; ボス WINDOW座標 X軸 当たり判定用

mapper_cnt									= $FE	;マッパー切り替えテスト用カウンタ
mapper_no									= $FE	;現在のマッパー番号

debug_var									= $FF	; デバッグ用
