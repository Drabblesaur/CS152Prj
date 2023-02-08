%{
#include <stdio.h>
extern FILE* yyin;
%}

%start prog
%token NUMBER VAR_NAME /* Custom REGEXs */
%token INT MOD WHILE DO ELSE_IF IF ELSE PRINT READ RETURN NONE FUNCT /* Reserverd Keywords */ 
%token COMMA SEMICOLON COLON RSB LSB RPR LPR LCB RCB  /* Other Characters */
/* Right precedence (ex: INT a = 45, group "= 45" instead of "a =" first */
%right ASSIGNMENT FUNCT_PARAMS
/* Left precedence (ex: 1+2*3, group "1+2" instead of "2*3" first */
%left LT LTE GT GTE EQ NEQ FACT
%left PLUS MINUS
%left MULT DIV

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
