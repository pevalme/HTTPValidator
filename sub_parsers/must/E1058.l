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
^(?i:PUT)(.+"\r\n")*(?i:Content-Range:) { /*E1058*/ printf("1058\n"); exit(-1);}
^(?i:PUT)(.+"\r\n")*(?i:Content-Range:)(.*"\r\n")*^(?i:HTTP)"/"[0-9]"."[0-9](" ")*"400" { exit(0);}

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
