;
; To assembly this, either use the zxasm.bat file:
;
; zxasm ballbat
;
; or... assemble with the following options:
;
; tasm -80 -b -s ballbat.asm ballbat.p
;
;==============================================
; ZX81 assembler version of a 'breakout' game 
;==============================================
;
;defs
#include "zx81defs.asm"
;EQUs for ROM routines
#include "zx81rom.asm"
;ZX81 char codes/how to survive without ASCII
#include "charcodes.asm"
;system variables
#include "zx81sys.asm"
    
;the standard REM statement that will contain our 'hex' code
#include "line1.asm"

;------------------------------------------------------------
; code starts here and gets added to the end of the REM 
;------------------------------------------------------------

;exciting EQUS for this game
#include "equs.asm"

;set everything up
	call initvars
	call instruct
	
mainlp	
	call readkeys
	call drawbat
	call banner

	
;some stuff with the 'ball'	
;speed of the damn thing...
	ld a,(skip)
	add a,$1
	ld (skip),a
	cp BALLSPEED
	jp nz,skipball
	ld	a,$0
	ld (skip),a
;got to here, so...	
;move the ball
	ld hl,(act_pos)		
	ld bc,(x_dir)
	add	hl,bc
	ld bc,(y_dir)
	add hl,bc	
;save what's in the square currently	
	ld (act_pos),hl 
	ld a,(hl)
;'draw' the ball	
	ld d,a
	ld (hl),_O	

;now the lazy x/y thing	
;x
	ld	a,(x_pos)
	ld	hl,wx_dir
	add	a,(hl)
	ld (x_pos),a	
	cp MAXXPOS
	jr nz,notx1
	ld a,$ff
	ld (wx_dir),a
	ld bc,$ffff
	ld (x_dir),bc
notx1
	cp MINXPOS
	jr nz,notx2
	ld a,$1
	ld (wx_dir),a
	ld bc,$1
	ld (x_dir),bc	
notx2


;check if we hit a brick
;bit 3 will be set if it's a brick	
	bit 3,d
	jr z,noBrick
	ld a,TEXTFRAMES
	ld (displp),a
	ld a,(bricks)
	dec a
	ld (bricks),a	
	cp $0
	jr nz,morebricks
	ld a,FINALFRAMES
	ld (displp),a
	ld a,$fe
	ld (alldone),a
	ld hl,done
	jr pt1
morebricks	
	ld hl,joy
pt1
	ld (displk),hl

;are we going up or down?
	ld a,(wy_dir)
	cp $1
	jr nz,nbrk1
	ld d,$ff
	ld bc,$ffdf
	jr nbrk2
nbrk1
	ld d,$01
	ld bc,$21
nbrk2	
;move the ball
	ld a,(y_pos)
	ld hl,wy_dir
	add a,(hl)	
	ld (y_pos),a
;now switch ypos	
	ld a,d
	ld (wy_dir),a
	ld (y_dir),bc
	jp noty2
noBrick

;y 

	ld a,(y_pos)
	ld hl,wy_dir
	add a,(hl)
	ld (y_pos),a
;check if it hit the bat
	cp BOUNCEBAT
	jr nz,nobat
;at bat y level, see if we hit it
;pos 1
	ld a,(x_pos)
	ld d,a	
	ld a,(batxpos)
  	cp d
	jr nz,nobat2
	cp $0
	jr nz,nozbat
	ld a,$00
	ld bc,$0000
	jr nozbat2
nozbat
	ld a,$ff
	ld bc,$ffff
nozbat2	
	ld (wx_dir),a	
	ld (x_dir),bc
	jr setbaty
nobat2	
;pos 2
	add a,1
	cp d
	jr nz,nobat3
	ld a,$0
	ld (wx_dir),a
	ld bc,$0000
	ld (x_dir),bc
	jr setbaty
nobat3
;pos 3
	add a,1
	cp d
	jr nz,nobat
	cp MAXXPOS
	jr nz,nozbat3
	ld a,$00
	ld bc,$0000
	jr nozbat4
nozbat3	
	ld a,$1
	ld bc,$0001
nozbat4	
	ld (wx_dir),a
	ld (x_dir),bc

setbaty
	ld a,$ff
	ld (wy_dir),a
	ld bc,$ffdf
	ld (y_dir),bc

