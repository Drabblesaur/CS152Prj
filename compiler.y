%{
#include <stdio.h>
extern FILE* yyin;
%}

%start prog_start
%token INT SEMICOLON IDENT LBR RBR COMMA LPR RPR


%%
prog_start: /* epsilon */ {printf("prog_start->epsilon\n");}
        | functions {printf("prog_start -> functions\n");}


functions: function {printf("function -> function\n");} 
        | function functions {printf("function -> function functions\n");}


function: INT IDENT LPR arguments RPR LBR statements RBR {printf("function: INT IDENT LPR arguments RPR LBR statements RBR\n");}

arguments: argument  {printf("arguments -> arguments\n");}
        |  COMMA arguments {printf("arguments -> COMMA arguments\n");}

argument: /*epsilon*/ {printf("argument ->: epsilon\n");}
        | INT IDENT {printf("argument -> INT IDNET\n");}

statements: /*epsilon*/ {printf("statements -> epsilon\n");}
        | statement SEMICOLON statements {printf("statements -> statement SEMICOLON statements\n");}

statement: /*epsilon*/ {printf("statement -> epsilson\n");}

%%


void main(int argc, char** argv){
        if(argc >= 2){
                yyin = fopen(argv[1], "r");
                if(yyin == NULL)
                        yyin = stdin;
        }
        else{
                yyin = stdin;
        }
        yyparse();

}

int yyerror(){}

