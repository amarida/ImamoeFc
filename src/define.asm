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
bg_already_draw		EQU $2F	; BG�`��ςݕϐ��i�u���b�N�P�ʁj
field_scrool_x_up	EQU	$30	; �Q�[�����̃X�N���[���ʒu���
field_scrool_x_low	EQU	$31	; �Q�[�����̃X�N���[���ʒu����
player_x_up			EQU	$32	; �v���C���ʒuX���
window_player_x_up	EQU	$33	; �E�B���h�E���̈ʒu���
window_player_x_low	EQU	$34	; �E�B���h�E���̈ʒu����
window_player_x_low8	EQU	$35	; �E�B���h�E���̈ʒu-8����
map_chip_index_up	EQU $36	; �}�b�v�`�b�v�C���f�b�N�X���
map_chip_index_low	EQU $37	; �}�b�v�`�b�v�C���f�b�N�X����
map_chip_offset_cal16_up	EQU $38	; �}�b�v�`�b�v�I�t�Z�b�g
map_chip_offset_cal16_low	EQU $39	; �}�b�v�`�b�v�I�t�Z�b�g
map_chip_offset_cal8_up		EQU $3A	; �}�b�v�`�b�v�I�t�Z�b�g
map_chip_offset_cal8_low	EQU $3B	; �}�b�v�`�b�v�I�t�Z�b�g
map_chip_offset_cal2_up		EQU $3C	; �}�b�v�`�b�v�I�t�Z�b�g
map_chip_offset_cal2_low	EQU $3D	; �}�b�v�`�b�v�I�t�Z�b�g
map_chip_offset_cal_up		EQU $3E	; �}�b�v�`�b�v�I�t�Z�b�g
map_chip_offset_cal_low		EQU $3F	; �}�b�v�`�b�v�I�t�Z�b�g
map_chip_offset_up		EQU $40	; �}�b�v�`�b�v�I�t�Z�b�g
map_chip_offset_low		EQU $41	; �}�b�v�`�b�v�I�t�Z�b�g
map_chip_offset_start	EQU $42	; �}�b�v�`�b�v�I�t�Z�b�g
draw_bg_display			EQU	$43	; ��ʂP��ʂQ�i20��24���j
draw_index_y			EQU $44 ; �`�掞�̃C���f�b�N�X���W�X�g���̃e���v
field_scrool_x_up_tmp	EQU	$45	; �Q�[�����̃X�N���[���ʒu��ʃe���v
field_scrool_x_low_tmp	EQU	$46	; �Q�[�����̃X�N���[���ʒu���ʃe���v
loop_count				EQU $47	; ���[�v�J�E���g
vblank_count			EQU $48 ; VBlank�̃J�E���g
test_toggle_update		EQU $49 ; �e�X�g�g�O��
test_toggle_vblank		EQU $4A ; �e�X�g�g�O��
map_table_outside_screen_low	EQU $4B ; 
map_table_outside_screen_hi		EQU $4C ;
bg_already_draw_attribute	EQU $4D ; BG�����ݒ�ςݕϐ��i4�u���b�N�P�ʁj
map_table_attribute_low		EQU $4E ; 
map_table_attribute_hi		EQU $4F ;
offset_y_attribute		EQU $50	; �����e�[�u���I�t�Z�b�gY
attribute_pos_adress_up	EQU $51 ; �����e�[�u���̈ʒu�A�h���X���
attribute_pos_adress_low	EQU $52 ; �����e�[�u���̈ʒu�A�h���X����
current_draw_display_no	EQU $53 ; ���݂̕`���ʔԍ��i0 or 1�j
map_table_now_low			EQU $54 ; 
map_table_now_hi			EQU $55 ;
bg_already_draw_pos			EQU $56	; BG�`��ʒu�i�u���b�N�P�ʁj
bg_already_draw_attribute_pos	EQU $57 ; BG�����ݒ�ʒu�i4�u���b�N�P�ʁj

; �X�v���C�gDMA�p$0700�`$07ff
player1_y	EQU	$0700	; 
player1_t	EQU	$0701	; 
player1_s	EQU	$0702	; 
player1_x	EQU	$0703	; 
player2_y	EQU	$0704	; 
player2_t	EQU	$0705	; 
player2_s	EQU	$0706	; 
player2_x	EQU	$0707	; 
player3_y	EQU	$0708	; 
player3_t	EQU	$0709	; 
player3_s	EQU	$070A	; 
player3_x	EQU	$070B	; 
player4_y	EQU	$070C	; 
player4_t	EQU	$070D	; 
player4_s	EQU	$070E	; 
player4_x	EQU	$070F	; 
player5_y	EQU	$0710	; 
player5_t	EQU	$0711	; 
player5_s	EQU	$0712	; 
player5_x	EQU	$0713	; 
player6_y	EQU	$0714	; 
player6_t	EQU	$0715	; 
player6_s	EQU	$0716	; 
player6_x	EQU	$0717	; 
player7_y	EQU	$0718	; 
player7_t	EQU	$0719	; 
player7_s	EQU	$071A	; 
player7_x	EQU	$071B	; 
player8_y	EQU	$071C	; 
player8_t	EQU	$071D	; 
player8_s	EQU	$071E	; 
player8_x	EQU	$071F	; 
inosisi1_y	EQU	$0720	; 
inosisi1_t	EQU	$0721	; 
inosisi1_s	EQU	$0722	; ����
inosisi1_x	EQU	$0723	; 
inosisi2_y	EQU	$0724	; 
inosisi2_t	EQU	$0725	; 
inosisi2_s	EQU	$0726	; 
inosisi2_x	EQU	$0727	; 
inosisi3_y	EQU	$0728	; 
inosisi3_t	EQU	$0729	; 
inosisi3_s	EQU	$072A	; 
inosisi3_x	EQU	$072B	; 
inosisi4_y	EQU	$072C	; 
inosisi4_t	EQU	$072D	; 
inosisi4_s	EQU	$072E	; 
inosisi4_x	EQU	$072F	; 
inosisi5_y	EQU	$0730	; 
inosisi5_t	EQU	$0731	; 
inosisi5_s	EQU	$0732	; 
inosisi5_x	EQU	$0733	; 
inosisi6_y	EQU	$0734	; 
inosisi6_t	EQU	$0735	; 
inosisi6_s	EQU	$0736	; 
inosisi6_x	EQU	$0737	; 
inosisi7_y	EQU	$0738	; 
inosisi7_t	EQU	$0739	; 
inosisi7_s	EQU	$073A	; 
inosisi7_x	EQU	$073B	; 
inosisi8_y	EQU	$073C	; 
inosisi8_t	EQU	$073D	; 
inosisi8_s	EQU	$073E	; 
inosisi8_x	EQU	$073F	; 
