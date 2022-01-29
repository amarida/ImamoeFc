; スプライトDMA用$0700～$07ff
.org $0700
spriteZero_y:		.byte 0
spriteZero_t:		.byte 0
spriteZero_s:		.byte 0
spriteZero_x:		.byte 0

playerFuki1_y: .byte 0
playerFuki1_t: .byte 0
playerFuki1_s: .byte 0
playerFuki1_x: .byte 0
playerFuki2_y: .byte 0
playerFuki2_t: .byte 0
playerFuki2_s: .byte 0
playerFuki2_x: .byte 0

char4_p1_index1_y:	.byte 0;	=	$070C	; 
char4_p1_index1_t:	.byte 0
char4_p1_index1_s:	.byte 0
char4_p1_index1_x:	.byte 0
char4_p1_index2_y:	.byte 0;    =	$0710	; 
char4_p1_index2_t:	.byte 0
char4_p1_index2_s:	.byte 0
char4_p1_index2_x:	.byte 0
char4_p1_index3_y:	.byte 0
char4_p1_index3_t:	.byte 0
char4_p1_index3_s:	.byte 0
char4_p1_index3_x:	.byte 0
char4_p1_index4_y:	.byte 0
char4_p1_index4_t:	.byte 0
char4_p1_index4_s:	.byte 0
char4_p1_index4_x:	.byte 0

char4_p2_index1_y:	.byte 0
char4_p2_index1_t:	.byte 0
char4_p2_index1_s:	.byte 0
char4_p2_index1_x:	.byte 0
char4_p2_index2_y:	.byte 0;     =	$0720	; 
char4_p2_index2_t:	.byte 0
char4_p2_index2_s:	.byte 0
char4_p2_index2_x:	.byte 0
char4_p2_index3_y:	.byte 0
char4_p2_index3_t:	.byte 0
char4_p2_index3_s:	.byte 0
char4_p2_index3_x:	.byte 0
char4_p2_index4_y:	.byte 0
char4_p2_index4_t:	.byte 0
char4_p2_index4_s:	.byte 0
char4_p2_index4_x:	.byte 0;     = $072B

; ↑ここまで11 4バイト目 ↓ここから12 4バイト目

char_6type1_y:	.byte 0;	=	$074C	; 
char_6type1_t:	.byte 0;	=	
char_6type1_s:	.byte 0;	=	$0722	; 属性
char_6type1_x:	.byte 0;	=	$0723	; 
char_6type2_y:	.byte 0; 0730;	=	$0724	; 
char_6type2_t:	.byte 0;	=	$0725	; 
char_6type2_s:	.byte 0;	=	$0726	; 
char_6type2_x:	.byte 0;	=	$0727	; 
char_6type3_y:	.byte 0;	=	$0728	; 
char_6type3_t:	.byte 0;	=	$0729	; 
char_6type3_s:	.byte 0;	=	$072A	; 
char_6type3_x:	.byte 0;	=	$072B	; 
char_6type4_y:	.byte 0;	=	$072C	; 
char_6type4_t:	.byte 0;	=	$072D	; 
char_6type4_s:	.byte 0;	=	$072E	; 
char_6type4_x:	.byte 0;	=	$072F	; 
char_6type5_y:	.byte 0;	=	$0730	; 
char_6type5_t:	.byte 0;	=	$0731	; 
char_6type5_s:	.byte 0;	=	$0732	; 
char_6type5_x:	.byte 0;	=	$0733	; 
char_6type6_y:	.byte 0; 0740;	=	$0734	; 
char_6type6_t:	.byte 0;	=	$0735	; 
char_6type6_s:	.byte 0;	=	$0736	; 
char_6type6_x:	.byte 0;	=	$0737	; 

