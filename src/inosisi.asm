.proc	InosisiInit
	lda #0
	sta inosisi0_world_pos_x_low
	sta inosisi1_world_pos_x_low
	sta inosisi0_world_pos_x_hi
	sta inosisi1_world_pos_x_hi
	sta inosisi00_status
	sta inosisi01_status
	sta inosisi00_wait
	sta inosisi01_wait
	sta inosisi00_update_dead_step
	sta inosisi01_update_dead_step
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
	sta inosisi21_s
	sta inosisi22_s
	sta inosisi23_s
	sta inosisi24_s
	sta inosisi25_s
	sta inosisi26_s
	sta inosisi1_s2
	sta inosisi2_s2
	sta inosisi3_s2
	sta inosisi4_s2
	sta inosisi5_s2
	sta inosisi6_s2
	sta inosisi21_s2
	sta inosisi22_s2
	sta inosisi23_s2
	sta inosisi24_s2
	sta inosisi25_s2
	sta inosisi26_s2

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
	
	; �F�X������
	lda #0
	sta inosisi00_status,x
	sta inosisi00_update_dead_step,x
	; �C�m�V�V������ʏ�ɕς���
	lda #%00000001
	sta REG0
	jsr Inosisi_SetAttribute

	; �t���O�𗧂Ă�
	clc
	lda inosisi_alive_flag
	adc inosisi_alive_flag_current
	sta inosisi_alive_flag

skip_inosisi:
	; �X�L�b�v
	rts
