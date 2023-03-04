%{
#include "CodeNode.h"
#include <stdio.h>
#include <string>
#include <vector>
#include <string.h>
#include <sstream>
#define YYERROR_VERBOSE 1
extern int yylex(void);
extern FILE* yyin;
extern int yylineno;

extern int yylex(void);
int yyerror(const char *msg);

char *identToken;
int numberToken;
int count_names = 0;

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

std::string create_temp(){
  std::stringstream sstm;
  sstm << std::string("_temp") << count_names++;
  return sstm.str();
}

std::string decl_temp_code(std::string &temp){
  CodeNode *node = new CodeNode;
  node->name = temp;
  node->code = "";
  node->code = std::string(". ") + temp + std::string("\n");
  return node->code;
}
%}

%union {
  struct CodeNode *code_node;
  char *op_val;
  int int_val;
}

%start prog
/* Custom REGEXs */
%token <op_val> NUMBER 
%token <op_val> VAR_NAME 
%token INT FACT BOOL MOD WHILE DO ELSE_IF IF ELSE PRINT PRINTLN READ RETURN FUNCT /* Reserved Keywords */ 
%token COMMA SEMICOLON LSB RSB LPR RPR LCB RCB ASSIGNMENT FUNCT_PARAMS /* Special Characters */
%token LT LTE GT GTE EQ NEQ /* Relational Operators */
%token PLUS MINUS MULT DIV /* Arithemtic Operators */
%type <code_node> functions
%type <code_node> function
%type <code_node> arguments
%type <code_node> statements
%type <code_node> statement
%type <code_node> s_declarations
%type <code_node> s_declaration
%type <code_node> s_assignment
%type <code_node> s_while
%type <code_node> s_do
%type <code_node> s_if
%type <code_node> s_else_if
%type <code_node> s_print
%type <code_node> s_println
%type <code_node> s_read
%type <code_node> s_return
%type <code_node> expression
%type <code_node> mulop
%type <code_node> term

%%
prog: 
  functions
  {
    CodeNode *code_node = $1;
    printf("%s\n", code_node->code.c_str());
  };

functions: 
  /* epsilon */
  {
    CodeNode *node = new CodeNode;
    $$ = node;
  }
  | function functions
  {
    CodeNode *code_node1 = $1;
    CodeNode *code_node2 = $2;
    CodeNode *node = new CodeNode;
    node->code = code_node1->code + code_node2->code;
    $$ = node;
  };

function: 
  FUNCT type VAR_NAME FUNCT_PARAMS LPR arguments RPR LCB statements RCB
  {
    CodeNode *node = new CodeNode;
    CodeNode *arguments = $6;
    CodeNode *statements = $9;
    std::string func_name = $3;
    add_function_to_symbol_table(func_name);
    node->code = "";
    node->code += std::string("func ") + func_name + std::string("\n");
    node->code += arguments->code;
    node->code += statements->code;
    node->code += std::string("endfunc\n");
    $$ = node;
  };

arguments: 
  /* epsilon */
  {
    CodeNode *node = new CodeNode;
    $$ = node;
  }
  | s_declaration COMMA arguments
  {
    CodeNode *node = new CodeNode;
    CodeNode *s_declaration = $1;
    CodeNode *arguments = $3;
    node->code = "";
    node->code += s_declaration->code;
    node->code += arguments->code;
    $$ = node;
  }
  | s_declaration arguments
  {
    CodeNode *node = new CodeNode;
    CodeNode *s_declaration = $1;
    CodeNode *arguments = $2;
    node->code = "";
    node->code += s_declaration->code;
    node->code += arguments->code;
    $$ = node;
  };

statements:
  /* epsilon */
  {
    CodeNode *node = new CodeNode;
    $$ = node;
  }
	| statement statements{
    CodeNode *code_node1 = $1;
    CodeNode *code_node2 = $2;
    CodeNode *node = new CodeNode;
    node->code = code_node1->code + code_node2->code;
    $$ = node;
  };

statement: 
  s_declarations
  {
    CodeNode *node = new CodeNode;
    CodeNode *s_declarations = $1;
    node->code = s_declarations->code;
    $$ = node;
  }
  | s_while
  {
    CodeNode *node = new CodeNode;
    CodeNode *s_while = $1;
    node->code = s_while->code;
    $$ = node;
  }
  | s_do
  {
    CodeNode *node = new CodeNode;
    CodeNode *s_do = $1;
    node->code = s_do->code;
    $$ = node;
  }
  | s_if
  {
    CodeNode *node = new CodeNode;
    CodeNode *s_if = $1;
    node->code = s_if->code;
    $$ = node;
  }
  | s_print
  {
    CodeNode *node = new CodeNode;
    CodeNode *s_print = $1;
    node->code = s_print->code;
    $$ = node;
  }
  | s_println
  {
    CodeNode *node = new CodeNode;
    CodeNode *s_println = $1;
    node->code = s_println->code;
    $$ = node;
  }
  | s_read
  {
    CodeNode *node = new CodeNode;
    CodeNode *s_read = $1;
    node->code = s_read->code;
    $$ = node;
  }
  | s_return
  {
    CodeNode *node = new CodeNode;
    CodeNode *s_return = $1;
    node->code = s_return->code;
    $$ = node;
  }

