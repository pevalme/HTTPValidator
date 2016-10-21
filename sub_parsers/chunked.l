%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

%}

%option noyywrap


%%
(?i:Transfer-encoding:)(" ")*.*(?i:Chunked).*"\r\n" { exit(-1);}

"\n" {}
"\r" {}
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
