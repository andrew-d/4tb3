LEX		= flex
CFLAGS	= -Wall

all: calculator



calculator: calculator.o calculator.yy.o
	$(CC) -o $@ $(LDFLAGS) $^

calculator.yy.c: calculator.yy
	$(LEX) $(LFLAGS) -o $@ $^



test:
	python test.py



clean:
	$(RM) *.o *.yy.c calculator
