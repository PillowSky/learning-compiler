/* Grammar(EBNF):
	<statement> -> <identifier> = <expression>
	<identifier> -> $[a-zA-Z0-9_]{[a-zA-Z0-9_]}
	<expression> -> <term> { <addop> <term> }
	<addop> -> + | -
	<term> -> <factor> { <mulop> <factor> }
	<mulop> -> * | /
	<factor> -> <base> { <powop> <base> }
	<powop> -> ^ | @ | % | ** | //
	<base> -> (expression) | <identifier> | NUMBER
*/

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <math.h>
#include <unordered_map>
#include <stdexcept>

using namespace std;

char token;
unordered_map<string, double> symbol;

double expression();
double term();
double factor();
double base();
void next();
#define error(message) fprintf(stderr, "%s:%d: Error: %s\n", __FILE__, __LINE__, message); throw runtime_error(message);

int main(int argc, char* argv[]) {
	printf("Nano Calculator (build: %s %s)\n", __DATE__, __TIME__);

	while (true) {
		try {
			printf(">>> ");
			next();
			double value;

			switch (token) {
				case '$': {
					char buffer[256];
					if (scanf("%255[a-zA-Z0-9_]", buffer)) {
						next();
						switch (token) {
							case '=': {
								next();
								value = expression();
								symbol[buffer] = value;
								break;
							}
							case '\n': {
								if (symbol.find(buffer) != symbol.end()) {
									value = symbol[buffer];
								} else {
									ungetc(token, stdin);
									error("undefined identifier");
								}
								break;
							}
							default: {
								if (symbol.find(buffer) != symbol.end()) {
									ungetc(token, stdin);
									string literal = to_string(symbol[buffer]);
									for (auto rit = literal.rbegin(); rit != literal.rend(); rit++) {
										ungetc(*rit, stdin);
									}
									next();
									value = expression();
								} else {
									error("undefined identifier");
								}
							}
						}
					} else {
						error("invalid identifier");
					}
					break;
				}
				case '\n': {
					continue;
				}
				default: {
					value = expression();
				}
			}

			if (token == '\n') {
				printf("%.17g\n", value);
			} else {
				error("incomplete line");
			}
		} catch (runtime_error& e) {
			char c;
			while((c = getchar()) != '\n' && c != EOF);
		}
	}

	return EXIT_SUCCESS;
}

double expression() {
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
				break;
			}
			case '/': {
				next();
				if (token == '/') {
					next();
					value = int(value / base());
				} else {
					ungetc(token, stdin);
					token = '/';
					return value;
				}
				break;
			}
			default: {
				return value;
			}
		}
	}
}

double base() {
	double value;
	if (token == '(') {
		next();
		value = expression();
		if (token == ')') {
			next();
		} else {
			error("unmatched parentheses");
		}
	} else if (token == '$') {
		char buffer[256];
		if (scanf("%255[a-zA-Z0-9_]", buffer)) {
			next();
			if (symbol.find(buffer) != symbol.end()) {
				value = symbol[buffer];
			} else {
				error("undefined identifier");
			}
		} else {
			error("invalid identifier");
		}
	} else {
		if (isdigit(token) || token == '-') {
			ungetc(token, stdin);
			if (scanf("%lf", &value)) {
				next();
			} else {
				error("numeric scan error");
			}
		} else {
			error("numeric value error");
		}
	}

	return value;
}

void next() {
	do {
		token = getchar();
	} while ((token == ' ') || (token == '\t'));
}
