.include "macro.asm"

.proc	Button_Init
	lda #0
	sta item_world_pos_x_low
	sta item_world_pos_x_hi
	sta item_status
	sta item_pos_y
	sta button_alive_flag
	sta boss_room_status

	rts
.endproc

; �o��
.proc appear_button

	; �󂢂Ă��邩
	lda button_alive_flag
	beq set_item
	
;	jmp skip_appear

set_item:
	lda enemy_pos_x_hi
	sta item_world_pos_x_hi
	lda enemy_pos_x_low
	sta item_world_pos_x_low
	lda enemy_pos_y
	sta item_pos_y
	
	; �F�X������
	lda #0
	sta item_status
	
	; ����
	lda #%00000001	; �p���b�g2���g�p
	sta sw_index1_s
	sta sw_index2_s
	sta sw_index3_s
	sta sw_index4_s
	sta sw_index1_s2
	sta sw_index2_s2
	sta sw_index3_s2
	sta sw_index4_s2

	; �t���O�𗧂Ă�
	clc
	lda #1
	sta button_alive_flag

skip_appear:
	; �X�L�b�v
	rts
.endproc	; Button_Appear

; �{�^���N���A
.proc Button_Clear
	
	; �����t���O�̊m�F
	lda button_alive_flag
	bne not_skip_clear		; ���݂��Ă���
	jmp skip_clear
	not_skip_clear:

	lda #0

	lda #0
	sta item_world_pos_x_low
	sta item_world_pos_x_hi
	sta item_pos_y
	
	; �����t���O�𗎂Ƃ�
	lda #0
	sta button_alive_flag

skip_clear:

	rts
.endproc ; Button_Clear

; �X�V
.proc	Button_Update
	lda is_dead
	bne skip_item

	; ���Ȃ�
	lda button_alive_flag
	beq skip_item

	; ���݂��Ă���

	lda item_status
	cmp #0
	beq case_update_normal
	cmp #1
	beq case_update_push
	
case_update_normal:
	jsr Button_UpdateNormal
	jmp break
case_update_push:
	jsr Button_UpdatePush
	jmp break
	
break:

	; ��ʊO����
	sec
	lda field_scroll_x_hi
	sbc item_world_pos_x_hi
	bcc skip_dead
	sec
	lda field_scroll_x_low
	sbc item_world_pos_x_low
	bcc skip_dead
	; ��ʊO����
	jsr Button_Clear


skip_dead:

skip_item:
	rts
.endproc	; Button_Update

; �ʏ�X�V
.proc	Button_UpdateNormal

	rts
.endproc	; Button_UpdateNormal

; �j���X�V
.proc	Button_UpdatePush
	
	rts
.endproc	; Button_UpdatePush

; �`��
.proc	Button_DrawDma7

	; ���Ȃ�
	lda button_alive_flag
	bne not_skip_draw
	jmp skip_draw
not_skip_draw:

	lda item_status
	cmp #0
	beq case_normal
	cmp #1
	beq case_push

case_normal:
	; �ʏ�^�C��
	lda #$7D
	sta sw_index1_t
	lda #$7E
	sta sw_index2_t
	lda #$8D
	sta sw_index3_t
	lda #$8E
	sta sw_index4_t	

	jmp tile_exit

case_push:
	; �������^�C��
	lda #$00
	sta sw_index1_t
	lda #$00
	sta sw_index2_t
	lda #$6D
	sta sw_index3_t
	lda #$6E
	sta sw_index4_t	

	jmp tile_exit


tile_exit:

; Y���W
	clc			; �L�����[�t���OOFF
	lda item_pos_y
	sta sw_index1_y
	sta sw_index2_y

	adc #8
	sta sw_index3_y
	sta sw_index4_y

; X���W

	; ���݂��Ă���΁A���[���h���W����E�B���h�E���W�ɕϊ�
	sec
	lda item_world_pos_x_low
	sbc field_scroll_x_low
	sta item_window_pos_x

	lda item_window_pos_x
	sta sw_index1_x
	sta sw_index3_x

	lda item_window_pos_x
	clc
	adc #8
	bcc not_overflow_8
	lda #231	; ��ʊO
	sta sw_index2_y
	sta sw_index4_y
not_overflow_8:
	sta sw_index2_x
	sta sw_index4_x

skip_draw:

	rts

.endproc	; Button_DrawDma7

; �`��
.proc	Button_DrawDma6
	; ���Ȃ�
	lda button_alive_flag
	bne not_skip_draw
	jmp skip_draw
not_skip_draw:


	lda item_status
	cmp #0
	beq case_normal
	cmp #1
	beq case_push

case_normal:
	; �ʏ�^�C��
	lda #$7D
	sta sw_index1_t2
	lda #$7E
	sta sw_index2_t2
	lda #$8D
	sta sw_index3_t2
	lda #$8E
	sta sw_index4_t2

	jmp tile_exit

case_push:
	; �������^�C��
	lda #$00
	sta sw_index1_t2
	lda #$00
	sta sw_index2_t2
	lda #$6D
	sta sw_index3_t2
	lda #$6E
	sta sw_index4_t2

	jmp tile_exit

tile_exit:	

; Y���W
	clc			; �L�����[�t���OOFF
	lda item_pos_y
	sta sw_index1_y2
	sta sw_index2_y2

	adc #8
	sta sw_index3_y2
	sta sw_index4_y2

; X���W

	; ���݂��Ă���΁A���[���h���W����E�B���h�E���W�ɕϊ�
	sec
	lda item_world_pos_x_low
	sbc field_scroll_x_low
	sta item_window_pos_x

	lda item_window_pos_x
	sta sw_index1_x2
	sta sw_index3_x2

	lda item_window_pos_x
	clc
	adc #8
	bcc not_overflow_8
	lda #231	; ��ʊO
	sta sw_index2_y2
	sta sw_index4_y2
not_overflow_8:
	sta sw_index2_x2
	sta sw_index4_x2

skip_draw:

	rts

.endproc	; Button_DrawDma6

.proc Button_Action
	lda #1
	sta item_status
	; �{�X��ړ�
	lda #3
	sta boss_status
	; �{�X����
	lda #5 ; scene_maingame��scene_update_step
	sta scene_update_step
	; ����
	lda #1
	sta boss_room_status
	lda #0
	sta boss_room_status_wait

	rts
.endproc	; Button_GetAction