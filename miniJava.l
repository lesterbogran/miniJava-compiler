%{
#include <cstdio>
#include <iostream>
#include <cmath>
using namespace std;
#define YY_DECL extern "C" int yylex()

#include "miniJava.tab.h"  // to get the token types that we return

%}
%%
[ \t\n]           ;
.                ;
%%
int yywrap(){
    return 1;
}
