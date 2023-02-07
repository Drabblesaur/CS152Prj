%{
#include "y.tab.h"
%}

%%

int             {return INT;}
;               {return SEMICOLON;}
[a-zA-Z]+       {return IDENT;}
"{"             {return LBR;}
"}"             {return RBR;}
","             {return COMMA;}
"("             {return LPR;}
")"             {return RPR;}
"\n"            {}
[ \t]+          {}

%%
