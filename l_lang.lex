%{
#include <stdio.h>
%}

NUMBER [0-9]+
VAR_NAME (_*[a-zA-Z]*)+
COMMENT #[^\n]*

%%

{NUMBER} {printf("NUMBER %s\n", yytext);}
{COMMENT} {}
"INT" {printf("INTEGER\n");}
"MOD" {printf("REMAINDER\n");}
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
