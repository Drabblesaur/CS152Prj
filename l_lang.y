%{
#include <stdio.h>
#define YYERROR_VERBOSE 1
extern FILE* yyin;
extern int yylineno;
%}


%start prog
%token NUMBER VAR_NAME /* Custom REGEXs */
%token INT FACT BOOL MOD WHILE DO ELSE_IF IF ELSE PRINT PRINTLN READ RETURN FUNCT /* Reserved Keywords */ 
%token COMMA SEMICOLON LSB RSB LPR RPR LCB RCB ASSIGNMENT FUNCT_PARAMS /* Special Characters */
%token LT LTE GT GTE EQ NEQ /* Relational Operators */
%token PLUS MINUS MULT DIV  /* Arithemtic Operators */

%%
prog: /* epsilon */
    | function prog

function: FUNCT type VAR_NAME FUNCT_PARAMS LPR arguments RPR LCB statements RCB 

arguments: /* epsilon */
	 | s_declaration COMMA arguments
	 | s_declaration arguments

statements: /* epsilon */
	  | statement statements

statement: s_declarations
	 | s_assignment
         | s_while
         | s_do
         | s_if
         | s_print
         | s_println
         | s_read
         | s_return

s_declarations: s_declaration SEMICOLON
	      | s_declaration COMMA s_declarations
	      | s_declaration ASSIGNMENT expression SEMICOLON
	      | s_declaration ASSIGNMENT expression COMMA s_declarations

s_declaration: type VAR_NAME LSB NUMBER RSB
             | type VAR_NAME LSB RSB
	     | type VAR_NAME

s_assignment: VAR_NAME ASSIGNMENT expression SEMICOLON

s_while: WHILE LPR relational RPR LCB statements RCB

s_do: DO LCB statements RCB WHILE LPR relational RPR

s_if: IF LPR relational RPR LCB statements RCB SEMICOLON
    | IF LPR relational RPR LCB statements RCB s_else_if

s_else_if: ELSE_IF LPR relational RPR LCB statements RCB s_else_if
	 | ELSE LPR relational RPR LCB statements RCB SEMICOLON

s_print: PRINT LPR expression RPR SEMICOLON

s_println: PRINTLN LPR expression RPR SEMICOLON

s_read: READ LPR VAR_NAME RPR SEMICOLON

s_return: RETURN expression SEMICOLON

relational: expression comp expression

comp: LT
    | LTE
    | GT
    | GTE
    | EQ
    | NEQ

expression: mulop
	  | mulop PLUS mulop
	  | mulop MINUS mulop

mulop: term
     | mulop MULT term
     | mulop DIV term
     | mulop MOD term

term: VAR_NAME
    | NUMBER
    | LPR expression RPR
    | VAR_NAME LPR RPR
    | VAR_NAME LPR expression RPR

type: INT
    | BOOL
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

int yyerror(const char *str){
  printf("ERROR: %s (Line %d)\n",str,yylineno);
}
