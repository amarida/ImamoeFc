.proc	Habatan_Init
	lda #0
	sta habatan_alive_flag
	sta habatan_world_pos_x_low
	sta habatan_world_pos_x_hi
	sta habatan_pos_y
	sta habatan_window_pos_x
	sta habatan_status
	; �����͕ς��Ȃ�
	lda #%00000000     ; 0(10�i��)��A�Ƀ��[�h
	sta habatan01_s
	sta habatan08_s
	sta habatan09_s
	lda #%00000011
	sta habatan02_s
	sta habatan03_s
	sta habatan04_s
	sta habatan05_s
	sta habatan06_s
	sta habatan07_s
	sta habatan10_s
	sta habatan11_s
	sta habatan12_s

	rts
.endproc

; �o��
.proc appear_habatan

	; �󂢂Ă��邩
	lda habatan_alive_flag
	beq set_habatan
	; �����܂ŗ�����󂫂͂Ȃ��̂ŃX�L�b�v
	jmp skip_habatan

set_habatan:
	
	; �F�X������
	lda #0
	sta habatan_status

	; �����\���ʒu
	sec
	lda player_x_low
	sbc #124
	sta habatan_world_pos_x_low
	lda player_x_up
	sbc #0
	sta habatan_world_pos_x_hi

	lda #100
	sta habatan_pos_y

	; �p���b�g4���͂΃^��
	lda #3
	sta palette_change_state

	; �����͕ς��Ȃ�
	lda #%00000000     ; 0(10�i��)��A�Ƀ��[�h
	sta habatan01_s
	sta habatan08_s
	sta habatan09_s
	sta habatan01_s2
	sta habatan08_s2
	sta habatan09_s2
	lda #%00000011
	sta habatan02_s
	sta habatan03_s
	sta habatan04_s
	sta habatan05_s
	sta habatan06_s
	sta habatan07_s
	sta habatan10_s
	sta habatan11_s
	sta habatan12_s
	sta habatan02_s2
	sta habatan03_s2
	sta habatan04_s2
	sta habatan05_s2
	sta habatan06_s2
	sta habatan07_s2
	sta habatan10_s2
	sta habatan11_s2
	sta habatan12_s2

	; �t���O�𗧂Ă�
	lda #1
	sta habatan_alive_flag

skip_habatan:
	; �X�L�b�v
	rts
.endproc	; appear_habatan

; �͂΃^���N���A
.proc Habatan_Clear

	; �����t���O�̊m�F
	lda habatan_alive_flag
	bne not_skip_clear		; ���݂��Ă���
	jmp skip_clear
	not_skip_clear:

	lda #0
	sta habatan01_y
	sta habatan01_t
	sta habatan01_s
	sta habatan01_x
	sta habatan02_y
	sta habatan02_t
	sta habatan02_s
	sta habatan02_x
	sta habatan03_y
	sta habatan03_t
	sta habatan03_s
	sta habatan03_x
	sta habatan04_y
	sta habatan04_t
	sta habatan04_s
	sta habatan04_x
	sta habatan05_y
	sta habatan05_t
	sta habatan05_s
	sta habatan05_x
	sta habatan06_y
	sta habatan06_t
	sta habatan06_s
	sta habatan06_x
	sta habatan07_y
	sta habatan07_t
	sta habatan07_s
	sta habatan07_x
	sta habatan08_y
	sta habatan08_t
	sta habatan08_s
	sta habatan08_x
	sta habatan09_y
	sta habatan09_t
	sta habatan09_s
	sta habatan09_x
	sta habatan10_y
	sta habatan10_t
	sta habatan10_s
	sta habatan10_x
	sta habatan11_y
	sta habatan11_t
	sta habatan11_s
	sta habatan11_x
	sta habatan12_y
	sta habatan12_t
	sta habatan12_s
	sta habatan12_x
	sta habatan01_y2
	sta habatan01_t2
	sta habatan01_s2
	sta habatan01_x2
	sta habatan02_y2
	sta habatan02_t2
	sta habatan02_s2
	sta habatan02_x2
	sta habatan03_y2
	sta habatan03_t2
	sta habatan03_s2
	sta habatan03_x2
	sta habatan04_y2
	sta habatan04_t2
	sta habatan04_s2
	sta habatan04_x2
	sta habatan05_y2
	sta habatan05_t2
	sta habatan05_s2
	sta habatan05_x2
	sta habatan06_y2
	sta habatan06_t2
	sta habatan06_s2
	sta habatan06_x2
	sta habatan07_y2
	sta habatan07_t2
	sta habatan07_s2
	sta habatan07_x2
	sta habatan08_y2
	sta habatan08_t2
	sta habatan08_s2
	sta habatan08_x2
	sta habatan09_y2
	sta habatan09_t2
	sta habatan09_s2
	sta habatan09_x2
	sta habatan10_y2
	sta habatan10_t2
	sta habatan10_s2
	sta habatan10_x2
	sta habatan11_y2
	sta habatan11_t2
	sta habatan11_s2
	sta habatan11_x2
	sta habatan12_y2
	sta habatan12_t2
	sta habatan12_s2
	sta habatan12_x2

	lda #0
	sta habatan_world_pos_x_low
	sta habatan_world_pos_x_hi
	sta habatan_pos_y
	
	; �����t���O�𗎂Ƃ�
	lda #0
	sta habatan_alive_flag