char_6type21_y:	.byte 0;	=	$0740
char_6type21_t:	.byte 0;	=	$0741	; 
char_6type21_s:	.byte 0;	=	$0742	; 属性
char_6type21_x:	.byte 0;	=	$0743	; 
char_6type22_y:	.byte 0;	=	$0744	; 
char_6type22_t:	.byte 0;	=	$0745	; 
char_6type22_s:	.byte 0;	=	$0746	; 
char_6type22_x:	.byte 0;	=	$0747	; 
char_6type23_y:	.byte 0;	=	$0748	; 
char_6type23_t:	.byte 0;	=	$0749	; 
char_6type23_s:	.byte 0;	=	$074A	; 
char_6type23_x:	.byte 0;	=	$074B	; 
char_6type24_y:	.byte 0; 0750;	=	$074C	; 
char_6type24_t:	.byte 0;	=	$074D	; 
char_6type24_s:	.byte 0;	=	$074E	; 
char_6type24_x:	.byte 0;	=	$074F	; 
char_6type25_y:	.byte 0;	=	$0750	; 
char_6type25_t:	.byte 0;	=	$0751	; 
char_6type25_s:	.byte 0;	=	$0752	; 
char_6type25_x:	.byte 0;	=	$0753	; 
char_6type26_y:	.byte 0;	=	$0754	; 
char_6type26_t:	.byte 0;	=	$0755	; 
char_6type26_s:	.byte 0;	=	$0756	; 
char_6type26_x:	.byte 0;	=	$0757	; 

haba_fire1_y:	.byte 0
haba_fire1_t:	.byte 0
haba_fire1_s:	.byte 0
haba_fire1_x:	.byte 0
haba_fire2_y:	.byte 0; 6
haba_fire2_t:	.byte 0
haba_fire2_s:	.byte 0
haba_fire2_x:	.byte 0
haba_fire3_y:	.byte 0
haba_fire3_t:	.byte 0
haba_fire3_s:	.byte 0
haba_fire3_x:	.byte 0
haba_fire4_y:	.byte 0
haba_fire4_t:	.byte 0
haba_fire4_s:	.byte 0
haba_fire4_x:	.byte 0
haba_fire5_y:	.byte 0
haba_fire5_t:	.byte 0
haba_fire5_s:	.byte 0
haba_fire5_x:	.byte 0
haba_fire6_y:	.byte 0; 7
haba_fire6_t:	.byte 0
haba_fire6_s:	.byte 0
haba_fire6_x:	.byte 0
haba_fire7_y:	.byte 0
haba_fire7_t:	.byte 0
haba_fire7_s:	.byte 0
haba_fire7_x:	.byte 0
haba_fire8_y:	.byte 0
haba_fire8_t:	.byte 0
haba_fire8_s:	.byte 0
haba_fire8_x:	.byte 0
haba_fire9_y:	.byte 0
haba_fire9_t:	.byte 0
haba_fire9_s:	.byte 0
haba_fire9_x:	.byte 0

str4_index1_y:	.byte 0; 8
str4_index1_t:	.byte 0
str4_index1_s:	.byte 0
str4_index1_x:	.byte 0
str4_index2_y:	.byte 0
str4_index2_t:	.byte 0
str4_index2_s:	.byte 0
str4_index2_x:	.byte 0
str4_index3_y:	.byte 0
str4_index3_t:	.byte 0
str4_index3_s:	.byte 0
str4_index3_x:	.byte 0
str4_index4_y:	.byte 0
str4_index4_t:	.byte 0
str4_index4_s:	.byte 0
str4_index4_x:	.byte 0

d0_y:	.byte 0; $0790
d0_t:	.byte 0
d0_s:	.byte 0
d0_x:	.byte 0
d1_y:	.byte 0
d1_t:	.byte 0
d1_s:	.byte 0
d1_x:	.byte 0
d2_y:	.byte 0
d2_t:	.byte 0
d2_s:	.byte 0
d2_x:	.byte 0
d3_y:	.byte 0
d3_t:	.byte 0
d3_s:	.byte 0
d3_x:	.byte 0; $079f
d4_y:	.byte 0; $07a0
d4_t:	.byte 0
d4_s:	.byte 0
d4_x:	.byte 0
d5_y:	.byte 0
d5_t:	.byte 0
d5_s:	.byte 0
d5_x:	.byte 0
d6_y:	.byte 0
d6_t:	.byte 0
d6_s:	.byte 0
d6_x:	.byte 0
d7_y:	.byte 0
d7_t:	.byte 0
d7_s:	.byte 0
d7_x:	.byte 0; $07af
char_12_type01_y:	.byte 0 ; 07b0 07d8
char_12_type01_t:	.byte 0
char_12_type01_s:	.byte 0
char_12_type01_x:	.byte 0
char_12_type02_y:	.byte 0
char_12_type02_t:	.byte 0
char_12_type02_s:	.byte 0
char_12_type02_x:	.byte 0

