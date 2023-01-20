a.out: l_lang.lex
	flex l_lang.lex	
	gcc -o a.out lex.yy.c -lfl
