LEX		= flex
CFLAGS	= -Wall

all: calculator



calculator: calculator.o
	$(CC) -o $@ $(LDFLAGS) $^

calculator.o: calculator.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $^

calculator.c: calculator.yy
	$(LEX) $(LFLAGS) -o $@ $^



test: test_calculator

test_calculator:
	./test_calculator.sh



clean:
	$(RM) *.o calculator calculator.c
