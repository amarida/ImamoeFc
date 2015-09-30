.proc	InosisiInit
	lda #0
	sta inosisi0_world_pos_x_low
	sta inosisi1_world_pos_x_low
	sta inosisi0_world_pos_x_hi
	sta inosisi1_world_pos_x_hi
	lda #224	; 画面外;#184
	sta inosisi0_pos_y
	sta inosisi1_pos_y
	; 属性は変わらない
	lda #%00000001     ; 0(10進数)をAにロード
	sta inosisi1_s
	sta inosisi2_s
	sta inosisi3_s
	sta inosisi4_s
	sta inosisi5_s
	sta inosisi6_s
	sta inosisi7_s
	sta inosisi8_s
	sta inosisi21_s
	sta inosisi22_s
	sta inosisi23_s
	sta inosisi24_s
	sta inosisi25_s
	sta inosisi26_s
	sta inosisi27_s
	sta inosisi28_s
	sta inosisi1_s2
	sta inosisi2_s2
	sta inosisi3_s2
	sta inosisi4_s2
	sta inosisi5_s2
	sta inosisi6_s2
	sta inosisi7_s2
	sta inosisi8_s2
	sta inosisi21_s2
	sta inosisi22_s2
	sta inosisi23_s2
	sta inosisi24_s2
	sta inosisi25_s2
	sta inosisi26_s2
	sta inosisi27_s2
	sta inosisi28_s2

	rts
.endproc

; 登場
.proc appear_inosisi
	; 空いているイノシシを探す

	lda #1
	sta inosisi_alive_flag_current	; フラグ参照現在位置
	ldx #0
loop_x:
	; 空いているか
	lda inosisi_alive_flag
	and inosisi_alive_flag_current
	beq set_inosisi
	
	; 次
	asl inosisi_alive_flag_current
	inx
	cpx inosisi_max_count	; ループ最大数
	bne loop_x				; ループ

	; ここまで来たら空きはないのでスキップ
	jmp skip_inosisi

set_inosisi:
	; 空いているイノシシに情報をセットする
	lda enemy_pos_x_hi
	sta inosisi0_world_pos_x_hi,x
	lda enemy_pos_x_low
	sta inosisi0_world_pos_x_low,x
	lda enemy_pos_y
	sta inosisi0_pos_y,x
	

	; フラグを立てる
	clc
	lda inosisi_alive_flag
	adc inosisi_alive_flag_current
	sta inosisi_alive_flag

skip_inosisi:
	; スキップ
	rts
.endproc

; 更新
.proc	InosisiUpdate
	lda is_dead
	bne skip_inosisi

	lda #1
	sta inosisi_alive_flag_current	; フラグ参照現在位置
	ldx #0
loop_x:
	; 生存しているか
	lda inosisi_alive_flag
	and inosisi_alive_flag_current
	beq next_update		; 存在していない

	; 存在している
	sec
	lda inosisi0_world_pos_x_low,x
	sbc #1
	sta inosisi0_world_pos_x_low,x
	lda inosisi0_world_pos_x_hi,x
	sbc #0
	sta inosisi0_world_pos_x_hi,x
;	dec inosisi0_pos_x,x

;	sec
;	lda scroll_x;
;	sbc inosisi0_pos_x,x
;	bne next_update 

	; 画面外判定
	sec
	lda field_scroll_x_up
	sbc inosisi0_world_pos_x_hi,x
	bcc skip_dead
	sec
	lda field_scroll_x_low
	sbc inosisi0_world_pos_x_low,x
	bcc skip_dead
	; 画面外処理
	lda inosisi_alive_flag
	eor inosisi_alive_flag_current
	sta inosisi_alive_flag
	lda #224	; 画面外
	sta inosisi0_pos_y,x

skip_dead:

;	clc
;	lda scroll_x
;	adc #255
;	sta inosisi0_pos_x

next_update:
	; 次
	asl inosisi_alive_flag_current
	inx
	cpx inosisi_max_count	; ループ最大数
	bne loop_x				; ループ

skip_inosisi:
	rts
.endproc


; 描画
.proc	InosisiDrawDma7
	; アニメパターン
	;REG0 = (p_pat == 0) ? #$20 : #0;

	ldx #$20
	lda p_pat
	bne	Pat1
	ldx #0
Pat1:
	stx REG0