; ここまでで07B7にしたい

player1_y:	.byte 0; $07b8
player1_t:	.byte 0
player1_s:	.byte 0
player1_x:	.byte 0
player2_y:	.byte 0
player2_t:	.byte 0
player2_s:	.byte 0
player2_x:	.byte 0
player3_y:	.byte 0; $07c0
player3_t:	.byte 0
player3_s:	.byte 0
player3_x:	.byte 0
player4_y:	.byte 0
player4_t:	.byte 0
player4_s:	.byte 0
player4_x:	.byte 0
player5_y:	.byte 0
player5_t:	.byte 0
player5_s:	.byte 0
player5_x:	.byte 0
player6_y:	.byte 0
player6_t:	.byte 0
player6_s:	.byte 0
player6_x:	.byte 0
player7_y:	.byte 0; d
player7_t:	.byte 0
player7_s:	.byte 0
player7_x:	.byte 0
player8_y:	.byte 0
player8_t:	.byte 0
player8_s:	.byte 0
player8_x:	.byte 0; 07d7

char_12_type03_y:	.byte 0; 07d8
char_12_type03_t:	.byte 0
char_12_type03_s:	.byte 0
char_12_type03_x:	.byte 0
char_12_type04_y:	.byte 0
char_12_type04_t:	.byte 0
char_12_type04_s:	.byte 0
char_12_type04_x:	.byte 0 
char_12_type05_y:	.byte 0
char_12_type05_t:	.byte 0; 07e0
char_12_type05_s:	.byte 0
char_12_type05_x:	.byte 0
char_12_type06_y:	.byte 0
char_12_type06_t:	.byte 0
char_12_type06_s:	.byte 0
char_12_type06_x:	.byte 0
char_12_type07_y:	.byte 0;
char_12_type07_t:	.byte 0
char_12_type07_s:	.byte 0
char_12_type07_x:	.byte 0
char_12_type08_y:	.byte 0
char_12_type08_t:	.byte 0
char_12_type08_s:	.byte 0
char_12_type08_x:	.byte 0
char_12_type09_y:	.byte 0
char_12_type09_t:	.byte 0 ; 07f0
char_12_type09_s:	.byte 0
char_12_type09_x:	.byte 0
char_12_type10_y:	.byte 0
char_12_type10_t:	.byte 0
char_12_type10_s:	.byte 0
char_12_type10_x:	.byte 0
char_12_type11_y:	.byte 0
char_12_type11_t:	.byte 0
char_12_type11_s:	.byte 0
char_12_type11_x:	.byte 0
char_12_type12_y:	.byte 0
char_12_type12_t:	.byte 0
char_12_type12_s:	.byte 0
char_12_type12_x:	.byte 0 ; $07fe

