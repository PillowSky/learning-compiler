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

%{
#include <math.h>
#include <stdio.h>
#include <ctype.h>
int yylex(void);
void yyerror(char* message);
%}

%define api.value.type {double}
%token NUM
%left '-' '+'
%left '*' '/'
%precedence NEG
%right '^'        
%start input

%%

input: %empty
	 | input line
	 ;

line: '\n'
	| exp '\n' { printf("%.17g\n", $1); printf(">>> "); }
;

exp: NUM { $$ = $1; }
	| exp '+' exp { $$ = $1 + $3; }
	| exp '-' exp { $$ = $1 - $3; }
	| exp '*' exp { $$ = $1 * $3; }
	| exp '/' exp { $$ = $1 / $3; }
	| '-' exp  %prec NEG { $$ = -$2; }
	| exp '^' exp { $$ = pow ($1, $3); }
	| '(' exp ')' { $$ = $2; }
	;

%%

void yyerror(char* message) {
	fprintf(stderr, "%s\n", message);
}

int main(int argc, char* argv[]) {
	printf("Nano Calculator (build: %s %s)\n", __DATE__, __TIME__);
	printf(">>> ");
	return yyparse();
}
