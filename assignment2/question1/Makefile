.PHONY: clean test

prettyprint: prettyprint.pas symboltable2.pas scanner2.pas riscgenerator2.pas risc2.pas
	fpc prettyprint.pas

risccompiler: risccompiler.pas symboltable.pas scanner.pas riscgenerator.pas risc.pas
	fpc risccompiler.pas

clean:
	rm *.ppu *.o prettyprint risccompiler

check: prettyprint risccompiler
	python check.py


all: prettyprint risccompiler

