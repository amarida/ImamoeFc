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
	sta char_12_type01_s
	sta char_12_type08_s
	sta char_12_type09_s
	lda #%00000011
	sta char_12_type02_s
	sta char_12_type03_s
	sta char_12_type04_s
	sta char_12_type05_s
	sta char_12_type06_s
	sta char_12_type07_s
	sta char_12_type10_s
	sta char_12_type11_s

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
	lda player_x_hi
	sbc #0
	sta habatan_world_pos_x_hi

	lda #100
	sta habatan_pos_y

	; �p���b�g4���͂΃^��
	lda #3
	sta palette_change_state

	; �����͕ς��Ȃ�
	lda #%00000000     ; 0(10�i��)��A�Ƀ��[�h
	sta char_12_type01_s
	sta char_12_type08_s
	sta char_12_type09_s
	sta char_12_type01_s2
	sta char_12_type08_s2
	sta char_12_type09_s2
	lda #%00000011
	sta char_12_type02_s
	sta char_12_type03_s
	sta char_12_type04_s
	sta char_12_type05_s
	sta char_12_type06_s
	sta char_12_type07_s
	sta char_12_type10_s
	sta char_12_type11_s
	sta char_12_type02_s2
	sta char_12_type03_s2
	sta char_12_type04_s2
	sta char_12_type05_s2
	sta char_12_type06_s2
	sta char_12_type07_s2
	sta char_12_type10_s2
	sta char_12_type11_s2

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
	sta char_12_type01_y
	sta char_12_type01_t
	sta char_12_type01_s
	sta char_12_type01_x
	sta char_12_type02_y
	sta char_12_type02_t
	sta char_12_type02_s
	sta char_12_type02_x
	sta char_12_type03_y
	sta char_12_type03_t
	sta char_12_type03_s
	sta char_12_type03_x
	sta char_12_type04_y
	sta char_12_type04_t
	sta char_12_type04_s
	sta char_12_type04_x
	sta char_12_type05_y
	sta char_12_type05_t
	sta char_12_type05_s
	sta char_12_type05_x
	sta char_12_type06_y
	sta char_12_type06_t
	sta char_12_type06_s
	sta char_12_type06_x
	sta char_12_type07_y
	sta char_12_type07_t
	sta char_12_type07_s
	sta char_12_type07_x
	sta char_12_type08_y
	sta char_12_type08_t
	sta char_12_type08_s
	sta char_12_type08_x
	sta char_12_type09_y
	sta char_12_type09_t
	sta char_12_type09_s
	sta char_12_type09_x
	sta char_12_type10_y
	sta char_12_type10_t
	sta char_12_type10_s
	sta char_12_type10_x
	sta char_12_type11_y
	sta char_12_type11_t
	sta char_12_type11_s
	sta char_12_type11_x
	sta char_12_type01_y2
	sta char_12_type01_t2
	sta char_12_type01_s2
	sta char_12_type01_x2
	sta char_12_type02_y2
	sta char_12_type02_t2
	sta char_12_type02_s2
	sta char_12_type02_x2
	sta char_12_type03_y2
	sta char_12_type03_t2
	sta char_12_type03_s2
	sta char_12_type03_x2
	sta char_12_type04_y2
	sta char_12_type04_t2
	sta char_12_type04_s2
	sta char_12_type04_x2
	sta char_12_type05_y2
	sta char_12_type05_t2
	sta char_12_type05_s2
	sta char_12_type05_x2
	sta char_12_type06_y2
	sta char_12_type06_t2
	sta char_12_type06_s2
	sta char_12_type06_x2
	sta char_12_type07_y2
	sta char_12_type07_t2
	sta char_12_type07_s2
	sta char_12_type07_x2
	sta char_12_type08_y2
	sta char_12_type08_t2
	sta char_12_type08_s2
	sta char_12_type08_x2
	sta char_12_type09_y2
	sta char_12_type09_t2
	sta char_12_type09_s2
	sta char_12_type09_x2
	sta char_12_type10_y2
	sta char_12_type10_t2
	sta char_12_type10_s2
	sta char_12_type10_x2
	sta char_12_type11_y2
	sta char_12_type11_t2
	sta char_12_type11_s2
	sta char_12_type11_x2

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
	lda field_scroll_x_hi
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
	adc #2
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
	sta habatan_wait_low
	lda #1
	sta habatan_wait_hi
	
	next_skip:

	rts
.endproc	; Habatan_UpdateApproach

; �ʏ�X�V
.proc	Habatan_UpdateNormal

	; �v���C���ɒǏ]
	lda player_x_hi
	sta habatan_world_pos_x_hi
	lda player_x_low
	sta habatan_world_pos_x_low
	
	sec
	lda player_y
	sbc #24
	sta habatan_pos_y
	
	dec habatan_wait_low
	lda habatan_wait_low
	bne next_skip

	lda habatan_wait_hi
	beq next

	dec habatan_wait_hi
	lda #255
	sta habatan_wait_low
	jmp next_skip
	
	next:
	lda #2
	sta habatan_status
	next_skip:

	rts