; fuki_test := $0704 ; 直接アドレス指定
; ボス用にエイリアス $070C～
.org $070C
boss_index1_y:		.byte 0 ; 070C
boss_index1_t:		.byte 0
boss_index1_s:		.byte 0
boss_index1_x:		.byte 0
boss_index2_y:		.byte 0 ; 0710
boss_index2_t:		.byte 0
boss_index2_s:		.byte 0
boss_index2_x:		.byte 0
boss_index3_y:		.byte 0
boss_index3_t:		.byte 0
boss_index3_s:		.byte 0
boss_index3_x:		.byte 0
boss_index4_y:		.byte 0
boss_index4_t:		.byte 0
boss_index4_s:		.byte 0
boss_index4_x:		.byte 0
boss_index5_y:		.byte 0
boss_index5_t:		.byte 0
boss_index5_s:		.byte 0
boss_index5_x:		.byte 0
boss_index6_y:		.byte 0 ; 0720
boss_index6_t:		.byte 0
boss_index6_s:		.byte 0
boss_index6_x:		.byte 0
boss_index7_y:		.byte 0
boss_index7_t:		.byte 0
boss_index7_s:		.byte 0
boss_index7_x:		.byte 0
boss_index8_y:		.byte 0
boss_index8_t:		.byte 0
boss_index8_s:		.byte 0
boss_index8_x:		.byte 0 ; 072B
boss_index9_y:		.byte 0
boss_index9_t:		.byte 0
boss_index9_s:		.byte 0
boss_index9_x:		.byte 0
boss_index10_y:		.byte 0 ; 0730
boss_index10_t:		.byte 0
boss_index10_s:		.byte 0
boss_index10_x:		.byte 0
boss_index11_y:		.byte 0
boss_index11_t:		.byte 0
boss_index11_s:		.byte 0
boss_index11_x:		.byte 0
boss_index12_y:		.byte 0
boss_index12_t:		.byte 0
boss_index12_s:		.byte 0
boss_index12_x:		.byte 0
boss_index13_y:		.byte 0
boss_index13_t:		.byte 0
boss_index13_s:		.byte 0
boss_index13_x:		.byte 0
boss_index14_y:		.byte 0 ;4
boss_index14_t:		.byte 0
boss_index14_s:		.byte 0
boss_index14_x:		.byte 0
boss_index15_y:		.byte 0
boss_index15_t:		.byte 0
boss_index15_s:		.byte 0
boss_index15_x:		.byte 0
boss_index16_y:		.byte 0
boss_index16_t:		.byte 0
boss_index16_s:		.byte 0
boss_index16_x:		.byte 0
boss_index17_y:		.byte 0
boss_index17_t:		.byte 0
boss_index17_s:		.byte 0
boss_index17_x:		.byte 0
boss_index18_y:		.byte 0 ;5
boss_index18_t:		.byte 0
boss_index18_s:		.byte 0
boss_index18_x:		.byte 0
boss_index19_y:		.byte 0
boss_index19_t:		.byte 0
boss_index19_s:		.byte 0
boss_index19_x:		.byte 0
boss_index20_y:		.byte 0
boss_index20_t:		.byte 0
boss_index20_s:		.byte 0
boss_index20_x:		.byte 0
boss_index21_y:		.byte 0
boss_index21_t:		.byte 0
boss_index21_s:		.byte 0
boss_index21_x:		.byte 0
boss_index22_y:		.byte 0 ;6
boss_index22_t:		.byte 0
boss_index22_s:		.byte 0
boss_index22_x:		.byte 0
boss_index23_y:		.byte 0
boss_index23_t:		.byte 0
boss_index23_s:		.byte 0
boss_index23_x:		.byte 0
boss_index24_y:		.byte 0
boss_index24_t:		.byte 0
boss_index24_s:		.byte 0
boss_index24_x:		.byte 0
boss_index25_y:		.byte 0
boss_index25_t:		.byte 0
boss_index25_s:		.byte 0
boss_index25_x:		.byte 0
boss_index26_y:		.byte 0 ;7
boss_index26_t:		.byte 0
boss_index26_s:		.byte 0
boss_index26_x:		.byte 0
boss_index27_y:		.byte 0
boss_index27_t:		.byte 0
boss_index27_s:		.byte 0
boss_index27_x:		.byte 0
boss_index28_y:		.byte 0
boss_index28_t:		.byte 0
boss_index28_s:		.byte 0
boss_index28_x:		.byte 0
boss_index29_y:		.byte 0
boss_index29_t:		.byte 0
boss_index29_s:		.byte 0
boss_index29_x:		.byte 0
boss_index30_y:		.byte 0 ;8
boss_index30_t:		.byte 0
boss_index30_s:		.byte 0
boss_index30_x:		.byte 0
boss_index31_y:		.byte 0
boss_index31_t:		.byte 0
boss_index31_s:		.byte 0
boss_index31_x:		.byte 0
boss_index32_y:		.byte 0
boss_index32_t:		.byte 0
boss_index32_s:		.byte 0
boss_index32_x:		.byte 0
boss_index33_y:		.byte 0
boss_index33_t:		.byte 0
boss_index33_s:		.byte 0
boss_index33_x:		.byte 0
boss_index34_y:		.byte 0 ;9
boss_index34_t:		.byte 0
boss_index34_s:		.byte 0
boss_index34_x:		.byte 0
boss_index35_y:		.byte 0
boss_index35_t:		.byte 0
boss_index35_s:		.byte 0
boss_index35_x:		.byte 0
boss_index36_y:		.byte 0
boss_index36_t:		.byte 0
boss_index36_s:		.byte 0
boss_index36_x:		.byte 0
boss_index37_y:		.byte 0
boss_index37_t:		.byte 0
boss_index37_s:		.byte 0
boss_index37_x:		.byte 0
boss_index38_y:		.byte 0 ;a
boss_index38_t:		.byte 0
boss_index38_s:		.byte 0
boss_index38_x:		.byte 0
boss_index39_y:		.byte 0
boss_index39_t:		.byte 0
boss_index39_s:		.byte 0
boss_index39_x:		.byte 0
boss_index40_y:		.byte 0
boss_index40_t:		.byte 0
boss_index40_s:		.byte 0
boss_index40_x:		.byte 0
boss_index41_y:		.byte 0
boss_index41_t:		.byte 0
boss_index41_s:		.byte 0
boss_index41_x:		.byte 0
boss_index42_y:		.byte 0 ;b
boss_index42_t:		.byte 0
boss_index42_s:		.byte 0
boss_index42_x:		.byte 0
boss_index43_y:		.byte 0
boss_index43_t:		.byte 0
boss_index43_s:		.byte 0
boss_index43_x:		.byte 0 ;07b7


