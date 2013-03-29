.PHONY: clean test

risccompiler: risccompiler.pas symboltable.pas scanner.pas riscgenerator.pas risc.pas
	fpc risccompiler.pas

risccompiler_test: risccompiler_test.pas symboltable.pas scanner.pas riscgenerator.pas risc.pas
	fpc risccompiler_test.pas

clean:
	rm -f *.ppu *.o risccompiler risccompiler_test

check: risccompiler_test
	@python check.py

all: risccompiler risccompiler_test