s_declarations: 
  s_declaration SEMICOLON
  {
    CodeNode *node = new CodeNode;
    CodeNode *s_declaration = $1;
    node->code = s_declaration->code;
    $$ = node;
  }
	| s_declaration COMMA s_declarations
  {
    CodeNode *node = new CodeNode;
    CodeNode *s_declaration = $1;
    CodeNode *s_declarations = $3;
    node->code = s_declaration->code + s_declarations->code;
    $$ = node;
  }
	| s_assignment SEMICOLON
  {
    CodeNode *node = new CodeNode;
    CodeNode *s_assignment = $1;
    node->code = s_assignment->code;
    $$ = node;
  }
	| s_assignment COMMA s_declarations
  {
    CodeNode *node = new CodeNode;
    CodeNode *s_assignment = $1;
    CodeNode *s_declarations = $3;
    node->code = s_assignment->code + s_declarations->code;
    $$ = node;
  }

s_declaration: 
  type VAR_NAME LSB NUMBER RSB
  {
    CodeNode *node = new CodeNode;
    std::string name = $2;
    std::string n = $4;
    node->code = std::string(".[] ") + name + std::string(", ") + n + std::string("\n");
    $$ = node;
  }
  | type VAR_NAME LSB RSB
  {
    CodeNode *node = new CodeNode;
    std::string name = $2;
    node->code = std::string(".[] ") + name + std::string(", 0\n");
    $$ = node;
  }
	| type VAR_NAME
  {
    CodeNode *node = new CodeNode;
    std::string name = $2;
    node->code = std::string(". ") + name + std::string("\n");
    $$ = node;
  };

s_assignment: 
  VAR_NAME ASSIGNMENT expression 
  {
    CodeNode *node = new CodeNode;
    CodeNode *expression = $3;
    std::string id = $1;
    node->code = "";
    node->code += expression->code;
    node->code += std::string("= ") + id + std::string(", ") + expression->name + std::string("\n");
    $$ = node;
  }
  | VAR_NAME LSB NUMBER RSB ASSIGNMENT expression
  {
    CodeNode *node = new CodeNode;
    CodeNode *expression = $6;
    std::string name = $1;
    std::string n = $3;
    //std::string temp = create_temp();
    node->code = "";
    node->code += expression->code;
    node->code += std::string("[]= ") + name + std::string(", ") + n + std::string(", ") + expression->name + std::string("\n");
    //node->code += decl_temp_code(temp) + std::string("=[] ") + temp + std::string(", ") + name + std::string(", ") + n + std::string("\n");
    $$ = node;
  }

s_while: 
  WHILE LPR relational RPR LCB statements RCB
  {
    CodeNode *node = new CodeNode;
    $$ = node;
  }

s_do: 
  DO LCB statements RCB WHILE LPR relational RPR
  {
    CodeNode *node = new CodeNode;
    $$ = node;
  }

s_if: 
  IF LPR relational RPR LCB statements RCB SEMICOLON
  {
    CodeNode *node = new CodeNode;
    $$ = node;
  }
  | IF LPR relational RPR LCB statements RCB s_else_if
  {
    CodeNode *node = new CodeNode;
    $$ = node;
  }

s_else_if: 
  ELSE_IF LPR relational RPR LCB statements RCB s_else_if
  {
    CodeNode *node = new CodeNode;
    $$ = node;
  }
	| ELSE LPR relational RPR LCB statements RCB SEMICOLON
  {
    CodeNode *node = new CodeNode;
    $$ = node;
  }

s_print: 
  PRINT LPR expression RPR SEMICOLON
  {
    CodeNode *node = new CodeNode;
    CodeNode *expression = $3;
    node->code = expression->code;
    node->code += std::string(".> ") + expression->name + std::string("\n");
    $$ = node;
  }
  | PRINT LPR VAR_NAME LSB NUMBER RSB RPR SEMICOLON
  {
    CodeNode *node = new CodeNode;
    std::string name = $3;
    std::string n = $5; 
    node->code = "";
    node->code += std::string(".[]> ") + name + std::string(", ") + n + std::string("\n");
    $$ = node;
  }
