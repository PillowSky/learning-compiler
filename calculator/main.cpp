#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <math.h>

/* Grammar(EBNF):
	<exp> -> <term> { <addop> <term> }
	<addop> -> + | -
	<term> -> <factor> { <mulop> <factor> }
	<mulop> -> * | /
	<factor> -> <base> { <powop> <base> }
	<powop> -> ^ | @ | % | ** | //
	<base> -> (exp) | Number
*/

char token;
double exp();
double term();
double factor();
double base();
void next();
#define error(message) fprintf(stderr, "%s:%d: Error: %s\n", __FILE__, __LINE__, message); exit(EXIT_FAILURE);

int main(int argc, char* argv[]) {
	printf("Nano Calculator (build: %s %s)\n", __DATE__, __TIME__);
	printf(">>> ");

	next();
	double value = exp();

	if (token == '\n') {
		printf("%.17g\n", value);
	} else {
		error("incomplete line");
	}
	return EXIT_SUCCESS;
}

double exp() {
	double value = term();
	while (true) {
		switch (token) {
			case '+': {
				next();
				value += term();
				break;
			}
			case '-': {
				next();
				value -= term();
				break;
			}
			default: {
				return value;
			}
		}
	}
}

double term() {
	double value = factor();
	while (true) {
		switch (token) {
			case '*': {
				next();
				value *= factor();
				break;
			}
			case '/': {
				next();
				value /= factor();
				break;
			}
			default: {
				return value;
			}
		}
	}
}

double factor() {
	double value = base();
	while (true) {
		switch (token) {
			case '^': {
				next();
				value = pow(value, base());
				break;
			}
			case '@': {
				next();
				value = pow(value, 1.0 / base());
				break;
			}
			case '%': {
				next();
				value = fmod(value, base());
				break;
			}
			case '*': {
				next();
				if (token == '*') {
					next();
					value = pow(value, base());
				} else {
					ungetc(token, stdin);
					token = '*';
					return value;
				}
			}
			case '/': {
				next();
				if (token == '/') {
					next();
					value = int(value / factor());
				} else {
					ungetc(token, stdin);
					token = '/';
					return value;
				}
			}
			default: {
				return value;
			}
		}
	}
}

double base() {
	char sign = 1;
	double value;
	if (token == '(') {
		next();
		value = exp();
		if (token == ')') {
			next();
		} else {
			error("unmatched parentheses");
		}
	} else {
		if (token == '-') {
			sign = -1;
			next();
		}
		if (isdigit(token)) {
			ungetc(token, stdin);
			scanf("%lf", &value);
			next();
		} else {
			error("numeric value error");
		}
	}
	return sign * value;
}

void next() {
	do {
		token = getchar();
	} while ((token == ' ') || (token == '\t'));
}
