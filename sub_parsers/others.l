%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* This parser detects the following errors, described
in the list of notices of HTTPolice
E 1001, 1002
E 1018, 1023
E 1020
E 1026
E 1028
E 1034
E 1051
E 1088
E 1175, 1176, 1187
*/

%}

%option noyywrap


%%
(?i:transfer-encoding:).*"chunked"([^"\r"]) { printf("E 1001 1002\n"); exit(-1);}

(?i:HTTP)"/"[0-9]"."[0-9](" ")*("1"[0-9][0-9]|"204").*"\r\n"(.+"\r\n")*((?i:content-length:)|(?i:transfer-encoding:)) { printf("E 1018 1023\n"); exit(-1);}

((?i:transfer-encoding:).*+"\r\n"(.+"\r\n")*(?i:Content-length:).*+"\r\n")|((?i:transfer-encoding:).*+"\r\n"(.+"\r\n")*(?i:Content-length:).*+"\r\n") { printf("E 1020\n"); exit(-1);
}

(?i:trailer:).*((?i:Age)|(?i:Alt-Used)|(?i:Authorization)|(?i:Cache-Control)|(?i:Content-Encoding)|(?i:Content-Length)|(?i:Content-Range)|(?i:Content-Type)|(?i:Date)|(?i:Expect)|(?i:Expires)|(?i:Host)|(?i:If)|(?i:If-Match)|(?i:If-Modified-Since)|(?i:If-None-Match)|(?i:If-Range)|(?i:If-Schedule-Tag-Match)|(?i:If-Unmodified-Since)|(?i:Location)|(?i:Max-Forwards)|(?i:Pragma)|(?i:Proxy-Authorization)|(?i:Range)|(?i:Retry-After)|(?i:TE)|(?i:Trailer)|(?i:Transfer-Encoding)|(?i:Vary)|(?i:Warning)) { printf("E 1026\n"); exit(-1);}

(?i:te:).*(?i:chunked).*"\r\n" { printf("E 1028\n"); exit(-1);}

(?i:connection:).*(?i:cache-control).*"\r\n" { printf("E 1034\n"); exit(-1);}

(?i:HTTP)"/1.0".*"\r\n"(.*"\r\n")*(?i:upgrade:) { printf("E 1051\n"); exit(-1);}

(?i:HTTP)"/"[0-9]"."[0-9](" ")*"402" { printf("E 1088\n"); exit(-1);}

((?i:cache-control:).*("no-cache"|"no-store"|"must-revalidate").*"\r\n"(.+"\r\n")*(?i:age:)(" ")*[0-9]+)|((?i:age:)(" ")*[0-9]+"\r\n"(.+"\r\n")*(?i:cache-control:).*("no-cache"|"no-store"|"must-revalidate").*"\r\n") { printf("E 1175, 1176, 1187\n"); exit(-1);}


"\r" {}
"\n" {}
"\r\n\r\n" {exit(0);}
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
