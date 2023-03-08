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
int count_temps = 0;
int count_c_labels = 0;
int count_b_labels = 0;
int count_e_labels = 0;
int count_if_labels = 0;
int count_endif_labels = 0;
int count_else_labels = 0;
FILE* f = stdout;

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
  sstm << std::string("_temp") << count_temps++;
  return sstm.str();
}

std::string decl_temp_code(std::string &temp){
  CodeNode *node = new CodeNode;
  node->name = temp;
  node->code = "";
  node->code = std::string(". ") + temp + std::string("\n");
  return node->code;
}

std::string create_label(){
  std::stringstream sstm;
  sstm << std::string("beginloop") << count_c_labels++;
  return sstm.str();
}

std::string end_label(){
  std::stringstream sstm;
  sstm << std::string("endloop") << count_e_labels++;
  return sstm.str();
}

std::string body_label(){
  std::stringstream sstm;
  sstm << std::string("loopbody") << count_b_labels++;
  return sstm.str();
}


std::string decl_label(std::string &temp_labels){
  CodeNode *node = new CodeNode;
  node->name = temp_labels;
  node->code = "";
  node->code = temp_labels + std::string("\n");
  return node->code;
}

std::string if_label(){
  std::stringstream sstm;
  sstm << std::string("if_true") << count_if_labels++;
  return sstm.str();
}

std::string endif_label(){
  std::stringstream sstm;
  sstm << std::string("endif") << count_endif_labels++;
  return sstm.str();
}

std::string else_label(){
  std::stringstream sstm;
  sstm << std::string("else") << count_else_labels++;
  return sstm.str();
}

%}

%union {
  struct CodeNode *code_node;
  char *op_val;
  int int_val;
}

%start prog
/* Custom REGEXs */
%token <op_val> NUMBER VAR_NAME 
%token INT FACT BOOL MOD WHILE DO ELSE_IF IF ELSE PRINT PRINTLN READ RETURN FUNCT /* Reserved Keywords */ 
%token COMMA SEMICOLON LSB RSB LPR RPR LCB RCB ASSIGNMENT FUNCT_PARAMS /* Special Characters */
%token LT LTE GT GTE EQ NEQ /* Relational Operators */
%token PLUS MINUS MULT DIV /* Arithemtic Operators */
%type <code_node> functions function
%type <code_node> arguments
%type <code_node> statements statement
%type <code_node> s_declarations s_declaration s_assignment s_params
%type <code_node> s_while s_do
%type <code_node> s_if s_else s_else_if
%type <code_node> s_print s_println s_read
%type <code_node> s_return
%type <code_node> expression mulop term

%%
prog: 
  functions
  {
    CodeNode *code_node = $1;
    FILE *f;
    f = fopen("test.mil", "w");
    if(f!=NULL){
      printf("%s\n", code_node->code.c_str());
      fprintf(f,"%s\n", code_node->code.c_str());
      fclose(f);
    }
  };

functions: 
  /* epsilon */
  {
    CodeNode *node = new CodeNode;
    $$ = node;
  }
  | function functions
  {
    CodeNode *function = $1;
    CodeNode *functions = $2;
    CodeNode *node = new CodeNode;
    node->code = function->code + functions->code;
    $$ = node;
  };

function: 
  FUNCT type VAR_NAME
  { //Midrule to add function to symbol table
    CodeNode *node = new CodeNode;
    std::string func_name = $3;
    add_function_to_symbol_table(func_name); 
    node->code = std::string("func ") + func_name + std::string("\n");
    $<code_node>$ = node;
  }
  FUNCT_PARAMS LPR arguments RPR LCB statements RCB
  {
    CodeNode *node = new CodeNode;
    CodeNode *startfunc = $<code_node>4;
    CodeNode *arguments = $7;
    CodeNode *statements = $10;
    node->code = startfunc->code + arguments->code + statements->code + std::string("endfunc\n\n");
    $$ = node;
  }

