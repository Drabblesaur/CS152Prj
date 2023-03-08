all:
	flex l_lang.lex
	bison -v -d --file-prefix=y l_lang.y
	g++ -o parser lex.yy.c y.tab.c -lfl

clean:
	rm -f parser lex.yy.c y.tab.c y.output y.tab.h
