.proc	PlayerInit
	lda #0
	sta chr_lr
	sta is_dead
	sta update_dead_step
	sta player_draw_status
	sta item_count
	rts
.endproc

; A
.proc	PlayerJump
	; �W�����v���Ȃ甲����
	lda is_jump
	bne	End
	lda is_dead
	bne End

	; �W�����v�t���OON
	lda	#1
	sta	is_jump

	; �W�����v
	lda #1
	sta player_draw_status

	; ���x�ƕ������Z�b�g
	lda	#6;#10
	sta	spd_y

	lda	#1		; ���x�����
	sta	spd_vec

	jsr Sound_PlayJump
End:
	rts
.endproc

; B
.proc	PlayerAttack
	
	; �͂΃^��������΃t�@�C�A�[
	lda habatan_alive_flag
	beq skip_haba_fire
	lda habatan_status
	cmp #1
	bne skip_haba_fire
	jsr HabatanFire_Appear
	jsr Sound_PlayFire

	jmp exit

	skip_haba_fire:
	
	; ����ȊO�͐����߂�
	; �U��
	lda #2
	sta player_draw_status
	lda #0
	sta attack_frame
	; �����߂�SE
	jsr Sound_PlayFukimodoshi

exit:
	rts
.endproc

; ��ړ�
.proc	PlayerMoveUp
	rts
.endproc

; ���ړ�
.proc	PlayerMoveDown
	rts
.endproc

; ���ړ�
.proc	PlayerMoveLeft
	lda is_dead
	bne skip

	; ��ʂ̍��[�Ȃ獶�ړ����Ȃ�
	sec
	lda player_x_low
	sbc field_scroll_x_low
;	sbc #9
;	bcc skip; �L�����[�t���O���N���A����Ă��鎞
	beq skip; �[���t���O�������Ă��Ȃ��Ƃ��X�L�b�v

	sec					; �L�����[�t���OON
	lda player_x_decimal
	sbc player_spd_decimal
	sta player_x_decimal
	lda	player_x_low	; ����
	sbc	player_spd_low
	sta	player_x_low

	lda	player_x_hi		; ���
	sbc	#0
	sta	player_x_hi

	lda #1
	sta chr_lr

	; �����蔻��
	jsr collision_object
	lda obj_collision_result
	beq skip

	clc
	lda player_x_low
	adc #1
	sta player_x_low
	lda player_x_hi
	adc #0
	sta player_x_hi
skip:

	rts
.endproc

; �E�ړ�
.proc	PlayerMoveRight
	lda is_dead
	beq skip_skip
	jmp skip
	skip_skip:

	lda habatan_fire_alive_flag
	beq skip_skip2
	jmp skip
	skip_skip2:

	clc					; �L�����[�t���OOFF
	lda player_x_decimal
	adc player_spd_decimal
	sta player_x_decimal
	lda	player_x_low	; ����
	adc	player_spd_low
	sta	player_x_low

	lda	player_x_hi		; ���
	adc	#0
	sta	player_x_hi

	; �����蔻��
	jsr collision_object
	lda obj_collision_result
	beq roll_skip

	sec
	lda player_x_low
	sbc #1
	sta player_x_low
	lda player_x_hi
	sbc #0
	sta player_x_hi
	jmp skip
roll_skip:

	; �X�N���[�����W�ƃL�����N�^���W�̍���
	; 127�ȉ��̓X�N���[�����W���X�V���Ȃ�
	sec
	lda player_x_low
	sbc field_scroll_x_low
	sec
	sbc #127
	bcc skip	; �L�����[�t���O���N���A����Ă��鎞

	; �X�N���[�����
	clc
	lda scroll_x
	adc #1
	sta scroll_x

	inc scroll_count_8dot
	lda scroll_count_8dot
	cmp #8
	bne skip_scroll_count_8dot_off
	lda #0
	sta scroll_count_8dot
	inc scroll_count_8dot_count	
skip_scroll_count_8dot_off:

	inc scroll_count_32dot
	lda scroll_count_32dot
	cmp #32
	bne skip_scroll_count_32dot_off
	lda #0
	sta scroll_count_32dot
	inc scroll_count_32dot_count
skip_scroll_count_32dot_off:

	; �X�N���[�����̍X�V
	clc
	lda field_scroll_x_low
	adc #1
	sta field_scroll_x_low

	bcc eor_skip
	lda #%00000001
	eor current_draw_display_no
	sta current_draw_display_no
eor_skip:

	lda field_scroll_x_hi
	adc #0
	sta field_scroll_x_hi

skip:

;	inc player_x;
	lda #0
	sta chr_lr
	rts
.endproc

.proc	PlayerDead
	; ���S�t���OON
	lda	#1
	sta	is_dead

	; �W�����v�t���OOFF
	lda #0
	sta is_jump

	; ���S
	lda #4
	sta player_draw_status

	rts
.endproc

; �X�V
.proc	Player_Update
	; ���S��
	;	�X�e�b�v
	;	�~�܂�
	;	��ɔ��
	; �W�����v��
	; �W�����v������Ȃ�����

	; ��L�ɂ�����炸�ʂ鏈��


	; ���S���̏���
	lda is_dead
	beq skip_dead
	jsr Player_UpdateDead
skip_dead:

	; �W�����v���m�F
	lda	is_jump
	beq	skip_jump
	; �W�����v������
	jsr	Player_UpdateJump
skip_jump:

	; �W�����v������Ȃ�
	lda	is_jump
	bne	skip_not_jump
	lda is_dead
	bne skip_not_jump
	; �d��
	clc
	lda #1
	adc player_y
	sta player_y
	; �����蔻�菈��
	jsr collision_object

	; �����蔻��t���O
	lda obj_collision_result
	beq roll_skip
	; ������������

	; �W�����v���Ȃ�ʏ�
	lda is_jump
	beq skip_nomal
	lda #0
	sta player_draw_status
skip_nomal:

	; ��������0
	lda #0
	sta player_y+1

	;���̏���
	sec
	lda player_y
	and #%11111000
	sta player_y
	; �W�����v�t���O�𗎂Ƃ�
	lda is_jump
	beq skip_jump_off
	lda	#0
	sta	is_jump
skip_jump_off:



	lda #0
	sta spd_y
	sta spd_y+1
	jmp not_jump_exit
	
roll_skip:
	; �߂��Ȃ������R�����J�n
	lda #1
	sta is_jump
	; �W�����v
	lda #1
	sta player_draw_status

	; ���x�ƕ������Z�b�g
	lda	#0
	sta	spd_y
	sta spd_y+1

	lda	#0		; ���x������
	sta	spd_vec

not_jump_exit:
skip_not_jump:

	; ���̑��̕K���ʂ鏈��

	; ���x�ω��X�V
	jsr Player_UpdateSpeed

	lda player_draw_status
	cmp #0	; �ʏ�
	beq case_nomal
	cmp #1	; �W�����v
	beq case_jump
	cmp #2	; �U����1
	beq case_attack1
	cmp #3	; �U����2
	beq case_attack2
	cmp #4	; ���S
	beq case_dead
	jmp break_status

case_nomal:
	jmp break_status
case_jump:
	jmp break_status
case_attack1:
	inc attack_frame
	lda attack_frame
	cmp #10
	bne break_status
	lda #3
	sta player_draw_status
	jmp break_status
case_attack2:
	inc attack_frame
	lda attack_frame
	cmp #20
	bne break_status
	lda #0
	sta player_draw_status
	jmp break_status
case_dead:

break_status:

	; �C������t���O
	lda obj_collision_sea
	beq skip_first_sea_hit
	lda is_dead					; ���S�t���O
	bne skip_first_sea_hit
	; �C�����肩�����Ă���ꍇ
	; ���񏈗��Ǝ��S�t���O�𗧂Ă�
	jsr PlayerDead
	
skip_first_sea_hit:


	; �G�Ƃ̂����蔻��
	jsr collision_char
	lda is_dead					; ���S�t���O
	eor #1						; is_dead�𔽓]
	and char_collision_result	; �����蔻���and
	; �����肩�����Ă���ꍇ
	; ���񏈗��Ǝ��S�t���O�𗧂Ă�
	beq skip_first_hit
	jsr PlayerDead
	
skip_first_hit:

	; �A�C�e�������蔻��
	jsr collision_item
	lda char_collision_result
	beq not_get
	jsr Item_GetAction
	not_get:

	rts
.endproc

; �W�����v������
.proc	Player_UpdateJump
	lda spd_vec
	; 0�Ȃ瑫���Z��
	beq tashizan
	;; �����Z begin
	; �������̈����Z
	sec			; �L�����[�t���OON
	lda	player_y+1	; ����������A�Ƀ��[�h���܂�
	sbc	spd_y+1		; ���Z
	sta	player_y+1	; A���烁�����ɃX�g�A���܂�

	; �������̈����Z
	lda	player_y
	sbc	spd_y
	sta	player_y

	; ���x�̌��Z
	; �������̌���
	sec			; �L�����[�t���OON
	lda	spd_y+1
	sbc	#$40
	sta	spd_y+1
	; �������̌���
	lda	spd_y
	sbc	#$0
	sta	spd_y
	; ���������}�C�i�X�ɂȂ�����
	bpl	skip_negative_proc; �l�K�e�B�u�t���O���N���A����Ă���
	; ���x���}�C�i�X�ɂȂ����̂ŁA���x���������ɂ���
	lda #0
	sta spd_vec
	sta spd_y
	sta spd_y+1

skip_negative_proc:

	jmp skip_tashizan
	;; �����Z end

	;; �����Z
tashizan:
	; �������̑����Z
	clc			; �L�����[�t���OOFF
	lda	player_y+1	; ����������A�Ƀ��[�h���܂�
	adc	spd_y+1		; ���Z
	sta	player_y+1	; A���烁�����ɃX�g�A���܂�

	; �������̑����Z
	lda	player_y
	adc	spd_y
	sta	player_y

	; ���x�������Z
	; �������̉��Z
	clc			; �L�����[�t���OOFF
	lda	spd_y+1
	adc	#$40
	sta	spd_y+1
	; �������̉��Z
	lda	spd_y
	adc	#$0
	sta	spd_y

	; ���x�̏����8�Ƃ���
	lda spd_y
	cmp #8
	bne skip_an_upper_limit
	lda #8
	sta spd_y
	lda #0
	sta spd_y+1
skip_an_upper_limit:

skip_tashizan:

	; �����蔻��
	jsr collision_object
	lda obj_collision_result
	;lda #0
	beq roll_skip
	; ��œ���������A8�̗]���؂�̂Ă�7������A���x��0�ɂ���
	; ���œ���������A8�̗]���؂�̂Ă�1�����A���x��0�ɂ���

	; ��������0
	lda #0
	sta player_y+1

	; ��œ����������A���œ���������
	lda obj_collision_pos
	beq shita
	;��̏���
	clc
	lda player_y
	and #%11111000
	adc #8
	sta player_y
	jmp end
shita:
	;���̏���
	sec
	lda player_y
	and #%11111000
	sta player_y
	; �W�����v�t���O�𗎂Ƃ�
	lda	#0
	sta	is_jump

	; �ʏ�
	lda #0
	sta player_draw_status
end:
	lda #0
	sta spd_y
	sta spd_y+1
	
roll_skip:

	; ����ł���224�Ŏ~�߂�
	lda is_dead
	cmp #1
	bne dead_stop_skip
	sec
	lda #224
	sbc player_y
	bcs dead_stop_skip	; �L�����[�t���O�Z�b�g����Ă���
	lda #224
	sta player_y
dead_stop_skip:

	rts
.endproc

; ���S���X�V
.proc	Player_UpdateDead
;	enum {
;		step_init,
;		step_stop,
;		step_jump,
;		step_wait,
;	};
;	switch(m_step) {
;	case step_init:
;		m_step++;
;		break;
;	case step_stop:
;		m_step++;
;		break;
;	case step_jump:
;		m_step++;
;		break;
;	case step_wait:
;		m_step++;
;		break;
;	}

	lda update_dead_step
	cmp #0
	beq case_init
	cmp #1
	beq case_stop
	cmp #2
	beq case_jump
	cmp #3
	beq case_wait

case_init:
	; ����0
	inc update_dead_step
	jmp break;
case_stop:
	; ����1
	lda #30
	sta wait_frame
	inc update_dead_step
	jmp break;
case_jump:
	; ����2
	dec wait_frame
	bne break
	lda #1
	sta is_jump

	; ���x�ƕ������Z�b�g
	lda	#6;#10
	sta	spd_y

	lda	#1		; ���x�����
	sta	spd_vec
	inc update_dead_step
	jmp break;
case_wait:
	; ����3
	sec
	lda #224
	cmp player_y
	bne break
	lda #4					; �Q�[���I�[�o�[
	sta scene_type			; �V�[��
	lda #0
	sta scene_update_step	; �V�[�����X�e�b�v

	inc update_dead_step
	jmp break;

break:



	rts
.endproc

.proc player_draw_dma7_attack1
	ldx #2
	stx REG0
	; �����߂�
	clc			; �L�����[�t���OOFF
	lda player_y
	adc #21
	sta playerFuki1_y
	sta playerFuki2_y
	lda #$0C
	sta playerFuki1_t
	lda #$0D
	sta playerFuki2_t

	lda chr_lr
	cmp #0
	beq case_attack1_right
	cmp #1
	beq case_attack1_left

case_attack1_right:
	lda #%00000000
	sta playerFuki1_s
	sta playerFuki2_s
	clc			; �L�����[�t���OOFF
	lda window_player_x_low
	adc #12
	sta playerFuki1_x
	clc			; �L�����[�t���OOFF
	lda window_player_x_low
	adc #20
	sta playerFuki2_x

	jmp break_fuki_attack1
case_attack1_left:
	lda #%01000000
	sta playerFuki1_s
	sta playerFuki2_s
	sec			; �L�����[�t���OON
	lda window_player_x_low
	sbc #4
	sta playerFuki1_x
	sec			; �L�����[�t���OON
	lda window_player_x_low
	sbc #12
	sta playerFuki2_x

	jmp break_fuki_attack1

break_fuki_attack1:


	rts
.endproc

.proc player_draw_dma7_attack2
	ldx #0
	stx REG0
	; �����߂�
	clc			; �L�����[�t���OOFF
	lda player_y
	adc #21
	sta playerFuki1_y
	lda #232	; ��ʊO
	sta playerFuki2_y
	lda #$1D
	sta playerFuki1_t

	lda chr_lr
	cmp #0
	beq case_attack2_right
	cmp #1
	beq case_attack2_left

case_attack2_right:
	lda #%00000000
	sta playerFuki1_s
;	sta playerFuki2_s
	clc			; �L�����[�t���OOFF
	lda window_player_x_low
	adc #12
	sta playerFuki1_x
	jmp break_fuki_attack2
case_attack2_left:
	lda #%01000000
	sta playerFuki1_s
;	sta playerFuki2_s
	sec			; �L�����[�t���OON
	lda window_player_x_low
	sbc #4
	sta playerFuki1_x

	jmp break_fuki_attack2

break_fuki_attack2:

	rts
.endproc	; player_draw_dma7_attack2


; �`��
.proc	player_draw_dma7
	; �t�B�[���h�v���C���[�ʒu - �t�B�[���h�X�N���[���ʒu
	sec
	lda player_x_low
	sbc field_scroll_x_low
	sta window_player_x_low

	clc
	lda window_player_x_low
	adc #8
	sta window_player_x_low8

	;						�E����			������
	; REG1 = (chr_lr == 0) ? #%00000000 : #%01000000;
	; REG2 = (chr_lr == 0) ? window_player_x_low8 : window_player_x_low;
	; REG3 = (chr_lr == 0) ? window_player_x_low : window_player_x_low8;
	; ���E����
	lda #%01000000
	sta REG1
	lda window_player_x_low
	sta REG2
	lda window_player_x_low8
	sta REG3

	lda chr_lr
	bne ContinueLR

	lda #%00000000
	sta REG1
	lda window_player_x_low8
	sta REG2
	lda window_player_x_low
	sta REG3

ContinueLR:


	lda #232	; ��ʊO
	sta playerFuki1_y
	sta playerFuki2_y


	lda player_draw_status
	cmp #0	; �ʏ�
	beq case_nomal
	cmp #1	; �W�����v
	beq case_jump
	cmp #2	; �U����1
	beq case_attack1
	cmp #3	; �U����2
	beq case_attack2
	cmp #4	; ���S
	beq case_dead

; �ʏ�
case_nomal:
	;REG0 = (p_pat == 0) ? 2 : 0;
	ldx #2
	lda p_pat
	bne	Pat1
	ldx #0
Pat1:
	stx REG0

	jmp break

; �W�����v
case_jump:
	ldx #$40
	stx REG0

	jmp break

; �U����1
case_attack1:
	jsr player_draw_dma7_attack1

	jmp break

; �U����2
case_attack2:
	jsr player_draw_dma7_attack2

	jmp break

; ���S
case_dead:
	ldx #$42
	stx REG0

	jmp break
break:




	clc			; �L�����[�t���OOFF
	lda player_y
	adc #7
	sta player1_y;
	sta player2_y;
	clc
	lda #$80     ; 21��A�Ƀ��[�h
	adc REG0
	sta player1_t
	lda REG1;#%00000000     ; 0(10�i��)��A�Ƀ��[�h
	sta player1_s
	sta player2_s
	sta player3_s
	sta player4_s
	sta player5_s
	sta player6_s
	sta player7_s
	sta player8_s

	lda REG3; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta player1_x
	sta player3_x
	sta player5_x
	sta player7_x

	clc
	lda #$81     ; 21��A�Ƀ��[�h
	adc REG0
	sta player2_t
	lda REG2; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta player2_x
	sta player4_x
	sta player6_x
	sta player8_x

	clc			; �L�����[�t���OOFF
	lda player_y
	adc #15
	sta player3_y;
	sta player4_y;
	clc
	lda #$90     ; 21��A�Ƀ��[�h
	adc REG0
	sta player3_t

	clc
	lda #$91     ; 21��A�Ƀ��[�h
	adc REG0
	sta player4_t

	clc			; �L�����[�t���OOFF
	lda player_y
	adc #23
	sta player5_y;
	sta player6_y;
	clc
	lda #$A0     ; 21��A�Ƀ��[�h
	adc REG0
	sta player5_t

	clc
	lda #$A1     ; 21��A�Ƀ��[�h
	adc REG0
	sta player6_t

	clc			; �L�����[�t���OOFF
	lda player_y
	adc #31
	sta player7_y;
	sta player8_y;
	clc
	lda #$B0     ; 21��A�Ƀ��[�h
	adc REG0
	sta player7_t

	clc
	lda #$B1     ; 21��A�Ƀ��[�h
	adc REG0
	sta player8_t

	dec pat_change_frame
	;lda	#10
	;cmp pat_change_frame
	lda pat_change_frame
	bne change_pat_skip
	jsr change_pat

change_pat_skip:
;End:
	rts

.endproc

.proc player_draw_dma6_attack1
	ldx #2
	stx REG0
	; �����߂�
	clc			; �L�����[�t���OOFF
	lda player_y
	adc #21
	sta playerFuki1_y2
	sta playerFuki2_y2
	lda #$0C
	sta playerFuki1_t2
	lda #$0D
	sta playerFuki2_t2

	lda chr_lr
	cmp #0
	beq case_attack1_right
	cmp #1
	beq case_attack1_left

case_attack1_right:
	lda #%00000000
	sta playerFuki1_s2
	sta playerFuki2_s2
	clc			; �L�����[�t���OOFF
	lda window_player_x_low
	adc #12
	sta playerFuki1_x2
	clc			; �L�����[�t���OOFF
	lda window_player_x_low
	adc #20
	sta playerFuki2_x2

	jmp break_fuki_attack1
case_attack1_left:
	lda #%01000000
	sta playerFuki1_s2
	sta playerFuki2_s2
	sec			; �L�����[�t���OON
	lda window_player_x_low
	sbc #4
	sta playerFuki1_x2
	sec			; �L�����[�t���OON
	lda window_player_x_low
	sbc #12
	sta playerFuki2_x2

	jmp break_fuki_attack1

break_fuki_attack1:


	rts
.endproc	; player_draw_dma6_attack1

.proc player_draw_dma6_attack2
	ldx #0
	stx REG0
	; �����߂�
	clc			; �L�����[�t���OOFF
	lda player_y
	adc #21
	sta playerFuki1_y2
	lda #232	; ��ʊO
	sta playerFuki2_y2
	lda #$1D
	sta playerFuki1_t2

	lda chr_lr
	cmp #0
	beq case_attack2_right
	cmp #1
	beq case_attack2_left

case_attack2_right:
	lda #%00000000
	sta playerFuki1_s2
;	sta playerFuki2_s2
	clc			; �L�����[�t���OOFF
	lda window_player_x_low
	adc #12
	sta playerFuki1_x2
	jmp break_fuki_attack2
case_attack2_left:
	lda #%01000000
	sta playerFuki1_s2
;	sta playerFuki2_s2
	sec			; �L�����[�t���OON
	lda window_player_x_low
	sbc #4
	sta playerFuki1_x2

	jmp break_fuki_attack2

break_fuki_attack2:

	rts
.endproc	; player_draw_dma6_attack2


; �`��
.proc	player_draw_dma6

	; �t�B�[���h�v���C���[�ʒu - �t�B�[���h�X�N���[���ʒu
	sec
	lda player_x_low
	sbc field_scroll_x_low
	sta window_player_x_low

	clc
	lda window_player_x_low
	adc #8
	sta window_player_x_low8

	; REG1 = (chr_lr == 0) ? #%00000000 : #%01000000;
	; REG2 = (chr_lr == 0) ? window_player_x_low8 : window_player_x_low;
	; REG3 = (chr_lr == 0) ? window_player_x_low : window_player_x_low8;
	; ���E����
	lda #%01000000
	sta REG1
	lda window_player_x_low
	sta REG2
	lda window_player_x_low8
	sta REG3

	lda chr_lr
	bne ContinueLR

	lda #%00000000
	sta REG1
	lda window_player_x_low8
	sta REG2
	lda window_player_x_low
	sta REG3

ContinueLR:

	lda #232	; ��ʊO
	sta playerFuki1_y2
	sta playerFuki2_y2


	lda player_draw_status
	cmp #0	; �ʏ�
	beq case_nomal
	cmp #1	; �W�����v
	beq case_jump
	cmp #2	; �U����1
	beq case_attack1
	cmp #3	; �U����2
	beq case_attack2
	cmp #4	; ���S
	beq case_dead

; �ʏ�
case_nomal:
	;REG0 = (p_pat == 0) ? 2 : 0;
	ldx #2
	lda p_pat
	bne	Pat1
	ldx #0
Pat1:
	stx REG0

	jmp break

; �W�����v
case_jump:
	ldx #$40
	stx REG0

	jmp break

; �U����
case_attack1:
	jsr player_draw_dma6_attack1

	jmp break

; �U����
case_attack2:
	jsr player_draw_dma6_attack2

	jmp break

; ���S
case_dead:
	ldx #$42
	stx REG0

	jmp break

break:


	clc			; �L�����[�t���OOFF
	lda player_y
	adc #7
	sta player1_y2;
	sta player2_y2;
	clc
	lda #$80     ; 21��A�Ƀ��[�h
	adc REG0
	sta player1_t2
	lda REG1;#%00000000     ; 0(10�i��)��A�Ƀ��[�h
	sta player1_s2
	sta player2_s2
	sta player3_s2
	sta player4_s2
	sta player5_s2
	sta player6_s2
	sta player7_s2
	sta player8_s2

	lda REG3; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta player1_x2
	sta player3_x2
	sta player5_x2
	sta player7_x2

	clc
	lda #$81     ; 21��A�Ƀ��[�h
	adc REG0
	sta player2_t2
	lda REG2; player_x;#30;#%01111110     ; 30(10�i��)��A�Ƀ��[�h
	sta player2_x2
	sta player4_x2
	sta player6_x2
	sta player8_x2

	clc			; �L�����[�t���OOFF
	lda player_y
	adc #15
	sta player3_y2;
	sta player4_y2;
	clc
	lda #$90     ; 21��A�Ƀ��[�h
	adc REG0
	sta player3_t2

	clc
	lda #$91     ; 21��A�Ƀ��[�h
	adc REG0
	sta player4_t2

	clc			; �L�����[�t���OOFF
	lda player_y
	adc #23
	sta player5_y2;
	sta player6_y2;
	clc
	lda #$A0     ; 21��A�Ƀ��[�h
	adc REG0
	sta player5_t2

	clc
	lda #$A1     ; 21��A�Ƀ��[�h
	adc REG0
	sta player6_t2

	clc			; �L�����[�t���OOFF
	lda player_y
	adc #31
	sta player7_y2;
	sta player8_y2;
	clc
	lda #$B0     ; 21��A�Ƀ��[�h
	adc REG0
	sta player7_t2

	clc
	lda #$B1     ; 21��A�Ƀ��[�h
	adc REG0
	sta player8_t2


	dec pat_change_frame
	;lda	#10
	;cmp pat_change_frame
	lda pat_change_frame
	bne change_pat_skip
	jsr change_pat

change_pat_skip:

;End:
	rts

.endproc

; �p�^�[���؂�ւ�
.proc	change_pat
	; p_pat��0,1���]
	sec			; �L�����[�t���OON
	lda	#1
	sbc p_pat
	sta p_pat

	lda	#10
	sta	pat_change_frame

	rts
.endproc

; �I�u�W�F�N�g�Ƃ̂����蔻��
.proc collision_object
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
	lda player_y
	sta player_y_top_for_collision		; �����蔻��p��Y���W�iY���W�j
	clc
	adc #31
	sta player_y_bottom_for_collision	; �����蔻��p��Y���W�iY���W+31�j

	lda player_x_hi
	sta player_x_left_hi_for_collision	; �����蔻��p��X���W��ʁiX���W�j
	lda player_x_low
	sta player_x_left_low_for_collision	; �����蔻��p��X���W���ʁiX���W�j
	clc
	adc #15
	sta player_x_right_low_for_collision; �����蔻��p�EX���W���ʁiX���W+15�j
	lda player_x_left_hi_for_collision
	adc #0
	sta player_x_right_hi_for_collision	; �����蔻��p�EX���W��ʁiX���W+15�j


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
	rts
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
	sta map_chip_collision_index_right_bottom_low		; �L�������L������
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


	; �v���C���[�̃E�B���h�E���ʒu(�s�N�Z������u���b�N)
	; �����8�Ŋ������l��32����������l(x)��
	; int x = 32 - window_player_x_low8 / 8
	; map_table_attribute_low����߂镪(x�̒l
	;	lda (map_table_attribute_low), y
	;diff[] 25, 50, 75, 100, 125, 150, 175, 200, 225, 250,
	;		275, 300, 325, 350, 375, 400, 425, 450 ,475, 500
	;		525, 550, 575, 600, 625, 650, 675, 700, 725, 750
	;		750, 775
	; int map[��l���̈ʒu,y] = map_table_attribute_low - diff[x]
	rts
.endproc

; �L�����Ƃ̂����蔻��
.proc collision_char
	lda #0
	sta char_collision_result

	; �v���C����X���W�ƃC�m�V�V��X���W��
	; �v���C����Y���W�ƃC�m�V�V��Y���W��
	; ��r���āA�Ƃ��ɍ��������ȉ��Ȃ�
	; ���������B
	lda #1
	sta inosisi_alive_flag_current	; �t���O�Q�ƌ��݈ʒu
	ldx #0
loop_x:
	; �������Ă��邩
	lda inosisi_alive_flag
	and inosisi_alive_flag_current
	beq next_update		; ���݂��Ă��Ȃ�

	; ���݂��Ă���
	; �v���C����X�ƃC�m�V�V��X�̑傫����
	sec
	lda window_player_x_low
	sbc inosisi0_window_pos_x,x
	bpl big_player	; �v���C���̕����傫��
	; �C�m�V�V�̕����傫��
	sec
	lda inosisi0_window_pos_x,x
	sbc window_player_x_low
big_player:
	sta REG0	; X����

	; �v���C����Y�ƃC�m�V�V��Y�̑傫����
	sec
	lda player_y
	sbc inosisi0_pos_y,x
	bpl big_player_y	; �v���C���̕����傫��
	; �C�m�V�V�̕����傫��
	sec
	lda inosisi0_pos_y,x
	sbc player_y
big_player_y:
	sta REG1	; y����

	lda #0
	sta char_collision_result
	
	sec
	lda REG0
	sbc #17
	bpl	next_update	; ������16���傫��
	
	sec
	lda REG1
	sbc #17
	bpl	next_update	; ������16���傫��

	lda #1
	sta char_collision_result
	jmp exit


next_update:
	; ��
	asl inosisi_alive_flag_current
	inx
	cpx inosisi_max_count	; ���[�v�ő吔
	bne loop_x				; ���[�v
	

;exit:

	; REG2 ����
	; REG3 alive_flag
	lda #0
	sta REG2

loop_tako_type:
	lda tako_alive_flag
	sta REG3		; �^�R�����t���O
	lda REG2		; ���ڂ̃^�R
	beq skip_alive_flag
	lda tako_haba_alive_flag
	sta REG3		; �͂΃^�R�����t���O
	skip_alive_flag:

	; �v���C����X���W�ƃ^�R��X���W��
	; �v���C����Y���W�ƃ^�R��Y���W��
	; ��r���āA�Ƃ��ɍ��������ȉ��Ȃ�
	; ���������B
	lda #1
	sta tako_alive_flag_current	; �t���O�Q�ƌ��݈ʒu
	ldx #0
loop_x_tako:
	; �������Ă��邩
	lda REG3
	and tako_alive_flag_current
	beq next_update_tako	; ���݂��Ă��Ȃ�
	
	; �R���Ă��Ȃ���
	lda tako00_status,x
	cmp #1
	beq next_update_tako	; �R���Ă���

	; ���݂��Ă���
	; �v���C����X�ƃ^�R��X�̑傫����
	sec
	lda window_player_x_low
	sbc tako0_window_pos_x,x
	bpl big_player_tako	; �v���C���̕����傫��
	; �^�R�̕����傫��
	sec
	lda tako0_window_pos_x,x
	sbc window_player_x_low
big_player_tako:
	sta REG0	; X����

	; �v���C����X�ƃ^�R��Y�̑傫����
	sec
	lda player_y
	sbc tako0_pos_y,x
	bpl big_player_y_tako	; �v���C���̕����傫��
	; �^�R�̕����傫��
	sec
	lda tako0_pos_y,x
	sbc player_y
big_player_y_tako:
	sta REG1	; y����

	lda #0
	sta char_collision_result
	
	sec
	lda REG0
	sbc #17
	bpl	next_update_tako	; ������16���傫��
	
	sec
	lda REG1
	sbc #17
	bpl	next_update_tako	; ������16���傫��

	lda #1
	sta char_collision_result
	jmp exit


next_update_tako:
	; ��
	asl tako_alive_flag_current
	inx
	cpx tako_max_count	; ���[�v�ő吔
	bne loop_x_tako		; ���[�v
	

	inc REG2			; ���ڂ̃^�R
	lda REG2
	cmp #2
	bne loop_tako_type
;exit:

	; �v���C����X���W�ƃ^�}�l�M��X���W��
	; �v���C����Y���W�ƃ^�}�l�M��Y���W��
	; ��r���āA�Ƃ��ɍ��������ȉ��Ȃ�
	; ���������B
	lda #1
	sta tamanegi_alive_flag_current	; �t���O�Q�ƌ��݈ʒu
	ldx #0
loop_x_tamanegi:
	; �������Ă��邩
	lda tamanegi_alive_flag
	and tamanegi_alive_flag_current
	beq next_update_tamanegi	; ���݂��Ă��Ȃ�
	
	; �R���Ă��Ȃ���
	lda tamanegi00_status,x
	cmp #3
	beq next_update_tamanegi	; �R���Ă���

	; ���݂��Ă���
	; �v���C����X�ƃ^�}�l�M��X�̑傫����
	sec
	lda window_player_x_low
	sbc tamanegi0_window_pos_x,x
	bpl big_player_tamanegi	; �v���C���̕����傫��
	; �^�}�l�M�̕����傫��
	sec
	lda tamanegi0_window_pos_x,x
	sbc window_player_x_low
big_player_tamanegi:
	sta REG0	; X����

	; �v���C����X�ƃ^�}�l�M��Y�̑傫����
	sec
	lda player_y
	sbc tamanegi0_pos_y,x
	bpl big_player_y_tamanegi	; �v���C���̕����傫��
	; �^�}�l�M�̕����傫��
	sec
	lda tamanegi0_pos_y,x
	sbc player_y
big_player_y_tamanegi:
	sta REG1	; y����

	lda #0
	sta char_collision_result
	
	sec
	lda REG0
	sbc #17
	bpl	next_update_tamanegi	; ������16���傫��
	
	sec
	lda REG1
	sbc #17
	bpl	next_update_tamanegi	; ������16���傫��

	lda #1
	sta char_collision_result
	jmp exit


next_update_tamanegi:
	; ��
	asl tamanegi_alive_flag_current
	inx
	cpx tamanegi_max_count	; ���[�v�ő吔
	bne loop_x_tamanegi				; ���[�v
	

exit:

	rts
.endproc


; �A�C�e���Ƃ̂����蔻��
.proc collision_item
	lda #0
	sta char_collision_result

	; �v���C����X���W�ƃA�C�e����X���W��
	; �v���C����Y���W�ƃA�C�e����Y���W��
	; ��r���āA�Ƃ��ɍ��������ȉ��Ȃ�
	; ���������B

	; �������Ă��邩
	lda item_alive_flag
	beq exit		; ���݂��Ă��Ȃ�
	
	; �ʏ��Ԃ�
	lda item_status
	bne exit		; �ʏ��Ԃł͂Ȃ�

	; ���݂��Ă���
	; �v���C����X�ƃA�C�e����X�̑傫����
	sec
	lda window_player_x_low
	sbc item_window_pos_x
	bpl big_player	; �v���C���̕����傫��
	; �A�C�e���̕����傫��
	sec
	lda item_window_pos_x
	sbc window_player_x_low
big_player:
	sta REG0	; X����

	; �v���C����Y�ƃA�C�e����Y�̑傫����
	sec
	lda player_y
	sbc item_pos_y
	bpl big_player_y	; �v���C���̕����傫��
	; �A�C�e���̕����傫��
	sec
	lda item_pos_y
	sbc player_y
big_player_y:
	sta REG1	; y����

	lda #0
	sta char_collision_result
	
	sec
	lda REG0
	sbc #17
	bpl	exit	; ������16���傫��
	
	sec
	lda REG1
	sbc #49
	bpl	exit	; ������48���傫��

	lda #1	; ��������
	sta char_collision_result
	inc item_count
	; ���������ꍇ�Ƃ肠�����\���ʒu���i�[����
	lda item_window_pos_x
	sta REG0
	lda item_pos_y
	sta REG1
	jsr String_Init
	jmp exit

exit:

	rts
.endproc	; collision_item

.proc Player_SetSpeed
	lda REG0
	sta player_spd_decimal
	lda REG1
	sta player_spd_low
	
	rts
.endproc	; Player_SetSpeed

; ���x�ω��X�V
.proc Player_UpdateSpeed
	; �ŏ��̒��n���̑��x�ω�
		; ���W��256+140����512�̊�
		; ���x��������
	; ���x�ύX�m�F(�ŏ��̒��n)
	lda player_speed_hi_or_low
	beq not_speed_change
	lda player_x_hi
	cmp #1
	bne not_speed_change
	sec
	lda player_x_low
	sbc #$60
	bcc not_speed_change	; �L�����[�t���O���N���A����Ă��鎞
	
	; ���x�ύX
	lda #$80
	sta REG0
	lda #0
	sta REG1
	jsr Player_SetSpeed
	lda #0	; ���x���Ƃ���
	sta player_speed_hi_or_low
	
	not_speed_change:

	; �A�C�e���擾�ɂ�鑬�x�ω�
		; �A�C�e��3�擾������
		; ���x���x���Ƃ�
	lda player_speed_hi_or_low
	bne skip_speedup	; ���x������(1)�̎��͏������Ȃ�
	lda item_count
	cmp #3
	bne skip_speedup
	lda #0
	sta REG0
	lda #1
	sta REG1
	jsr Player_SetSpeed
	lda #1
	sta str_speedup_state
	lda #1	; ���x�グ��
	sta player_speed_hi_or_low
	skip_speedup:
	
	rts
.endproc	; Player_UpdateSpeed