skip_clear:

	rts
.endproc ; Habatan_Clear

; �X�V
.proc	HabatanUpdate
	lda is_dead
	bne skip_update

	; ���Ȃ�
	lda habatan_alive_flag
	beq skip_update

	; ���݂��Ă���
	
	lda habatan_status
	cmp #0
	beq case_approach
	cmp #1
	beq case_normal
	cmp #2
	beq case_leave
	
case_approach:
	jsr Habatan_UpdateApproach
	jmp break
	
case_normal:
	jsr Habatan_UpdateNormal
	jmp break
	
case_leave:
	jsr Habatan_UpdateLeave
	jmp break

break:


	; ��ʊO����
	sec
	lda field_scroll_x_up
	sbc habatan_world_pos_x_hi
	bcc skip_dead
	sec
	lda field_scroll_x_low
	sbc habatan_world_pos_x_low
	bcc skip_dead

	; ��ʊO����
	jsr Habatan_Clear

skip_dead:

skip_update:
	rts
.endproc	; Habatan_Clear

; �߂Â��X�V
.proc Habatan_UpdateApproach

	; �E�ړ�
	clc
	lda habatan_world_pos_x_low
	adc #1
	sta habatan_world_pos_x_low
	lda habatan_world_pos_x_hi
	adc #0
	sta habatan_world_pos_x_hi
	
	sec
	lda window_player_x_low
	sbc habatan_window_pos_x
	bcs next_skip	; �L�����[�t���O���Z�b�g����Ă���ꍇ�X�L�b�v

	lda #1
	sta habatan_status
	lda #255
	sta habatan_wait
	
	next_skip:

	rts
.endproc	; Habatan_UpdateApproach

; �ʏ�X�V
.proc	Habatan_UpdateNormal

	; �v���C���ɒǏ]
	lda player_x_up
	sta habatan_world_pos_x_hi
	lda player_x_low
	sta habatan_world_pos_x_low
	
	sec
	lda player_y
	sbc #32
	sta habatan_pos_y
	
	dec habatan_wait
	lda habatan_wait
	bne next_skip
	
	lda #2
	sta habatan_status
	next_skip:

	rts
.endproc	; Habatan_UpdateNormal

; �ޏ�X�V
.proc	Habatan_UpdateLeave

	jsr Habatan_Clear
	
	rts
.endproc	; Habatan_UpdateLeave

