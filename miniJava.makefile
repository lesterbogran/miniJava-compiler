cc=g++
all: miniJava

miniJava: miniJava.tab.c miniJava.lex.c
	g++ -o miniJava miniJava.tab.c miniJava.lex.c

miniJava.tab.c: miniJava.y
	bison -d -o miniJava.tab.c miniJava.y

miniJava.lex.c: miniJava.tab.c miniJava.l
	flex -o miniJava.lex.c miniJava.l

clean:
	rm miniJava.tab.c
	rm miniJava.tab.h
	rm miniJava.lex.c
	rm miniJava


