LD=ld -g -m elf_i386
ASM=nasm -f elf -g

selectionsort: selectionsort.o
	$(LD) selectionsort/selectionsort.o -o selectionsort_bin
selectionsort.o: 
	$(ASM) -l selectionsort.lst selectionsort/selectionsort.asm

insertionsort: insertionsort.o
	$(LD) insertionSort/insertionsort.o -o insertionsort_bin
insertionsort.o: 
	$(ASM) -l insertionsort.lst insertionSort/insertionsort.asm

bubblesort: bubblesort.o
	$(LD) bubblesort/bubblesort.o -o bubblesort_bin
bubblesort.o: 
	$(ASM) -l bubblesort.lst bubblesort/bubblesort.asm

clean:
	$(shell for file in `find . -name *.o` ;do rm $$file; done)
	rm *.lst 2>&1 > /dev/null
	rm *_bin 2>&1 > /dev/null