; タイル
	clc
	lda #$84     ; 
	adc REG0
	sta inosisi1_t
	sta inosisi21_t
	clc
	lda #$85     ; 21をAにロード
	adc REG0
	sta inosisi2_t
	sta inosisi22_t
	clc
	lda #$86     ; 21をAにロード
	adc REG0
	sta inosisi3_t
	sta inosisi23_t
	clc
	lda #$87     ; 21をAにロード
	adc REG0
	sta inosisi4_t
	sta inosisi24_t
	clc
	lda #$94     ; 21をAにロード
	adc REG0
	sta inosisi5_t
	sta inosisi25_t
	clc
	lda #$95     ; 21をAにロード
	adc REG0
	sta inosisi6_t
	sta inosisi26_t
	clc
	lda #$96     ; 21をAにロード
	adc REG0
	sta inosisi7_t
	sta inosisi27_t
	clc
	lda #$97     ; 21をAにロード
	adc REG0
	sta inosisi8_t
	sta inosisi28_t

; 生存確認準備
	lda #1
	sta inosisi_alive_flag_current	; フラグ参照現在位置

; Y座標は更新必須
	clc			; キャリーフラグOFF
	lda inosisi0_pos_y
	adc #7
	sta inosisi1_y
	sta inosisi2_y
	sta inosisi3_y
	sta inosisi4_y

	clc			; キャリーフラグOFF
	lda inosisi0_pos_y
	adc #15
	sta inosisi5_y
	sta inosisi6_y
	sta inosisi7_y
	sta inosisi8_y

; Y座標以外は非表示時スキップ

	; 生存しているか
	lda inosisi_alive_flag
	and inosisi_alive_flag_current
	beq skip_inosisi0		; 存在していない

	; 存在していれば、ワールド座標からウィンドウ座標に変換
	sec
	lda inosisi0_world_pos_x_low
	sbc field_scroll_x_low
	sta inosisi0_window_pos_x

	lda inosisi0_window_pos_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta inosisi1_x
	sta inosisi5_x

	lda inosisi0_window_pos_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	clc			; キャリーフラグOFF
	adc #8
	bcc not_overflow_8	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta inosisi2_y
	sta inosisi6_y
not_overflow_8:
	sta inosisi2_x
	sta inosisi6_x

	lda inosisi0_window_pos_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	clc			; キャリーフラグOFF
	adc #16
	bcc not_overflow_16	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta inosisi3_y
	sta inosisi7_y
not_overflow_16:
	sta inosisi3_x
	sta inosisi7_x

	lda inosisi0_window_pos_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	clc			; キャリーフラグOFF
	adc #24
	bcc not_overflow_24	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta inosisi4_y
	sta inosisi8_y
not_overflow_24:
	sta inosisi4_x
	sta inosisi8_x

skip_inosisi0:

; Y座標は更新必須

	clc			; キャリーフラグOFF
	lda inosisi1_pos_y
	adc #7
	sta inosisi21_y
	sta inosisi22_y
	sta inosisi23_y
	sta inosisi24_y

	clc			; キャリーフラグOFF
	lda inosisi1_pos_y
	adc #15
	sta inosisi25_y
	sta inosisi26_y
	sta inosisi27_y
	sta inosisi28_y

; Y座標以外は非表示時スキップ

	; 生存しているか
	asl inosisi_alive_flag_current	; 左シフト
	lda inosisi_alive_flag
	and inosisi_alive_flag_current
	beq skip_inosisi1		; 存在していない

	; 存在していれば、ワールド座標からウィンドウ座標に変換
	sec
	lda inosisi1_world_pos_x_low
	sbc field_scroll_x_low
	sta inosisi1_window_pos_x

	lda inosisi1_window_pos_x
	sta inosisi21_x
	sta inosisi25_x

	lda inosisi1_window_pos_x
	clc			; キャリーフラグOFF
	adc #8
	bcc not_overflow2_8	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta inosisi22_y
	sta inosisi26_y
not_overflow2_8:
	sta inosisi22_x
	sta inosisi26_x

	lda inosisi1_window_pos_x
	clc			; キャリーフラグOFF
	adc #16
	bcc not_overflow2_16	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta inosisi23_y
	sta inosisi27_y
not_overflow2_16:
	sta inosisi23_x
	sta inosisi27_x

	lda inosisi1_window_pos_x
	clc			; キャリーフラグOFF
	adc #24
	bcc not_overflow2_24	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #231	; 画面外
	sta inosisi24_y
	sta inosisi28_y
not_overflow2_24:
	sta inosisi24_x
	sta inosisi28_x

skip_inosisi1:


;End:
	rts

.endproc

; 描画
.proc	InosisiDrawDma6
	; アニメパターン
	;REG0 = (p_pat == 0) ? #$20 : #0;

	ldx #$20
	lda p_pat
	bne	Pat1
	ldx #0
Pat1:
	stx REG0

