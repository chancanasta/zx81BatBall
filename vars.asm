;variables for the game
skip	DEFB	$0
x_dir	DEFW	$1
y_dir	DEFW	$21
wx_dir	DEFB	$1
wy_dir	DEFB	$1
x_pos	DEFB	STARTX
y_pos	DEFB	STARTY
act_pos	DEFW	$0
hitbrk	DEFB	$0
batxpos	DEFB	$0
batpos	DEFW	$0
displp	DEFB 	$0
dispact	DEFB	$1
displk	DEFW	$0
bricks	DEFB	$38
alldone	DEFB	$0


shame
		DEFB	_S,_H,_A,_M,_E,$ff
joy
		DEFB	__,_J,_O,_Y,__,$ff
done
		DEFB	_D,_O,_N,_E,__,$ff
notxt
		DEFB	__,__,__,__,__,$ff

instruct1
		DEFB	_5,__,_L,_E,_F,_T,_CM,_8,__,_R,_I,_G,_H,_T,$ff
instruct2
		DEFB	_P,_R,_E,_S,_S,__,_A,_N,_Y,__,_K,_E,_Y,__,_T,_O,__,_S,_T,_A,_R,_T,$ff

