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
^(?i:HTTP)"/"[0-9]"."[0-9](.+"\r\n")*(?i:WWW-Authenticate:) { exit(0); }
^(?i:HTTP)"/"[0-9]"."[0-9](" ")*"401" { printf("1194\n"); exit(-1);}


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
