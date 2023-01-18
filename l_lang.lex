%{
#include <stdio.h>

%}

NUMBER [0-9]+
VAR_NAME (_*[a-zA-Z]*)+
COMMENT #[0-9a-zA-Z\[\], ]*

%%

{NUMBER} {printf("NUMBER %s\n", yytext);}
"INT" {printf("INTEGER\n");}
{VAR_NAME} {printf("VAR_NAME %s\n", yytext);}
{COMMENT} {printf("COMMENT %s\n",yytext);}
";"  {printf("SEMICOLON\n");}
","  {printf("COMMA\n");}
"["  {printf("ARY_SUB_L\n");}
"]"  {printf("ARY_SUB_R\n");}
"->" {printf("ASSIGNMENT\n");}
"+"  {printf("PLUS\n");}
"-"  {print:f("MINUS\n");}
"*"  {printf("MULT\n");}
"/"  {printf("DIV\n");}
"\n" {}
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
