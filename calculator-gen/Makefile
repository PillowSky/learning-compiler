all:
	bison -d main.y
	flex -o main.lex.c main.lex
	g++ -std=c++11 -Wall -march=native -O3 main.tab.c main.lex.c -o main.out -lfl -ly

clean:
	rm main.out main.lex.c main.tab.c main.tab.h
