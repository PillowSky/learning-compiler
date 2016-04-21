%{
#include "main.tab.h"
%}

digit [0-9]
num ({digit}*\.)?{digit}+

%%

{num} {
	yylval = atof(yytext);
	return NUM;
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
