%{  
#include <cstdio>
#include <iostream>
using namespace std;
#define YY_DECL extern "C" int yylex()
#include "calc2.tab.h"  //由bison生成  
extern int yyerror(const char *);  
using namespace std;  
%}
%%
[0-9]+ { yylval.dv = strtod(yytext, 0); return Number; }
[0-9]*\.[0-9]+ { yylval.dv = strtod(yytext, 0); return Number;}
[)(+*-/\n] { return *yytext; }
[ \t] ;
%%
int yywrap(){
    return 1;
}

