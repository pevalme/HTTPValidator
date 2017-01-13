E1100.l
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* This parser detects some errors, described
in the list of notices of HTTPolice:
	http://pythonhosted.org/HTTPolice/notices.html
*/
	/* Incomplete */
%}

%option noyywrap
%x IGNORE


%%
^((?i:If-Modified-Since:)|(?i:If-Match)|(?i:If-None-Match)|(?i:If-Unmodified-Since)|(?i:If-Range))(.*"\r\n")*(?i:HTTP)"/"[0-9]"."[0-9](" ")*("304"|"412") { exit(0); }
^"======== BEGIN OUTBOUND STREAM ========\r\n"(.+"\r\n")*(?i:HTTP)"/"[0-9]"."[0-9](" ")*("304"|"412") { printf("1125\n"); exit(-1);}

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
