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
pgm *root;

// tracking
int line_num = 1;
int column_num = 1;
extern char *yytext;


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
    vector<state_node *> *statelistnode;
    state_node *statenode;
    type_node *minitypenode;
    pgm *prog;
}

%token <num> NUMBER
%token <id> ID
%token NEW
%left IF
%left ELSE
%left WHILE
%left PRINT
%left ASSIGN
%left AND
%left OR
%left NOT
%left LESS MORE EQUAL
%left PLUS MINUS
%left TIMES DIVIDE
%left LPAREN RPAREN
%left LBRACE RBRACE
%nonassoc UMINUS
%type <expnode> exp
%type <statelistnode> statelist
%type <statelistnode> states
%type <statenode> state
%type <minitypenode> minitype
%type <prog> program

%%
program : statelist { $$ = new pgm($1); root = $$; }
;


minitype : ID  {{ $$ = new type_node($1); }}
    |   ID '[' ']' {{ $$ = new type_list_node($1); }}
    ;


states : LBRACE statelist RBRACE { $$ = $2; }
;

statelist : statelist state { $$ = $1; $1->push_back($2); }
    |   { $$ = new vector<state_node *>(); }
    ;

state : IF LPAREN exp RPAREN states ELSE states { $$ = new state_if_node($3, $5, $7); }
    |   WHILE LPAREN exp RPAREN states { $$ = new state_while_node($3, $5); }
    |   PRINT LPAREN exp RPAREN ';' { $$ = new state_print_node($3); }
    |   ID ASSIGN exp ';' { $$ = new state_assign_node($1, $3); }
    |   ID '[' exp ']' ASSIGN exp ';' { $$ = new state_list_assign_node($1, $3, $6); }
    |   ';' { $$ = new state_nop_node(); }
    ;
    
exp :   NUMBER { $$ = new exp_num_node($1); }
    |   ID { $$ = new exp_id_node($1); }
    |   exp AND exp { $$ = new exp_operator_node("&&", $1, $3); }
    |   exp OR exp { $$ = new exp_operator_node("||", $1, $3); }
    |   NOT exp { $$ = new exp_not_node($2); }
    |   exp LESS exp { $$ = new exp_operator_node("<", $1, $3); }
    |   exp MORE exp { $$ = new exp_operator_node(">", $1, $3); }
    |   exp EQUAL exp { $$ = new exp_operator_node("==", $1, $3); }
    |   exp PLUS exp { $$ = new exp_operator_node("+", $1, $3); }
    |	exp MINUS exp { $$ = new exp_operator_node("-", $1, $3); }
	|	exp TIMES exp { $$ = new exp_operator_node("*", $1, $3); }
	|	exp DIVIDE exp { $$ = new exp_operator_node("/", $1, $3); }
	|	LPAREN exp RPAREN  { $$ = $2; }
    |   ID '[' exp ']' { $$ = new exp_at_node($1, $3); }
    |   ID '.' ID { $$ = new exp_point_node($1, $3); }
    |   NEW ID LPAREN RPAREN { $$ = new exp_new_node($2); }
    |   NEW ID '[' exp ']' { $$ = new exp_new_list_node($2, $4); }
    ;
    

%%
int main(int argc, char *argv[]){
	///cout << "Under Constrction" << endl;
    yyparse();
    root->print();
    cout << endl;
    cout << "eval!!!!!" << endl;
    root->eval();
    return 0;
}

int yyerror(const char *s) {
	cout << "EEK, parse error!  Message: " << s << " Line: " << line_num  << " Column: " << column_num << " Current token: " << yytext << endl;
	// might as well halt now:
	exit(-1);
}
