/* Nano Calculator */

%{
#include <stdio.h>
#include <math.h>
#include <unordered_map>

using namespace std;

bool success = true;
unordered_map<string, double> symbol;

int yylex(void);
void yyerror(char* message);
%}

%define api.value.type union
%token <double> NUM
%token <char*> VAR
%type <double> exp

%token STAR2
%token SLASH2
%token COS
%token SIN
%token TAN
%token ACOS
%token ASIN
%token ATAN
%token EXP
%token LOG
%token LOG10
%token POW
%token SQRT
%token CBRT
%token CEIL
%token FLOOR
%token ROUND
%token ABS
%token PI
%token E

%precedence '='
%left '-' '+'
%left '*' '/'
%precedence NEG
%right '^' '@' '%' STAR2 SLASH2
%start input

%%

input: %empty
	 | input line
	 ;

line: '\n' { printf(">>> "); }
	| exp '\n' { if (success) { printf("%.17g\n", $1); } else { success = true; }; printf(">>> "); }
	| error '\n' { yyerrok; printf(">>> "); }
;

exp: NUM { $$ = $1; }
	| PI { $$ = M_PI; }
	| E { $$ = M_E; }
	| VAR { if (symbol.find($1) != symbol.end()) { $$ = symbol[$1]; } else { success = false; yyerror("undefined identifier"); }; delete[] $1; }
	| VAR '=' exp { $$ = symbol[$1] = $3; delete[] $1; }
	| COS '(' exp ')' { $$ = cos($3); }
	| SIN '(' exp ')' { $$ = sin($3); }
	| TAN '(' exp ')' { $$ = tan($3); }
	| ACOS '(' exp ')' { $$ = acos($3); }
	| ASIN '(' exp ')' { $$ = asin($3); }
	| ATAN '(' exp ')' { $$ = atan($3); }
	| EXP '(' exp ')' { $$ = exp($3); }
	| LOG '(' exp ')' { $$ = log($3); }
	| LOG10 '(' exp ')' { $$ = log10($3); }
	| POW '(' exp ',' exp ')' { $$ = pow($3, $5); }
	| SQRT '(' exp ')' { $$ = sqrt($3); }
	| CBRT '(' exp ')' { $$ = cbrt($3); }
	| CEIL '(' exp ')' { $$ = ceil($3); }
	| FLOOR '(' exp ')' { $$ = floor($3); }
	| ROUND '(' exp ')' { $$ = round($3); }
	| ABS '(' exp ')' { $$ = fabs($3); }
	| exp '+' exp { $$ = $1 + $3; }
	| exp '-' exp { $$ = $1 - $3; }
	| exp '*' exp { $$ = $1 * $3; }
	| exp '/' exp { $$ = $1 / $3; }
	| '-' exp  %prec NEG { $$ = -$2; }
	| exp '^' exp { $$ = pow($1, $3); }
	| exp '@' exp { $$ = pow($1, 1.0 / $3); }
	| exp '%' exp { $$ = fmod($1, $3); }
	| exp STAR2 exp { $$ = pow($1, $3); }
	| exp SLASH2 exp { $$ = int($1 / $3); }
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
