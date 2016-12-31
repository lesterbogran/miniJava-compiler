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
extern int RUNNING_TYPE;

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
    state_node *statenode;
    vector<state_node *> *statelistnode;
    vector<exp_node *> *explistnode;
    type_node *minitypenode;
    var_declare_node *vardeclarenode;
    method_declare_node *methoddeclarenode;
    vector<method_declare_node *> *methodlistnode;
    class_declare_node *classdeclarenode;
    vector<class_declare_node *>*classlistnode;
    pgm *prog;
}

%token <num> NUMBER
%token <id> ID
%token NEW
%token TRUE
%token FALSE
%token THIS
%token LENGTH
%token VOID
%token STATIC
%token CLASS
%token EXTENDS
%token PUBLIC
%token RETURN
%token IF
%token ELSE
%token WHILE
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
%type <methodlistnode> methodlist
%type <statelistnode> vardeclares
%type <statelistnode> statelist
%type <statelistnode> states
%type <explistnode> explist
%type <statenode> state
%type <minitypenode> minitype
%type <vardeclarenode> vardeclare
%type <methoddeclarenode> methoddeclare
%type <classdeclarenode> classdeclare
%type <classlistnode> classlist
%type <prog> program

%%
program : classlist { $$ = new pgm($1); root = $$; }
;
///program : vardeclares methodlist { $$ = new pgm($1, $2); root = $$; }
///;


classlist : classlist classdeclare { $$ = $1; $1->push_back($2); }
    | { $$ = new vector<class_declare_node *>(); }
    ;

classdeclare : CLASS ID LBRACE vardeclares methodlist RBRACE { $$ = new class_declare_node($2, $4, $5); }
    |  CLASS ID EXTENDS ID LBRACE vardeclares methodlist RBRACE { $$ = new class_declare_node($2, $6, $7); }
;


methodlist : methodlist methoddeclare { $$ = $1; $1->push_back($2); }
    |   { $$ = new vector<method_declare_node *>(); }
    ;


methoddeclare :        PUBLIC STATIC VOID ID 
                       LPAREN vardeclares RPAREN 
                       LBRACE statelist RBRACE 
                       { $$ = new method_declare_node($4, $6, $9, new exp_num_node(0)); }
   |        PUBLIC STATIC minitype ID 
                       LPAREN vardeclares RPAREN 
                       LBRACE statelist
                       RETURN exp ';' RBRACE 
                       { $$ = new method_declare_node($4, $6, $9, $11); }
                       
    |                  PUBLIC minitype ID 
                       LPAREN vardeclares RPAREN 
                       LBRACE statelist
                       RETURN exp ';' RBRACE 
                       { $$ = new method_declare_node($3, $5, $8, $10); }
;


vardeclares : vardeclares vardeclare { $$ = $1; $1->push_back($2); }
    |   { $$ = new vector<state_node *>(); }
    ;

vardeclare : STATIC vardeclare {{ $$ = $2; }}
    | minitype ID ';' {{ $$ = new var_declare_node($1, $2); }}
    | ',' minitype ID {{ $$ = new var_declare_node($2, $3); }}
    | minitype ID {{ $$ = new var_declare_node($1, $2); }}
;

minitype : ID  {{ $$ = new type_node($1); }}
    |   ID '[' ']' {{ $$ = new type_list_node($1); }}
    ;


states : LBRACE statelist RBRACE { $$ = $2; }
    | state { vector<state_node *>* tmp = new vector<state_node *>();
              tmp->push_back($1); $$ = tmp; };
;

statelist : statelist state { $$ = $1; $1->push_back($2); }
    |   { $$ = new vector<state_node *>(); }
    ;

state : vardeclare { $$ = $1; }
    |   IF LPAREN exp RPAREN states ELSE states { $$ = new state_if_node($3, $5, $7); }
    |   WHILE LPAREN exp RPAREN states { $$ = new state_while_node($3, $5); }
    |   PRINT LPAREN exp RPAREN ';' { $$ = new state_print_node($3); }
    |   ID ASSIGN exp ';' { $$ = new state_assign_node($1, $3); }
    |   ID '[' exp ']' ASSIGN exp ';' { $$ = new state_list_assign_node($1, $3, $6); }
    |   ';' { $$ = new state_nop_node(); }
    ;
    
explist: explist ',' exp { $$ = $1; $1->push_back($3); }
    |  exp { $$ = new vector<exp_node *>(); $$->push_back($1); }
    | { $$ = new vector<exp_node *>(); }
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
    |   ID '[' exp ']' { $$ = new exp_at_node($1, $3); }
    |   TRUE { $$ = new exp_num_node(1); }
    |   FALSE { $$ = new exp_num_node(0); }
    |   THIS {  $$ = new exp_id_node("this"); }
    |   exp '.' LENGTH { $$ = new exp_length_node($1); }
    |   exp '.' ID LPAREN explist RPAREN { $$ = new exp_num_node(0); }
    |   exp '.' ID LPAREN RPAREN { $$ = new exp_num_node(1); }
    |   NEW ID LPAREN RPAREN { $$ = new exp_new_node($2); }
    |   NEW ID '[' exp ']' { $$ = new exp_new_list_node($2, $4); }
	|	LPAREN exp RPAREN  { $$ = $2; }
    ;
    

%%
void help(int argc, char *argv[]){
    cout << "Usage: " << argv[0] << " -r x.java" << endl;
    cout << "( run x.java )" << endl;
    cout << "Or: " << argv[0] << " -p x.java" << endl;
    cout << "( print human-readable AST of x.java )" << endl;
    cout << "Or: " << argv[0] << " -t x.java" << endl;
    cout << "( print AST of x.java )" << endl;
    cout << "Or: " << argv[0] << " -h" << endl;
    cout << "( show this help message )" << endl;
    
}
int main(int argc, char *argv[]){
	///cout << "Under Constrction" << endl;
    RUNNING_TYPE=0;
    if(argc>1){
        if(argv[1][1]=='t')RUNNING_TYPE=2;
        if(argv[1][1]=='p')RUNNING_TYPE=1;
        if(argv[1][1]=='r')RUNNING_TYPE=0;
        if(argv[1][1]=='h'){
            help(argc, argv);
            return 0;
        }
        FILE *myfile = fopen(argv[2], "r");
        yyin = myfile;
    }else{
        help(argc, argv);return 0;
    }
    ///yyparse();
    do {
		yyparse();
	} while (!feof(yyin));
    root->print();
    cout << endl;
    if(RUNNING_TYPE==0){
        cout << "running!!!!!" << endl;
        root->eval();
    }
    return 0;
}

int yyerror(const char *s) {
	cout << "EEK, parse error!  Message: " << s << " Line: " << line_num  << " Column: " << column_num << " Current token: " << yytext << endl;
	// might as well halt now:
	exit(-1);
}
