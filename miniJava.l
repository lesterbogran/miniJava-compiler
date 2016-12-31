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
extern int column_num;

%}

DIGIT [0-9]
LETTER [a-zA-Z_]

%x ERROR

%%


"true" { column_num+=4;return TRUE; }
"false" { column_num+=5;return FALSE; }
"this" { column_num+=4;return THIS; }
"length" { column_num+=6;return LENGTH; }
"void" { column_num+=4;return VOID; }
"static" { column_num+=6;return STATIC; }
"class" { column_num+=5;return CLASS; }
"return" { column_num+=6;return RETURN; }
"public" { column_num+=6;return PUBLIC; }
"if" { column_num+=2;return IF; }
"else" { column_num+=4;return ELSE; }
"while" { column_num+=5;return WHILE; }
"System.out.println" { column_num+=18;return PRINT; }
"new" { column_num+=3;return NEW; }
{DIGIT}+ {
    column_num+=strlen(yytext);
	yylval.num = atof(yytext); return NUMBER;
}

{LETTER}[0-9a-zA-Z_]* {
    column_num+=strlen(yytext);
	yylval.id = strdup(yytext); return ID;
}

[ \t\f\r]	;		 { column_num+=1; }// ignore white space 
\/\/.* ; { column_num+=1; }//ignore comment


\n      { line_num++;column_num=1; }
"-"	{ column_num+=1;return MINUS;  }
"+"	{ column_num+=1;return PLUS;   }
"*"	{ column_num+=1;return TIMES;  }
"/"	{ column_num+=1;return DIVIDE; }
"("	{ column_num+=1;return LPAREN; }
")"	{ column_num+=1;return RPAREN; }
"&&" { column_num+=2;return AND; }
"||" { column_num+=2;return OR; }
"!" { column_num+=1;return NOT; }
"<" { column_num+=1;return LESS; }
">" { column_num+=1;return MORE; }
"==" { column_num+=2;return EQUAL; }
"="  { column_num+=1;return ASSIGN; }
"{" { column_num+=1;return LBRACE; }
"}" { column_num+=1;return RBRACE; }


[\[\]\.;,] { column_num+=1;return *yytext; }

. { BEGIN(ERROR); yymore(); }
<ERROR>[^{DIGIT}{LETTER}+\-/*()= \t\n\f\r] { yymore(); }
<ERROR>(.|\n) { yyless(yyleng-1); printf("error token: %s on line %d\n", yytext, line_num); 
           BEGIN(INITIAL); }     

%%
int yywrap(){
    return 1;
}