; �`��
.proc	HabatanDrawDma7

	; ���Ȃ�
	lda habatan_alive_flag
	bne not_skip_draw
	jmp skip_draw
not_skip_draw:

	; �A�j���p�^�[��
	;REG0 = (p_pat == 0) ? #$00 : #$05;

	lda p_pat
	beq set_pat0
	bne set_pat1
	
set_pat0:
	lda #$00
	sta REG0
	jmp break_pat
set_pat1:
	lda #$05
	sta REG0
	jmp break_pat
	
break_pat:

; �����^�C��
	; 1���
	clc
	lda #$42
	adc REG0
	sta habatan01_t
	clc
	lda #$43
	adc REG0
	sta habatan02_t
	clc
	lda #$44
	adc REG0
	sta habatan03_t
	; 2���
	clc
	lda #$51
	adc REG0
	sta habatan04_t
	clc
	lda #$52
	adc REG0
	sta habatan05_t
	clc
	lda #$53
	adc REG0
	sta habatan06_t
	clc
	lda #$54
	adc REG0
	sta habatan07_t
	; 3���
	clc
	lda #$60
	adc REG0
	sta habatan08_t
	clc
	lda #$61
	adc REG0
	sta habatan09_t
	clc
	lda #$62
	adc REG0
	sta habatan10_t
	clc
	lda #$63
	adc REG0
	sta habatan11_t
	clc
	lda #$64
	adc REG0
	sta habatan12_t

; Y���W
	; 1���
	clc			; �L�����[�t���OOFF
	lda habatan_pos_y
	adc #7
	sta habatan01_y
	sta habatan02_y
	sta habatan03_y
	
	; 2���
	clc			; �L�����[�t���OOFF
	lda habatan_pos_y
	adc #15
	sta habatan04_y
	sta habatan05_y
	sta habatan06_y
	sta habatan07_y
	
	; 3���
	clc			; �L�����[�t���OOFF
	lda habatan_pos_y
	adc #23
	sta habatan08_y
	sta habatan09_y
	sta habatan10_y
	sta habatan11_y
	sta habatan12_y
	

; X���W
	; xx123
	; x4567
	; 89012

	; ���݂��Ă���΁A���[���h���W����E�B���h�E���W�ɕϊ�
	sec
	lda habatan_world_pos_x_low
	sbc field_scroll_x_low
	sta habatan_window_pos_x

	lda habatan_window_pos_x
	sta habatan08_x

	lda habatan_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #8
	sta habatan04_x
	sta habatan09_x

	lda habatan_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #16
	sta habatan01_x
	sta habatan05_x
	sta habatan10_x

	lda habatan_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #24
	sta habatan02_x
	sta habatan06_x
	sta habatan11_x

	lda habatan_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #32
	sta habatan03_x
	sta habatan07_x
	sta habatan12_x

skip_draw:

	rts

.endproc	; HabatanDrawDma7

; �`��
.proc	HabatanDrawDma6

	; ���Ȃ�
	lda habatan_alive_flag
	bne not_skip_draw
	jmp skip_draw
not_skip_draw:

	; �A�j���p�^�[��
	;REG0 = (p_pat == 0) ? #$00 : #$05;

	lda p_pat
	beq set_pat0
	bne set_pat1
	
set_pat0:
	lda #$00
	sta REG0
	jmp break_pat
set_pat1:
	lda #$05
	sta REG0
	jmp break_pat
	
break_pat:

; �����^�C��
	; 1���
	clc
	lda #$42
	adc REG0
	sta habatan01_t2
	clc
	lda #$43
	adc REG0
	sta habatan02_t2
	clc
	lda #$44
	adc REG0
	sta habatan03_t2
	; 2���
	clc
	lda #$51
	adc REG0
	sta habatan04_t2
	clc
	lda #$52
	adc REG0
	sta habatan05_t2
	clc
	lda #$53
	adc REG0
	sta habatan06_t2
	clc
	lda #$54
	adc REG0
	sta habatan07_t2
	; 3���
	clc
	lda #$60
	adc REG0
	sta habatan08_t2
	clc
	lda #$61
	adc REG0
	sta habatan09_t2
	clc
	lda #$62
	adc REG0
	sta habatan10_t2
	clc
	lda #$63
	adc REG0
	sta habatan11_t2
	clc
	lda #$64
	adc REG0
	sta habatan12_t2

; Y���W
	; 1���
	clc			; �L�����[�t���OOFF
	lda habatan_pos_y
	adc #7
	sta habatan01_y2
	sta habatan02_y2
	sta habatan03_y2
	
	; 2���
	clc			; �L�����[�t���OOFF
	lda habatan_pos_y
	adc #15
	sta habatan04_y2
	sta habatan05_y2
	sta habatan06_y2
	sta habatan07_y2
	
	; 3���
	clc			; �L�����[�t���OOFF
	lda habatan_pos_y
	adc #23
	sta habatan08_y2
	sta habatan09_y2
	sta habatan10_y2
	sta habatan11_y2
	sta habatan12_y2
	

; X���W
	; xx123
	; x4567
	; 89012

	; ���݂��Ă���΁A���[���h���W����E�B���h�E���W�ɕϊ�
	sec
	lda habatan_world_pos_x_low
	sbc field_scroll_x_low
	sta habatan_window_pos_x

	lda habatan_window_pos_x
	sta habatan08_x2

	lda habatan_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #8
	sta habatan04_x2
	sta habatan09_x2

	lda habatan_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #16
	sta habatan01_x2
	sta habatan05_x2
	sta habatan10_x2

	lda habatan_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #24
	sta habatan02_x2
	sta habatan06_x2
	sta habatan11_x2

	lda habatan_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #32
	sta habatan03_x2
	sta habatan07_x2
	sta habatan12_x2

skip_draw:

	rts

.endproc	; HabatanDrawDma6