; タイル
	clc
	lda #$84     ; 
	adc REG0
	sta inosisi1_t2
	sta inosisi21_t2
	clc
	lda #$85     ; 21をAにロード
	adc REG0
	sta inosisi2_t2
	sta inosisi22_t2
	clc
	lda #$86     ; 21をAにロード
	adc REG0
	sta inosisi3_t2
	sta inosisi23_t2
	clc
	lda #$87     ; 21をAにロード
	adc REG0
	sta inosisi4_t2
	sta inosisi24_t2
	clc
	lda #$94     ; 21をAにロード
	adc REG0
	sta inosisi5_t2
	sta inosisi25_t2
	clc
	lda #$95     ; 21をAにロード
	adc REG0
	sta inosisi6_t2
	sta inosisi26_t2
	clc
	lda #$96     ; 21をAにロード
	adc REG0
	sta inosisi7_t2
	sta inosisi27_t2
	clc
	lda #$97     ; 21をAにロード
	adc REG0
	sta inosisi8_t2
	sta inosisi28_t2

; 生存確認準備
	lda #1
	sta inosisi_alive_flag_current	; フラグ参照現在位置

; Y座標は更新必須
	clc			; キャリーフラグOFF
	lda inosisi0_pos_y
	adc #7
	sta inosisi1_y2
	sta inosisi2_y2
	sta inosisi3_y2
	sta inosisi4_y2

	clc			; キャリーフラグOFF
	lda inosisi0_pos_y
	adc #15
	sta inosisi5_y2
	sta inosisi6_y2
	sta inosisi7_y2
	sta inosisi8_y2

; Y座標以外は非表示時スキップ

	; 生存しているか
	lda inosisi_alive_flag
	and inosisi_alive_flag_current
	beq skip_inosisi0		; 存在していない

	; 存在していれば、ワールド座標からウィンドウ座標に変換
	sec
	lda inosisi0_world_pos_x_low
	sbc field_scroll_x_low
	sta inosisi0_window_pos_x


	lda inosisi0_window_pos_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	sta inosisi1_x2
	sta inosisi5_x2

	lda inosisi0_window_pos_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	clc			; キャリーフラグOFF
	adc #8
	bcc not_overflow_8	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #232	; 画面外
	sta inosisi2_y2
	sta inosisi6_y2
not_overflow_8:
	sta inosisi2_x2
	sta inosisi6_x2

	lda inosisi0_window_pos_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	clc			; キャリーフラグOFF
	adc #16
	bcc not_overflow_16	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #232	; 画面外
	sta inosisi3_y2
	sta inosisi7_y2
not_overflow_16:
	sta inosisi3_x2
	sta inosisi7_x2

	lda inosisi0_window_pos_x; player_x;#30;#%01111110     ; 30(10進数)をAにロード
	clc			; キャリーフラグOFF
	adc #24
	bcc not_overflow_24	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #232	; 画面外
	sta inosisi4_y2
	sta inosisi8_y2
not_overflow_24:
	sta inosisi4_x2
	sta inosisi8_x2

skip_inosisi0:

; Y座標は更新必須

	clc			; キャリーフラグOFF
	lda inosisi1_pos_y
	adc #7
	sta inosisi21_y2
	sta inosisi22_y2
	sta inosisi23_y2
	sta inosisi24_y2

	clc			; キャリーフラグOFF
	lda inosisi1_pos_y
	adc #15
	sta inosisi25_y2
	sta inosisi26_y2
	sta inosisi27_y2
	sta inosisi28_y2

; Y座標以外は非表示時スキップ

	; 生存しているか
	asl inosisi_alive_flag_current	; 左シフト
	lda inosisi_alive_flag
	and inosisi_alive_flag_current
	beq skip_inosisi1		; 存在していない

	; 存在していれば、ワールド座標からウィンドウ座標に変換
	sec
	lda inosisi1_world_pos_x_low
	sbc field_scroll_x_low
	sta inosisi1_window_pos_x

	lda inosisi1_window_pos_x
	sta inosisi21_x2
	sta inosisi25_x2

	lda inosisi1_window_pos_x
	clc			; キャリーフラグOFF
	adc #8
	bcc not_overflow2_8	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #232	; 画面外
	sta inosisi22_y2
	sta inosisi26_y2
not_overflow2_8:
	sta inosisi22_x2
	sta inosisi26_x2

	lda inosisi1_window_pos_x
	clc			; キャリーフラグOFF
	adc #16
	bcc not_overflow2_16	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #232	; 画面外
	sta inosisi23_y2
	sta inosisi27_y2
not_overflow2_16:
	sta inosisi23_x2
	sta inosisi27_x2

	lda inosisi1_window_pos_x
	clc			; キャリーフラグOFF
	adc #24
	bcc not_overflow2_24	; キャリーフラグが立っていない
	; オーバーフローしている場合はY座標を画面外
	lda #232	; 画面外
	sta inosisi24_y2
	sta inosisi28_y2
not_overflow2_24:
	sta inosisi24_x2
	sta inosisi28_x2

skip_inosisi1:


;End:
	rts

.endproc
