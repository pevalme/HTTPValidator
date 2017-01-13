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
^(?i:Transfer-Encoding:).*"chunked".*"chunked".*"\r\n" { /* E1002 */ printf("1002 \n"); exit(-1);}

^(?i:Transfer-Encoding:).*"chunked".+"\r\n" { /* E1001 */ printf("1001 \n"); exit(-1);}

^(?i:HTTP)"/"[0-9]"."[0-9](" ")*("1"[0-9][0-9]|"204")(.*"\r\n")(.+"\r\n")*(?i:Transfer-Encoding:) { /* E1018 */ printf("1018 \n"); exit(-1);}

^(?i:Connect)(.*"\r\n")*.*"======== BEGIN OUTBOUND STREAM ========\r\n"(?i:HTTP)"/"[0-9]"."[0-9](" ")*("2"[0-9][0-9])(.*"\r\n")(.+"\r\n")*(?i:Transfer-Encoding:) { /* E1019*/ printf("E1019\n"); exit(-1);}

^((?i:Transfer-Encoding:)(.+"\r\n")*(?i:content-length))|((?i:content-length)(.+"\r\n")*(?i:Transfer-Encoding:)) { /* E1020 */ printf("1020 \n"); exit(-1);}

^(?i:HTTP)"/"[0-9]"."[0-9](" ")*(("1"[0-9][0-9])|("204"))(.*"\r\n")(.+"\r\n")*(?i:Content-length:) { /* E1023 */ printf("1023 \n"); exit(-1);}

^(?i:Connect)" "(.*"\r\n")*.*"======== BEGIN OUTBOUND STREAM ========\r\n"(?i:HTTP)"/"[0-9]"."[0-9](" ")*("2"[0-9][0-9])(.*"\r\n")(.+"\r\n")*(?i:Content-length:) { /* E1024*/ printf("E1024\n"); exit(-1);}

^(?i:Trailer:).*((?i:Transfer-Encoding)|(?i:content-length)|(?i:Host)|(?i:Authentication)|(?i:Content-Encoding)|(?i:Content-Type)|(?i:Content-Range)|(?i:Trailer)) { /* E1026 */ printf("1026 \n"); exit(-1);}

^(?i:TE:).*"chunked" { /* E1028*/ printf("E1028\n"); exit(-1);}

^(?i:Connection:).*(?i:cache-control) { /* E1034 */ printf("1034 \n"); exit(-1); /*More headers are invalid apart from cache-control */}

^(?i:GET).*(?i:HTTP)"/1.0"(" ")*(.*"\r\n")*(?i:Upgrade:).*"\r\n"(.*"\r\n")*"\r\n".*"======== BEGIN OUTBOUND STREAM ========\r\n"(?i:HTTP)"/"[0-9]"."[0-9](" ")*"101" { /* E1051 */ printf("1051 \n"); exit(-1);}

^(?i:HTTP)"/"[0-9]"."[0-9](" ")*"100".*(.+"\r\n")*(?i:Content-Type:) { /* E1052 */ printf("1052\n"); exit(-1);}

^(?i:Expect:).*(?i:100-Continue).*"\r\n"(.+"\r\n")*"\r\n"("\r\n"|"======== BEGIN OUTBOUND STREAM ========\r\n") { /* E1066 */ printf("1066\n"); exit(-1);}

((?i:GET)|(?i:HEAD)|(?i:POST)|(?i:PUT)|(?i:DELETE)|(?i:CONNECT)|(?i:OPTIONS)|(?i:TRACE)).*(?i:HTTP)"/1.0"(.*"\r\n")*"\r\n".*"======== BEGIN OUTBOUND STREAM ========\r\n"(?i:HTTP)"/"[0-9]"."[0-9](" ")*("1"[0-9][0-9]) { /* E1071 */ printf("1071 \n"); exit(-1);}

^((?i:Get)|(?i:HEAD)|(?i:OPTIONS))(.*"\r\n")*"======== BEGIN OUTBOUND STREAM ========\r\n"(?i:HTTP)"/"[0-9]"."[0-9](" ")*"201" { /* E1072 */ printf("1072 \n"); exit(-1);}

