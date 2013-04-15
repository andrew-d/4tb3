.PHONY: clean

risccompiler: risccompiler.pas symboltable.pas scanner.pas riscgenerator.pas risc.pas
	fpc risccompiler.pas

clean:
	rm -f *.ppu *.o risccompiler

all: risccompiler
