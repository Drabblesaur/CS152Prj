lexer: l_lang.lex
	flex l_lang.lex	
	gcc -o lexer lex.yy.c -lfl
	$(info Input "cat test.l | lexer" for tests)
