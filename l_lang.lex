{\rtf1\ansi\ansicpg1252\cocoartf2707
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fnil\fcharset0 Menlo-Bold;\f1\fnil\fcharset0 Menlo-Regular;}
{\colortbl;\red255\green255\blue255;\red202\green51\blue35;\red0\green0\blue0;\red86\green32\blue244;
\red219\green39\blue218;\red135\green138\blue4;\red56\green185\blue199;\red57\green192\blue38;}
{\*\expandedcolortbl;;\cssrgb\c83899\c28663\c18026;\csgray\c0;\cssrgb\c41681\c25958\c96648;
\cssrgb\c89513\c29736\c88485;\cspthree\c60000\c60000\c18455;\cssrgb\c25546\c77007\c82023;\cssrgb\c25706\c77963\c19557;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural\partightenfactor0

\f0\b\fs22 \cf2 \CocoaLigature0 %\{
\f1\b0 \cf3 \

\f0\b \cf4 #include \cf5 <stdio.h>
\f1\b0 \cf3 \
\

\f0\b \cf2 %\}
\f1\b0 \cf3 \
\

\f0\b \cf2 NUMBER
\f1\b0 \cf3  
\f0\b \cf4 [0-9]+
\f1\b0 \cf3 \

\f0\b \cf2 VAR_NAME
\f1\b0 \cf3  
\f0\b \cf4 (_*[a-zA-Z]*)+
\f1\b0 \cf3 \

\f0\b \cf2 COMMENT
\f1\b0 \cf3  
\f0\b \cf4 #[0-9a-zA-Z\\[\\], ]*
\f1\b0 \cf3 \
\
\cb6 %%\cb1 \
\

\f0\b \cf7 \{NUMBER\}
\f1\b0 \cf3  
\f0\b \cf2 \{
\f1\b0 \cf3 printf(
\f0\b \cf5 "NUMBER \cf2 %s\\n\cf5 "
\f1\b0 \cf3 , yytext);
\f0\b \cf2 \}
\f1\b0 \cf3 \

\f0\b \cf5 "\cf7 INT\cf5 "
\f1\b0 \cf3  
\f0\b \cf2 \{
\f1\b0 \cf3 printf(
\f0\b \cf5 "INTEGER\cf2 \\n\cf5 "
\f1\b0 \cf3 );
\f0\b \cf2 \}
\f1\b0 \cf3 \

\f0\b \cf7 \{VAR_NAME\}
\f1\b0 \cf3  
\f0\b \cf2 \{
\f1\b0 \cf3 printf(
\f0\b \cf5 "VAR_NAME \cf2 %s\\n\cf5 "
\f1\b0 \cf3 , yytext);
\f0\b \cf2 \}
\f1\b0 \cf3 \

\f0\b \cf7 \{COMMENT\}
\f1\b0 \cf3  
\f0\b \cf2 \{
\f1\b0 \cf3 printf(
\f0\b \cf5 "COMMENT \cf2 %s\\n\cf5 "
\f1\b0 \cf3 ,yytext);
\f0\b \cf2 \}
\f1\b0 \cf3 \

\f0\b \cf5 "\cf7 ;\cf5 "
\f1\b0 \cf3   
\f0\b \cf2 \{
\f1\b0 \cf3 printf(
\f0\b \cf5 "SEMICOLON\cf2 \\n\cf5 "
\f1\b0 \cf3 );
\f0\b \cf2 \}
\f1\b0 \cf3 \

\f0\b \cf5 "\cf7 ,\cf5 "
\f1\b0 \cf3   
\f0\b \cf2 \{
\f1\b0 \cf3 printf(
\f0\b \cf5 "COMMA\cf2 \\n\cf5 "
\f1\b0 \cf3 );
\f0\b \cf2 \}
\f1\b0 \cf3 \

\f0\b \cf5 "\cf7 [\cf5 "
\f1\b0 \cf3   
\f0\b \cf2 \{
\f1\b0 \cf3 printf(
\f0\b \cf5 "ARY_SUB_L\cf2 \\n\cf5 "
\f1\b0 \cf3 );
\f0\b \cf2 \}
\f1\b0 \cf3 \

\f0\b \cf5 "\cf7 ]\cf5 "
\f1\b0 \cf3   
\f0\b \cf2 \{
\f1\b0 \cf3 printf(
\f0\b \cf5 "ARY_SUB_R\cf2 \\n\cf5 "
\f1\b0 \cf3 );
\f0\b \cf2 \}
\f1\b0 \cf3 \

\f0\b \cf5 "\cf7 ->\cf5 "
\f1\b0 \cf3  
\f0\b \cf2 \{
\f1\b0 \cf3 printf(
\f0\b \cf5 "ASSIGNMENT\cf2 \\n\cf5 "
\f1\b0 \cf3 );
\f0\b \cf2 \}
\f1\b0 \cf3 \

\f0\b \cf5 "\cf7 +\cf5 "
\f1\b0 \cf3   
\f0\b \cf2 \{
\f1\b0 \cf3 printf(
\f0\b \cf5 "PLUS\cf2 \\n\cf5 "
\f1\b0 \cf3 );
\f0\b \cf2 \}
\f1\b0 \cf3 \

\f0\b \cf5 "\cf7 -\cf5 "
\f1\b0 \cf3   
\f0\b \cf2 \{
\f1\b0 \cf3 printf(
\f0\b \cf5 "MINUS\cf2 \\n\cf5 "
\f1\b0 \cf3 );
\f0\b \cf2 \}
\f1\b0 \cf3 \

\f0\b \cf5 "\cf7 *\cf5 "
\f1\b0 \cf3   
\f0\b \cf2 \{
\f1\b0 \cf3 printf(
\f0\b \cf5 "MULT\cf2 \\n\cf5 "
\f1\b0 \cf3 );
\f0\b \cf2 \}
\f1\b0 \cf3 \

\f0\b \cf5 "\cf7 /\cf5 "
\f1\b0 \cf3   
\f0\b \cf2 \{
\f1\b0 \cf3 printf(
\f0\b \cf5 "DIV\cf2 \\n\cf5 "
\f1\b0 \cf3 );
\f0\b \cf2 \}
\f1\b0 \cf3 \

\f0\b \cf5 "\cf7 \\n\cf5 "
\f1\b0 \cf3  
\f0\b \cf2 \{\}
\f1\b0 \cf3 \

\f0\b \cf5 "\cf7  \cf5 "
\f1\b0 \cf3   
\f0\b \cf2 \{\}
\f1\b0 \cf3 \

\f0\b \cf7 .
\f1\b0 \cf3     
\f0\b \cf2 \{
\f1\b0 \cf3 quit_error();
\f0\b \cf2 \}
\f1\b0 \cf3 \
\
\cb6 %%\cb1 \
\
main(
\f0\b \cf8 void
\f1\b0 \cf3 )\{\
  printf(
\f0\b \cf5 "Ctrl-D to exit\cf2 \\n\cf5 "
\f1\b0 \cf3 );\
  yylex();\
\}\
\
quit_error(
\f0\b \cf8 void
\f1\b0 \cf3 )\{\
  printf(
\f0\b \cf5 "ERROR: UNKNOWN TOKEN\cf2 \\n\cf5 "
\f1\b0 \cf3 );\
  exit(
\f0\b \cf5 1
\f1\b0 \cf3 );\
\}\
}