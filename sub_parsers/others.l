%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* This parser detects the following errors, described
in the list of notices of HTTPolice
E 1023
E 1088
E 1175, 1176, 1187
*/
%}

%option noyywrap


%%
(?i:HTTP)"/"[0-9]"."[0-9](" ")*("1"[0-9][0-9]|"204")(.*"\r\n")(.+"\r\n")*(?i:content-length:) { exit(-1);}

(?i:HTTP)"/"[0-9]"."[0-9](" ")*"402" { exit(-1);}

((?i:cache-control:).*("no-cache"|"no-store"|"must-revalidate").*"\r\n"(.+"\r\n")*(?i:age:)(" ")*[0-9]+)|((?i:age:)(" ")*[0-9]+"\r\n"(.+"\r\n")*(?i:cache-control:).*("no-cache"|"no-store"|"must-revalidate").*"\r\n") { exit(-1);}


"\r" {}
"\n" {}
"\r\n\r\n" {exit(0);}
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