.org $0600
spriteZero_y2:		.byte 0
spriteZero_t2:		.byte 0
spriteZero_s2:		.byte 0
spriteZero_x2:		.byte 0

playerFuki1_y2: .byte 0
playerFuki1_t2: .byte 0
playerFuki1_s2: .byte 0
playerFuki1_x2: .byte 0
playerFuki2_y2: .byte 0
playerFuki2_t2: .byte 0
playerFuki2_s2: .byte 0
playerFuki2_x2: .byte 0

player1_y2:	.byte 0
player1_t2:	.byte 0
player1_s2:	.byte 0
player1_x2:	.byte 0
player2_y2:	.byte 0; $0610
player2_t2:	.byte 0
player2_s2:	.byte 0
player2_x2:	.byte 0
player3_y2:	.byte 0
player3_t2:	.byte 0
player3_s2:	.byte 0
player3_x2:	.byte 0
player4_y2:	.byte 0
player4_t2:	.byte 0
player4_s2:	.byte 0
player4_x2:	.byte 0
player5_y2:	.byte 0
player5_t2:	.byte 0
player5_s2:	.byte 0
player5_x2:	.byte 0
player6_y2:	.byte 0; $0620
player6_t2:	.byte 0
player6_s2:	.byte 0
player6_x2:	.byte 0
player7_y2:	.byte 0
player7_t2:	.byte 0
player7_s2:	.byte 0
player7_x2:	.byte 0
player8_y2:	.byte 0
player8_t2:	.byte 0
player8_s2:	.byte 0
player8_x2:	.byte 0

haba_fire1_y2:	.byte 0; $062C
haba_fire1_t2:	.byte 0
haba_fire1_s2:	.byte 0
haba_fire1_x2:	.byte 0
haba_fire2_y2:	.byte 0; $0630
haba_fire2_t2:	.byte 0
haba_fire2_s2:	.byte 0
haba_fire2_x2:	.byte 0
haba_fire3_y2:	.byte 0
haba_fire3_t2:	.byte 0
haba_fire3_s2:	.byte 0
haba_fire3_x2:	.byte 0
haba_fire4_y2:	.byte 0
haba_fire4_t2:	.byte 0
haba_fire4_s2:	.byte 0
haba_fire4_x2:	.byte 0
haba_fire5_y2:	.byte 0
haba_fire5_t2:	.byte 0
haba_fire5_s2:	.byte 0
haba_fire5_x2:	.byte 0
haba_fire6_y2:	.byte 0; $0640
haba_fire6_t2:	.byte 0
haba_fire6_s2:	.byte 0
haba_fire6_x2:	.byte 0
haba_fire7_y2:	.byte 0
haba_fire7_t2:	.byte 0
haba_fire7_s2:	.byte 0
haba_fire7_x2:	.byte 0
haba_fire8_y2:	.byte 0
haba_fire8_t2:	.byte 0
haba_fire8_s2:	.byte 0
haba_fire8_x2:	.byte 0
haba_fire9_y2:	.byte 0
haba_fire9_t2:	.byte 0
haba_fire9_s2:	.byte 0
haba_fire9_x2:	.byte 0

