%{
	int newline_count = 0;
	int word_count = 0;
	int character_count = 0;
	int byte_count = 0;
%}

word [a-zA-Z0-9_]*

%%

{word} {
	word_count++;
	character_count += yyleng;
}
\n {
	newline_count++;
}
. {
	byte_count++;
}

%%

int main(int argc, char** argv) {
	yylex();
	byte_count += character_count + newline_count;

	fprintf(yyout, "newline count: %d\n", newline_count);
	fprintf(yyout, "word count: %d\n", word_count);
	fprintf(yyout, "character count: %d\n", character_count);
	fprintf(yyout, "byte count: %d\n", byte_count);

	return EXIT_SUCCESS;
}
