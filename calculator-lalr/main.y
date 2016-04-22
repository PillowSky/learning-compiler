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
#include <stdio.h>
#include <math.h>
#include <unordered_map>

using namespace std;
unordered_map<string, double> symbol;

int yylex(void);
void yyerror(char* message);
%}

%define api.value.type union
%token <double> NUM
%token <char*> VAR
%type <double> exp

%token POWER
%token DIVI

%precedence '='
%left '-' '+'
%left '*' '/'
%precedence NEG
%right '^' '@' '%' POWER DIVI
%start input

%%

input: %empty
	 | input line
	 ;

line: '\n' { printf(">>> "); }
	| exp '\n' { printf("%.17g\n", $1); printf(">>> "); }
	| error '\n' { yyerrok; printf(">>> "); }
;

exp: NUM { $$ = $1; }
	| VAR { if (symbol.find($1) != symbol.end()) { $$ = symbol[$1]; } else { $$ = 0; yyerror("undefined identifier"); }; delete[] $1; }
	| VAR '=' exp { $$ = symbol[$1] = $3; delete[] $1; }
	| exp '+' exp { $$ = $1 + $3; }
	| exp '-' exp { $$ = $1 - $3; }
	| exp '*' exp { $$ = $1 * $3; }
	| exp '/' exp { $$ = $1 / $3; }
	| '-' exp  %prec NEG { $$ = -$2; }
	| exp '^' exp { $$ = pow($1, $3); }
	| exp '@' exp { $$ = pow($1, 1.0 / $3); }
	| exp '%' exp { $$ = fmod($1, $3); }
	| exp POWER exp { $$ = pow($1, $3); }
	| exp DIVI exp { $$ = int($1 / $3); }
	| '(' exp ')' { $$ = $2; }
	;

%%

#include "main.lex.c"

void yyerror(char* message) {
	fprintf(stderr, "%s\n", message);
}

int main(int argc, char* argv[]) {
	printf("Nano Calculator (build: %s %s)\n", __DATE__, __TIME__);
	printf(">>> ");
	return yyparse();
}
