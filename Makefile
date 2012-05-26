LD=ld -m elf_i386 -s 
ASM=nasm -f elf
slectionsort: selectionSort.o
	$(LD) -o selectionsort selectionSort/selectionSort.o
selectionSort.o:
	$(ASM) selectionSort/selectionSort.asm