.endproc	; appear_inosisi

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

	; ���
	lda inosisi00_status,x
	cmp #0
	beq case_normal
	jmp case_dead	;	(1�`3)

; �ʏ�
case_normal:
	jsr Inosisi_UpdateNormal
	jmp break;

; ���S
case_dead:
	jsr Inosisi_UpdateDead
	jmp break;

break:

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

next_update:
	; ��
	asl inosisi_alive_flag_current
	inx
	cpx inosisi_max_count	; ���[�v�ő吔
	bne loop_x				; ���[�v

skip_inosisi:
	rts
.endproc	; InosisiUpdate

; �ʏ�X�V
.proc	Inosisi_UpdateNormal
	; �d��
	clc
	lda #1
	adc inosisi0_pos_y,x
	sta inosisi0_pos_y,x

	; �����蔻��
	jsr inosisi_collision_object
	; �M��锻��
	lda obj_collision_sea
	beq skip_sea
	lda #1
	sta inosisi00_status,x
skip_sea:
	
	lda obj_collision_result
	beq roll_skip
	; ������������


	;���̏���
	sec
	lda inosisi0_pos_y,x
	and #%11111000
	sta inosisi0_pos_y,x
	; �������t���O�𗧂Ă�
;	lda	#0
;	sta	is_jump
	
roll_skip:

	; ���ړ�
	sec
	lda inosisi0_world_pos_x_low,x
	sbc #1
	sta inosisi0_world_pos_x_low,x
	lda inosisi0_world_pos_x_hi,x
	sbc #0
	sta inosisi0_world_pos_x_hi,x

	rts
.endproc	; Inosisi_UpdateNormal

; �M���X�V
.proc	Inosisi_UpdateDead

	lda inosisi00_update_dead_step,x
	cmp #0
	beq case_init
	cmp #1
	beq case_drown_wait
	cmp #2
	beq case_splash1_wait
	cmp #3
	beq case_splash2_wait
	cmp #4
	beq case_release

case_init:
	; ����0
	lda #60
	sta inosisi00_wait,x

	inc inosisi00_update_dead_step,x
	jmp break;

case_drown_wait:
	; �M��
	dec inosisi00_wait,x
	bne break
	inc inosisi00_update_dead_step,x
	lda #30
	sta inosisi00_wait,x
	lda #2
	sta inosisi00_status,x
	; �C�m�V�V�����𐅂��Ԃ��ɕς���
	lda #%00000000
	sta REG0
	jsr Inosisi_SetAttribute
	jmp break

case_splash1_wait:
	; �����Ԃ�1
	dec inosisi00_wait,x
	bne break
	inc inosisi00_update_dead_step,x
	lda #30
	sta inosisi00_wait,x
	lda #3
	sta inosisi00_status,x
	jmp break;

case_splash2_wait:
	; �����Ԃ�2
	dec inosisi00_wait,x
	bne break
	inc inosisi00_update_dead_step,x
	jmp break;

case_release:
	; ����2
	lda inosisi_alive_flag
	eor inosisi_alive_flag_current
	sta inosisi_alive_flag
	lda #224	; ��ʊO
	sta inosisi0_pos_y,x

	inc update_dead_step
	jmp break;

break:

	rts
.endproc	; Inosisi_UpdateDead


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

	lda inosisi00_status
	cmp #1
	beq drown_tail
	cmp #2
	beq splash1_tail
	cmp #3
	beq splash2_tail
; �����^�C��
	clc
	lda #$84     ; 
	adc REG0
	sta inosisi1_t
	clc
	lda #$85
	adc REG0
	sta inosisi2_t
	clc
	lda #$86
	adc REG0
	sta inosisi3_t
	clc
	lda #$94
	adc REG0
	sta inosisi4_t
	clc
	lda #$95
	adc REG0
	sta inosisi5_t
	clc
	lda #$96
	adc REG0
	sta inosisi6_t
	
	jmp break_tile
; �M��^�C��
drown_tail:
	clc
	lda #$87     ; 
	adc REG0
	sta inosisi1_t
	clc
	lda #$88
	adc REG0
	sta inosisi2_t
	clc
	lda #$97
	adc REG0
	sta inosisi4_t
	clc
	lda #$98
	adc REG0
	sta inosisi5_t

	lda #$03	; �u�����N
	sta inosisi3_t
	sta inosisi6_t

	jmp break_tile
; �����Ԃ�1�^�C��
splash1_tail:
	lda #$89     ; 
	sta inosisi1_t
	lda #$8A
	sta inosisi2_t
	lda #$99
	sta inosisi4_t
	lda #$9A
	sta inosisi5_t

	lda #$03	; �u�����N
	sta inosisi3_t
	sta inosisi6_t

	jmp break_tile

; �����Ԃ�2�^�C��
splash2_tail:
	lda #$A9     ; 
	sta inosisi1_t
	lda #$AA
	sta inosisi2_t
	lda #$B9
	sta inosisi4_t
	lda #$BA
	sta inosisi5_t

	lda #$03	; �u�����N
	sta inosisi3_t
	sta inosisi6_t

	jmp break_tile

break_tile:

; �\���m�F����
	lda #1
	sta inosisi_alive_flag_current	; �t���O�Q�ƌ��݈ʒu

; Y���W�͍X�V�K�{
	clc			; �L�����[�t���OOFF
	lda inosisi0_pos_y
	adc #7
	sta inosisi1_y
	sta inosisi2_y
	sta inosisi3_y

	clc			; �L�����[�t���OOFF
	lda inosisi0_pos_y
	adc #15
	sta inosisi4_y
	sta inosisi5_y
	sta inosisi6_y

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
	sta inosisi4_x

	lda inosisi0_window_pos_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	clc			; �L�����[�t���OOFF
	adc #8
	bcc not_overflow_8	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #231	; ��ʊO
	sta inosisi2_y
	sta inosisi5_y
not_overflow_8:
	sta inosisi2_x
	sta inosisi5_x

	lda inosisi0_window_pos_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	clc			; �L�����[�t���OOFF
	adc #16
	bcc not_overflow_16	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #231	; ��ʊO
	sta inosisi3_y
	sta inosisi6_y
not_overflow_16:
	sta inosisi3_x
	sta inosisi6_x

skip_inosisi0:

; �^�C��
	;REG0 = (p_pat == 0) ? #$20 : #0;

	ldx #$20
	lda p_pat
	bne	skip_pat2
	ldx #0
skip_pat2:
	stx REG0

	lda inosisi01_status
	cmp #1
	beq drown_tail2
	cmp #2
	beq splash1_tail2
	cmp #3
	beq splash2_tail2
; �����^�C��
	clc
	lda #$84     ; 
	adc REG0
	sta inosisi21_t
	clc
	lda #$85
	adc REG0
	sta inosisi22_t
	clc
	lda #$86
	adc REG0
	sta inosisi23_t
	clc
	lda #$94
	adc REG0
	sta inosisi24_t
	clc
	lda #$95
	adc REG0
	sta inosisi25_t
	clc
	lda #$96
	adc REG0
	sta inosisi26_t
	
	jmp break_tile2
; �M��^�C��
drown_tail2:
	clc
	lda #$87     ; 
	adc REG0
	sta inosisi21_t
	clc
	lda #$88
	adc REG0
	sta inosisi22_t
	clc
	lda #$97
	adc REG0
	sta inosisi24_t
	clc
	lda #$98
	adc REG0
	sta inosisi25_t

	lda #$03	; �u�����N
	sta inosisi23_t
	sta inosisi26_t

	jmp break_tile2

; �����Ԃ�1�^�C��
splash1_tail2:
	lda #$89     ; 
	sta inosisi21_t
	lda #$8A
	sta inosisi22_t
	lda #$99
	sta inosisi24_t
	lda #$9A
	sta inosisi25_t

	lda #$03	; �u�����N
	sta inosisi3_t
	sta inosisi6_t

	jmp break_tile2

; �����Ԃ�2�^�C��
splash2_tail2:
	lda #$A9     ; 
	sta inosisi21_t
	lda #$AA
	sta inosisi22_t
	lda #$B9
	sta inosisi24_t
	lda #$BA
	sta inosisi25_t

	lda #$03	; �u�����N
	sta inosisi23_t
	sta inosisi26_t

	jmp break_tile2


break_tile2:

; Y���W�͍X�V�K�{

	clc			; �L�����[�t���OOFF
	lda inosisi1_pos_y
	adc #7
	sta inosisi21_y
	sta inosisi22_y
	sta inosisi23_y

	clc			; �L�����[�t���OOFF
	lda inosisi1_pos_y
	adc #15
	sta inosisi24_y
	sta inosisi25_y
	sta inosisi26_y

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
	sta inosisi24_x

	lda inosisi1_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #8
	bcc not_overflow2_8	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #231	; ��ʊO
	sta inosisi22_y
	sta inosisi25_y
not_overflow2_8:
	sta inosisi22_x
	sta inosisi25_x

	lda inosisi1_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #16
	bcc not_overflow2_16	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #231	; ��ʊO
	sta inosisi23_y
	sta inosisi26_y
not_overflow2_16:
	sta inosisi23_x
	sta inosisi26_x

skip_inosisi1:


;End:
	rts

.endproc	; InosisiDrawDma7

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

	lda inosisi00_status
	cmp #1
	beq drown_tail
	cmp #2
	beq splash1_tail
	cmp #3
	beq splash2_tail
; �����^�C��
	clc
	lda #$84     ; 
	adc REG0
	sta inosisi1_t2
	clc
	lda #$85     ; 21��A�Ƀ��[�h
	adc REG0
	sta inosisi2_t2
	clc
	lda #$86     ; 21��A�Ƀ��[�h
	adc REG0
	sta inosisi3_t2
	clc
	lda #$94     ; 21��A�Ƀ��[�h
	adc REG0
	sta inosisi4_t2
	clc
	lda #$95     ; 21��A�Ƀ��[�h
	adc REG0
	sta inosisi5_t2
	clc
	lda #$96     ; 21��A�Ƀ��[�h
	adc REG0
	sta inosisi6_t2

	jmp break_tile
; �M��^�C��
drown_tail:
	clc
	lda #$87     ; 
	adc REG0
	sta inosisi1_t2
	clc
	lda #$88
	adc REG0
	sta inosisi2_t2
	clc
	lda #$97
	adc REG0
	sta inosisi4_t2
	clc
	lda #$98
	adc REG0
	sta inosisi5_t2

	lda #$03	; �u�����N
	sta inosisi3_t2
	sta inosisi6_t2

	jmp break_tile
; �����Ԃ�1�^�C��
splash1_tail:
	lda #$89     ; 
	sta inosisi1_t2
	lda #$8A
	sta inosisi2_t2
	lda #$99
	sta inosisi4_t2
	lda #$9A
	sta inosisi5_t2

	lda #$03	; �u�����N
	sta inosisi3_t2
	sta inosisi6_t2

	jmp break_tile

; �����Ԃ�2�^�C��
splash2_tail:
	lda #$A9     ; 
	sta inosisi1_t2
	lda #$AA
	sta inosisi2_t2
	lda #$B9
	sta inosisi4_t2
	lda #$BA
	sta inosisi5_t2

	lda #$03	; �u�����N
	sta inosisi3_t2
	sta inosisi6_t2

	jmp break_tile

break_tile:

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

	clc			; �L�����[�t���OOFF
	lda inosisi0_pos_y
	adc #15
	sta inosisi4_y2
	sta inosisi5_y2
	sta inosisi6_y2

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
	sta inosisi4_x2

	lda inosisi0_window_pos_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	clc			; �L�����[�t���OOFF
	adc #8
	bcc not_overflow_8	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #232	; ��ʊO
	sta inosisi2_y2
	sta inosisi5_y2
not_overflow_8:
	sta inosisi2_x2
	sta inosisi5_x2

	lda inosisi0_window_pos_x; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	clc			; �L�����[�t���OOFF
	adc #16
	bcc not_overflow_16	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #232	; ��ʊO
	sta inosisi3_y2
	sta inosisi6_y2
not_overflow_16:
	sta inosisi3_x2
	sta inosisi6_x2

skip_inosisi0:

; �^�C��
	;REG0 = (p_pat == 0) ? #$20 : #0;

	ldx #$20
	lda p_pat
	bne	skip_pat2
	ldx #0
skip_pat2:
	stx REG0

	lda inosisi01_status
	cmp #1
	beq drown_tail2
	cmp #2
	beq splash1_tail2
	cmp #3
	beq splash2_tail2
; �����^�C��
	clc
	lda #$84     ; 
	adc REG0
	sta inosisi21_t2
	clc
	lda #$85
	adc REG0
	sta inosisi22_t2
	clc
	lda #$86
	adc REG0
	sta inosisi23_t2
	clc
	lda #$94
	adc REG0
	sta inosisi24_t2
	clc
	lda #$95
	adc REG0
	sta inosisi25_t2
	clc
	lda #$96
	adc REG0
	sta inosisi26_t2
	
	jmp break_tile2
; �M��^�C��
drown_tail2:
	clc
	lda #$87     ; 
	adc REG0
	sta inosisi21_t2
	clc
	lda #$88
	adc REG0
	sta inosisi22_t2
	clc
	lda #$97
	adc REG0
	sta inosisi24_t2
	clc
	lda #$98
	adc REG0
	sta inosisi25_t2

	lda #$03	; �u�����N
	sta inosisi23_t2
	sta inosisi26_t2

	jmp break_tile2

; �����Ԃ�1�^�C��
splash1_tail2:
	lda #$89     ; 
	sta inosisi21_t2
	lda #$8A
	sta inosisi22_t2
	lda #$99
	sta inosisi24_t2
	lda #$9A
	sta inosisi25_t2

	lda #$03	; �u�����N
	sta inosisi3_t2
	sta inosisi6_t2

	jmp break_tile2

; �����Ԃ�2�^�C��
splash2_tail2:
	lda #$A9     ; 
	sta inosisi21_t2
	lda #$AA
	sta inosisi22_t2
	lda #$B9
	sta inosisi24_t2
	lda #$BA
	sta inosisi25_t2

	lda #$03	; �u�����N
	sta inosisi23_t2
	sta inosisi26_t2

	jmp break_tile2

break_tile2:
; Y���W�͍X�V�K�{

	clc			; �L�����[�t���OOFF
	lda inosisi1_pos_y
	adc #7
	sta inosisi21_y2
	sta inosisi22_y2
	sta inosisi23_y2

	clc			; �L�����[�t���OOFF
	lda inosisi1_pos_y
	adc #15
	sta inosisi24_y2
	sta inosisi25_y2
	sta inosisi26_y2

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
	sta inosisi24_x2

	lda inosisi1_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #8
	bcc not_overflow2_8	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #232	; ��ʊO
	sta inosisi22_y2
	sta inosisi25_y2
not_overflow2_8:
	sta inosisi22_x2
	sta inosisi25_x2

	lda inosisi1_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #16
	bcc not_overflow2_16	; �L�����[�t���O�������Ă��Ȃ�
	; �I�[�o�[�t���[���Ă���ꍇ��Y���W����ʊO
	lda #232	; ��ʊO
	sta inosisi23_y2
	sta inosisi26_y2
not_overflow2_16:
	sta inosisi23_x2
	sta inosisi26_x2

skip_inosisi1:


;End:
	rts

.endproc	; InosisiDrawDma6

; �C�m�V�V�ƃI�u�W�F�N�g�Ƃ̂����蔻��
.proc inosisi_collision_object
	; ���S���͔��肵�Ȃ�
	lda is_dead
	beq skip_return
	lda #0
	sta obj_collision_result
	rts
skip_return:

	lda #0
	sta obj_collision_sea

	; TODO:	����̍��͍����̍��𗬗p����
	;		�E���̉��͍����̉��𗬗p����
	;		�E��͍���̏�ƉE���̉E�𗬗p����
	; �����蔻��p��4�����i�[
	clc
	lda inosisi0_pos_y,x ;player_y
	sta player_y_top_for_collision		; �����蔻��p��Y���W�iY���W�j
	clc
	adc #15
	sta player_y_bottom_for_collision	; �����蔻��p��Y���W�iY���W+15�j

	lda inosisi0_world_pos_x_hi,x ;player_x_up
	sta player_x_left_hi_for_collision	; �����蔻��p��X���W��ʁiX���W�j
	lda inosisi0_world_pos_x_low,x ;player_x_low
	sta player_x_left_low_for_collision	; �����蔻��p��X���W���ʁiX���W�j
	clc
	adc #23
	sta player_x_right_low_for_collision; �����蔻��p�EX���W���ʁiX���W+23�j
	lda player_x_left_hi_for_collision
	adc #0
	sta player_x_right_hi_for_collision	; �����蔻��p�EX���W��ʁiX���W+23�j


	; �v���C���[�̃t�B�[���h��̈ʒu(�����̍���)(player_x_left_low_for_collision, player_x_left_hi_for_collision)
	; �����8�Ŋ������l�i���j���A�}�b�v�`�b�v�̈ʒu
	; map_chip���������l�́AX*25
	lda player_x_left_low_for_collision
	sta map_chip_player_x_low
	lda player_x_left_hi_for_collision
	sta map_chip_player_x_hi
	; 8�Ŋ���
	clc
	lsr map_chip_player_x_hi	; ��ʂ͉E�V�t�g
	ror map_chip_player_x_low	; ���ʂ͉E���[�e�[�g
	lsr map_chip_player_x_hi	; ��ʂ͉E�V�t�g
	ror map_chip_player_x_low	; ���ʂ͉E���[�e�[�g
	lsr map_chip_player_x_hi	; ��ʂ͉E�V�t�g
	ror map_chip_player_x_low	; ���ʂ͉E���[�e�[�g
	; ���ʂ�25�{(16+8+1)����@�}�b�v�`�b�v�̋N�_���Z�o����
	; REG0��16�{��low REG1��16�{��hi�Ƃ���
	; REG2�� 8�{��low REG3�� 8�{��hi�Ƃ���
	; REG4�� 1�{��low REG5�� 1�{��hi�Ƃ���
	; 16�{
	lda map_chip_player_x_hi
	sta REG1
	lda map_chip_player_x_low
	sta REG0
	clc
	asl REG0		; ���ʂ͍��V�t�g
	rol REG1		; ��ʂ͍����[�e�[�g
	asl REG0		; ���ʂ͍��V�t�g
	rol REG1		; ��ʂ͍����[�e�[�g
	asl REG0		; ���ʂ͍��V�t�g
	rol REG1		; ��ʂ͍����[�e�[�g
	asl REG0		; ���ʂ͍��V�t�g
	rol REG1		; ��ʂ͍����[�e�[�g
	; 8�{
	lda map_chip_player_x_hi
	sta REG3
	lda map_chip_player_x_low
	sta REG2
	clc
	asl REG2		; ���ʂ͍��V�t�g
	rol REG3		; ��ʂ͍����[�e�[�g
	asl REG2		; ���ʂ͍��V�t�g
	rol REG3		; ��ʂ͍����[�e�[�g
	asl REG2		; ���ʂ͍��V�t�g
	rol REG3		; ��ʂ͍����[�e�[�g
	; 1�{
	lda map_chip_player_x_hi
	sta REG5
	lda map_chip_player_x_low
	sta REG4
	; 16�{+8�{
	clc
	lda REG0
	adc REG2
	sta map_chip_collision_index_base_low
	lda REG1
	adc REG3
	sta map_chip_collision_index_base_hi
	; (16�{+8�{) + 1�{
	clc
	lda map_chip_collision_index_base_low
	adc REG4
	sta map_chip_collision_index_base_low
	lda map_chip_collision_index_base_hi
	adc REG5
	sta map_chip_collision_index_base_hi
	; �����܂łŃL�����̍���̈�ԉ��i��ʓI�Ɂj���w���B

	; ����
	clc
	lda player_y_bottom_for_collision
	sta REG0
	lsr REG0	; �E�V�t�g
	lsr REG0	; �E�V�t�g
	lsr REG0	; �E�V�t�g	; 8�Ŋ���

	; 27�������
	sec
	lda #27
	sbc REG0
	sta REG0	; ��ԉ�����̃u���b�N��

	clc
	lda REG0
	adc map_chip_collision_index_base_low			; �L��������ʈ�ԉ�
	sta map_chip_collision_index_left_bottom_low	; �L�������L������
	lda map_chip_collision_index_base_hi
	adc #0
	sta map_chip_collision_index_left_bottom_hi

	; �L�����N�^�̍����̃u���b�N�̍���
	; ����
	; ����
	; ����
	; ����
	; �}�b�v�`�b�v�̋N�_
	lda #< map_chip
	sta map_table_char_pos_offset_low
	lda #> map_chip
	sta map_table_char_pos_offset_hi

	clc
	lda map_table_char_pos_offset_low
	adc map_chip_collision_index_left_bottom_low
	sta map_table_char_pos_offset_low
	lda map_table_char_pos_offset_hi
	adc map_chip_collision_index_left_bottom_hi
	sta map_table_char_pos_offset_hi

	ldy #0	; ���炵�I����Ă���̂�y��0
	lda (map_table_char_pos_offset_low), y
	sta map_table_char_pos_value

	; obj_collision_result��߂�l�Ƃ��Ďg�p����
	; 0�Ȃ�false
	; 1�Ȃ�true
	lda #0
	sta obj_collision_result
	lda map_table_char_pos_value
	cmp #$01
	beq hit0
	cmp #$02
	beq hit0
	cmp #$11
	beq hit0
	cmp #$12
	beq hit0
	cmp #$07
	beq hit0
	cmp #$08
	beq hit0
	cmp #$17
	beq hit0
	cmp #$18
	beq hit0
	jmp skip0
hit0:
	lda #1
	sta obj_collision_result
	lda #0	; �����蔻��0��
	sta obj_collision_pos
	rts
skip0:

	lda map_table_char_pos_value
	cmp #$05
	beq hit_sea
	cmp #$06
	beq hit_sea
	jmp skip_sea
hit_sea:
	lda #1
	sta obj_collision_sea
skip_sea:

	; y���W(����)��8�Ŋ��� 28���炻����Ђ�
	; map_chip_collision_index�ɂ���𑫂�

	; ����
;	clc
;	lda player_y_top_for_collision
;	sta REG0
;	lsr REG0	; �E�V�t�g
;	lsr REG0	; �E�V�t�g
;	lsr REG0	; �E�V�t�g
;
;	sec
;	lda #28
;	sbc REG0
;	sta REG0
;
;	clc
;	lda REG0
;	adc map_chip_collision_index_base_low
;	sta map_chip_collision_index_base_low
;	lda map_chip_collision_index_base_hi
;	adc #0
;	sta map_chip_collision_index_base_hi

	; �L�����N�^�̍���̃u���b�N�̍���
	; ����
	; ����
	; ����
	; ����
	; �}�b�v�`�b�v�̋N�_
	; �v���C���[�̃t�B�[���h��̈ʒu(����̍���)(player_x_left_low_for_collision, player_x_left_hi_for_collision)
	; �����8�Ŋ������l�i���j���A�}�b�v�`�b�v�̈ʒu

	; ����
	clc
	lda player_y_top_for_collision
	sta REG0
	lsr REG0	; �E�V�t�g
	lsr REG0	; �E�V�t�g
	lsr REG0	; �E�V�t�g	; 8�Ŋ���

	; 27�������
	sec
	lda #27
	sbc REG0
	sta REG0	; ��ԉ�����̃u���b�N��

	clc
	lda REG0
	adc map_chip_collision_index_base_low			; �L��������ʈ�ԉ�
	sta map_chip_collision_index_left_top_low		; �L�������L������
	lda map_chip_collision_index_base_hi
	adc #0
	sta map_chip_collision_index_left_top_hi

	lda #< map_chip
	sta map_table_char_pos_offset_low
	lda #> map_chip
	sta map_table_char_pos_offset_hi

	clc
	lda map_table_char_pos_offset_low
	adc map_chip_collision_index_left_top_low
	sta map_table_char_pos_offset_low
	lda map_table_char_pos_offset_hi
	adc map_chip_collision_index_left_top_hi
	sta map_table_char_pos_offset_hi

	ldy #0	; ���炵�I����Ă���̂�y��0
	lda (map_table_char_pos_offset_low), y
	sta map_table_char_pos_value

	; obj_collision_result��߂�l�Ƃ��Ďg�p����
	; 0�Ȃ�false
	; 1�Ȃ�true
	lda #0
	sta obj_collision_result
	lda map_table_char_pos_value
	cmp #$01
	beq hit1
	cmp #$02
	beq hit1
	cmp #$11
	beq hit1
	cmp #$12
	beq hit1
	cmp #$07
	beq hit1
	cmp #$08
	beq hit1
	cmp #$17
	beq hit1
	cmp #$18
	beq hit1
	jmp skip1
hit1:
	lda #1
	sta obj_collision_result
	lda #1	; �����蔻��1��
	sta obj_collision_pos
	rts
skip1:


	; �L�����N�^�̉E���̃u���b�N�̉E��
	; ����
	; ����
	; ����
	; ����
	; �}�b�v�`�b�v�̋N�_
	; �v���C���[�̃t�B�[���h��̈ʒu(�E���̉E��)(player_x_right_low_for_collision, player_x_right_hi_for_collision)
	; �����8�Ŋ������l�i���j���A�}�b�v�`�b�v�̈ʒu
	lda player_x_right_low_for_collision
	sta map_chip_player_x_low
	lda player_x_right_hi_for_collision
	sta map_chip_player_x_hi
	; 8�Ŋ���
	clc
	lsr map_chip_player_x_hi	; ��ʂ͉E�V�t�g
	ror map_chip_player_x_low	; ���ʂ͉E���[�e�[�g
	lsr map_chip_player_x_hi	; ��ʂ͉E�V�t�g
	ror map_chip_player_x_low	; ���ʂ͉E���[�e�[�g
	lsr map_chip_player_x_hi	; ��ʂ͉E�V�t�g
	ror map_chip_player_x_low	; ���ʂ͉E���[�e�[�g
	; ���ʂ�25�{(16+8+1)����@�}�b�v�`�b�v�̋N�_���Z�o����
	; REG0��16�{��low REG1��16�{��hi�Ƃ���
	; REG2�� 8�{��low REG3�� 8�{��hi�Ƃ���
	; REG4�� 1�{��low REG5�� 1�{��hi�Ƃ���
	; 16�{
	lda map_chip_player_x_hi
	sta REG1
	lda map_chip_player_x_low
	sta REG0
	clc
	asl REG0		; ���ʂ͍��V�t�g
	rol REG1		; ��ʂ͍����[�e�[�g
	asl REG0		; ���ʂ͍��V�t�g
	rol REG1		; ��ʂ͍����[�e�[�g
	asl REG0		; ���ʂ͍��V�t�g
	rol REG1		; ��ʂ͍����[�e�[�g
	asl REG0		; ���ʂ͍��V�t�g
	rol REG1		; ��ʂ͍����[�e�[�g
	; 8�{
	lda map_chip_player_x_hi
	sta REG3
	lda map_chip_player_x_low
	sta REG2
	clc
	asl REG2		; ���ʂ͍��V�t�g
	rol REG3		; ��ʂ͍����[�e�[�g
	asl REG2		; ���ʂ͍��V�t�g
	rol REG3		; ��ʂ͍����[�e�[�g
	asl REG2		; ���ʂ͍��V�t�g
	rol REG3		; ��ʂ͍����[�e�[�g
	; 1�{
	lda map_chip_player_x_hi
	sta REG5
	lda map_chip_player_x_low
	sta REG4
	; 16�{+8�{
	clc
	lda REG0
	adc REG2
	sta map_chip_collision_index_base_low
	lda REG1
	adc REG3
	sta map_chip_collision_index_base_hi
	; (16�{+8�{) + 1�{
	clc
	lda map_chip_collision_index_base_low
	adc REG4
	sta map_chip_collision_index_base_low
	lda map_chip_collision_index_base_hi
	adc REG5
	sta map_chip_collision_index_base_hi
	; �����܂łŃL�����̍���̈�ԉ��i��ʓI�Ɂj���w���B


	; �E��
	clc
	lda player_y_bottom_for_collision
	sta REG0
	lsr REG0	; �E�V�t�g
	lsr REG0	; �E�V�t�g
	lsr REG0	; �E�V�t�g	; 8�Ŋ���

	; 27�������
	sec
	lda #27
	sbc REG0
	sta REG0	; ��ԉ�����̃u���b�N��

	clc
	lda REG0
	adc map_chip_collision_index_base_low			; �L��������ʈ�ԉ�
	sta map_chip_collision_index_right_bottom_low		; �L�����E�L������
	lda map_chip_collision_index_base_hi
	adc #0
	sta map_chip_collision_index_right_bottom_hi

	lda #< map_chip
	sta map_table_char_pos_offset_low
	lda #> map_chip
	sta map_table_char_pos_offset_hi

	clc
	lda map_table_char_pos_offset_low
	adc map_chip_collision_index_right_bottom_low
	sta map_table_char_pos_offset_low
	lda map_table_char_pos_offset_hi
	adc map_chip_collision_index_right_bottom_hi
	sta map_table_char_pos_offset_hi

	ldy #0	; ���炵�I����Ă���̂�y��0
	lda (map_table_char_pos_offset_low), y
	sta map_table_char_pos_value

	; obj_collision_result��߂�l�Ƃ��Ďg�p����
	; 0�Ȃ�false
	; 1�Ȃ�true
	lda #0
	sta obj_collision_result
	lda map_table_char_pos_value
	cmp #$01
	beq hit2
	cmp #$02
	beq hit2
	cmp #$11
	beq hit2
	cmp #$12
	beq hit2
	cmp #$07
	beq hit2
	cmp #$08
	beq hit2
	cmp #$17
	beq hit2
	cmp #$18
	beq hit2
	jmp skip2
hit2:
	lda #1
	sta obj_collision_result
	lda #0	; �����蔻��0��
	sta obj_collision_pos
	rts
skip2:

	; �L�����N�^�̉E��̃u���b�N�̉E��
	; ����
	; ����
	; ����
	; ����
	; �}�b�v�`�b�v�̋N�_
	; �v���C���[�̃t�B�[���h��̈ʒu(�E��̉E��)(player_x_right_low_for_collision, player_x_right_hi_for_collision)
	; �����8�Ŋ������l�i���j���A�}�b�v�`�b�v�̈ʒu

	; �E��
	clc
	lda player_y_top_for_collision
	sta REG0
	lsr REG0	; �E�V�t�g
	lsr REG0	; �E�V�t�g
	lsr REG0	; �E�V�t�g	; 8�Ŋ���

	; 27�������
	sec
	lda #27
	sbc REG0
	sta REG0	; ��ԉ�����̃u���b�N��

	clc
	lda REG0
	adc map_chip_collision_index_base_low			; �L��������ʈ�ԉ�
	sta map_chip_collision_index_right_top_low		; �L�������L������
	lda map_chip_collision_index_base_hi
	adc #0
	sta map_chip_collision_index_right_top_hi

	lda #< map_chip
	sta map_table_char_pos_offset_low
	lda #> map_chip
	sta map_table_char_pos_offset_hi

	clc
	lda map_table_char_pos_offset_low
	adc map_chip_collision_index_right_top_low
	sta map_table_char_pos_offset_low
	lda map_table_char_pos_offset_hi
	adc map_chip_collision_index_right_top_hi
	sta map_table_char_pos_offset_hi

	ldy #0	; ���炵�I����Ă���̂�y��0
	lda (map_table_char_pos_offset_low), y
	sta map_table_char_pos_value

	; collision_result��߂�l�Ƃ��Ďg�p����
	; 0�Ȃ�false
	; 1�Ȃ�true
	lda #0
	sta obj_collision_result
	lda map_table_char_pos_value
	cmp #$01
	beq hit3
	cmp #$02
	beq hit3
	cmp #$11
	beq hit3
	cmp #$12
	beq hit3
	cmp #$07
	beq hit3
	cmp #$08
	beq hit3
	cmp #$17
	beq hit3
	cmp #$18
	beq hit3
	jmp skip3
hit3:
	lda #1
	sta obj_collision_result
	lda #1	; �����蔻��1��
	sta obj_collision_pos
	rts
skip3:

	rts
.endproc	; inosisi_collision_object

.proc Inosisi_SetAttribute
	; ����REG0�F����(0��1)
	; ����x�F�C�m�V�V�P���C�m�V�V�Q
	; x��0��1���ŕς��鑮���𔻒肷��
	txa
	cmp #0
	beq inosisi1
	cmp #1
	beq inosisi2
inosisi1:
	lda REG0
	sta inosisi1_s
	sta inosisi2_s
	sta inosisi3_s
	sta inosisi4_s
	sta inosisi5_s
	sta inosisi6_s
	sta inosisi1_s2
	sta inosisi2_s2
	sta inosisi3_s2
	sta inosisi4_s2
	sta inosisi5_s2
	sta inosisi6_s2
	
	jmp break
inosisi2:
	lda REG0
	sta inosisi21_s
	sta inosisi22_s
	sta inosisi23_s
	sta inosisi24_s
	sta inosisi25_s
	sta inosisi26_s
	sta inosisi21_s2
	sta inosisi22_s2
	sta inosisi23_s2
	sta inosisi24_s2
	sta inosisi25_s2
	sta inosisi26_s2

break:
	rts
.endproc	; Inosisi_SetSplashAttribute