char_12_type01_y2:	.byte 0; $0650
char_12_type01_t2:	.byte 0
char_12_type01_s2:	.byte 0
char_12_type01_x2:	.byte 0
char_12_type02_y2:	.byte 0
char_12_type02_t2:	.byte 0
char_12_type02_s2:	.byte 0
char_12_type02_x2:	.byte 0
char_12_type03_y2:	.byte 0
char_12_type03_t2:	.byte 0
char_12_type03_s2:	.byte 0
char_12_type03_x2:	.byte 0
char_12_type04_y2:	.byte 0
char_12_type04_t2:	.byte 0
char_12_type04_s2:	.byte 0
char_12_type04_x2:	.byte 0
char_12_type05_y2:	.byte 0
char_12_type05_t2:	.byte 0
char_12_type05_s2:	.byte 0
char_12_type05_x2:	.byte 0
char_12_type06_y2:	.byte 0
char_12_type06_t2:	.byte 0
char_12_type06_s2:	.byte 0
char_12_type06_x2:	.byte 0
char_12_type07_y2:	.byte 0
char_12_type07_t2:	.byte 0
char_12_type07_s2:	.byte 0
char_12_type07_x2:	.byte 0
char_12_type08_y2:	.byte 0
char_12_type08_t2:	.byte 0
char_12_type08_s2:	.byte 0
char_12_type08_x2:	.byte 0
char_12_type09_y2:	.byte 0
char_12_type09_t2:	.byte 0
char_12_type09_s2:	.byte 0
char_12_type09_x2:	.byte 0
char_12_type10_y2:	.byte 0
char_12_type10_t2:	.byte 0
char_12_type10_s2:	.byte 0
char_12_type10_x2:	.byte 0
char_12_type11_y2:	.byte 0
char_12_type11_t2:	.byte 0
char_12_type11_s2:	.byte 0
char_12_type11_x2:	.byte 0
char_12_type12_y2:	.byte 0
char_12_type12_t2:	.byte 0
char_12_type12_s2:	.byte 0
char_12_type12_x2:	.byte 0

char_6type1_y2:	.byte 0
char_6type1_t2:	.byte 0
char_6type1_s2:	.byte 0
char_6type1_x2:	.byte 0
char_6type2_y2:	.byte 0
char_6type2_t2:	.byte 0
char_6type2_s2:	.byte 0
char_6type2_x2:	.byte 0
char_6type3_y2:	.byte 0
char_6type3_t2:	.byte 0
char_6type3_s2:	.byte 0
char_6type3_x2:	.byte 0
char_6type4_y2:	.byte 0
char_6type4_t2:	.byte 0
char_6type4_s2:	.byte 0
char_6type4_x2:	.byte 0
char_6type5_y2:	.byte 0
char_6type5_t2:	.byte 0
char_6type5_s2:	.byte 0
char_6type5_x2:	.byte 0
char_6type6_y2:	.byte 0
char_6type6_t2:	.byte 0
char_6type6_s2:	.byte 0
char_6type6_x2:	.byte 0

char_6type21_y2:	.byte 0
char_6type21_t2:	.byte 0
char_6type21_s2:	.byte 0
char_6type21_x2:	.byte 0
char_6type22_y2:	.byte 0
char_6type22_t2:	.byte 0
char_6type22_s2:	.byte 0
char_6type22_x2:	.byte 0
char_6type23_y2:	.byte 0
char_6type23_t2:	.byte 0
char_6type23_s2:	.byte 0
char_6type23_x2:	.byte 0
char_6type24_y2:	.byte 0
char_6type24_t2:	.byte 0
char_6type24_s2:	.byte 0
char_6type24_x2:	.byte 0
char_6type25_y2:	.byte 0
char_6type25_t2:	.byte 0
char_6type25_s2:	.byte 0
char_6type25_x2:	.byte 0
char_6type26_y2:	.byte 0
char_6type26_t2:	.byte 0
char_6type26_s2:	.byte 0
char_6type26_x2:	.byte 0

char4_p1_index1_y2:	.byte 0
char4_p1_index1_t2:	.byte 0
char4_p1_index1_s2:	.byte 0
char4_p1_index1_x2:	.byte 0
char4_p1_index2_y2:	.byte 0
char4_p1_index2_t2:	.byte 0
char4_p1_index2_s2:	.byte 0
char4_p1_index2_x2:	.byte 0
char4_p1_index3_y2:	.byte 0
char4_p1_index3_t2:	.byte 0
char4_p1_index3_s2:	.byte 0
char4_p1_index3_x2:	.byte 0
char4_p1_index4_y2:	.byte 0
char4_p1_index4_t2:	.byte 0
char4_p1_index4_s2:	.byte 0
char4_p1_index4_x2:	.byte 0

