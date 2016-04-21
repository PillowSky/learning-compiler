%{
char var_buffer[256];
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
	return STAR2;
}

"//" {
	return SLASH2;
}

{var} {
	yylval.VAR = strncpy(var_buffer, yytext+1, yyleng-1);
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
