LD=gcc -g -m32 -masm=intel
ASM=nasm -g -f elf 
selectionsort: 
	$(LD) -o selectionsort selectionSort/selectionSort.o
