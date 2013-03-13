.PHONY: clean test

risccompiler: risccompiler.pas
	fpc risccompiler.pas

clean:
	rm *.ppu *.o

check: risccompiler
	@echo '****************************************************'
	@echo 'Please read the note in README.txt for this question'
	@echo '****************************************************'
	python check.py

all: risccompiler