s_println: 
  PRINTLN LPR expression RPR SEMICOLON
  {
    CodeNode *node = new CodeNode;
    CodeNode *expression = $3;
    node->code = expression->code;
    node->code += std::string(".> ") + expression->name + std::string("\n");
    $$ = node;
  }

s_read: 
  READ LPR VAR_NAME RPR SEMICOLON
  {
    CodeNode *node = new CodeNode;
    $$ = node;
  }

s_return: 
  RETURN expression SEMICOLON
  {
    CodeNode *node = new CodeNode;
    $$ = node;
  }

relational: expression comp expression

comp: LT
    | LTE
    | GT
    | GTE
    | EQ
    | NEQ

expression: 
  mulop
  {
    CodeNode *node = new CodeNode;
    CodeNode *mulop = $1;
    node->code = "";
    node->code += mulop->code;
    node->name = mulop->name;
    $$ = node;
  }
	| mulop PLUS mulop
  {
    CodeNode *node = new CodeNode;
    CodeNode *mulop1 = $1;
    CodeNode *mulop2 = $3;
    std::string temp = create_temp();
    node->code = mulop1->code + mulop2->code + decl_temp_code(temp);
    node->code += std::string("+ ") + temp + std::string(", ") + mulop1->name + std::string(", ") + mulop2->name + std::string("\n");
    node->name = temp;
    $$ = node;
  }
	| mulop MINUS mulop
  {
    CodeNode *node = new CodeNode;
    CodeNode *mulop1 = $1;
    CodeNode *mulop2 = $3;
    std::string temp = create_temp();
    node->code = mulop1->code + mulop2->code + decl_temp_code(temp);
    node->code += std::string("- ") + temp + std::string(", ") + mulop1->name + std::string(", ") + mulop2->name + std::string("\n");
    node->name = temp;
    $$ = node;
  }

mulop: 
  term
  {
    CodeNode *node = new CodeNode;
    CodeNode *term = $1;
    node->code = term->code;
    node->name = term->name;
    $$ = node;
  }
  | mulop MULT term
  {
    CodeNode *node = new CodeNode;
    CodeNode *mulop = $1;
    CodeNode *term = $3;
    std::string temp = create_temp();
    node->code = mulop->code + term->code + decl_temp_code(temp);
    node->code += std::string("* ") + temp + std::string(", ") + mulop->name + std::string(", ") + term->name + std::string("\n");
    node->name = temp;
    $$ = node;
  }
  | mulop DIV term
  {
    CodeNode *node = new CodeNode;
    CodeNode *mulop = $1;
    CodeNode *term = $3;
    std::string temp = create_temp();
    node->code = mulop->code + term->code + decl_temp_code(temp);
    node->code += std::string("/ ") + temp + std::string(", ") + mulop->name + std::string(", ") + term->name + std::string("\n");
    node->name = temp;
    $$ = node;
  }
  | mulop MOD term
  {
    CodeNode *node = new CodeNode;
    CodeNode *mulop = $1;
    CodeNode *term = $3;
    std::string temp = create_temp();
    node->code = mulop->code + term->code + decl_temp_code(temp);
    node->code += std::string("% ") + temp + std::string(", ") + mulop->name + std::string(", ") + term->name + std::string("\n");
    node->name = temp;
    $$ = node;
  }

term: 
  VAR_NAME
  {
    CodeNode *node = new CodeNode;
    std::string id = $1;
    node->code = "";
    node->name = $1;
    $$ = node;
  }
  | NUMBER
  {
    CodeNode *node = new CodeNode;
    std::string val = $1;
    node->code = "";
    node->name = val;
    $$ = node;
  }
  | LPR expression RPR
  {
    CodeNode *node = new CodeNode;
    CodeNode *expression = $2;
    node->code = "";
    node->code += expression->code;
    node->name = expression->name;
    $$ = node;
  }
  | VAR_NAME LSB RSB
  {
    CodeNode *node = new CodeNode;
    $$ = node;
  }
  | VAR_NAME LSB expression RSB
  {
    CodeNode *node = new CodeNode;
    CodeNode *expression = $3;
    std::string id = $1;
    std::string temp = create_temp();
    node->code = "";
    node->code += expression->code + decl_temp_code(temp);
    node->code += std::string("=[] ") + temp + std::string(", ") + id + std::string(", ") + expression->name + std::string("\n");
    node->name = temp;
    $$ = node;
  }

type: INT
    | BOOL
%%

int main(int argc, char** argv){
  if(argc>=2){
    yyin = fopen(argv[1], "r");
    if(yyin == NULL)
      yyin = stdin;
  }else{
    yyin = stdin;
  }
  yyparse();
  //print_symbol_table();
}

int yyerror(const char *str){
  printf("ERROR: %s (Line %d)\n",str,yylineno);
}
