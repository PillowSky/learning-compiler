%{
#include <stdlib.h>
#include <string.h>
%}

digit [0-9]
num ({digit}*\.)?{digit}+
var $[a-zA-Z0-9_]+

%%

{num} {
	yylval.NUM = atof(yytext);
	return NUM;
}

"**" {
	return POWER;
}

"//" {
	return DIVI;
}

{var} {
	yylval.VAR = strncpy(new char[yyleng], yytext+1, yyleng);
	return VAR;
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
