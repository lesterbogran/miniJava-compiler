CCC = g++
CCFLAGS= -O2
LEX = flex
LFLAGS= -8     
YACC= bison 
YFLAGS= -d -t -y

RM = /bin/rm -f

all: miniJava

miniJava: y.tab.o lex.yy.o miniJava.o
	${CCC} ${CCFLAGS} lex.yy.o y.tab.o miniJava.o -o miniJava

miniJava.o: miniJava.cpp miniJava.h
	${CCC} -c miniJava.cpp
y.tab.o: miniJava.y
	${YACC} ${YFLAGS} miniJava.y
	${CCC} ${CCFLAGS} y.tab.c -c 

lex.yy.o: miniJava.l
	${LEX} $(LFLAGS) miniJava.l
	${CCC} ${CCFLAGS} lex.yy.c -c 

clean:
	/bin/rm -f lex.yy.* y.tab.* *.o miniJava
