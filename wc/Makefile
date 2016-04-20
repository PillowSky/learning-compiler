LEX 		= flex
CC		= gcc
CFLAGS		= -Wall -O2 -march=native
LDFLAGS		= -lfl

LEXS		= main.lex
SRCS		= main.c
PROG		= main.out

all:
	$(LEX) -o $(SRCS) $(LEXS)
	$(CC) $(CFLAGS) $(SRCS) $(LDFLAGS) -o $(PROG)

clean:
	rm $(PROG)