char4_p2_index1_y2:	.byte 0
char4_p2_index1_t2:	.byte 0
char4_p2_index1_s2:	.byte 0
char4_p2_index1_x2:	.byte 0
char4_p2_index2_y2:	.byte 0
char4_p2_index2_t2:	.byte 0
char4_p2_index2_s2:	.byte 0
char4_p2_index2_x2:	.byte 0
char4_p2_index3_y2:	.byte 0
char4_p2_index3_t2:	.byte 0
char4_p2_index3_s2:	.byte 0
char4_p2_index3_x2:	.byte 0
char4_p2_index4_y2:	.byte 0
char4_p2_index4_t2:	.byte 0
char4_p2_index4_s2:	.byte 0
char4_p2_index4_x2:	.byte 0

str4_index1_y2:	.byte 0
str4_index1_t2:	.byte 0
str4_index1_s2:	.byte 0
str4_index1_x2:	.byte 0
str4_index2_y2:	.byte 0
str4_index2_t2:	.byte 0
str4_index2_s2:	.byte 0
str4_index2_x2:	.byte 0
str4_index3_y2:	.byte 0
str4_index3_t2:	.byte 0
str4_index3_s2:	.byte 0
str4_index3_x2:	.byte 0
str4_index4_y2:	.byte 0
str4_index4_t2:	.byte 0
str4_index4_s2:	.byte 0
str4_index4_x2:	.byte 0

