%{
#include <stdio.h>
extern FILE* yyin;
%}

%start prog
%token NUMBER VAR_NAME /* Custom REGEXs */
%token INT MOD WHILE DO ELSE_IF IF ELSE PRINT PRINTLN READ RETURN NONE FUNCT BEGINBODY ENDBODY BEGINLOCAL ENDLOCAL /* Reserved Keywords */ 
%token COMMA SEMICOLON COLON RSB LSB RPR LPR LCB RCB ASSIGNMENT FUNCT_PARAMS /* Special Characters */
%token LT LTE GT GTE EQ NEQ /* Relational Operators */
%token PLUS MINUS MULT DIV  /* Arithemtic Operators */

%%
prog: function
      {printf("prog -> function\n")}

function: FUNCT identifier LPR declarations RPR LCB BEGINBODY BEGINLOCAL declaration ENDLOCAL statement ENDBODY RETURN identifier RCB
          {printf("function -> identifier RPR declarations LPR LCB BEGINBODY BEGINLOCAL declaration ENDLOCAL statement ENDBODY RETURN identifier RCB")}

identifier: identifier
              {printf("identifier -> identifier")}
           | identifier identifier
              {printf("identifier -> identifier identifier ")}


declarations: declaration declarations
                {printf("declarations -> declaration declarations")}

declaration: identifier COLON INT [NUMBER]: identifier COLON INT
                {printf("declaration -> identifier COLON INT [NUMBER]: identifier COLON INT")}

statements: statement statements | statement SEMICOLON
statement: variable
              {printf("statement -> VAR")}
          | WHILE_stmt 
              {printf("statement -> WHILE_stmt")}
          | DO_stmt 
              {printf("statement -> DO_stmt")}
          | IF_stmt 
              {printf("statement -> IF_stmt")}
          | ELSE_IF_stmt 
              {printf("statement -> ELSE_IF_stmt")}
          | PRINT_stmt 
              {printf("statement -> PRINT_stmt")}
          | PRINTLN_stmt 
              {printf("statement -> PRINTLN_stmt")}
          | BOOL_stmt
              {printf("statement -> BOOL_stmt")}
WHILE_stmt: WHILE LPR declarations RPR LCB statements RCB
            {printf("WHILE_stmt -> WHILE LPR declarations RPR LCB statements RCB")}
DO_stmt: DO LCB statements RCB WHILE LPR declarations RPR
            {printf("DO_stmt -> DO LCB statements RCB WHILE LPR declarations RPR")}
IF_stmt: 
ELSE_IF_stmt:
PRINT_stmt: PRINT VAR_NAME
            {printf("PRINT_stmt -> PRINT VAR_NAME")}
PRINTLN_stmt: PRINTLN VAR_NAME
            {printf("PRINTLN_stmt -> PRINTLN VAR_NAME")}
BOOL_stmt: relational | BOOl | 


relational: relationals | relational relational
realtions: r_op|expression
r_op: EQ | NEQ | GT | GTE | LT | LTE
expression: mulop | addop
mulop: term | term MULT mulop | term DIV mulop | term MOD mulop 
addop: PLUS expression | MINUS expression | /*epislon*/

term: MINUS variable | variable | MINUS NUMBER | NUMBER | LPR expression RPR
variable: identifier | identifier LSB expression RSB 

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
