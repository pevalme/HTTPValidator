%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* This parser detects the following errors, described
in the list of notices of HTTPolice
E 1019 1024
E 1033
E 1058
*/

%}

%option noyywrap

%x INPUT
%x OUTPUT

input ("======== BEGIN INBOUND STREAM ========\r\n")
output ("======== BEGIN OUTBOUND STREAM ========\r\n")
%%

{input}"CONNECT"(.*"\r\n")*"\r\n"(.|"\r"|"\n")*{output}"HTTP/"[0-9]"."[0-9](" ")*"2"[0-9][0-9](.*"\r\n")*((?i:transfer-encoding)|(?i:content-length)) { printf("E 1019 1024\n"); exit(-1);}

{input}(([^(?i:H)]|(?i:H)[^(?i:O)]|(?i:HO)[^(?i:S)]|(?i:HOS)[^(?i:T)])*"\r\n")*(.|"\r"|"\n")*{output}"HTTP/"[0-9]"."[0-9](" ")*[^"4"] { printf("E 1033\n"); exit(-1);}

"\r" {}
"\n" {}
. {}


%%

int main(int argc, char *argv[]){
	int token;

	/*Checking the correctness of the arguments given*/
	if(argc!=2 || argv[1] == NULL){
 		printf("Invalid argument: program input_file\n\n");
 		return -1;
	}

	yyin = fopen(argv[1], "r\n");

	while((token=yylex()) != 0){
		//printf("%d\n",token);
	}

	return 0;
}
