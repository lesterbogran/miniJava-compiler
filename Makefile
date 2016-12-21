all: miniJava

miniJava: miniJava.tab.c miniJava.lex.c
	g++ -o $@ miniJava.tab.c miniJava.lex.c

miniJava.tab.c: miniJava.y
	bison -d -o $@ miniJava.y

miniJava.lex.c: miniJava.tab.c miniJava.l
	flex -o $@ miniJava.l

clean:
	rm miniJava.tab.c
	rm miniJava.tab.h
	rm miniJava.lex.c
	rm miniJava


