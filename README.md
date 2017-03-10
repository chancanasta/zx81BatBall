# zx81BatBall
Simple ZX81 assembly language version of the standard 'ball , bat , brick' game

### How to assembe

This project uses the [The Telemark Assembler (TASM)](http://www.cpcalive.com/docs/TASMMAN.HTM) - a cross assembler for DOS and Linus.

To assembly this project, either use the zxasm.bat file:


```bash
zxasm ballbat
```

or... assemble with the following options:


```bash
 tasm -80 -b -s ballbat.asm ballbat.p
```

