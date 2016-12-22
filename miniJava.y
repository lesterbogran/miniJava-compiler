%{
#include <cstdio>
#include <iostream>
#include <cmath>
#include <map>
#include <list>
#include <vector>

#include "miniJava.h"

using namespace std;

// root of AST
exp_node *root;

// tracking
int line_num = 1;

// stuff from flex that bison needs to know about:
extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;


// for bison
int yylex();
int yyerror(const char *s);
%}

%start program

%union {
    int num;
    char *id;
    exp_node *expnode;
}

%token <num> NUMBER
%token <id> ID
%token NEWLINE
%left EQUALS
%left AND
%left OR
%left NOT
%left PLUS MINUS
%left TIMES DIVIDE
%left LPAREN RPAREN
%nonassoc UMINUS
%type <expnode> exp

%%
program : ID EQUALS exp NEWLINES { root = $3;}
exp :   NUMBER { $$ = new exp_num_node($1); }
    |   ID { $$ = new exp_id_node($1); }
    |   exp AND exp { $$ = new exp_operator_node("&&", $1, $3); }
    |   exp OR exp { $$ = new exp_operator_node("||", $1, $3); }
    |   NOT exp { $$ = new exp_not_node($2); }
    |   exp PLUS exp { $$ = new exp_operator_node("+", $1, $3); }
    |	exp MINUS exp { $$ = new exp_operator_node("-", $1, $3); }
	|	exp TIMES exp { $$ = new exp_operator_node("*", $1, $3); }
	|	exp DIVIDE exp { $$ = new exp_operator_node("/", $1, $3); }
	|	LPAREN exp RPAREN  { $$ = $2; }
    |   ID '[' exp ']' { $$ = new exp_at_node($1, $3); }
    |   ID '{' exp '}' { $$ = new exp_at_node($1, $3); }
    |   ID '.' ID { $$ = new exp_point_node($1, $3); }
    ;
    
NEWLINES : NEWLINES NEWLINE 
         |
         ;

%%
int main(int argc, char *argv[]){
	///cout << "Under Constrction" << endl;
    yyparse();
    root->print();
    cout << endl;
    return 0;
}

int yyerror(const char *s) {
	cout << "EEK, parse error!  Message: " << s << "Line: " << line_num << endl;
	// might as well halt now:
	exit(-1);
}
