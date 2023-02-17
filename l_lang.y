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
prog: /* epsilon */ {printf("prog -> epsilon\n");}
    | function prog {printf("prog -> functions prog\n");}

function: FUNCT type VAR_NAME FUNCT_PARAMS LPR arguments RPR LCB statements RCB {printf("function -> FUNCT type VAR_NAME FUNCT_PARAMS LPR arguments RPR LCB statements RCB\n");}

arguments: /* epsilon */ {printf("arguments -> epsilon\n");}
	 | argument COMMA arguments {printf("arguements -> argument COMMA arguments\n");}

argument: type VAR_NAME LSB NUMBER RSB {printf("argument -> type VAR_NAME LSB NUMBER RSB\n");}
        | type VAR_NAME {printf("argument -> type VAR_NAME\n");}

statements: /* epsilon */ {printf("statements -> epsilon\n");}
	  | statement statements {printf("statements -> statement statements\n");}

statement: s_declarations {printf("statement -> s_declarations\n");}
	 | s_assignment {printf("statement -> s_assignment\n");}
         | s_while {printf("statement -> s_while\n");}
         | s_do {printf("statement -> s_do\n");}
         | s_if {printf("statement -> s_if\n");}            
         | s_print {printf("statement -> s_print\n");}
         | s_println {printf("statement -> s_println\n");}
         | s_read {printf("statement -> s_read\n");}
         | s_return {printf("statement -> s_return\n");}

s_declarations: /* epsilon */ {printf("declarations -> epsilon\n");}
              | s_declaration SEMICOLON s_declarations {printf("declarations -> declaration SEMICOLON declarations\n");}

s_declaration: type VAR_NAME LSB NUMBER RSB {printf("declaration -> type VAR_NAME LSB NUMBER RSB\n");}
           | type VAR_NAME {printf("declaration -> type VAR_NAME\n");}

s_assignment: VAR_NAME ASSIGNMENT expression SEMICOLON{printf("s_assignment -> VAR_NAME ASSIGNMENT expression SEMICOLON\n");}

s_while: WHILE LPR relational RPR LCB statements RCB {printf("s_while -> WHILE LPR relational RPR LCB statements RCB\n");}

s_do: DO LCB statements RCB WHILE LPR relational RPR {printf("s_do -> DO LCB statements RCB WHILE LPR relational RPR\n");}

s_if: IF LPR relational RPR LCB statements RCB SEMICOLON {printf("s_if -> IF LPR relational RPR LCB statements RCB SEMICOLON\n");}
    | IF LPR relational RPR LCB statements RCB s_else_if {printf("IF LPR relational RPR LCB statements RCB s_else_if\n");}

s_else_if: ELSE_IF LPR relational RPR LCB statements RCB s_else_if  {printf("s_else_if -> ELSE_IF LPR relational RPR LCB statements RCB s_else_if\n");}
	 | ELSE LPR relational RPR LCB statements RCB SEMICOLON {printf("s_else_if -> ELSE_IF LPR relational RPR LCB statements RCB SEMICOLON\n");}

s_print: PRINT LPR expression RPR SEMICOLON {printf("s_print -> PRINT LPR expression RPR\n");}

s_println: PRINTLN LPR expression RPR SEMICOLON {printf("s_println -> PRINTLN LPR expression RPR\n");}

s_read: READ LPR VAR_NAME RPR SEMICOLON {printf("s_read -> READ LPR VAR_NAME RPR\n");}

s_return: RETURN expression SEMICOLON {printf("s_return -> RETURN expression\n");}

relational: expression comp expression {printf("relational -> expression comp expression\n");}

comp: LT {printf("comp -> LT\n");}
    | LTE {printf("comp -> LTE\n");}
    | GT {printf("comp -> GT\n");}
    | GTE {printf("comp -> GTE\n");}
    | EQ  {printf("comp -> EQ\n");}
    | NEQ {printf("comp -> NEQ\n");}

expression: mulop {printf("experssion -> mulop\n");} 
	  | mulop PLUS mulop  {printf("expression -> mulop PLUS mulop\n");}
	  | mulop MINUS mulop  {printf("expression -> mulop MINUS mulop\n");}

mulop: term {printf("mulop -> term\n");}
     | mulop MULT term {printf("mulop -> mulop MULT term\n");}
     | mulop DIV term {printf("mulop -> mulop DIV term\n");}
     | mulop MOD term {printf("mulop -> mulop MOD term\n");}

term: VAR_NAME {printf("term -> VAR_NAME\n");}
    | NUMBER {printf("term -> NUMBER\n");}
    | LPR expression RPR {printf("term -> LPR expression RPR\n");}
    | VAR_NAME LPR RPR {printf("term -> VAR_NAME LPR RPR\n");}
    | VAR_NAME LPR expression RPR {printf("term -> VAR_NAME LPR expression RPR\n");}

type: INT {printf("type -> INT\n");}
    | BOOL {printf("type -> BOOL\n");}
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