nobat


	ld a,(y_pos)
	cp MAXYPOS
	jr nz,noty1
	
	ld a,TEXTFRAMES
	ld (displp),a
	ld hl,shame
	ld (displk),hl	
	
	ld a,$ff
	ld (wy_dir),a
	ld bc,$ffdf
	ld (y_dir),bc
noty1
	cp MINYPOS
	jr nz,noty2
	ld a,$1
	ld (wy_dir),a
	ld bc,$21
	ld (y_dir),bc	
noty2
	
	
;wait for a vsync...
	ld b,VSYNCLP
pauselp	
	call vsync
	djnz pauselp
	
;erase	
	ld hl,(act_pos)
	ld (hl),__

;see if we've finished
	ld a,(alldone)
	cp $fe
	jp nz,done1
	ld a,$ff
	ld (alldone),a
	jp mainlp
done1	
	cp $ff
	jp nz,mainlp
	ret
	

skipball
;don't move the ball, just draw it
	ld hl,(act_pos)
;'draw' the ball	
	ld (hl),_O	
	jr noty2

	ret
	
;subroutines
;say silly things
banner
	ld bc,15	
	ld	a,(displp)
	cp	$0
	jr z,nobanner
	dec a
	ld (displp),a
	ld de,(displk)
	call dispstring	
	ret
nobanner	
	ld de,notxt
	call dispstring
	ret
	

dispstring
;write directly to the screen
	ld hl,(D_FILE)
	add hl,bc	
loop2
	ld a,(de)
	cp $ff
	jp z,loop2End
	ld (hl),a
	inc hl
	inc de
	jp loop2
loop2End	
	ret


clearstring
	ld hl,(D_FILE)
	add hl,bc	
cloop2
	ld a,(de)
	cp $ff
	jp z,cloop2End
	ld (hl),__
	inc hl
	inc de
	jp cloop2
cloop2End	
	ret
	
	
;draw bat
drawbat
	ld hl,(batpos)
	ld (hl),$00
	inc hl
	ld (hl),$03
	inc hl
	ld (hl),$03
	inc hl
	ld (hl),$03
	inc hl
	ld (hl),$00
	ret
	
;read keys
readkeys
;a bit lazy - call the ROM routine to get the zone values into HL
	call KSCAN
;lazy test for zones...	
;bit 3 will give us left half of the keys on the top row of the keyboard
	bit 3,l	
	jr nz,nokey1
;check we're not a pos 0
	ld a,(batxpos)
	cp 0
	jr z,nokey1
	dec a
	ld (batxpos),a
	ld hl,(batpos)
	dec hl
	ld (batpos),hl
	ret
	
nokey1
;bit 4 will give us right half of the keys on the top row of the keyboard
	bit 4,l
	jr nz,pastnokey1
	ld a,(batxpos)
	cp MAXBATX
	jr z,pastnokey1
	inc a
	ld (batxpos),a
	ld hl,(batpos)
	inc hl
	ld (batpos),hl
pastnokey1		
	ret
	
	
;check for video sync
vsync	
	ld a,(FRAMES)
	ld c,a
sync
	ld a,(FRAMES)
	cp c
	jr z,sync
	ret
	

initvars
;setup init pos
	ld hl,(D_FILE)
	push hl
	ld bc,(DISPLEN*(STARTY+1))+3
	add hl,bc
	ld (act_pos),hl
	pop	hl
	ld bc,(DISPLEN*(STARTBATY))+1
	add hl,bc
	ld (batpos),hl

	ret
;show some rubbish instructions	
instruct
	ld bc,(DISPLEN*7)+10
	ld de,instruct1
	call dispstring
	ld bc,(DISPLEN*12)+6
	ld de,instruct2
	call dispstring
	
waitkpress
	call KSCAN
	ld a,l
	cp $ff
	jp z,waitkpress

	ld bc,(DISPLEN*7)+10
	ld de,instruct1
	call clearstring
	ld bc,(DISPLEN*12)+6
	ld de,instruct2
	call clearstring

	ret
;variables for this game
#include "vars.asm"

; ===========================================================
; code ends
; ===========================================================
;end the REM line and put in the RAND USR line to call our 'hex code'
#include "line2.asm"
                
;display file defintion
#include "screen.asm"               

;close out the basic program
#include "endbasic.asm"
