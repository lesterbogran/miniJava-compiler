%option interactive
%{
#include <cstdio>
#include <iostream>
#include <cmath>

#include "miniJava.h"

using namespace std;
#define YY_DECL extern "C" int yylex()

#include "y.tab.h"  // to get the token types that we return



extern int line_num;

%}

DIGIT [0-9]
LETTER [a-zA-Z]

%x ERROR

%%
{DIGIT}+ {
	yylval.num = atof(yytext); return NUMBER;
}

{LETTER}[0-9a-zA-Z]* {
        yylval.id = strdup(yytext); return ID;
}

[ \t\f\r]	;		 // ignore white space 
\/\/.* ; //ignore comment


\n      { line_num++; return NEWLINE; }
"-"	{ return MINUS;  }
"+"	{ return PLUS;   }
"*"	{ return TIMES;  }
"/"	{ return DIVIDE; }
"("	{ return LPAREN; }
")"	{ return RPAREN; }
"&&" { return AND; }
"||" { return OR; }
"!" { return NOT; }
"="  { return EQUALS; }

[\[\]\.\{\}] { return *yytext; }

. { BEGIN(ERROR); yymore(); }
<ERROR>[^{DIGIT}{LETTER}+\-/*()= \t\n\f\r] { yymore(); }
<ERROR>(.|\n) { yyless(yyleng-1); printf("error token: %s on line %d\n", yytext, line_num); 
           BEGIN(INITIAL); }     

%%
int yywrap(){
    return 1;
}
