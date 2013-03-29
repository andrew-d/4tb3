all: tablefmt

tablefmt: tablefmt.pas
	fpc tablefmt.pas

check: tablefmt
	@python check.py

clean:
	rm -f *.o *.ppu tablefmt
