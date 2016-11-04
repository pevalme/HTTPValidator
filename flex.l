%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "bison.tab.h"

#undef ECHO
#define ECHO {}
%}

%option noyywrap
%x HEADER
%x BODY

%%
<HEADER>(?i:allow:) { BEGIN(INITIAL); ECHO; return ALLOW; }
<HEADER>(?i:connection:) { BEGIN(INITIAL); ECHO; return CONNECTION; }
<HEADER>(?i:content-encoding:) { BEGIN(INITIAL); ECHO; return CONTENT_ENCODING; }
<HEADER>(?i:content-language:) { BEGIN(INITIAL); ECHO; return CONTENT_LANGUAGE; }
<HEADER>(?i:content-length:) { BEGIN(INITIAL); ECHO; return CONTENT_LENGTH; }
<HEADER>(?i:content-location:) { BEGIN(INITIAL); ECHO; return CONTENT_LOCATION; }
<HEADER>(?i:content-md5:) { BEGIN(INITIAL); ECHO; return CONTENT_MD5; }
<HEADER>(?i:content-range:) { BEGIN(INITIAL); ECHO; return CONTENT_RANGE; }
<HEADER>(?i:content-type:) { BEGIN(INITIAL); ECHO; return CONTENT_TYPE; }
<HEADER>(?i:cookie:) { BEGIN(INITIAL); ECHO; return COOKIE; }
<HEADER>(?i:date:) { BEGIN(INITIAL); ECHO; return DATE; }
<HEADER>(?i:expires:) { BEGIN(INITIAL); ECHO; return EXPIRES; }
<HEADER>(?i:last-modified:) { BEGIN(INITIAL); ECHO; return LAST_MODIFIED; }
<HEADER>(?i:keep-alive:) { BEGIN(INITIAL); ECHO; return KEEP_ALIVE; }
<HEADER>(?i:pragma:) { BEGIN(INITIAL); ECHO; return PRAGMA; }
<HEADER>(?i:trailer:) { BEGIN(INITIAL); ECHO; return TRAILER; }
<HEADER>(?i:transfer-encoding:) { BEGIN(INITIAL); ECHO; return TRANSFER_ENCODING; }
<HEADER>(?i:upgrade:) { BEGIN(INITIAL); ECHO; return UPGRADE; }
<HEADER>(?i:via:) { BEGIN(INITIAL); ECHO; return VIA; }
<HEADER>(?i:warning:) { BEGIN(INITIAL); ECHO; return WARNING; }
<HEADER>(?i:accept:) { BEGIN(INITIAL); ECHO; return ACCEPT; }
<HEADER>(?i:accept-charset:) { BEGIN(INITIAL); ECHO; return ACCEPT_CHARSET; }
<HEADER>(?i:accept-encoding:) { BEGIN(INITIAL); ECHO; return ACCEPT_ENCODING; }
<HEADER>(?i:accept-language:) { BEGIN(INITIAL); ECHO; return ACCEPT_LANGUAGE; }
<HEADER>(?i:authorization:) { BEGIN(INITIAL); ECHO; return AUTHORIZATION; }
<HEADER>(?i:cache-control:) { BEGIN(INITIAL); ECHO; return CACHE_CONTROL; }
<HEADER>(?i:expect:) { BEGIN(INITIAL); ECHO; return EXPECT; }
<HEADER>(?i:from:) { BEGIN(INITIAL); ECHO; return FROM; }
<HEADER>(?i:host:) { BEGIN(INITIAL); ECHO; return HOST; }
<HEADER>(?i:if-match:) { BEGIN(INITIAL); ECHO; return IF_MATCH; }
<HEADER>(?i:if-modified-since:) { BEGIN(INITIAL); ECHO; return IF_MODIFIED_SINCE; }
<HEADER>(?i:if-none-match:) { BEGIN(INITIAL); ECHO; return IF_NONE_MATCH; }
<HEADER>(?i:if-range:) { BEGIN(INITIAL); ECHO; return IF_RANGE; }
<HEADER>(?i:if-unmodified-since:) { BEGIN(INITIAL); ECHO; return IF_UNMODIFIED_SINCE; }
<HEADER>(?i:max-forwards:) { BEGIN(INITIAL); ECHO; return MAX_FORWARDS; }
<HEADER>(?i:proxy-authorization:) { BEGIN(INITIAL); ECHO; return PROXY_AUTHORIZATION; }
<HEADER>(?i:referer:) { BEGIN(INITIAL); ECHO; return REFERER; }
<HEADER>(?i:resource-freshness:) { BEGIN(INITIAL); ECHO; return RESOURCE_FRESHNESS; }
<HEADER>(?i:te:) { BEGIN(INITIAL); ECHO; return TE; }
<HEADER>(?i:upgrade-insecure-requests:) { BEGIN(INITIAL); ECHO; return UPGRADE_INSECURE_REQUESTS; }
<HEADER>(?i:user-agent:) { BEGIN(INITIAL); ECHO; return USER_AGENT; }


