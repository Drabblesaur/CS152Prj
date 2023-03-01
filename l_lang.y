%{
#include <stdio.h>
#include <string>
#include <vector>
#include <string.h>
#define YYERROR_VERBOSE 1
extern FILE* yyin;
extern int yylineno;

char *identToken;
int numberToken;
int  count_names = 0;


enum Type { Integer, Array };
struct Symbol {
  std::string name;
  Type type;
};
struct Function {
  std::string name;
  std::vector<Symbol> declarations;
};

std::vector <Function> symbol_table;


Function *get_function() {
  int last = symbol_table.size()-1;
  return &symbol_table[last];
}

bool find(std::string &value) {
  Function *f = get_function();
  for(int i=0; i < f->declarations.size(); i++) {
    Symbol *s = &f->declarations[i];
    if (s->name == value) {
      return true;
    }
  }
  return false;
}

void add_function_to_symbol_table(std::string &value) {
  Function f; 
  f.name = value; 
  symbol_table.push_back(f);
}

void add_variable_to_symbol_table(std::string &value, Type t) {
  Symbol s;
  s.name = value;
  s.type = t;
  Function *f = get_function();
  f->declarations.push_back(s);
}

void print_symbol_table(void) {
  printf("symbol table:\n");
  printf("--------------------\n");
  for(int i=0; i<symbol_table.size(); i++) {
    printf("function: %s\n", symbol_table[i].name.c_str());
    for(int j=0; j<symbol_table[i].declarations.size(); j++) {
      printf("  locals: %s\n", symbol_table[i].declarations[j].name.c_str());
    }
  }
  printf("--------------------\n");
}
%}

%union {
  char *op_val;
}

%start prog
%token NUMBER VAR_NAME /* Custom REGEXs */
%token INT FACT BOOL MOD WHILE DO ELSE_IF IF ELSE PRINT PRINTLN READ RETURN FUNCT /* Reserved Keywords */ 
%token COMMA SEMICOLON LSB RSB LPR RPR LCB RCB ASSIGNMENT FUNCT_PARAMS /* Special Characters */
%token LT LTE GT GTE EQ NEQ /* Relational Operators */
%token PLUS MINUS MULT DIV  /* Arithemtic Operators */

%%
prog: /* epsilon */
    | function prog

function: FUNCT type VAR_NAME
{
  // midrule:
  // add the function to the symbol table.
  std::string func_name = $3;
  add_function_to_symbol_table(func_name);
  printf("func %s\n", func_name.c_str());
}
  FUNCT_PARAMS LPR arguments RPR LCB statements RCB
{
  printf("endfunc\n")
}
arguments: /* epsilon */
	 | s_declaration COMMA arguments
	 | s_declaration arguments

statements: /* epsilon */
	  | statement statements

statement: s_declarations
	 | s_assignment
         | s_while
         | s_do
         | s_if
         | s_print
         | s_println
         | s_read
         | s_return

s_declarations: s_declaration SEMICOLON
	      | s_declaration COMMA s_declarations
	      | s_declaration ASSIGNMENT expression SEMICOLON
	      | s_declaration ASSIGNMENT expression COMMA s_declarations

s_declaration: type VAR_NAME LSB NUMBER RSB
             | type VAR_NAME LSB RSB
	           | type VAR_NAME
{
  // add the variable to the symbol table.
  std::string value = $2;
  printf(". %s\n", value.c_str())
  Type t = Integer;
  add_variable_to_symbol_table(value, t);
}

s_assignment: VAR_NAME ASSIGNMENT expression SEMICOLON
{
  std::string dst = $1;
  std::string src = $3;
  printf("= %s, %s\n", dst.c_str(), src.c_str());
}

s_while: WHILE LPR relational RPR LCB statements RCB

s_do: DO LCB statements RCB WHILE LPR relational RPR

s_if: IF LPR relational RPR LCB statements RCB SEMICOLON
    | IF LPR relational RPR LCB statements RCB s_else_if

s_else_if: ELSE_IF LPR relational RPR LCB statements RCB s_else_if
	 | ELSE LPR relational RPR LCB statements RCB SEMICOLON

s_print: PRINT LPR expression RPR SEMICOLON
{
  std::string src = $3;
  printf(".> %s\n", src.c_str());
}
s_println: PRINTLN LPR expression RPR SEMICOLON

s_read: READ LPR VAR_NAME RPR SEMICOLON

s_return: RETURN expression SEMICOLON

relational: expression comp expression

comp: LT
    | LTE
    | GT
    | GTE
    | EQ
    | NEQ

expression: mulop
	  | mulop PLUS mulop
{
  std::string dst = $0;
  std::string src1 = $1;
  std::string src2 = $3;
  printf("+, %s, %s, %s\n", dst.c_str(), src1.c_str(), src2.c_str());
}
	  | mulop MINUS mulop

mulop: term
     | mulop MULT term
     | mulop DIV term
     | mulop MOD term

term:VAR_NAME
{
  printf("symbol -> IDENT %s\n", $1)
  $$ = $1;
}
    | NUMBER
{
  printf("symbol -> NUMBER %s\n", $1)
  $$ = $1;
}
    | LPR expression RPR
    | VAR_NAME LPR RPR
    | VAR_NAME LPR expression RPR

type: INT
    | BOOL
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
