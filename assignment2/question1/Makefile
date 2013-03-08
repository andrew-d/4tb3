.PHONY: clean test

prettyprint: prettyprint.pas
	fpc prettyprint.pas

risccompiler: risccompiler.pas
	fpc risccompiler.pas

clean:
	rm *.ppu *.o

test: prettyprint risccompiler
	python test.py


all: prettyprint risccompiler

