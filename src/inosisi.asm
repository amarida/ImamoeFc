.proc	InosisiInit
	lda #0
	sta inosisi0_world_pos_x_low
	sta inosisi1_world_pos_x_low
	sta inosisi0_world_pos_x_hi
	sta inosisi1_world_pos_x_hi
	lda #224	; ��ʊO;#184
	sta inosisi0_pos_y
	sta inosisi1_pos_y
	; �����͕ς��Ȃ�
	lda #%00000001     ; 0(10�i��)��A�Ƀ��[�h
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

; �o��
.proc appear_inosisi
	; �󂢂Ă���C�m�V�V��T��

	lda #1
	sta inosisi_alive_flag_current	; �t���O�Q�ƌ��݈ʒu
	ldx #0
loop_x:
	; �󂢂Ă��邩
	lda inosisi_alive_flag
	and inosisi_alive_flag_current
	beq set_inosisi
	
	; ��
	asl inosisi_alive_flag_current
	inx
	cpx inosisi_max_count	; ���[�v�ő吔
	bne loop_x				; ���[�v

	; �����܂ŗ�����󂫂͂Ȃ��̂ŃX�L�b�v
	jmp skip_inosisi

set_inosisi:
	; �󂢂Ă���C�m�V�V�ɏ����Z�b�g����
	lda enemy_pos_x_hi
	sta inosisi0_world_pos_x_hi,x
	lda enemy_pos_x_low
	sta inosisi0_world_pos_x_low,x
	lda enemy_pos_y
	sta inosisi0_pos_y,x
	

	; �t���O�𗧂Ă�
	clc
	lda inosisi_alive_flag
	adc inosisi_alive_flag_current
	sta inosisi_alive_flag

skip_inosisi:
	; �X�L�b�v
	rts
.endproc

; �X�V
.proc	InosisiUpdate
	lda is_dead
	bne skip_inosisi

	lda #1
	sta inosisi_alive_flag_current	; �t���O�Q�ƌ��݈ʒu
	ldx #0
loop_x:
	; �������Ă��邩
	lda inosisi_alive_flag
	and inosisi_alive_flag_current
	beq next_update		; ���݂��Ă��Ȃ�

	; ���݂��Ă���
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

	; ��ʊO����
	sec
	lda field_scroll_x_up
	sbc inosisi0_world_pos_x_hi,x
	bcc skip_dead
	sec
	lda field_scroll_x_low
	sbc inosisi0_world_pos_x_low,x
	bcc skip_dead
	; ��ʊO����
	lda inosisi_alive_flag
	eor inosisi_alive_flag_current
	sta inosisi_alive_flag
	lda #224	; ��ʊO
	sta inosisi0_pos_y,x

skip_dead:

;	clc
;	lda scroll_x
;	adc #255
;	sta inosisi0_pos_x

next_update:
	; ��
	asl inosisi_alive_flag_current
	inx
	cpx inosisi_max_count	; ���[�v�ő吔
	bne loop_x				; ���[�v

skip_inosisi:
	rts
.endproc


; �`��
.proc	InosisiDrawDma7
	; �A�j���p�^�[��
	;REG0 = (p_pat == 0) ? #$20 : #0;

	ldx #$20
	lda p_pat
	bne	Pat1
	ldx #0
Pat1:
	stx REG0

; �^�C��
	clc
	lda #$84     ; 
	adc REG0
	sta inosisi1_t
	sta inosisi21_t
	clc
	lda #$85     ; 21��A�Ƀ��[�h
	adc REG0
	sta inosisi2_t
	sta inosisi22_t
	clc
	lda #$86     ; 21��A�Ƀ��[�h
	adc REG0
	sta inosisi3_t
	sta inosisi23_t
	clc
	lda #$87     ; 21��A�Ƀ��[�h
	adc REG0
	sta inosisi4_t
	sta inosisi24_t
	clc
	lda #$94     ; 21��A�Ƀ��[�h
	adc REG0
	sta inosisi5_t
	sta inosisi25_t
	clc
	lda #$95     ; 21��A�Ƀ��[�h
	adc REG0
	sta inosisi6_t
	sta inosisi26_t
	clc
	lda #$96     ; 21��A�Ƀ��[�h
	adc REG0
	sta inosisi7_t
	sta inosisi27_t
	clc
	lda #$97     ; 21��A�Ƀ��[�h
	adc REG0
	sta inosisi8_t
	sta inosisi28_t

; �����m�F����
	lda #1
	sta inosisi_alive_flag_current	; �t���O�Q�ƌ��݈ʒu

; Y���W�͍X�V�K�{
	clc			; �L�����[�t���OOFF
	lda inosisi0_pos_y
	adc #7
	sta inosisi1_y
	sta inosisi2_y
	sta inosisi3_y
	sta inosisi4_y

	clc			; �L�����[�t���OOFF
	lda inosisi0_pos_y
	adc #15
	sta inosisi5_y
	sta inosisi6_y
	sta inosisi7_y
	sta inosisi8_y

; Y���W�ȊO�͔�\�����X�L�b�v

	; �������Ă��邩
	lda inosisi_alive_flag
	and inosisi_alive_flag_current
	beq skip_inosisi0		; ���݂��Ă��Ȃ�

	; ���݂��Ă���΁A���[���h���W����E�B���h�E���W�ɕϊ�
	sec
	lda inosisi0_world_pos_x_low
	sbc field_scroll_x_low
	sta inosisi0_window_pos_x

	lda inosisi0_window_pos_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta inosisi1_x
	sta inosisi5_x

	lda inosisi0_window_pos_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	clc			; �L�����[�t���OOFF
	adc #8
	bcc not_overflow_8	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #231	; ��ʊO
	sta inosisi2_y
	sta inosisi6_y
not_overflow_8:
	sta inosisi2_x
	sta inosisi6_x

	lda inosisi0_window_pos_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	clc			; �L�����[�t���OOFF
	adc #16
	bcc not_overflow_16	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #231	; ��ʊO
	sta inosisi3_y
	sta inosisi7_y
not_overflow_16:
	sta inosisi3_x
	sta inosisi7_x

	lda inosisi0_window_pos_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	clc			; �L�����[�t���OOFF
	adc #24
	bcc not_overflow_24	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #231	; ��ʊO
	sta inosisi4_y
	sta inosisi8_y
not_overflow_24:
	sta inosisi4_x
	sta inosisi8_x

skip_inosisi0:

; Y���W�͍X�V�K�{

	clc			; �L�����[�t���OOFF
	lda inosisi1_pos_y
	adc #7
	sta inosisi21_y
	sta inosisi22_y
	sta inosisi23_y
	sta inosisi24_y

	clc			; �L�����[�t���OOFF
	lda inosisi1_pos_y
	adc #15
	sta inosisi25_y
	sta inosisi26_y
	sta inosisi27_y
	sta inosisi28_y

; Y���W�ȊO�͔�\�����X�L�b�v

	; �������Ă��邩
	asl inosisi_alive_flag_current	; ���V�t�g
	lda inosisi_alive_flag
	and inosisi_alive_flag_current
	beq skip_inosisi1		; ���݂��Ă��Ȃ�

	; ���݂��Ă���΁A���[���h���W����E�B���h�E���W�ɕϊ�
	sec
	lda inosisi1_world_pos_x_low
	sbc field_scroll_x_low
	sta inosisi1_window_pos_x

	lda inosisi1_window_pos_x
	sta inosisi21_x
	sta inosisi25_x

	lda inosisi1_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #8
	bcc not_overflow2_8	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #231	; ��ʊO
	sta inosisi22_y
	sta inosisi26_y
not_overflow2_8:
	sta inosisi22_x
	sta inosisi26_x

	lda inosisi1_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #16
	bcc not_overflow2_16	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #231	; ��ʊO
	sta inosisi23_y
	sta inosisi27_y
not_overflow2_16:
	sta inosisi23_x
	sta inosisi27_x

	lda inosisi1_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #24
	bcc not_overflow2_24	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #231	; ��ʊO
	sta inosisi24_y
	sta inosisi28_y
not_overflow2_24:
	sta inosisi24_x
	sta inosisi28_x

skip_inosisi1:


;End:
	rts

.endproc

; �`��
.proc	InosisiDrawDma6
	; �A�j���p�^�[��
	;REG0 = (p_pat == 0) ? #$20 : #0;

	ldx #$20
	lda p_pat
	bne	Pat1
	ldx #0
Pat1:
	stx REG0

; �^�C��
	clc
	lda #$84     ; 
	adc REG0
	sta inosisi1_t2
	sta inosisi21_t2
	clc
	lda #$85     ; 21��A�Ƀ��[�h
	adc REG0
	sta inosisi2_t2
	sta inosisi22_t2
	clc
	lda #$86     ; 21��A�Ƀ��[�h
	adc REG0
	sta inosisi3_t2
	sta inosisi23_t2
	clc
	lda #$87     ; 21��A�Ƀ��[�h
	adc REG0
	sta inosisi4_t2
	sta inosisi24_t2
	clc
	lda #$94     ; 21��A�Ƀ��[�h
	adc REG0
	sta inosisi5_t2
	sta inosisi25_t2
	clc
	lda #$95     ; 21��A�Ƀ��[�h
	adc REG0
	sta inosisi6_t2
	sta inosisi26_t2
	clc
	lda #$96     ; 21��A�Ƀ��[�h
	adc REG0
	sta inosisi7_t2
	sta inosisi27_t2
	clc
	lda #$97     ; 21��A�Ƀ��[�h
	adc REG0
	sta inosisi8_t2
	sta inosisi28_t2

; �����m�F����
	lda #1
	sta inosisi_alive_flag_current	; �t���O�Q�ƌ��݈ʒu

; Y���W�͍X�V�K�{
	clc			; �L�����[�t���OOFF
	lda inosisi0_pos_y
	adc #7
	sta inosisi1_y2
	sta inosisi2_y2
	sta inosisi3_y2
	sta inosisi4_y2

	clc			; �L�����[�t���OOFF
	lda inosisi0_pos_y
	adc #15
	sta inosisi5_y2
	sta inosisi6_y2
	sta inosisi7_y2
	sta inosisi8_y2

; Y���W�ȊO�͔�\�����X�L�b�v

	; �������Ă��邩
	lda inosisi_alive_flag
	and inosisi_alive_flag_current
	beq skip_inosisi0		; ���݂��Ă��Ȃ�

	; ���݂��Ă���΁A���[���h���W����E�B���h�E���W�ɕϊ�
	sec
	lda inosisi0_world_pos_x_low
	sbc field_scroll_x_low
	sta inosisi0_window_pos_x


	lda inosisi0_window_pos_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta inosisi1_x2
	sta inosisi5_x2

	lda inosisi0_window_pos_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	clc			; �L�����[�t���OOFF
	adc #8
	bcc not_overflow_8	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #232	; ��ʊO
	sta inosisi2_y2
	sta inosisi6_y2
not_overflow_8:
	sta inosisi2_x2
	sta inosisi6_x2

	lda inosisi0_window_pos_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	clc			; �L�����[�t���OOFF
	adc #16
	bcc not_overflow_16	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #232	; ��ʊO
	sta inosisi3_y2
	sta inosisi7_y2
not_overflow_16:
	sta inosisi3_x2
	sta inosisi7_x2

	lda inosisi0_window_pos_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	clc			; �L�����[�t���OOFF
	adc #24
	bcc not_overflow_24	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #232	; ��ʊO
	sta inosisi4_y2
	sta inosisi8_y2
not_overflow_24:
	sta inosisi4_x2
	sta inosisi8_x2

skip_inosisi0:

; Y���W�͍X�V�K�{

	clc			; �L�����[�t���OOFF
	lda inosisi1_pos_y
	adc #7
	sta inosisi21_y2
	sta inosisi22_y2
	sta inosisi23_y2
	sta inosisi24_y2

	clc			; �L�����[�t���OOFF
	lda inosisi1_pos_y
	adc #15
	sta inosisi25_y2
	sta inosisi26_y2
	sta inosisi27_y2
	sta inosisi28_y2

; Y���W�ȊO�͔�\�����X�L�b�v

	; �������Ă��邩
	asl inosisi_alive_flag_current	; ���V�t�g
	lda inosisi_alive_flag
	and inosisi_alive_flag_current
	beq skip_inosisi1		; ���݂��Ă��Ȃ�

	; ���݂��Ă���΁A���[���h���W����E�B���h�E���W�ɕϊ�
	sec
	lda inosisi1_world_pos_x_low
	sbc field_scroll_x_low
	sta inosisi1_window_pos_x

	lda inosisi1_window_pos_x
	sta inosisi21_x2
	sta inosisi25_x2

	lda inosisi1_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #8
	bcc not_overflow2_8	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #232	; ��ʊO
	sta inosisi22_y2
	sta inosisi26_y2
not_overflow2_8:
	sta inosisi22_x2
	sta inosisi26_x2

	lda inosisi1_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #16
	bcc not_overflow2_16	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #232	; ��ʊO
	sta inosisi23_y2
	sta inosisi27_y2
not_overflow2_16:
	sta inosisi23_x2
	sta inosisi27_x2

	lda inosisi1_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #24
	bcc not_overflow2_24	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #232	; ��ʊO
	sta inosisi24_y2
	sta inosisi28_y2
not_overflow2_24:
	sta inosisi24_x2
	sta inosisi28_x2

skip_inosisi1:


;End:
	rts

.endproc