arguments: 
  /* epsilon */
  {
    CodeNode *node = new CodeNode;
    count_names = 0;
    $$ = node;
  }
  | s_declaration COMMA arguments
  {
    std::stringstream sstm;
    sstm << std::string("$") << count_names++;
    CodeNode *node = new CodeNode;
    CodeNode *s_declaration = $1;
    CodeNode *arguments = $3;
    node->code = s_declaration->code;
    node->code += arguments->code;
    node->code += std::string("= ") + s_declaration->name + std::string(", ") + sstm.str() + std::string("\n");
    $$ = node;
  }
  | s_declaration arguments
  {
    std::stringstream sstm;
    sstm << std::string("$") << count_names++;
    CodeNode *node = new CodeNode;
    CodeNode *s_declaration = $1;
    CodeNode *arguments = $2;
    node->code = s_declaration->code;
    node->code += arguments->code;
    node->code += std::string("= ") + s_declaration->name + std::string(", ") + sstm.str() + std::string("\n");
    $$ = node;
  };

statements:
  /* epsilon */
  {
    CodeNode *node = new CodeNode;
    $$ = node;
  }
	| statement statements{
    CodeNode *statement = $1;
    CodeNode *statements = $2;
    CodeNode *node = new CodeNode;
    node->code = statement->code + statements->code;
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
    std::string id = $2;
    std::string n = $4;
    Type t = Integer;
    add_variable_to_symbol_table(id,t);
    node->code = std::string(".[] ") + id + std::string(", ") + n + std::string("\n");
    node->name = $2;
    $$ = node;
  }
  | type VAR_NAME LSB RSB
  {
    CodeNode *node = new CodeNode;
    std::string id = $2;
    Type t = Integer;
    add_variable_to_symbol_table(id,t);
    node->code = std::string(".[] ") + id + std::string(", 0\n");
    node->name = $2;
    $$ = node;
  }
	| type VAR_NAME
  {
    CodeNode *node = new CodeNode;
    std::string id = $2;
    Type t = Integer;
    add_variable_to_symbol_table(id,t);
    node->code = std::string(". ") + id + std::string("\n");
    node->name = $2;
    $$ = node;
  };

s_assignment: 
  VAR_NAME ASSIGNMENT expression 
  {
    CodeNode *node = new CodeNode;
    CodeNode *expression = $3;
    std::string id = $1;
    if(!find(id))yyerror((std::string("'") + $1 + std::string("' has not been declared")).c_str());
    node->code = expression->code;
    node->code += std::string("= ") + id + std::string(", ") + expression->name + std::string("\n");
    $$ = node;
  }
  | VAR_NAME LSB NUMBER RSB ASSIGNMENT expression
  {
    CodeNode *node = new CodeNode;
    CodeNode *expression = $6;
    std::string id = $1;
    std::string n = $3;
    if(!find(id))yyerror((std::string("'") + $1 + std::string("' has not been declared")).c_str());
    node->code = expression->code;
    node->code += std::string("[]= ") + id + std::string(", ") + n + std::string(", ") + expression->name + std::string("\n");
    $$ = node;
  }

