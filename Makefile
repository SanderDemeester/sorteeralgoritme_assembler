LD=ld -g -m elf_i386
ASM=nasm -f elf -g -l

selectionsort: selectionsort.o
	$(LD) selectionsort/selectiosort.asm
selectionsort.o: selectionsort/selectiosort.asm
	$(ASM) -l selectionsort.lst selectionort/selectiosort.asm

