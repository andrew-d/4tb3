LEX		= flex
CFLAGS	= -Wall -DDEBUG

all: calculator



calculator: calculator.o
	$(CC) -o $@ $(LDFLAGS) $^

calculator.o: calculator.yy.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $^

calculator.yy.c: calculator.yy
	$(LEX) $(LFLAGS) -o $@ $^



test: test_calculator

test_calculator:
	./test_calculator.sh



clean:
	$(RM) *.o calculator calculator.c
