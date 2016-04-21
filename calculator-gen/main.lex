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

"**" {
	return STAR2;
}

"//" {
	return SLASH2;
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
