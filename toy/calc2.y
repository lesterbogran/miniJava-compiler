%{
#include <cstdio>
#include <iostream>
using namespace std;

// stuff from flex that bison needs to know about:
extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
 
int yyerror(const char *s);
%}
%token <dv> Number /// %token Number;%type <dv> Number;
%type <dv> exp
%union {
    double dv;
}
%left '+' '-'
%left '*' '/'
%%

main : main exp '\n' { cout << "Result = " << $2 << endl; }
     |
     ;

exp : exp '+' exp { $$ = $1 + $3; }
    | exp '-' exp { $$ = $1 - $3; }
    | exp '*' exp { $$ = $1 * $3; }
    | exp '/' exp { $$ = $1 / $3; }
    | '(' exp ')' { $$ = $2; }
    | Number { $$ = $1; }

%%

int yyerror(const char *emseg){
    cout << "Error: " << emseg << endl;
}

int main(){
    yyparse();
    return 0;
}


