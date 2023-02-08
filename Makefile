all:
	flex l_lang.lex
	bison -v -d --file-prefix=y l_lang.y
	gcc -o parser lex.yy.c y.tab.c -lfl

clean:
	rm -f parser lex.yy.c y.tab.c