^((?i:Get)|(?i:HEAD)|(?i:OPTIONS))(.*"\r\n")*"======== BEGIN OUTBOUND STREAM ========\r\n"(?i:HTTP)"/"[0-9]"."[0-9](" ")*"202" { /* E1074 */ printf("1074 \n"); exit(-1);}

^(?i:HTTP)"/"[0-9]"."[0-9](" ")*("205")(.*"\r\n")*"\r\n". { /* E1076 */ printf("1076 \n"); exit(-1);}

^(?i:HTTP)"/"[0-9]"."[0-9](" ")*"305" { /* E1082 */ printf("1082 \n"); exit(-1);}

^(?i:HTTP)"/"[0-9]"."[0-9](" ")*"306" { /* E1083 */ printf("1083 \n"); exit(-1);}

^(?i:Options:)(.*"\r\n")*"======== BEGIN OUTBOUND STREAM ========\r\n"(?i:HTTP)"/"[0-9]"."[0-9](" ")*"302" { /* E1086*/ printf("E1086\n"); exit(-1);}

^(?i:HTTP)"/"[0-9]"."[0-9](" ")*"402" { /* E1088 */ printf("1088 \n"); exit(-1);}

^((?i:cache-control:).*("no-cache"|"no-store"|"must-revalidate").*"\r\n"(.+"\r\n")*(?i:age:)(" ")*[0-9]+)|((?i:age:)(" ")*[0-9]+"\r\n"(.+"\r\n")*(?i:cache-control:).*("no-cache"|"no-store"|"must-revalidate").*"\r\n") { exit(-1);}

^((?i:GET)|(?i:HEAD)|(?i:OPTIONS))(.*"\r\n")*"======== BEGIN OUTBOUND STREAM ========\r\n"(?i:HTTP)"/"[0-9]"."[0-9](" ")*"409" { /* E1095 */ printf("1095 \n"); exit(-1);}

^(?i:content-length)(.*"\r\n")*"======== BEGIN OUTBOUND STREAM ========\r\n"(?i:HTTP)"/"[0-9]"."[0-9](" ")*"411" { /* E1097 */ printf("1097 \n"); exit(-1);}

^(.*"\r\n")*"\r\n""======== BEGIN OUTBOUND STREAM ========\r\n"(?i:HTTP)"/"[0-9]"."[0-9](" ")*"413" { /* E1098 */ printf("1098 \n"); exit(-1);}

^(.*"\r\n")*"\r\n""======== BEGIN OUTBOUND STREAM ========\r\n"(?i:HTTP)"/"[0-9]"."[0-9](" ")*"415" { /* E1099 */ printf("1099 \n"); exit(-1);}

^(?i:HTTP)"/"[0-9]"."[0-9](" ")*"201"(.*"\r\n")*(?i:Location:).*"#" { /* E1111 */ printf("1111\n"); exit(-1);}

^(?i:GET)(.*"\r\n")*"======== BEGIN OUTBOUND STREAM ========\r\n"(?i:HTTP)"/"[0-9]"."[0-9](" ")*"405"(.*"\r\n")*(?i:Allow:).*(?i:GET) { /* E1114 */ printf("1114\n"); exit(-1);}
^(?i:HEAD)(.*"\r\n")*"======== BEGIN OUTBOUND STREAM ========\r\n"(?i:HTTP)"/"[0-9]"."[0-9](" ")*"405"(.*"\r\n")*(?i:Allow:).*(?i:HEAD) { /* E1114 */ printf("1114\n"); exit(-1);}
^(?i:POST)(.*"\r\n")*"======== BEGIN OUTBOUND STREAM ========\r\n"(?i:HTTP)"/"[0-9]"."[0-9](" ")*"405"(.*"\r\n")*(?i:Allow:).*(?i:POST) { /* E1114 */ printf("1114\n"); exit(-1);}
^(?i:PUT)(.*"\r\n")*"======== BEGIN OUTBOUND STREAM ========\r\n"(?i:HTTP)"/"[0-9]"."[0-9](" ")*"405"(.*"\r\n")*(?i:Allow:).*(?i:PUT) { /* E1114 */ printf("1114\n"); exit(-1);}
^(?i:DELETE)(.*"\r\n")*"======== BEGIN OUTBOUND STREAM ========\r\n"(?i:HTTP)"/"[0-9]"."[0-9](" ")*"405"(.*"\r\n")*(?i:Allow:).*(?i:DELETE) { /* E1114 */ printf("1114\n"); exit(-1);}
^(?i:CONNECT)(.*"\r\n")*"======== BEGIN OUTBOUND STREAM ========\r\n"(?i:HTTP)"/"[0-9]"."[0-9](" ")*"405"(.*"\r\n")*(?i:Allow:).*(?i:CONNECT) { /* E1114 */ printf("1114\n"); exit(-1);}
^(?i:OPTIONS)(.*"\r\n")*"======== BEGIN OUTBOUND STREAM ========\r\n"(?i:HTTP)"/"[0-9]"."[0-9](" ")*"405"(.*"\r\n")*(?i:Allow:).*(?i:OPTIONS) { /* E1114 */ printf("1114\n"); exit(-1);}
^(?i:TRACE)(.*"\r\n")*"======== BEGIN OUTBOUND STREAM ========\r\n"(?i:HTTP)"/"[0-9]"."[0-9](" ")*"405"(.*"\r\n")*(?i:Allow:).*(?i:TRACE) { /* E1114 */ printf("1114\n"); exit(-1);}

