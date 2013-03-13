.PHONY: clean test

risccompiler: risccompiler.pas
	fpc risccompiler.pas

clean:
	rm *.ppu *.o

check: risccompiler
	python check.py

all: risccompiler

