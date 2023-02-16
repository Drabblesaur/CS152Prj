%{
#include <stdio.h>
#include "y.tab.h"
%}

/* Keeps track of line number in file */
%option yylineno

/* Variable names are invalid when there is a number anywhere or an underscore at the end */
/* Single Line Comments start with '#' and continues until newline */
/* Multi Line Comments start with '#*' and continues until '*#' */

LETTER [a-zA-Z]
NUMBER [0-9]+
VAR_NAME (_|{LETTER})*{LETTER}
INVALID_VAR_NAME {VAR_NAME}_+|(({VAR_NAME}{NUMBER}|{NUMBER}{VAR_NAME})+{VAR_NAME}*)_*
COMMENT (#[^\n]*)|(#\*(.|\n)*\*#)

%%

{NUMBER} {return NUMBER;}
{COMMENT} {}
"INT" {return INT;}
"BOOL" {return BOOL;}
"MOD" {return MOD;}
"WHILE" {return WHILE;}
"DO" {return DO;}
"ELSE IF" {return ELSE_IF;}
"IF" {return IF;}
"ELSE" {return ELSE;}
"PRINT" {return PRINT;}
"PRINTLN" {return PRINT;}
"READ"  {return READ;}
"RETURN" {return RETURN;}
"FUNCT" {return FUNCT;}
"FACT" {return FACT;}
{VAR_NAME} {return VAR_NAME;}
{INVALID_VAR_NAME} {printf("ERROR: INVALID VARIABLE NAME \"%s\" (Line %d) \n", yytext, yylineno);}
";"  {return SEMICOLON;}
","  {return COMMA;}
"["  {return LSB;}
"]"  {return RSB;}
"("  {return LPR;}
")"  {return RPR;}
"{"  {return LCB;}
"}"  {return RCB;}
"->" {return ASSIGNMENT;}
"<-" {return FUNCT_PARAMS;}
"+"  {return PLUS;}
"-"  {return MINUS;}
"*"  {return MULT;}
"/"  {return DIV;}
"!"  {return FACT;}
"="  {return EQ;}
"~=" {return NEQ;}
">"  {return GT;}
">=" {return GTE;}
"<"  {return LT;}
"<=" {return LTE;}
"\n" {}
"\t" {}
" "  {}
.    {quit_error();}

%%

quit_error(void){
  printf("ERROR: UNKNOWN TOKEN\n");
  exit(1);
}
