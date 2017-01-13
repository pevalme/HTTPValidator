%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* This parser detects some errors, described
in the list of notices of HTTPolice:
	http://pythonhosted.org/HTTPolice/notices.html
*/
%}

%option noyywrap
%x IGNORE


%%
^(?i:WWW-Authenticate:).*","" "*(?i:Basic).*(?i:charset)"=\""(?i:UTF-8)"\"".* { exit(0);}
^(?i:WWW-Authenticate:).*","" "*(?i:Basic).*(?i:charset)"=\"".*"\"".* { /*E1208*/ printf("1208\n"); exit(-1);}
^(?i:WWW-Authenticate:)" "*(?i:Basic).*(?i:charset)"=\""(?i:UTF-8)"\"".* { exit(0);}
^(?i:WWW-Authenticate:)" "*(?i:Basic).*(?i:charset)"=\"".*"\"".* { /*E1208*/ printf("1208\n"); exit(-1);}

"\r" {}
"\n" {}
. {}


%%

int main(int argc, char *argv[]){
	int token;

	/*Checking the correctness of the arguments given*/
	if(argc!=2 || argv[1] == NULL){
 		printf("Invalid argument: program input_file\n");
 		return -1;
	}

	yyin = fopen(argv[1], "r");

	while((token=yylex()) != 0){
		//printf("%d\n",token);
	}

	return 0;
}