s_while: 
  WHILE LPR relational RPR LCB statements RCB
  {
    s_while: 
  WHILE LPR relational RPR LCB statements RCB  
  {
    CodeNode *node = new CodeNode;
    CodeNode *relational = $3;
    CodeNode *statements = $6;
    std::string c_label = create_label();
    std::string b_label = body_label();
    std::string e_label = end_label();
    //std::string temp1_label = create_label();
    //std::string temp2_label = body_label();
    //std::string temp3_label = end_label();    

    node->code = std::string (": ") + c_label + std::string("\n");
    node->code += relational->code;
    node->code += std::string("?:= ") + b_label + std::string(", ") + relational->name;
    node->code += "\n";
    node->code += std::string(":= ") + e_label + std::string("\n");
    node->code += std::string(": ") + b_label + std::string("\n");
    node->code += statements->code;
    node->code += std::string(":= ") + decl_label(c_label);
    node->code += std::string(": ") + e_label + std::string("\n");

    $$ = node;
  }

s_do: 
  DO LCB statements RCB WHILE LPR relational RPR
  {
    CodeNode *node = new CodeNode;
    $$ = node;
  }
s_if:  
  IF LPR relational RPR LCB statements RCB 
  { 
    printf("THIS IS IF\n");
    CodeNode *node = new CodeNode;
    CodeNode *relational = $3;
    CodeNode *statements = $6;
    std::string if_true = if_label();
    std::string endif = endif_label();
    node->code = std::string("?:= ") + if_true + std::string(", ") + relational->name + std::string("\n");

    $$ = node;
  }
  | IF LPR relational RPR LCB statements RCB s_else_if
  { 
    printf("THIS IS IF then ELSEIF\n");
    CodeNode* node = new CodeNode;
    $$ = node;
  } 
  |IF LPR relational RPR LCB statements RCB s_else
  { 
    //printf("THIS IS IF then ELSE\n");
    CodeNode *node = new CodeNode;
    CodeNode *relational = $3;
    CodeNode *statements = $6;
    CodeNode *s_else = $8;
    std::string if_true = if_label();
    std::string endif = endif_label();
    
    node->code = statements->name + relational->code;
    node->code += std::string("?:= ") + if_true + std::string(", ") + relational->name +std::string("\n");
    node->code += std::string(": ") + s_else->name + std::string("\n");
    node->code += if_true + std::string("\n");
    node->code += statements->code;  
    node->code += std::string(":= ") + endif + std::string("\n");
    node->code += s_else->code + std::string("\n");
    $$ = node;
  }
  
s_else:
  ELSE LCB statements RCB
  { 
    //printf("THIS IS ELSE\n");
    CodeNode *node = new CodeNode;
    CodeNode *statements = $3;
    std::string then = else_label();
    std::string endifs = endif_label();
    
    node->code = std::string(":= ") + then + std::string("\n");
    node->code += statements->code; 
    node->code += std::string(": ") + endifs;
    node->name = then;
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
  | PRINT LPR VAR_NAME LSB expression RSB RPR SEMICOLON
  {
    CodeNode *node = new CodeNode;
    CodeNode *expression = $5;
    std::string id = $3;
    node->code = std::string(".[]> ") + id + std::string(", ") + expression->name + std::string("\n");
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
    std::string id = $3;
    node->code = std::string(".< ") + id + std::string("\n");
    $$ = node;
  }
  | READ LPR VAR_NAME LSB expression RSB RPR SEMICOLON
  {
    CodeNode *node = new CodeNode;
    CodeNode *expression = $5;
    std::string id = $3;
    node->code = std::string(".[]< ") + id + std::string(", ") + expression->code + std::string("\n");
    $$ = node;
  }

s_return: 
  RETURN expression SEMICOLON
  {
    CodeNode *node = new CodeNode;
    CodeNode *expression = $2;
    node->code = expression->code;
    node->code += std::string("ret ") + expression->name + std::string("\n");
    $$ = node;
  }

s_params: 
  /* epsilon */
  {
    CodeNode *node = new CodeNode;
    $$ = node;
  }
  | expression COMMA s_params
  {
    CodeNode *node = new CodeNode;
    CodeNode *expression= $1;
    CodeNode *s_params = $3;
    node->code = std::string("param ") + expression->name + std::string("\n");
    node->code += expression->code + s_params->code;
    node->name = expression->name;
    $$ = node;
  }
  | expression s_params
  {
    CodeNode *node = new CodeNode;
    CodeNode *expression= $1;
    CodeNode *s_params = $2;
    node->code = std::string("param ") + expression->name + std::string("\n");
    node->code += expression->code + s_params->code;
    node->name = expression->name;
    $$ = node;
  };


relational: 
  expression comp expression
  {
    CodeNode *node = new CodeNode;
    CodeNode *expr1 = $1; 
    CodeNode *expr2 = $3;
    std::string temp = create_temp();
    node->code = expr1->code + expr2->code + decl_temp_code(temp);
    node->code += std::string("< ") + temp + std::string(", ") + expr1->name + std::string(", ") + expr2->name + std::string("\n");
    node->name = temp;
    $$ = node;
  }

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
    if(!find(id))yyerror((std::string("'") + $1 + std::string("' has not been declared")).c_str());
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
    node->code = expression->code;
    node->name = expression->name;
    $$ = node;
  }
  | VAR_NAME LPR s_params RPR
  {
    CodeNode *node = new CodeNode;
    CodeNode *s_params = $3;
    std::string id = $1;
    std::string temp = create_temp();
    node->code = s_params->code + decl_temp_code(temp);
    node->code += std::string("call ") + id + std::string(", ") + temp + std::string("\n");
    node->name = temp;
    $$ = node;
  }
  | VAR_NAME LSB expression RSB
  {
    CodeNode *node = new CodeNode;
    CodeNode *expression = $3;
    std::string id = $1;
    std::string temp = create_temp();
    node->code = expression->code + decl_temp_code(temp);
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
  exit(0);
}
