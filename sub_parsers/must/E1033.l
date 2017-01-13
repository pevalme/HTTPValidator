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
^((?i:GET)|(?i:HEAD)|(?i:POST)|(?i:PUT)|(?i:DELETE)|(?i:CONNECT)|(?i:OPTIONS)|(?i:TRACE)).+(?i:HTTP)"/1.1\r\n"(.+"\r\n")*(?i:HOST:)(.+"\r\n")*(?i:HOST:)(.*"\r\n")*(?i:HTTP)"/"[0-9]"."[0-9](" ")*"400" { exit(0); }
^((?i:GET)|(?i:HEAD)|(?i:POST)|(?i:PUT)|(?i:DELETE)|(?i:CONNECT)|(?i:OPTIONS)|(?i:TRACE)).+(?i:HTTP)"/1.1\r\n"(.+"\r\n")*(?i:HOST:)(.+"\r\n")*(?i:HOST:)(.*"\r\n")* { printf("1033\n"); exit(-1); }
^((?i:GET)|(?i:HEAD)|(?i:POST)|(?i:PUT)|(?i:DELETE)|(?i:CONNECT)|(?i:OPTIONS)|(?i:TRACE)).+(?i:HTTP)"/1.1\r\n"(.+"\r\n")*(?i:HOST:)(.*"\r\n")* { exit(0); }
^((?i:GET)|(?i:HEAD)|(?i:POST)|(?i:PUT)|(?i:DELETE)|(?i:CONNECT)|(?i:OPTIONS)|(?i:TRACE)).+(?i:HTTP)"/1.1\r\n"(.*"\r\n")* { /* E1033 */ printf("1033\n"); exit(-1);}
^((?i:GET)|(?i:HEAD)|(?i:POST)|(?i:PUT)|(?i:DELETE)|(?i:CONNECT)|(?i:OPTIONS)|(?i:TRACE)).+(?i:HTTP)"/1.1\r\n"(.*"\r\n")*(?i:HTTP)"/"[0-9]"."[0-9](" ")*"400" { exit(0); }

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
