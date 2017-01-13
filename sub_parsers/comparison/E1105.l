%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "bison.tab.h"

//#undef ECHO
//#define ECHO {}
%}

%option noyywrap
%x REQUEST_VERSION
%x RESPONSE_VERSION
%x MIDDLE
%x REST
%x CHECK

%%

<INITIAL>.*"\r\n\r\n======== BEGIN INBOUND STREAM ========\r\n"[^" "]+" "*[^" "]+" "*(?i:HTTP)"/" { BEGIN(REQUEST_VERSION); }

<REQUEST_VERSION,RESPONSE_VERSION>"1" { return '1'; }
<REQUEST_VERSION,RESPONSE_VERSION>"2" { return '2'; }
<REQUEST_VERSION,RESPONSE_VERSION>"3" { return '3'; }
<REQUEST_VERSION,RESPONSE_VERSION>"4" { return '4'; }
<REQUEST_VERSION,RESPONSE_VERSION>"5" { return '5'; }
<REQUEST_VERSION,RESPONSE_VERSION>"6" { return '6'; }
<REQUEST_VERSION,RESPONSE_VERSION>"7" { return '7'; }
<REQUEST_VERSION,RESPONSE_VERSION>"8" { return '8'; }
<REQUEST_VERSION,RESPONSE_VERSION>"9" { return '9'; }
<REQUEST_VERSION,RESPONSE_VERSION>"0" { return '0'; }
<REQUEST_VERSION,RESPONSE_VERSION>"." { return '.'; }
<REQUEST_VERSION>" "*"\r\n" { BEGIN(MIDDLE);}
<RESPONSE_VERSION>" " { BEGIN(CHECK);}

<CHECK>" "*"505" { BEGIN(REST); return END; }

<MIDDLE>(.*"\r\n")*"\r\n======== BEGIN OUTBOUND STREAM ========\r\nHTTP/" { BEGIN(RESPONSE_VERSION); return '#'; }


<REST>"\r" {}
<REST>"\n" {}
<REST>. {}

%%