.endproc	; Habatan_UpdateNormal

; �ޏ�X�V
.proc	Habatan_UpdateLeave

	jsr Habatan_Clear
	jsr HabatanFire_Clear
	
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
	sta char_12_type01_t
	clc
	lda #$43
	adc REG0
	sta char_12_type02_t
	clc
	lda #$44
	adc REG0
	sta char_12_type03_t
	; 2���
	clc
	lda #$51
	adc REG0
	sta char_12_type04_t
	clc
	lda #$52
	adc REG0
	sta char_12_type05_t
	clc
	lda #$53
	adc REG0
	sta char_12_type06_t
	clc
	lda #$54
	adc REG0
	sta char_12_type07_t
	; 3���
	clc
	lda #$60
	adc REG0
	sta char_12_type08_t
	clc
	lda #$61
	adc REG0
	sta char_12_type09_t
	clc
	lda #$62
	adc REG0
	sta char_12_type10_t
	clc
	lda #$63
	adc REG0
	sta char_12_type11_t

; Y���W
	; 1���
	clc			; �L�����[�t���OOFF
	lda habatan_pos_y
	adc #7
	sta char_12_type01_y
	sta char_12_type02_y
	sta char_12_type03_y
	
	; 2���
	clc			; �L�����[�t���OOFF
	lda habatan_pos_y
	adc #15
	sta char_12_type04_y
	sta char_12_type05_y
	sta char_12_type06_y
	sta char_12_type07_y
	
	; 3���
	clc			; �L�����[�t���OOFF
	lda habatan_pos_y
	adc #23
	sta char_12_type08_y
	sta char_12_type09_y
	sta char_12_type10_y
	sta char_12_type11_y
	

; X���W
	; xx123
	; x4567
	; 8901x

	; ���݂��Ă���΁A���[���h���W����E�B���h�E���W�ɕϊ�
	sec
	lda habatan_world_pos_x_low
	sbc field_scroll_x_low
	sta habatan_window_pos_x

	lda habatan_window_pos_x
	sta char_12_type08_x

	lda habatan_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #8
	sta char_12_type04_x
	sta char_12_type09_x

	lda habatan_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #16
	sta char_12_type01_x
	sta char_12_type05_x
	sta char_12_type10_x

	lda habatan_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #24
	sta char_12_type02_x
	sta char_12_type06_x
	sta char_12_type11_x

	lda habatan_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #32
	sta char_12_type03_x
	sta char_12_type07_x

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
	sta char_12_type01_t2
	clc
	lda #$43
	adc REG0
	sta char_12_type02_t2
	clc
	lda #$44
	adc REG0
	sta char_12_type03_t2
	; 2���
	clc
	lda #$51
	adc REG0
	sta char_12_type04_t2
	clc
	lda #$52
	adc REG0
	sta char_12_type05_t2
	clc
	lda #$53
	adc REG0
	sta char_12_type06_t2
	clc
	lda #$54
	adc REG0
	sta char_12_type07_t2
	; 3���
	clc
	lda #$60
	adc REG0
	sta char_12_type08_t2
	clc
	lda #$61
	adc REG0
	sta char_12_type09_t2
	clc
	lda #$62
	adc REG0
	sta char_12_type10_t2
	clc
	lda #$63
	adc REG0
	sta char_12_type11_t2

; Y���W
	; 1���
	clc			; �L�����[�t���OOFF
	lda habatan_pos_y
	adc #7
	sta char_12_type01_y2
	sta char_12_type02_y2
	sta char_12_type03_y2
	
	; 2���
	clc			; �L�����[�t���OOFF
	lda habatan_pos_y
	adc #15
	sta char_12_type04_y2
	sta char_12_type05_y2
	sta char_12_type06_y2
	sta char_12_type07_y2
	
	; 3���
	clc			; �L�����[�t���OOFF
	lda habatan_pos_y
	adc #23
	sta char_12_type08_y2
	sta char_12_type09_y2
	sta char_12_type10_y2
	sta char_12_type11_y2
	

; X���W
	; xx123
	; x4567
	; 8901x

	; ���݂��Ă���΁A���[���h���W����E�B���h�E���W�ɕϊ�
	sec
	lda habatan_world_pos_x_low
	sbc field_scroll_x_low
	sta habatan_window_pos_x

	lda habatan_window_pos_x
	sta char_12_type08_x2

	lda habatan_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #8
	sta char_12_type04_x2
	sta char_12_type09_x2

	lda habatan_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #16
	sta char_12_type01_x2
	sta char_12_type05_x2
	sta char_12_type10_x2

	lda habatan_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #24
	sta char_12_type02_x2
	sta char_12_type06_x2
	sta char_12_type11_x2

	lda habatan_window_pos_x
	clc			; �L�����[�t���OOFF
	adc #32
	sta char_12_type03_x2
	sta char_12_type07_x2

skip_draw:

	rts

.endproc	; HabatanDrawDma6

