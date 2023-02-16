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
      {printf("prog -> functions")}

functions: /*epsilon*/
           {printf("functions -> epsilon")}
         | functions function 
           {printf("functions -> functions function")}
function: FUNCT VAR_NAME FUNCT_PARAMS LPR declarations RPR LCB BEGINLOCAL declarations ENDLOCAL statements s_return RCB
          {printf("function -> FUNCT VAR_NAME FUNCT_PARAMS LPR declarations RPR LCB BEGINLOCAL declarations ENDLOCAL statements s_return RCB")}

declarations: /*epsilon*/
              {printf("declarations -> epsilon")}
            | declaration COMMA declarations
              {printf("declarations -> declaration COMMA declarations")}
declaration: type VAR_NAME LSB NUMBER RSB 
             {printf("declaration -> type VAR_NAME LSB NUMBER RSB")}
           | type VAR_NAME
             {printf("declaration -> type VAR_NAME")}

statements: statement SEMICOLON statements 
            {printf("statements -> statement SEMICOLON statements")}
          | statement SEMICOLON
            {printf("statements -> statement SEMICOLON")}
statement: s_assignment
           {printf("statement -> s_assignment")}
         | s_while 
           {printf("statement -> s_while")}
         | s_do 
           {printf("statement -> s_do")}
         | s_if 
           {printf("statement -> s_if")}            
         | s_else_if 
           {printf("statement -> s_else_if")}
         | s_print 
           {printf("statement -> s_print")}
         | s_println 
           {printf("statement -> s_println")}
         | s_read 
           {printf("statement -> s_read")}
         | s_return
           {printf("statement -> s_return")}

s_assignment: VAR_NAME ASSIGNMENT expression
            {printf("s_assignment -> VAR_NAME ASSIGNMENT expression")}
s_while: WHILE LPR relational RPR LCB statements RCB
            {printf("s_while -> WHILE LPR relational RPR LCB statements RCB")}
s_do: DO LCB statements RCB WHILE LPR relational RPR
            {printf("s_do -> DO LCB statements RCB WHILE LPR relational RPR")}
s_if: IF LPR relational RPR LCB statements RCB
            {printf("s_if -> IF LPR relational RPR LCB statements RCB")}
s_else_if: ELSE_IF LPR relational RPR LCB statements RCB
            {printf("s_else_if -> ELSE_IF LPR relational RPR LCB statements RCB")}
s_print: PRINT LPR expression RPR
            {printf("s_print -> PRINT LPR expression RPR")}
s_println: PRINTLN LPR expression RPR
            {printf("s_println -> PRINTLN LPR expression RPR")}
s_read: READ LPR VAR_NAME RPR
            {printf("s_read -> READ LPR VAR_NAME RPR")}
s_return: RETURN expression
            {printf("s_return -> RETURN expression")}

relational: expression comp expression 
            {printf("relational -> expression comp expression")}
          | TRUE 
            {printf("relational -> TRUE")}
          | FALSE
            {printf("relational -> FALSE")}

comp: LT 
        {printf("comp -> LT")}
    | LTE 
        {printf("comp -> LTE")}
    | GT 
        {printf("comp -> GT")}
    | GTE
        {printf("comp -> GTE")}
    | EQ 
        {printf("comp -> EQ")}
    | NEQ
        {printf("comp -> NEQ")}

expression: mulop 
            {printf("expression -> mulop")}
          | addop
            {printf("expression -> addop")}
mulop: mulop MULT term 
        {printf("mulop -> mulop MULT term")}
     | mulop DIV term 
        {printf("mulop -> mulop DIV term")}
     | mulop MOD term 
        {printf("mulop -> mulop MOD term")}
     | term
        {printf("mulop -> term")}
addop:/*epsilon*/
        {printf("addop -> epsilon")}
      |PLUS expression 
        {printf("addop -> PLUS expression")}
      | MINUS expression 
        {printf("addop -> MINUS expression")}

term: VAR_NAME 
        {printf("term -> VAR_NAME")}
    | NUMBER 
        {printf("term -> NUMBER")}
    | LPR expression RPR
        {printf("term -> LPR expression RPR")}

type: INT|BOOL
        {printf("type -> INT|BOOl|NONE")}

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
