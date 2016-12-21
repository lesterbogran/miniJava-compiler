%{
#include <cstdio>
#include <iostream>
#include <cmath>
using namespace std;

// stuff from flex that bison needs to know about:
extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
 
int yyerror(const char *s);
%}
%%
main: main '\n' { ; }
    |
    ;
%%
int main(int argc, char *argv[]){
	cout << "Under Constrction" << endl;
}

int yyerror(const char *s) {
	cout << "EEK, parse error!  Message: " << s << endl;
	// might as well halt now:
	exit(-1);
}