^(?i:Accept-Encoding:).*((?i:x-gzip;q=)|(?i:x-compress;q=)) { /* E1116 */ printf("1116\n"); exit(-1);}

^(?i:If-Match:).*"W/" { /* E1120 */ printf("1120\n"); exit(-1);}

^((?i:POST)|(?i:PUT)|(?i:DELETE)|(?i:CONNECT)|(?i:OPTIONS)|(?i:TRACE))(" ")+(.+"\r\n")*(?i:If-modified-since:) { /* E1122 */ printf("1122\n"); exit(-1);}

^((?i:POST)|(?i:PUT)|(?i:DELETE)|(?i:CONNECT)|(?i:OPTIONS)|(?i:TRACE))(" ")+(.*"\r\n")*"======== BEGIN OUTBOUND STREAM ========\r\n"(?i:HTTP)"/"[0-9]"."[0-9](" ")*"304" { /* E1124 */ printf("1124\n"); exit(-1);}

^((?i:CONNECT)|(?i:OPTIONS)|(?i:TRACE))(" ")+(.+"\r\n")*((?i:If-match:)|(?i:If-none-match:)|(?i:If-unmodified-since:)|(?i:If-range:)) { /* E1130 */ printf("1130\n"); exit(-1);}

^((?i:HEAD)|(?i:POST)|(?i:PUT)|(?i:DELETE)|(?i:CONNECT)|(?i:OPTIONS)|(?i:TRACE))(" ")+(.+"\r\n")*(?i:Range:) { /* E1132 */ printf("1132\n"); exit(-1);}

^(?i:If-Range:).*"W/" { /* E1135 */ printf("1135\n"); exit(-1);}

^((?i:HEAD)|(?i:POST)|(?i:PUT)|(?i:DELETE)|(?i:CONNECT)|(?i:OPTIONS)|(?i:TRACE))(" ")+(.+"\r\n")*(?i:Range)(.*"\r\n")*.*"======== BEGIN OUTBOUND STREAM ========\r\n"(?i:HTTP)"/"[0-9]"."[0-9](" ")*("206") { /* E1137*/ printf("E1137\n"); exit(-1);}

^((?i:Content-range:)(.+"\r\n")*(?i:Content-type:).*"multipart")|(?i:Content-type:).*"multipart".*(.+"\r\n")*(?i:Content-range:) { /* E1143 */ printf("1143\r\n"); exit(-1);}

^(?i:Range:)(" ")+(?i:bytes=)[0-9]*"-"[0-9]*(" ")*"\r\n"(.*"\r\n")*.*"======== BEGIN OUTBOUND STREAM ========\r\n"(.+"\r\n")*(?i:Content-type:).*"multipart" { /* E1144 */ printf("1144\n"); exit(-1);}

^(?i:Warning:)(" ")*("0"|[3-9]) { /* E1163 */ printf("1163\n"); exit(-1);}

