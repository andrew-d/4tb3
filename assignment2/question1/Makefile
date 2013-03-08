.PHONY: clean test

prettyprint: prettyprint.pas
	fpc prettyprint.pas

risccompiler: risccompiler.pas
	fpc risccompiler.pas

clean:
	rm *.ppu *.o

test:
	python test.py
