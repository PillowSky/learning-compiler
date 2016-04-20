#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <float.h>

/*
Grammar: EBNF:
<exp> -> <term> { <addop> <term> }
<addop> -> + | -
<term> -> <factor> { <mulop> <factor> }
<mulop> -> * | /
#<factor> -> (exp) | Number
<factor> -> <base> { <powop> <base> }
<powop> -> ** | ^ | @
<base> -> (exp) | Number

*/
char token;
double exp(void);
double term(void);
double factor(void);
void match(char expectedToken);
char gettoken();
#define error(message) fprintf(stderr, "%s:%d: %s\n", __FILE__, __LINE__, message); exit(EXIT_FAILURE);

int main(int argc, char* argv[]) {
	double result;
	token = gettoken();

	result = exp();
	if (token == '\n') {
		printf("Result = %.17g\n", result);
	} else {
		error("main");
	}
	return EXIT_SUCCESS;
}

double exp(void) {
	double temp = term();
	while ((token == '+') || (token == '-')) {
		switch (token) {
			case '+': {
				match('+');
				temp += term();
				break;
			}
			case '-': {
				match('-');
				temp -= term();
				break;
			}
		}
	}
	return temp;
}

double term(void) {
	double temp = factor();
	while ((token == '*') || (token == '/')) {
		switch (token) {
			case '*': {
				match('*');
				temp *= factor();
				break;
			}
			case '/': {
				match('/');
				temp /= factor();
				break;
			}
		}
	}
	return temp;
}

double factor(void) {
	double temp;
	if (token == '(') {
		match('(');
		temp = exp();
		match(')');
	} else if (isdigit(token)) {
		ungetc(token, stdin);
		scanf("%lf", &temp);
		token = gettoken();
	} else {
		error("factor");
	}

	return temp;
}

void match(char expectedToken) {
	if (token == expectedToken) {
		token = gettoken();
	} else {
		error("match");
	}
}

char gettoken() {
	char c;
	do {
		c = getchar();
	} while ((c == ' ') || (c == '\t'));
	return c;
}
