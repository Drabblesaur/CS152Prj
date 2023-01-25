%{
#include <stdio.h>
%}

/* Keeps track of line number in file */
%option yylineno

/* Variable names are invalid when there is a number anywhere or an underscore at the end */
/* Single Line Comments start with '#' and continues until newline */
/* Multi Line Comments start with '#*' and continues until '*#' */

LETTER [a-zA-Z]
NUMBER [0-9]+
VAR_NAME (_|{LETTER})*{LETTER}
INVALID_VAR_NAME {VAR_NAME}_
COMMENT (#[^\n]*)|(#\*(.|\n)*\*#)

%%

{NUMBER} {printf("NUMBER %s\n", yytext);}
{COMMENT} {}
"INT" {printf("INTEGER\n");}
"MOD" {printf("REMAINDER\n");}
"WHILE" {printf("WHILE\n");}
"DO" {printf("DO\n");}
"ELSE IF" {printf("ELSE_IF\n");}
"IF" {printf("IF\n");}
"ELSE" {printf("ELSE\n");}
"PRINT" {printf("PRINT\n");}
"READ"  {printf("READ\n");}
"RETURN" {printf("RETURN\n");}
"NONE" {printf("NONE\n");}
"FUNCT" {printf("FUNCTION_CALL\n");}
{VAR_NAME} {printf("VAR_NAME %s\n", yytext);}
{INVALID_VAR_NAME} {printf("ERROR: INVALID VARIABLE NAME \"%s\" (Line %d) \n", yytext, yylineno);}
";"  {printf("SEMICOLON\n");}
","  {printf("COMMA\n");}
"["  {printf("SQUARE_BRACKET_L\n");}
"]"  {printf("SQUARE_BRACKET_R\n");}
"("  {printf("PARAN_L\n");}
")"  {printf("PARAN_R\n");}
"{"  {printf("CURLY_BRACKET_L\n");}
"}"  {printf("CURLY_BRACKET_R\n");}
"->" {printf("ASSIGNMENT\n");}
"<-" {printf("FUNCTION_PARAMS\n");}
"+"  {printf("PLUS\n");}
"-"  {printf("MINUS\n");}
"*"  {printf("MULT\n");}
"/"  {printf("DIV\n");}
"="  {printf("EQUAL\n");}
"~=" {printf("NOT_EQUAL\n");}
">"  {printf("GREATER_THAN\n");}
">=" {printf("GREATER_THAN_OR_EQUAL\n");}
"<"  {printf("LESS_THAN\n");}
"<=" {printf("LESS_THAN_OR_EQUAL\n");}
"\n" {}
"\t" {}
" "  {}
.    {quit_error();}

%%

main(void){
  printf("Ctrl-D to exit\n");
  yylex();
}

quit_error(void){
  printf("ERROR: UNKNOWN TOKEN\n");
  exit(1);
}
