%{
#include <stdio.h>
extern FILE* yyin;
%}

%start prog
%token NUMBER VAR_NAME /* Custom REGEXs */
%token INT BOOL MOD WHILE DO ELSE_IF IF ELSE PRINT PRINTLN READ RETURN FUNCT BEGINLOCAL ENDLOCAL /* Reserved Keywords */ 
%token COMMA SEMICOLON RSB LSB RPR LPR LCB RCB ASSIGNMENT FUNCT_PARAMS /* Special Characters */
%token LT LTE GT GTE EQ NEQ TRUE FALSE /* Relational Operators */
%token PLUS MINUS MULT DIV  /* Arithemtic Operators */

%%
prog: functions
      {printf("prog -> functions\n");}

functions: /*epsilon*/
           {printf("functions -> epsilon\n");}
         | functions function 
           {printf("functions -> functions function\n");}
function: FUNCT VAR_NAME FUNCT_PARAMS LPR declarations RPR LCB BEGINLOCAL declarations ENDLOCAL statements s_return RCB
          {printf("function -> FUNCT VAR_NAME FUNCT_PARAMS LPR declarations RPR LCB BEGINLOCAL declarations ENDLOCAL statements s_return RCB\n");}

declarations: /*epsilon*/
              {printf("declarations -> epsilon\n");}
            | declaration COMMA declarations
              {printf("declarations -> declaration COMMA declarations\n");}
declaration: type VAR_NAME LSB NUMBER RSB 
             {printf("declaration -> type VAR_NAME LSB NUMBER RSB\n");}
           | type VAR_NAME
             {printf("declaration -> type VAR_NAME\n");}

statements: statement SEMICOLON statements 
            {printf("statements -> statement SEMICOLON statements\n");}
          | statement SEMICOLON
            {printf("statements -> statement SEMICOLON\n");}
statement: s_assignment
           {printf("statement -> s_assignment\n");}
         | s_while 
           {printf("statement -> s_while\n");}
         | s_do 
           {printf("statement -> s_do\n");}
         | s_if 
           {printf("statement -> s_if\n");}            
         | s_else_if 
           {printf("statement -> s_else_if\n");}
         | s_print 
           {printf("statement -> s_print\n");}
         | s_println 
           {printf("statement -> s_println\n");}
         | s_read 
           {printf("statement -> s_read\n");}
         | s_return
           {printf("statement -> s_return\n");}

s_assignment: VAR_NAME ASSIGNMENT expression
            {printf("s_assignment -> VAR_NAME ASSIGNMENT expression\n");}
s_while: WHILE LPR relational RPR LCB statements RCB
            {printf("s_while -> WHILE LPR relational RPR LCB statements RCB\n");}
s_do: DO LCB statements RCB WHILE LPR relational RPR
            {printf("s_do -> DO LCB statements RCB WHILE LPR relational RPR\n");}
s_if: IF LPR relational RPR LCB statements RCB
            {printf("s_if -> IF LPR relational RPR LCB statements RCB\n");}
s_else_if: ELSE_IF LPR relational RPR LCB statements RCB
            {printf("s_else_if -> ELSE_IF LPR relational RPR LCB statements RCB\n");}
s_print: PRINT LPR expression RPR
            {printf("s_print -> PRINT LPR expression RPR\n");}
s_println: PRINTLN LPR expression RPR
            {printf("s_println -> PRINTLN LPR expression RPR\n");}
s_read: READ LPR VAR_NAME RPR
            {printf("s_read -> READ LPR VAR_NAME RPR\n");}
s_return: RETURN expression
            {printf("s_return -> RETURN expression\n");}

relational: expression comp expression 
            {printf("relational -> expression comp expression\n");}
          | TRUE 
            {printf("relational -> TRUE\n");}
          | FALSE
            {printf("relational -> FALSE\n");}

comp: LT 
        {printf("comp -> LT\n");}
    | LTE 
        {printf("comp -> LTE\n");}
    | GT 
        {printf("comp -> GT\n");}
    | GTE
        {printf("comp -> GTE\n");}
    | EQ 
        {printf("comp -> EQ\n");}
    | NEQ
        {printf("comp -> NEQ\n");}

expression: mulop 
            {printf("expression -> mulop\n");}
          | addop
            {printf("expression -> addop\n");}
mulop: mulop MULT term 
        {printf("mulop -> mulop MULT term\n");}
     | mulop DIV term 
        {printf("mulop -> mulop DIV term\n");}
     | mulop MOD term 
        {printf("mulop -> mulop MOD term\n");}
     | term
        {printf("mulop -> term\n");}
addop:/*epsilon*/
        {printf("addop -> epsilon\n");}
      |PLUS expression 
        {printf("addop -> PLUS expression\n");}
      | MINUS expression 
        {printf("addop -> MINUS expression\n");}

term: VAR_NAME 
        {printf("term -> VAR_NAME\n");}
    | NUMBER 
        {printf("term -> NUMBER\n");}
    | LPR expression RPR
        {printf("term -> LPR expression RPR\n");}

type: INT
        {printf("type -> INT\n");}
    |BOOL
        {printf("type -> BOOL\n");}

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
