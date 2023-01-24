%{
#include <stdio.h>
%}

LETTER [a-zA-Z]
NUMBER [0-9]+
VAR_NAME (_*{LETTER}*)*{LETTER}
COMMENT ?s:(#[^\n]*)|(#\*.*\*#)

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
"SCAN"  {printf("SCAN\n");}
"RETURN" {printf("RETURN\n");}
"NONE" {printf("NONE\n");}
{VAR_NAME} {printf("VAR_NAME %s\n", yytext);}
";"  {printf("SEMICOLON\n");}
","  {printf("COMMA\n");}
"["  {printf("SQUARE_BRACKET_L\n");}
"]"  {printf("SQUARE_BRACKET_R\n");}
"("  {printf("PARAN_L\n");}
")"  {printf("PARAN_R\n");}
"{"  {printf("CURLY_BRACKET_L\n");}
"}"  {printf("CURLY_BRACKET_R\n");}
"->" {printf("ASSIGNMENT\n");}
"<-" {printf("FUNCTION_PARAMS");}
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
