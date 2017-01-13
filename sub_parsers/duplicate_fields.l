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
%x IGNORE

/* DATE */
wkday ("Mon"|"Tue"|"Wed"|"Thu"|"Fri"|"Sat"|"Sun")
weekday ("Monday"|"Tuesday"|"Wednesday"|"Thursday"|"Friday"|"Saturday"|"Sunday")
month ("Jan"|"Feb"|"Mar"|"Apr"|"May"|"Jun"|"Jul"|"Aug"|"Sep"|"Oct"|"Nov"|"Dec")

one_digit ([0-9])
two_digit ([0-9][0-9])
four_digit ([0-9][0-9][0-9][0-9])

date1 ({two_digit}" "{month}" "{four_digit})
date2 ({two_digit}"-"{month}"-"{two_digit})
date3 ({month}" "({two_digit}|(" "{one_digit})))
time ({two_digit}":"{two_digit}":"{two_digit})

http_date1 ({wkday}", "{date1}" "{time}" GMT")
http_date2 ({weekday}", "{date2}" "{time}" GMT")
http_date3 ({wkday}" "{date3}" "{time}" "{four_digit})


%%
(?i:Content-length:)(" ")*[0-9]+"\r\n"(.+"\r\n")*(?i:Content-length:)(" ")*[0-9]+"\r\n" {
	exit(-1);
}

(?i:Date:)(" ")*({http_date1}|{http_date2}|{http_date3})"\r\n"(.+"\r\n")*(?i:Date:)(" ")*({http_date1}|{http_date2}|{http_date3}) {
	exit(-1);
}

(?i:Last-modified:)(" ")*({http_date1}|{http_date2}|{http_date3})"\r\n"(.+"\r\n")*(?i:Last-modified:)(" ")*({http_date1}|{http_date2}|{http_date3}) {
	exit(-1);
}


(?i:Expires:)(" ")*({http_date1}|{http_date2}|{http_date3})"\r\n"(.+"\r\n")*(?i:Expires:)(" ")*({http_date1}|{http_date2}|{http_date3}) {
	exit(-1);
}

(?i:Referer:)(.*"\r\n")*(?i:Referer:) { exit(-1);}

"\n" {}
"\r" {}
. {}

.*"\r\n\r\n======== BEGIN INBOUND STREAM ========\r\n" {}
"\r\n\r\n" { BEGIN(IGNORE);}
<IGNORE>"======== BEGIN OUTBOUND STREAM ========\r\n" { printf("reading response\n"); BEGIN(INITIAL);}
<IGNORE>"\r" {}
<IGNORE>"\n" {}
<IGNORE>. {}

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