<HEADER>(?i:accept-ranges:) { BEGIN(INITIAL); ECHO; return ACCEPT_RANGES; }
<HEADER>(?i:age:) { BEGIN(INITIAL); ECHO; return AGE; }
<HEADER>(?i:etag:) { BEGIN(INITIAL); ECHO; return ETAG; }
<HEADER>(?i:location:) { BEGIN(INITIAL); ECHO; return LOCATION; }
<HEADER>(?i:proxy-authenticate:) { BEGIN(INITIAL); ECHO; return PROXY_AUTHENTICATE; }
<HEADER>(?i:retry-after:) { BEGIN(INITIAL); ECHO; return RETRY_AFTER; }
<HEADER>(?i:server:) { BEGIN(INITIAL); ECHO; return SERVER; }
<HEADER>(?i:vary:) { BEGIN(INITIAL); ECHO; return VARY; }
<HEADER>(?i:www-authenticate:) { BEGIN(INITIAL); ECHO; return WWW_AUTHENTICATE; }
<HEADER>("!"|"#"|"$"|"%"|"&"|"'"|"*"|"+"|"-"|"."|"^"|"_"|"`"|"|"|"~"|[0-9]|[a-zA-Z])+":" { BEGIN(INITIAL); ECHO; return GENERIC_FIELD; }