^((?i:GET)|(?i:HEAD)|(?i:POST)|(?i:PUT)|(?i:DELETE)|(?i:CONNECT)|(?i:OPTIONS)|(?i:TRACE))(" ")*(.+"\r\n")*(?i:Warning:)(" ")*"1" { /* E1165 */ printf("1165\n"); exit(-1);}

^(?i:HTTP)"/"[0-9]"."[0-9](" ")*([6-9]|"0") { /* E1167 */ printf("1167\n"); exit(-1);}

^((?i:POST)|(?i:PUT)|(?i:DELETE)|(?i:OPTIONS))(" ")*(.*"\r\n")*(?i:Warning:)(" ")*"11"[0-3] { /* E1172 */ printf("1172\n"); exit(-1);}

^(?i:Cache-control:).*(?i:no-cache)(.*"\r\n")*((?i:Warning:)(" ")*"11"[0-3]|(?i:Age:)) { /* E1173 */ printf("1173\n"); exit(-1);}

^(?i:Cache-control:).*(?i:no-store)(.*"\r\n")*(?i:Warning:)(" ")*"11"[0-3] { /* E1176 */ printf("1176\n"); exit(-1);}

^(?i:Expires:)(.+"\r\n")*(?i:Warning:).*(?i:Heuristic)" "*(?i:Expiration) { /* E1181 */ printf("1181\n"); exit(-1);}

^(?i:Cache-control:).*(?i:max-age)(.+"\r\n")*(?i:Warning:).*(?i:Heuristic)" "*(?i:Expiration) { /* E1182 */ printf("1182\n"); exit(-1);}

^(?i:HTTP)"/"[0-9]"."[0-9](" ")*"203".*"\r\n"(.+"\r\n")*(?i:Cache-control:).*(?i:no-transform) { /* E1192 */ printf("1192\n"); exit(-1);}

^(?i:HTTP)"/"[0-9]"."[0-9](" ")*"101".*"\r\n"(.+"\r\n")*(?i:Connection:).*(?i:close) { /* E1198 */ printf("1198\n"); exit(-1);}

^(?i:CONNECT)(" ")*(.*"\r\n")*(?i:HTTP)"/"[0-9]"."[0-9](" ")*"200".*"\r\n"(.+"\r\n")*(?i:Connection:).*(?i:close) { /* E1199 */ printf("1199\n"); exit(-1);}

^(?i:HTTP)"/"[0-9]"."[0-9](" ")*("403"|"429").*"\r\n"(.+"\r\n")*((?i:Warning:)(" ")*"11"[0-3]|(?i:Age:)) { /* E1202 */ printf("1202\n"); exit(-1);}

^(?i:Upgrade:).*"h2"(","|"\r\n"|" ") { /* E1228 */ printf("1228\n"); exit(-1); }

^(?i:HEAD)" "*(.+"\r\n")*"\r\n". { /* E1239 */ printf("1239\n"); exit(-1);}

^(?i:HTTP)"/"[0-9]"."[0-9](" ")*"204"(.*"\r\n")*"\r\n".+ { /* E1240 */ printf("1240\n"); exit(-1);}

^(?i:HTTP)"/"2"."[0-9](" ")*[0-9][0-9][0-9].*"\r\n"(.+"\r\n")*(?i:Connection:) { /* E1244 */ printf("1244\n"); exit(-1);}

^(?i:HTTP)"/"2"."[0-9](" ")*[0-9][0-9][0-9].*"\r\n"(.+"\r\n")*(?i:Upgrade:) { /* E1245 */ printf("1245\n"); exit(-1);}

^(?i:HTTP)"/"2"."[0-9](" ")*"101" { /* E1246 */ printf("1246\n"); exit(-1);}

^(?i:HTTP)"/"[0-9]"."[0-9](" ")*"421".*"\r\n"(.+"\r\n")*(?i:Alt-svc:) { /* E1260 */ printf("1260\n"); exit(-1);}

"\r" {}
"\n" {}
.*"\r\n\r\n======== BEGIN INBOUND STREAM ========\r\n" {}
"\r\n\r\n" { BEGIN(IGNORE);}
<IGNORE>"======== BEGIN OUTBOUND STREAM ========\r\n" { BEGIN(INITIAL);}
<IGNORE>"\r" {}
<IGNORE>"\n" {}
<IGNORE>. {}
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
