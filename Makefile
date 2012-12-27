LD=ld -g -m elf_i386
ASM=nasm -f elf -g

selectionsort: selectionsort.o
	$(LD) selectionsort/selectionsort.o -o selectionsort
selectionsort.o: 
	$(ASM) -l selectionsort.lst selectionsort/selectionsort.asm

bubblesort: bubblesort.o
	$(LD) bubblesort/bubblesort.o -o bubblesort_bin
bubblesort.o: 
	$(ASM) -l bubblesort.lst bubblesort/bubblesort.asm


