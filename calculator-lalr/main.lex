%{
#include <stdlib.h>
#include <string.h>
%}

num [-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?
var $[a-zA-Z0-9_]+

%%

{num} {
	yylval.NUM = atof(yytext);
	return NUM;
}

{var} {
	yylval.VAR = strncpy(new char[yyleng], yytext+1, yyleng);
	return VAR;
}

"**" {
	return STAR2;
}

"//" {
	return SLASH2;
}

"cos" {
	return COS;
}

"sin" {
	return SIN;
}

"tan" {
	return TAN;
}

"acos" {
	return ACOS;
}

"asin" {
	return ASIN;
}

"atan" {
	return ATAN;
}

"exp" {
	return EXP;
}

"log" {
	return LOG;
}

"log10" {
	return LOG10;
}

"pow" {
	return POW;
}

"sqrt" {
	return SQRT;
}

"cbrt" {
	return CBRT;
}

"ceil" {
	return CEIL;
}

"floor" {
	return FLOOR;
}

"round" {
	return ROUND;
}

"abs" {
	return ABS;
}

"PI" {
	return PI;
}

"E" {
	return E;
}

<<EOF>> {
	printf("\nBye\n");
	return 0;
}

[ \t] {
}

.|\n {
	return *yytext;
}
