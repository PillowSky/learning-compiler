all:
	flex -o main.lex.c main.lex
	bison main.y
	g++ -std=c++11 -Wall -march=native -O3 main.tab.c -o main.out -lfl -ly

clean:
	rm main.out main.lex.c main.tab.c
