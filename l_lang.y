%{
#include <stdio.h>
extern FILE* yyin;
%}

%start prog
%token NUMBER VAR_NAME /* Custom REGEXs */
%token INT MOD WHILE DO ELSE_IF IF ELSE PRINT READ RETURN NONE FUNCT /* Reserverd Keywords */ 
%token COMMA SEMICOLON COLON RSB LSB RPR LPR LCB RCB ASSIGNMENT FUNCT_PARAMS /* Special Characters */
%token LT LTE GT GTE EQ NEQ /* Relational Operators */
%token PLUS MINUS MULT DIV FACT /* Arithemtic Operators */

%%
prog: /* epsilon */ {printf("prog -> epsilon\n");} 

%%

void main(int argc, char** argv){
  if(argc>=2){
    yyin = fopen(argv[1], "r");
    if(yyin == NULL)
      yyin = stdin;
  }else{
    yyin = stdin;
  }
  yyparse();
}

int yyerror(){};
