.define EQU	=
REG0		EQU	$00	; �ėp0
REG1		EQU	$01	; �ėp1
REG2		EQU	$02	; �ėp2
REG3		EQU	$03	; �ėp3
REG4		EQU	$04	; �ėp4
REG5		EQU	$05	; �ėp5
REG6		EQU	$06	; �ėp6
scrool_x	EQU	$07	; $00��scrool_x�Ƃ��Ďg��
scrool_y	EQU	$08	; $01��scrool_y�Ƃ��Ďg��
loop_x		EQU	$09
loop_y		EQU	$0A
pos			EQU	$0B
len			EQU	$0C
diff				EQU	$0D
count_y				EQU	$0E
player_x_low		EQU	$0F	; �v���C���ʒuX�i���ʁj
player_x_decimal	EQU	$10	; �v���C���ʒuX�i�������j
player_y			EQU	$11	; �v���C���ʒuY�i+1�͏������j
screen_x			EQU	$13	; �X�N���[���ʒu
spd_y				EQU	$14	; Y�������x�i+1�͏������j
spd_vec				EQU	$16	; ���x�����i0�v���X�A1�}�C�i�X�j
is_jump				EQU	$17
p_pat				EQU $18 ; �v���C���`��p�^�[��
pat_change_frame	EQU	$19
chr_lr				EQU $1A	; �L�����N�^���E�t���O
inosisi_x			EQU $1B	; �C�m�V�V�ʒuX
inosisi_y			EQU $1C	; �C�m�V�V�ʒuY
FIELD_HEIGHT		EQU	$1D	; �n�ʂ̍���
multiplicand		EQU $1E	; ��搔�i�������鐔�j
multiplier			EQU $20	; �搔�i�����鐔�j
multi_ans_up		EQU $21	; ��Z���ʁ@��ʃr�b�g
multi_ans_low		EQU $22	; ��Z���ʁ@���ʃr�b�g
multi_loop_cnt		EQU $23	; ��Z�p���[�v�J�E���^
conv_coord_bit_x	EQU $24	; X���W
conv_coord_bit_y	EQU $25	; Y���W
conv_coord_bit_up	EQU $26	; ��ʃr�b�g
conv_coord_bit_low	EQU $27	; ���ʃr�b�g
draw_bg_tile		EQU $28 ; �^�C���ԍ�
draw_bg_x			EQU $29 ; X���W
draw_bg_y			EQU $2A ; Y���W
draw_bg_w			EQU $2B ; ���u���b�N��
draw_bg_h			EQU $2C ; �c�u���b�N��
draw_loop_x			EQU $2D ; ���[�v�ϐ�
draw_loop_y			EQU $2E ; ���[�v�ϐ�
bg_already_draw		EQU $2F	; BG�`��ςݕϐ�
field_scrool_x_up	EQU	$30	; �Q�[�����̃X�N���[���ʒu���
field_scrool_x_low	EQU	$31	; �Q�[�����̃X�N���[���ʒu����
player_x_up			EQU	$32	; �v���C���ʒuX���
window_player_x_up	EQU	$33	; �E�B���h�E���̈ʒu���
window_player_x_low	EQU	$34	; �E�B���h�E���̈ʒu����
window_player_x_low8	EQU	$35	; �E�B���h�E���̈ʒu-8����
map_chip_index_up	EQU $36	; �}�b�v�`�b�v�C���f�b�N�X���
map_chip_index_low	EQU $37	; �}�b�v�`�b�v�C���f�b�N�X����
map_chip_offset16_up	EQU $38	; �}�b�v�`�b�v�I�t�Z�b�g
map_chip_offset16_low	EQU $39	; �}�b�v�`�b�v�I�t�Z�b�g
map_chip_offset3_up	EQU $3A	; �}�b�v�`�b�v�I�t�Z�b�g
map_chip_offset3_low	EQU $3B	; �}�b�v�`�b�v�I�t�Z�b�g
map_chip_offset_up	EQU $3C	; �}�b�v�`�b�v�I�t�Z�b�g
map_chip_offset_low	EQU $3D	; �}�b�v�`�b�v�I�t�Z�b�g
map_chip_offset_start	EQU $3E	; �}�b�v�`�b�v�I�t�Z�b�g
draw_bg_display		EQU	$3F	; ��ʂP��ʂQ�i20��24���j
