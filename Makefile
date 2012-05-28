LD=gcc -m32
ASM=nasm -g -f elf 
slectionsort: selectionSort.o
	$(LD) -o selectionsort selectionSort/selectionSort.o
selectionSort.o:
	$(ASM) selectionSort/selectionSort.asm