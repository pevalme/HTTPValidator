%{
	/*
	HTTP Validator. Copyright (C) 2016  Pedro Valero

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
  	*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

%}

%option noyywrap


%%

.*"\r\n\r\n======== BEGIN INBOUND STREAM ========\r\n"(.+"\r\n")*(?i:Transfer-encoding:)(" ")*.*(?i:Chunked).*"\r\n" { exit(1);}
.*"\r\n\r\n======== BEGIN INBOUND STREAM ========\r\n"(.+"\r\n")*(?i:Transfer-encoding:)(" ")*.*(?i:Chunked).*"\r\n"(.+"\r\n")*"\r\n======== BEGIN OUTBOUND STREAM ========\r\n"(.+"\r\n")*(?i:Transfer-encoding:)(" ")*.*(?i:Chunked).*"\r\n" { exit(2);}
"======== BEGIN OUTBOUND STREAM ========\r\n"(.+"\r\n")*(?i:Transfer-encoding:)(" ")*.*(?i:Chunked).*"\r\n" { exit(3);}
(?i:Transfer-encoding:)(" ")*.*(?i:Chunked).*"\r\n" { exit(4);}

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