; ボス用にエイリアス
.org $062C
boss_index1_y2:		.byte 0
boss_index1_t2:		.byte 0
boss_index1_s2:		.byte 0
boss_index1_x2:		.byte 0
boss_index2_y2:		.byte 0     ; 0630
boss_index2_t2:		.byte 0
boss_index2_s2:		.byte 0
boss_index2_x2:		.byte 0
boss_index3_y2:		.byte 0
boss_index3_t2:		.byte 0
boss_index3_s2:		.byte 0
boss_index3_x2:		.byte 0
boss_index4_y2:		.byte 0
boss_index4_t2:		.byte 0
boss_index4_s2:		.byte 0
boss_index4_x2:		.byte 0
boss_index5_y2:		.byte 0
boss_index5_t2:		.byte 0
boss_index5_s2:		.byte 0
boss_index5_x2:		.byte 0
boss_index6_y2:		.byte 0     ; 0640
boss_index6_t2:		.byte 0
boss_index6_s2:		.byte 0
boss_index6_x2:		.byte 0
boss_index7_y2:		.byte 0
boss_index7_t2:		.byte 0
boss_index7_s2:		.byte 0
boss_index7_x2:		.byte 0
boss_index8_y2:		.byte 0
boss_index8_t2:		.byte 0
boss_index8_s2:		.byte 0
boss_index8_x2:		.byte 0
boss_index9_y2:		.byte 0
boss_index9_t2:		.byte 0
boss_index9_s2:		.byte 0
boss_index9_x2:		.byte 0
boss_index10_y2:		.byte 0     ; 0650
boss_index10_t2:		.byte 0
boss_index10_s2:		.byte 0
boss_index10_x2:		.byte 0
boss_index11_y2:		.byte 0
boss_index11_t2:		.byte 0
boss_index11_s2:		.byte 0
boss_index11_x2:		.byte 0
boss_index12_y2:		.byte 0
boss_index12_t2:		.byte 0
boss_index12_s2:		.byte 0
boss_index12_x2:		.byte 0
boss_index13_y2:		.byte 0
boss_index13_t2:		.byte 0
boss_index13_s2:		.byte 0
boss_index13_x2:		.byte 0
boss_index14_y2:		.byte 0     ; 0660
boss_index14_t2:		.byte 0
boss_index14_s2:		.byte 0
boss_index14_x2:		.byte 0
boss_index15_y2:		.byte 0
boss_index15_t2:		.byte 0
boss_index15_s2:		.byte 0
boss_index15_x2:		.byte 0
boss_index16_y2:		.byte 0
boss_index16_t2:		.byte 0
boss_index16_s2:		.byte 0
boss_index16_x2:		.byte 0
boss_index17_y2:		.byte 0
boss_index17_t2:		.byte 0
boss_index17_s2:		.byte 0
boss_index17_x2:		.byte 0
boss_index18_y2:		.byte 0     ; 0670
boss_index18_t2:		.byte 0
boss_index18_s2:		.byte 0
boss_index18_x2:		.byte 0
boss_index19_y2:		.byte 0
boss_index19_t2:		.byte 0
boss_index19_s2:		.byte 0
boss_index19_x2:		.byte 0
boss_index20_y2:		.byte 0
boss_index20_t2:		.byte 0
boss_index20_s2:		.byte 0
boss_index20_x2:		.byte 0
boss_index21_y2:		.byte 0
boss_index21_t2:		.byte 0
boss_index21_s2:		.byte 0
boss_index21_x2:		.byte 0
boss_index22_y2:		.byte 0     ; 0680
boss_index22_t2:		.byte 0
boss_index22_s2:		.byte 0
boss_index22_x2:		.byte 0
boss_index23_y2:		.byte 0
boss_index23_t2:		.byte 0
boss_index23_s2:		.byte 0
boss_index23_x2:		.byte 0
boss_index24_y2:		.byte 0
boss_index24_t2:		.byte 0
boss_index24_s2:		.byte 0
boss_index24_x2:		.byte 0
boss_index25_y2:		.byte 0
boss_index25_t2:		.byte 0
boss_index25_s2:		.byte 0
boss_index25_x2:		.byte 0
boss_index26_y2:		.byte 0     ; 0690
boss_index26_t2:		.byte 0
boss_index26_s2:		.byte 0
boss_index26_x2:		.byte 0
boss_index27_y2:		.byte 0
boss_index27_t2:		.byte 0
boss_index27_s2:		.byte 0
boss_index27_x2:		.byte 0
boss_index28_y2:		.byte 0
boss_index28_t2:		.byte 0
boss_index28_s2:		.byte 0
boss_index28_x2:		.byte 0
boss_index29_y2:		.byte 0
boss_index29_t2:		.byte 0
boss_index29_s2:		.byte 0
boss_index29_x2:		.byte 0
boss_index30_y2:		.byte 0     ; 06a0
boss_index30_t2:		.byte 0
boss_index30_s2:		.byte 0
boss_index30_x2:		.byte 0
boss_index31_y2:		.byte 0
boss_index31_t2:		.byte 0
boss_index31_s2:		.byte 0
boss_index31_x2:		.byte 0
boss_index32_y2:		.byte 0
boss_index32_t2:		.byte 0
boss_index32_s2:		.byte 0
boss_index32_x2:		.byte 0
boss_index33_y2:		.byte 0
boss_index33_t2:		.byte 0
boss_index33_s2:		.byte 0
boss_index33_x2:		.byte 0
boss_index34_y2:		.byte 0     ; 06b0
boss_index34_t2:		.byte 0
boss_index34_s2:		.byte 0
boss_index34_x2:		.byte 0
boss_index35_y2:		.byte 0
boss_index35_t2:		.byte 0
boss_index35_s2:		.byte 0
boss_index35_x2:		.byte 0
boss_index36_y2:		.byte 0
boss_index36_t2:		.byte 0
boss_index36_s2:		.byte 0
boss_index36_x2:		.byte 0
boss_index37_y2:		.byte 0
boss_index37_t2:		.byte 0
boss_index37_s2:		.byte 0
boss_index37_x2:		.byte 0
boss_index38_y2:		.byte 0     ; c
boss_index38_t2:		.byte 0
boss_index38_s2:		.byte 0
boss_index38_x2:		.byte 0
boss_index39_y2:		.byte 0
boss_index39_t2:		.byte 0
boss_index39_s2:		.byte 0
boss_index39_x2:		.byte 0
boss_index40_y2:		.byte 0
boss_index40_t2:		.byte 0
boss_index40_s2:		.byte 0
boss_index40_x2:		.byte 0
boss_index41_y2:		.byte 0
boss_index41_t2:		.byte 0
boss_index41_s2:		.byte 0
boss_index41_x2:		.byte 0
boss_index42_y2:		.byte 0     ; 06d0
boss_index42_t2:		.byte 0
boss_index42_s2:		.byte 0
boss_index42_x2:		.byte 0
boss_index43_y2:		.byte 0
boss_index43_t2:		.byte 0
boss_index43_s2:		.byte 0
boss_index43_x2:		.byte 0     ; 06d7