<BODY,INITIAL>(?i:q) { ECHO; return 'Q'; }
<BODY,INITIAL>(?i:w) { ECHO; return 'W'; }
<BODY,INITIAL>(?i:e) { ECHO; return 'E'; }
<BODY,INITIAL>(?i:r) { ECHO; return 'R'; }
<BODY,INITIAL>(?i:t) { ECHO; return 'T'; }
<BODY,INITIAL>(?i:y) { ECHO; return 'Y'; }
<BODY,INITIAL>(?i:u) { ECHO; return 'U'; }
<BODY,INITIAL>(?i:i) { ECHO; return 'I'; }
<BODY,INITIAL>(?i:o) { ECHO; return 'O'; }
<BODY,INITIAL>(?i:p) { ECHO; return 'P'; }
<BODY,INITIAL>(?i:a) { ECHO; return 'A'; }
<BODY,INITIAL>(?i:s) { ECHO; return 'S'; }
<BODY,INITIAL>(?i:d) { ECHO; return 'D'; }
<BODY,INITIAL>(?i:f) { ECHO; return 'F'; }
<BODY,INITIAL>(?i:g) { ECHO; return 'G'; }
<BODY,INITIAL>(?i:h) { ECHO; return 'H'; }
<BODY,INITIAL>(?i:j) { ECHO; return 'J'; }
<BODY,INITIAL>(?i:k) { ECHO; return 'K'; }
<BODY,INITIAL>(?i:l) { ECHO; return 'L'; }
<BODY,INITIAL>(?i:z) { ECHO; return 'Z'; }
<BODY,INITIAL>(?i:x) { ECHO; return 'X'; }
<BODY,INITIAL>(?i:c) { ECHO; return 'C'; }
<BODY,INITIAL>(?i:v) { ECHO; return 'V'; }
<BODY,INITIAL>(?i:b) { ECHO; return 'B'; }
<BODY,INITIAL>(?i:n) { ECHO; return 'N'; }
<BODY,INITIAL>(?i:m) { ECHO; return 'M'; }
<BODY,INITIAL>"-" { ECHO; return '-'; }
<BODY,INITIAL>"_" { ECHO; return '_'; }
<BODY,INITIAL>":" { ECHO; return ':'; }
<BODY,INITIAL>"." { ECHO; return '.'; }
<BODY,INITIAL>"~" { ECHO; return '~'; }
<BODY,INITIAL>"!" { ECHO; return '!'; }
<BODY,INITIAL>"*" { ECHO; return '*'; }
<BODY,INITIAL>"/" { ECHO; return '/'; }
<BODY,INITIAL>"(" { ECHO; return '('; }
<BODY,INITIAL>")" { ECHO; return ')'; }
<BODY,INITIAL>"'" { ECHO; return '\''; }
<BODY,INITIAL>"<" { ECHO; return '<'; }
<BODY,INITIAL>">" { ECHO; return '>'; }
<BODY,INITIAL>"@" { ECHO; return '@'; }
<BODY,INITIAL>"," { ECHO; return ','; }
<BODY,INITIAL>";" { ECHO; return ';'; }
<BODY,INITIAL>"\\" { ECHO; return '\\'; }
<BODY,INITIAL>"\"" { ECHO; return '"'; }
<BODY,INITIAL>"[" { ECHO; return '['; }
<BODY,INITIAL>"]" { ECHO; return ']'; }
<BODY,INITIAL>"?" { ECHO; return '?'; }
<BODY,INITIAL>"=" { ECHO; return '='; }
<BODY,INITIAL>"{" { ECHO; return '{'; }
<BODY,INITIAL>"}" { ECHO; return '}'; }
<BODY,INITIAL>"%" { ECHO; return '%'; }

<BODY,INITIAL>"1" { ECHO; return '1'; }
<BODY,INITIAL>"2" { ECHO; return '2'; }
<BODY,INITIAL>"3" { ECHO; return '3'; }
<BODY,INITIAL>"4" { ECHO; return '4'; }
<BODY,INITIAL>"5" { ECHO; return '5'; }
<BODY,INITIAL>"6" { ECHO; return '6'; }
<BODY,INITIAL>"7" { ECHO; return '7'; }
<BODY,INITIAL>"8" { ECHO; return '8'; }
<BODY,INITIAL>"9" { ECHO; return '9'; }
<BODY,INITIAL>"0" { ECHO; return '0'; }

<BODY,INITIAL>.*"\r\n\r\n======== BEGIN INBOUND STREAM ========\r\n" { ECHO; return INPUT_STREAM; }
<BODY,INITIAL>"======== BEGIN OUTBOUND STREAM ========\r\n" { BEGIN(INITIAL); ECHO; return OUTPUT_STREAM; }

<HEADER>"\r\n" { BEGIN(BODY); ECHO; return HTTP_NEWLINE; }
"\r\n" { BEGIN(HEADER); ECHO; return HTTP_NEWLINE; }

<BODY,INITIAL>"\r" { ECHO; return CARRIAGE_RETURN; }
<BODY,INITIAL>"\n" { ECHO; return NEW_LINE; }
<BODY,INITIAL>" " { ECHO; return SPACE;}

<BODY,INITIAL>. { ECHO; return CHAR; }
%%

//void read_msg() {BEGIN(MSG);}
