dnl Maximum allowed content length size
define(`MAX', 10)dnl
dnl useful marco e.g. md5
define(`copy', `$2 ifelse(eval($1 > 1),1, `copy(decr($1),$2)')')dnl
dnl Auxiliary definition to handle quotes
changequote([,])dnl
define([QUOTE],['])dnl
changequote dnl
dnl another one, \S matches non space character
define(`spellit',`patsubst(`$1', `\S', QUOTE`'\&`'QUOTE )')

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    extern  FILE *yyin;
%}

%token ALLOW
%token CONNECTION
%token CONTENT_ENCODING
%token CONTENT_LANGUAGE
%token CONTENT_LENGTH
%token CONTENT_LOCATION
%token CONTENT_MD5
%token CONTENT_RANGE
%token CONTENT_TYPE
%token COOKIE
%token DATE
%token EXPIRES
%token LAST_MODIFIED
%token KEEP_ALIVE
%token PRAGMA
%token TRAILER
%token TRANSFER_ENCODING
%token UPGRADE
%token VIA
%token WARNING
%token ACCEPT
%token ACCEPT_CHARSET
%token ACCEPT_ENCODING
%token ACCEPT_LANGUAGE
%token AUTHORIZATION
%token CACHE_CONTROL
%token EXPECT
%token FROM
%token HOST
%token IF_MATCH
%token IF_MODIFIED_SINCE
%token IF_NONE_MATCH
%token IF_RANGE
%token IF_UNMODIFIED_SINCE
%token `MAX_FORWARDS'
%token PROXY_AUTHORIZATION
%token REFERER
%token RESOURCE_FRESHNESS
%token TE
%token UPGRADE_INSECURE_REQUESTS
%token USER_AGENT

%token GENERIC_FIELD

%token HTTP_NEWLINE

%token ACCEPT_RANGES
%token AGE
%token ETAG
%token LOCATION
%token PROXY_AUTHENTICATE
%token RETRY_AFTER
%token SERVER
%token VARY
%token WWW_AUTHENTICATE

%token CARRIAGE_RETURN
%token NEW_LINE
%token SPACE
%token CHAR

%token INPUT_STREAM
%token OUTPUT_STREAM
%%


axiom: status_line | request_line | combined

combined: INPUT_STREAM request_line OUTPUT_STREAM status_line

status_line: HTTP VERSION SPACE STATUS_CODE SPACE STATUS_PHRASE HTTP_NEWLINE headers_response
request_line: METHOD SPACE request-uri SPACE HTTP VERSION HTTP_NEWLINE headers_request

HTTP: spellit(HTTP/)
VERSION: digit '.' digit
STATUS_CODE: digit digit digit
STATUS_PHRASE: NOTCRCL STATUS_PHRASE
             | /* empty */

METHOD: spellit(GET)
      | spellit(HEAD)
      | spellit(POST)
      | spellit(PUT)
      | spellit(DELETE)
      | spellit(CONNECT)
      | spellit(OPTIONS)
      | spellit(TRACE)

/* REQUEST-URI */
request-uri: abs_path
       | abs_path '?' query
       | alpha know_nothing
       | mark know_reg_name
       | escaped know_reg_name
       | digit know_reg_name
       | '$' know_reg_name
       | ',' know_reg_name
       | ';' know_reg_name
       | ':' know_reg_name
       | '@' know_reg_name
       | '&' know_reg_name
       | '=' know_reg_name
       | '+' know_reg_name
       | /* empty */

know_reg_name: unreserved know_reg_name
             | escaped know_reg_name
             | '$' know_reg_name
             | ',' know_reg_name
             | ';' know_reg_name
             | ':' know_reg_name
             | '@' know_reg_name
             | '&' know_reg_name
             | '=' know_reg_name
             | '+' know_reg_name
             | /* empty */

know_nothing: alphanum know_nothing
      | '+' know_nothing
      | '-' know_nothing
      | '.' know_nothing
      | ':' know_something
      | '_' know_reg_name
      | '?' know_reg_name
      | '@' know_reg_name
      | '&' know_reg_name
      | '=' know_reg_name
      | '$' know_reg_name
      | ',' know_reg_name
      | ';' know_reg_name
      | escaped know_reg_name

know_something: '/' know_hier_part
              | '?' query
              | unreserved know_more
              | escaped know_more
              | '$' know_more
              | ',' know_more
              | ';' know_more
              | ':' know_more
              | '@' know_more
              | '&' know_more
              | '=' know_more
              | '+' know_more

know_more: '/' know_more
         | '?' know_more
         | unreserved know_more
         | escaped know_more
         | '$' know_more
         | ',' know_more
         | ';' know_more
         | ':' know_more
         | '@' know_more
         | '&' know_more
         | '=' know_more
         | '+' know_more
         | /* empty */

know_hier_part: '/' reg_name abs_path
              | '/' abs_path
              | '/' reg_name
              | '/'
              | know_abs_path
              | '/' reg_name abs_path '?' query
              | '/' abs_path '?' query
              | '/' reg_name '?' query
              | '/' '?' query
              | know_abs_path '?' query

know_abs_path: reg_name_no_semicolon_star abs_path_2 abs_path_repeat
             | unreserved reg_name_no_semicolon_star abs_path_repeat
             | escaped reg_name_no_semicolon_star abs_path_repeat
             | '$' reg_name_no_semicolon_star abs_path_repeat
             | ',' reg_name_no_semicolon_star abs_path_repeat
             | ':' reg_name_no_semicolon_star abs_path_repeat
             | '&' reg_name_no_semicolon_star abs_path_repeat
             | '=' reg_name_no_semicolon_star abs_path_repeat
             | '+' reg_name_no_semicolon_star abs_path_repeat
/* If the reg_name_no_semicolon was empty followed by abs_path we are in the second rule of know_hier_part */

abs_path: '/' reg_name_no_semicolon_star abs_path_2 abs_path_repeat
        | '/' reg_name_no_semicolon_star abs_path_repeat

abs_path_repeat: abs_path
         | /* empty */

abs_path_2: ';' reg_name_no_semicolon_star abs_path_2
      | ';' reg_name_no_semicolon_star

reg_name_no_semicolon_star: unreserved reg_name_no_semicolon_star
              | escaped reg_name_no_semicolon_star
              | '$' reg_name_no_semicolon_star
              | ',' reg_name_no_semicolon_star
              | ':' reg_name_no_semicolon_star
              | '&' reg_name_no_semicolon_star
              | '=' reg_name_no_semicolon_star
              | '+' reg_name_no_semicolon_star
              | /* empty */


query: uric query
     | /* empty */

//////////////////////////////////////
///// REQUEST
//////////////////////////////////////
headers_request: ALLOW SPACE token_comma HTTP_NEWLINE headers_request
        | CONNECTION SPACE token HTTP_NEWLINE headers_request
        | CONTENT_ENCODING SPACE content_codings HTTP_NEWLINE headers_request
        | CONTENT_LANGUAGE SPACE content_languages HTTP_NEWLINE headers_request
        | CONTENT_LENGTH SPACE length_request
        | CONTENT_LOCATION SPACE content_location_data HTTP_NEWLINE headers_request
        | CONTENT_MD5 SPACE md5_digest HTTP_NEWLINE headers_request
        | CONTENT_RANGE SPACE CONTENT_RANGE_SPEC HTTP_NEWLINE headers_request
        | CONTENT_TYPE SPACE CONTENT_TYPE_DATA HTTP_NEWLINE headers_request
        | COOKIE SPACE NOTCRCL_STAR HTTP_NEWLINE headers_request
        | DATE SPACE http_date HTTP_NEWLINE headers_request
        | EXPIRES SPACE http_date HTTP_NEWLINE headers_request
        | LAST_MODIFIED SPACE http_date HTTP_NEWLINE headers_request
        | KEEP_ALIVE SPACE keep_alive_params HTTP_NEWLINE headers_request
        | PRAGMA SPACE pragma_directive HTTP_NEWLINE headers_request
        | TRAILER SPACE SOME_FIELDS HTTP_NEWLINE headers_request
        | TRANSFER_ENCODING SPACE transfer_coding HTTP_NEWLINE headers_request
        | UPGRADE SPACE product HTTP_NEWLINE headers_request
        | VIA SPACE via_data HTTP_NEWLINE headers_request
        | WARNING SPACE warning_value HTTP_NEWLINE headers_request
        | ACCEPT SPACE accept_value HTTP_NEWLINE headers_request
        | ACCEPT_CHARSET SPACE accept_charset_value HTTP_NEWLINE headers_request
        | ACCEPT_ENCODING SPACE accept_encoding_value HTTP_NEWLINE headers_request
        | ACCEPT_LANGUAGE SPACE accept_language_value HTTP_NEWLINE headers_request
        | AUTHORIZATION SPACE credentials HTTP_NEWLINE headers_request
        | CACHE_CONTROL SPACE cache_request_directive HTTP_NEWLINE headers_request
        | EXPECT SPACE expectation_comma_star HTTP_NEWLINE headers_request
        | FROM SPACE mailbox HTTP_NEWLINE headers_request
        | HOST SPACE host_name HTTP_NEWLINE headers_request
        | IF_MATCH SPACE entity_tag_or_star HTTP_NEWLINE headers_request
        | IF_MODIFIED_SINCE SPACE http_date HTTP_NEWLINE headers_request
        | IF_NONE_MATCH SPACE entity_tag_or_star HTTP_NEWLINE headers_request
        | IF_RANGE SPACE entity_tag_or_star_or_date HTTP_NEWLINE headers_request
        | IF_UNMODIFIED_SINCE SPACE http_date HTTP_NEWLINE headers_request
        | `MAX_FORWARDS' SPACE max HTTP_NEWLINE headers_request
        | PROXY_AUTHORIZATION SPACE credentials HTTP_NEWLINE headers_request
        | REFERER SPACE content_location_data HTTP_NEWLINE headers_request
        | RESOURCE_FRESHNESS SPACE value_resource HTTP_NEWLINE headers_request
        | TE SPACE t_codings_comma_star HTTP_NEWLINE headers_request
        | UPGRADE_INSECURE_REQUESTS SPACE value_upgrade HTTP_NEWLINE headers_request
        | USER_AGENT SPACE product_or_comma_star HTTP_NEWLINE headers_request
        | GENERIC_FIELD SPACE NOTCRCL_STAR HTTP_NEWLINE headers_request
        | HTTP_NEWLINE general_body

headers_request_CL: ALLOW SPACE token_comma HTTP_NEWLINE headers_request_CL
        | CONNECTION SPACE token HTTP_NEWLINE headers_request_CL
        | CONTENT_ENCODING SPACE content_codings HTTP_NEWLINE headers_request_CL
        | CONTENT_LANGUAGE SPACE content_languages HTTP_NEWLINE headers_request_CL
        | CONTENT_LENGTH SPACE length_request
        | CONTENT_LOCATION SPACE content_location_data HTTP_NEWLINE headers_request_CL
        | CONTENT_MD5 SPACE md5_digest HTTP_NEWLINE headers_request_CL
        | CONTENT_RANGE SPACE CONTENT_RANGE_SPEC HTTP_NEWLINE headers_request_CL
        | CONTENT_TYPE SPACE CONTENT_TYPE_DATA HTTP_NEWLINE headers_request_CL
        | COOKIE SPACE NOTCRCL_STAR HTTP_NEWLINE headers_request_CL
        | DATE SPACE http_date HTTP_NEWLINE headers_request_CL
        | EXPIRES SPACE http_date HTTP_NEWLINE headers_request_CL
        | LAST_MODIFIED SPACE http_date HTTP_NEWLINE headers_request_CL
        | KEEP_ALIVE SPACE keep_alive_params HTTP_NEWLINE headers_request_CL
        | PRAGMA SPACE pragma_directive HTTP_NEWLINE headers_request_CL
        | TRAILER SPACE SOME_FIELDS HTTP_NEWLINE headers_request_CL
        | TRANSFER_ENCODING SPACE transfer_coding HTTP_NEWLINE headers_request_CL
        | UPGRADE SPACE product HTTP_NEWLINE headers_request_CL
        | VIA SPACE via_data HTTP_NEWLINE headers_request_CL
        | WARNING SPACE warning_value HTTP_NEWLINE headers_request_CL
        | ACCEPT SPACE accept_value HTTP_NEWLINE headers_request_CL
        | ACCEPT_CHARSET SPACE accept_charset_value HTTP_NEWLINE headers_request_CL
        | ACCEPT_ENCODING SPACE accept_encoding_value HTTP_NEWLINE headers_request_CL
        | ACCEPT_LANGUAGE SPACE accept_language_value HTTP_NEWLINE headers_request_CL
        | AUTHORIZATION SPACE credentials HTTP_NEWLINE headers_request_CL
        | CACHE_CONTROL SPACE cache_request_directive HTTP_NEWLINE headers_request_CL
        | EXPECT SPACE expectation_comma_star HTTP_NEWLINE headers_request_CL
        | FROM SPACE mailbox HTTP_NEWLINE headers_request_CL
        | HOST SPACE host_name HTTP_NEWLINE headers_request_CL
        | IF_MATCH SPACE entity_tag_or_star HTTP_NEWLINE headers_request_CL
        | IF_MODIFIED_SINCE SPACE http_date HTTP_NEWLINE headers_request_CL
        | IF_NONE_MATCH SPACE entity_tag_or_star HTTP_NEWLINE headers_request_CL
        | IF_RANGE SPACE entity_tag_or_star_or_date HTTP_NEWLINE headers_request_CL
        | IF_UNMODIFIED_SINCE SPACE http_date HTTP_NEWLINE headers_request_CL
        | `MAX_FORWARDS' SPACE max HTTP_NEWLINE headers_request_CL
        | PROXY_AUTHORIZATION SPACE credentials HTTP_NEWLINE headers_request_CL
        | REFERER SPACE content_location_data HTTP_NEWLINE headers_request_CL
        | RESOURCE_FRESHNESS SPACE value_resource HTTP_NEWLINE headers_request_CL
        | TE SPACE t_codings_comma_star HTTP_NEWLINE headers_request_CL
        | UPGRADE_INSECURE_REQUESTS SPACE value_upgrade HTTP_NEWLINE headers_request_CL
        | USER_AGENT SPACE product_or_comma_star HTTP_NEWLINE headers_request_CL
        | GENERIC_FIELD SPACE NOTCRCL_STAR HTTP_NEWLINE headers_request_CL
        | HTTP_NEWLINE

/* ACCEPT-LANGUAGE */
accept_language_value: language_range
            | language_range ';' 'Q' '=' qvalue
            | language_range ',' SPACES accept_language_value
            | language_range ';' 'Q' '=' qvalue ',' SPACES accept_language_value

language_range: '*'
              | oneTo8alpha oneTo8alpha_star

oneTo8alpha_star: '-' oneTo8alpha oneTo8alpha_star
                | /*empty*/

oneTo8alpha: alpha | copy(2, alpha)  | copy(3, alpha)  | copy(4, alpha)  | copy(5, alpha)  | copy(6, alpha)  | copy(7, alpha)  | copy(8, alpha)

/* USER-AGENT */
product_or_comma_star: product SPACE product_or_comma_star
               | comment SPACE product_or_comma_star
               | product
               | comment
               | /* empty */

product: token
       | token '/' token

comment: '(' no_parenthesis_star ')'
       | '(' quoted_pair ')'
       | '(' comment ')'

no_parenthesis_star: reserved no_parenthesis_star
                   | escaped no_parenthesis_star
                   | alphanum no_parenthesis_star
                   | '-' no_parenthesis_star
                   | '_' no_parenthesis_star
                   | '.' no_parenthesis_star
                   | '!' no_parenthesis_star
                   | '~' no_parenthesis_star
                   | '*' no_parenthesis_star
                   | '\''  no_parenthesis_star
                   | SPACE no_parenthesis_star
                   | /* empty */

/* UPGRADE-INSECURE-REQUEST */
value_upgrade: SPACES '1' SPACES

/* TE */
t_codings_comma_star: /*empty*/
                    | transfer_extension t_codings_comma_star_2

t_codings_comma_star_2: ',' transfer_extension t_codings_comma_star_2
                      | /*empty*/

transfer_extension: token parameters

/* RESOURCE-FRESHNESS */
value_resource: 'M' 'A' 'X' '-' 'A' 'G' 'E' '=' delta_seconds ',' 'S' 'T' 'A' 'L' 'E' '-' 'W' 'H' 'I' 'L' 'E' '-' 'R' 'E' 'V' 'A' 'L' 'I' 'D' 'A' 'T' 'E' '=' delta_seconds ',' 'A' 'G' 'E' '=' delta_seconds

/* MAX-FORWARDS */
max: digit
   | digit max

/* ETAG */
entity_tag_or_star_or_date: '*'
                          | entity_tag_comma
                          | http_date

entity_tag_or_star: '*'
                  | entity_tag_comma

entity_tag_comma: entity_tag
                | entity_tag ',' entity_tag_comma

/* HOST */
host_name: host ':' port
      | host

host: digit no_top_label
    | alpha top_label

no_top_label: digit no_top_label
            | '.' ip1
            | alpha domain_label

domain_label: '.' domain_or_top
            | alphanum domain_label

domain_or_top: alpha top_label
             | digit alphanum domain_label

top_label: /* empty */
     | '.'
     | alpha top_label
     | digit domain_or_middle_top
     | '.' domain_or_top
     | '-' middle_top

domain_or_middle_top: '.' domain_or_top
                    | alpha top_label
                    | digit domain_or_middle_top
                    | '-' middle_top

middle_top: '-' middle_top
          | digit middle_top
          | alpha top_label

ip1: digit ip1
   | '.' ip2

ip2: digit ip2
   | '.' ip3

ip3: digit ip4
ip4: digit ip4
   | /* empty */

port: digit port
    | /* empty */

/* FROM */
mailbox: atom addr_spec_or_phrase_read_atom
       | quoted_string addr_spec_or_phrase_read_qs
       | route_addr

addr_spec_or_phrase_read_atom: '.' local_part '@' domain
                             | '@' domain
                             | '"' qstring '"' phrase route_addr
                             | route_addr

addr_spec_or_phrase_read_qs: '.' local_part '@' domain
                           | '@' domain
                           | phrase route_addr
                           | route_addr

phrase: atom
      | quoted_string phrase
      | atom quoted_string phrase

word: atom | quoted_string

addr_spec: local_part '@' domain

local_part: word
          | word '.' local_part

route_addr: '<' addr_spec '>'
          | '<' route addr_spec '>'

route: domain_comma_star ':'
domain_comma_star: '@' domain
                 | '@' domain ',' domain_comma_star

domain: sub_domain '.' domain
      | sub_domain

sub_domain: domain_ref | domain_literal

domain_ref: atom

atom: alphanum atom_end
    | '-' atom_end
    | '_' atom_end
    | '!' atom_end
    | '~' atom_end
    | '*' atom_end
    | '/' atom_end
    | '?' atom_end
    | '&' atom_end
    | '=' atom_end
    | '+' atom_end
    | '$' atom_end
    | CHAR atom_end

atom_end: atom
        | /*empty*/

domain_literal: '[' dtext_or_quoted_string_star ']'

dtext_or_quoted_string_star: /*empty*/
                           | dtext dtext_or_quoted_string_star
                           | quoted_string dtext_or_quoted_string_star

/* EXPECT */
expectation_comma_star: expectation
                      | expectation ',' expectation_comma_star

expectation: token
           | token '=' token expect_params_star
           | token '=' quoted_string expect_params_star

expect_params_star: /*empty*/
                  | ';' token expect_params_star
                  | ';' token '=' token expect_params_star
                  | ';' token '=' quoted_string expect_params_star


/* CACHE-CONTROL */

cache_request_directive: spellit(no-cache) cache_request_directive2
                       | spellit(no-store) cache_request_directive2
                       | spellit(max-age=) delta_seconds cache_request_directive2
                       | spellit(max-stale) cache_request_directive2
                       | spellit(max-stale=) delta_seconds cache_request_directive2
                       | spellit(min-refresh=) delta_seconds cache_request_directive2
                       | spellit(no-transform) cache_request_directive2
                       | spellit(only-if-cached) cache_request_directive2
                       | cache_extension cache_request_directive2

cache_request_directive2: ',' SPACE cache_request_directive
                        | /* empty*/

cache_extension: token
               | token '=' token
               | token '=' quoted_string

/* PROXY-AUTHORIZATION */
credentials: token auth_params
           | token

auth_params: '=' token
           | '=' quoted_string
           | '=' token ',' auth_params
           | '=' quoted_string ',' auth_params

/* ACCEPT-ENCODING */
accept_encoding_value: token
            | token ';' 'Q' '=' qvalue
            | token ',' SPACES accept_encoding_value
            | token ';' 'Q' '=' qvalue ',' SPACES accept_encoding_value

/* ACCEPT-CHARSER */
accept_charset_value: token
            | token ';' '1' '=' qvalue
            | token ',' accept_charset_value
            | token ';' '1' '=' qvalue ',' accept_charset_value
/* ACCEPT */
accept_value: media_range accept_value_star
            | /* empty */

accept_value_star: ',' SPACES media_range accept_value_star
                 | /* empty */

media_range: token '/' token parameters_star

parameters_star: ';' parameter parameters_star
               | /* empty */

parameter: token '=' value
value: token | quoted_string

//////////////////////////////////////
///// RESPONSE
//////////////////////////////////////
headers_response:  ALLOW SPACE token_comma HTTP_NEWLINE headers_response
        | CONNECTION SPACE token HTTP_NEWLINE headers_response
        | CONTENT_ENCODING SPACE content_codings HTTP_NEWLINE headers_response
        | CONTENT_LANGUAGE SPACE content_languages HTTP_NEWLINE headers_response
        | CONTENT_LENGTH SPACE length_response
        | CONTENT_LOCATION SPACE content_location_data HTTP_NEWLINE headers_response
        | CONTENT_MD5 SPACE md5_digest HTTP_NEWLINE headers_response
        | CONTENT_RANGE SPACE CONTENT_RANGE_SPEC HTTP_NEWLINE headers_response
        | CONTENT_TYPE SPACE CONTENT_TYPE_DATA HTTP_NEWLINE headers_response
        | COOKIE SPACE NOTCRCL_STAR HTTP_NEWLINE headers_response
        | DATE SPACE http_date HTTP_NEWLINE headers_response
        | EXPIRES SPACE http_date HTTP_NEWLINE headers_response
        | LAST_MODIFIED SPACE http_date HTTP_NEWLINE headers_response
        | KEEP_ALIVE SPACE keep_alive_params HTTP_NEWLINE headers_response
        | PRAGMA SPACE pragma_directive HTTP_NEWLINE headers_response
        | TRAILER SPACE SOME_FIELDS HTTP_NEWLINE headers_response
        | TRANSFER_ENCODING SPACE transfer_coding HTTP_NEWLINE headers_response
        | UPGRADE SPACE product HTTP_NEWLINE headers_response
        | VIA SPACE via_data HTTP_NEWLINE headers_response
        | WARNING SPACE warning_value HTTP_NEWLINE headers_response
        | ACCEPT_RANGES SPACE acceptable_ranges HTTP_NEWLINE headers_response
        | AGE SPACE delta_seconds HTTP_NEWLINE headers_response
        | CACHE_CONTROL SPACE cache_response_directive HTTP_NEWLINE headers_response
        | ETAG SPACE entity_tag HTTP_NEWLINE headers_response
        | LOCATION SPACE absoluteURI HTTP_NEWLINE headers_response
        | PROXY_AUTHENTICATE SPACE challenges_comma HTTP_NEWLINE headers_response
        | RETRY_AFTER SPACE pause HTTP_NEWLINE headers_response
        | SERVER SPACE product_or_comma_star HTTP_NEWLINE headers_response
        | VARY SPACE vary_value HTTP_NEWLINE headers_response
        | WWW_AUTHENTICATE SPACE challenges_comma HTTP_NEWLINE headers_response
        | GENERIC_FIELD SPACE NOTCRCL_STAR HTTP_NEWLINE headers_response
        | HTTP_NEWLINE ifdef(`CHUNKED',` chunked_msg', general_body)

headers_response_CL:  ALLOW SPACE token_comma HTTP_NEWLINE headers_response_CL
        | CONNECTION SPACE token HTTP_NEWLINE headers_response_CL
        | CONTENT_ENCODING SPACE content_codings HTTP_NEWLINE headers_response_CL
        | CONTENT_LANGUAGE SPACE content_languages HTTP_NEWLINE headers_response_CL
        | CONTENT_LENGTH SPACE length_response
        | CONTENT_LOCATION SPACE content_location_data HTTP_NEWLINE headers_response_CL
        | CONTENT_MD5 SPACE md5_digest HTTP_NEWLINE headers_response_CL
        | CONTENT_RANGE SPACE CONTENT_RANGE_SPEC HTTP_NEWLINE headers_response_CL
        | CONTENT_TYPE SPACE CONTENT_TYPE_DATA HTTP_NEWLINE headers_response_CL
        | COOKIE SPACE NOTCRCL_STAR HTTP_NEWLINE headers_response_CL
        | DATE SPACE http_date HTTP_NEWLINE headers_response_CL
        | EXPIRES SPACE http_date HTTP_NEWLINE headers_response_CL
        | LAST_MODIFIED SPACE http_date HTTP_NEWLINE headers_response_CL
        | KEEP_ALIVE SPACE keep_alive_params HTTP_NEWLINE headers_response_CL
        | PRAGMA SPACE pragma_directive HTTP_NEWLINE headers_response_CL
        | TRAILER SPACE SOME_FIELDS HTTP_NEWLINE headers_response_CL
        | TRANSFER_ENCODING SPACE transfer_coding HTTP_NEWLINE headers_response_CL
        | UPGRADE SPACE product HTTP_NEWLINE headers_response_CL
        | VIA SPACE via_data HTTP_NEWLINE headers_response_CL
        | WARNING SPACE warning_value HTTP_NEWLINE headers_response_CL
        | ACCEPT_RANGES SPACE acceptable_ranges HTTP_NEWLINE headers_response_CL
        | AGE SPACE delta_seconds HTTP_NEWLINE headers_response_CL
        | CACHE_CONTROL SPACE cache_response_directive HTTP_NEWLINE headers_response_CL
        | ETAG SPACE entity_tag HTTP_NEWLINE headers_response_CL
        | LOCATION SPACE absoluteURI HTTP_NEWLINE headers_response_CL
        | PROXY_AUTHENTICATE SPACE challenges_comma HTTP_NEWLINE headers_response_CL
        | RETRY_AFTER SPACE pause HTTP_NEWLINE headers_response_CL
        | SERVER SPACE product_or_comma_star HTTP_NEWLINE headers_response_CL
        | VARY SPACE vary_value HTTP_NEWLINE headers_response_CL
        | WWW_AUTHENTICATE SPACE challenges_comma HTTP_NEWLINE headers_response_CL
        | GENERIC_FIELD SPACE NOTCRCL_STAR HTTP_NEWLINE headers_response_CL
        | HTTP_NEWLINE ifdef(`CHUNKED',` chunked_msg')

/* General BODY */
general_body: MCHAR general_body | /*empty*/

/* WWW-AUTHENTICATE */
challenge: token spaces auth_param

challenges_comma: challenge
                | challenge ',' challenges_comma

spaces: SPACE spaces
      | SPACE

auth_param: token '=' token_or_quoted_string

token_or_quoted_string: token
                      | quoted_string

/* VARY */

vary_value: tokens_comma

tokens_comma: token
            | token ',' tokens_comma

/* RETRY-AFTER */
pause: http_date | delta_seconds

/* ETAG */
entity_tag: 'W' '/' quoted_string
          | quoted_string

/* LOCATION */
absoluteURI: scheme ':' hier_or_opaque

net_or_abs_path: '/' net_or_abs_path_2
               |  pchar path_segments
               | ';' path_segments
               | /*empty*/

net_or_abs_path_2: '/' segment segment_slash_star
                 | pchar net_or_abs_path_2
                 | ';' net_or_abs_path_2
                 | /*empty*/

optional_abs_path: /*empty*/ | '/' path_segments

hier_or_opaque: '/' net_or_abs_path
              | uric_no_slash uric_star

uric_star: /*empty*/
         | uric uric_star

uric_no_slash: unreserved | escaped | ';' | '?' | ':' | '@' |
                      '&' | '=' | '+' | '$' | ','

scheme: alpha scheme_end_star

scheme_end_star: /*empty*/
               | alphanum scheme_end_star
               | '+' scheme_end_star
               | '-' scheme_end_star
               | '.' scheme_end_star

reg_name: unreserved reg_name_star
        | escaped reg_name_star
        |'$' reg_name_star
        |',' reg_name_star
        |';' reg_name_star
        |':' reg_name_star
        |'@' reg_name_star
        |'&' reg_name_star
        |'=' reg_name_star
        |'+' reg_name_star

reg_name_star: /*empty*/ | reg_name

path_segments: segment segment_slash_star
segment_slash_star: /*empty*/ | '/' segment segment_slash_star

segment: pchar_star param_semicolon_star
param_semicolon_star: /*empty*/ | ';' param param_semicolon_star
param: pchar_star

pchar: unreserved | escaped |
                      ':' | '@' | '&' | '=' | '+' | '$' | ','
pchar_star: pchar pchar_star | /*empty*/


/* CACHE-CONTROL */

cache_response_directive: spellit(public) cache_response_directive2
                         | spellit(private) cache_response_directive2
                         | spellit(private=) '"' token '"' cache_response_directive2
                         | spellit(no-cache) cache_response_directive2
                         | spellit(no-cache=) '"' token '"' cache_response_directive2
                         | spellit(no-store) cache_response_directive2
                         | spellit(no-transform) cache_response_directive2
                         | spellit(must-revalidate) cache_response_directive2
                         | spellit(proxy-revalidate) cache_response_directive2
                         | spellit(s-maxage=) delta_seconds cache_response_directive2
                         | cache_extension cache_response_directive2

cache_response_directive2: ',' SPACE cache_response_directive
                         | /* empty */

acceptable_ranges: range_units_comma_star
range_units_comma_star: token
                      | token ',' range_units_comma_star

//////////////////////////////////////
///// COMMON
//////////////////////////////////////

/* WARNING */
warning_value: warning_val
             | warning_val ',' warning_value

warning_val: warn_code SPACE warn_agent SPACE warn_text
           | warn_code SPACE warn_agent SPACE warn_text SPACE warn_date


warn_code: digit digit digit
warn_agent: token
warn_text: quoted_string
warn_date: '"' http_date '"'

/* DATE */

http_date: wkday ',' SPACE date1 SPACE time SPACE 'G' 'M' 'T'
          | weekday ',' SPACE date2 SPACE time SPACE 'G' 'M' 'T'
          | wkday SPACE date3 SPACE time SPACE four_digit

wkday: spellit(MON) | spellit(TUE) | spellit(WED) | spellit(THU) | spellit(FRI) | spellit(SAT) | spellit(SUN)

weekday: spellit(MONDAY) | spellit(TUESDAY) | spellit(WEDNESDAY) | spellit(THURSDAY) | spellit(FRIDAY) | spellit(SATURDAY) | spellit(SUNDAY)

month: spellit(JAN) | spellit(FEB) | spellit(MAR) | spellit(APR) | spellit(MAY) | spellit(JUN) | spellit(JUL) | spellit(AUG) | spellit(SEP) | spellit(OCT) | spellit(NOV) | spellit(DEC)

two_digit: digit digit
four_digit: two_digit two_digit

date1: two_digit SPACE month SPACE four_digit
date2: two_digit '-' month '-' two_digit
date3: month SPACE two_digit
       month SPACE digit

time: two_digit ':' two_digit ':' two_digit

delta_seconds: digit
             | delta_seconds digit

/* VIA */
via_data: received_protocol SPACE received_by ','
        | received_protocol SPACE received_by comment ','
        | received_protocol SPACE received_by ',' via_data
        | received_protocol SPACE received_by comment ',' via_data

received_protocol: token | token '/' token
received_by: token

/* UPGRADE */
product: token ',' product_star
       | token '/' token ',' product_star

product_star: product
            | /*empty*/

/* TRANSFER-ENCODING */
transfer_coding: transfer_extension transfer_extension_end

transfer_extension_end: SPACES
                      | SPACES ',' SPACES transfer_extension transfer_extension_end


parameters: ';' parameter parameters
          | /*empty*/

/* TRAILER */
SOME_FIELDS: FIELD
           | FIELD ',' SOME_FIELDS

FIELD: spellit(ACCEPT) | spellit(ACCEPT-CHARSET) | spellit(ACCEPT-ENCODING) | spellit(ACCEPT-LANGUAGE) |
       spellit(ACCEPT-DATETIME) | spellit(AUTHORIZATION) | spellit(CACHE-CONTROL) | spellit(CONNECTION) |
       spellit(COOKIE)| spellit(CONTENT-MD5)| spellit(CONTENT-TYPE)| spellit(DATE)| spellit(EXPECT)|
       spellit(FORWARDED)| spellit(FROM)| spellit(HOST)| spellit(IF-MATCH)| spellit(IF-MODIFIED-SINCE)|
       spellit(IF-NONE-MATCH)| spellit(IF-RANGE)| spellit(`MAX-FORWARDS')| spellit(ORIGIN)| spellit(PRAGMA)|
       spellit(PROXY-AUTHORIZATION)| spellit(RANGE)| spellit(TE)| spellit(USER-AGENT)| spellit(UPGRADE)|
       spellit(VIA)| spellit(WARNING)| spellit(ACCESS-CONTROL-ALLOW-ORIGIN)| spellit(ACCEPT-PATCH)|
       spellit(ACCEPT-RANGES)| spellit(AGE)| spellit(ALLOW)| spellit(CONTENT-ENCODING)| spellit(CONTENT-LANGUAGE)|
       spellit(CONTENT-LOCATION)| spellit(CONTENT-RANGE)| spellit(EXPIRES)| spellit(LAST-MODIFIED)| spellit(LINK)|
       spellit(LOCATION)| spellit(P3P)| spellit(PROXY-AUTHENTICATE)| spellit(PUBLICK-KEY-PINS)| spellit(REFRESH)|
       spellit(RETRY-AFTER)| spellit(SERVER)| spellit(SET-COOKIE)| spellit(STATUS)| spellit(STRICT-TRANSPORT-SECURITY)|
       spellit(TSV)| spellit(VARY)| spellit(WWW-AUTHENTICATE)| spellit(X-FRAME-OPTIONS)

/* PRAGMA */
pragma_directive: spellit(no-cache)
                | extension-pragma
extension-pragma: token
                | token'='token
                | token'='quoted_string

/* KEEP-ALIVE */
keep_alive_params: /*empty*/
                 | token '=' token keep_alive_params_more

keep_alive_params_more: ',' SPACES token '=' token keep_alive_params_more
                      | /* empty */

/* CONTENT TYPE */

CONTENT_TYPE_DATA: token '/' token parameter_star

parameter_star: ';' SPACES parameter_content_type parameter_star
          | /* empty */

parameter_content_type: token '=' value_content_type

value_content_type: token | quoted_string

/* CONTENT-RANGE */
CONTENT_RANGE_SPEC: byte_content_range_spec

byte_content_range_spec: spellit(BYTES) SPACE byte_range_resp_spec '/' more_than_one_digit
                       |  spellit(BYTES) SPACE byte_range_resp_spec '/' '*'

byte_range_resp_spec: more_than_one_digit "_" more_than_one_digit
                                      | "*"

more_than_one_digit: digit more_than_one_digit
                   | digit

/* CONTENT-MD5 */
md5_digest: copy(64,md5digit)

md5digit: alphanum | '+' | '/'

/* CONTENT-ENCODING */
content_codings: token
           | token ',' content_codings

/* ALLOW */
token_comma: token
           | token ',' token_comma

/* CONTENT-LANGUAGE */
content_languages: language_tag
           | language_tag ',' content_languages

language_tag: primary_tag subtags

subtags: "-" subtag subtags
       | /*empty*/

primary_tag: oneTo8alpha
subtag: oneTo8alpha


/* CONTENT-LOCATION */
content_location_data: '/' net_or_abs_path optional_query
                     | alpha scheme_or_rel_path
                     | escaped rel_segment_star optional_query
                     | ';' rel_segment_star optional_query
                     | '@' rel_segment_star optional_query
                     | '&' rel_segment_star optional_query
                     | '=' rel_segment_star optional_query
                     | '+' rel_segment_star optional_query
                     | '$' rel_segment_star optional_query
                     | ',' rel_segment_star optional_query
                     | digit rel_segment_star optional_query
optional_query: /*empty*/ | '?' uric_star

scheme_or_rel_path: ':' hier_or_opaque
                  | alphanum scheme_or_rel_path
                  | '+' scheme_or_rel_path
                  | '-' scheme_or_rel_path
                  | '.' scheme_or_rel_path
                  | '/' path_segments
                  | '_' rel_segment_star optional_abs_path
                  | '!' rel_segment_star optional_abs_path
                  | '~' rel_segment_star optional_abs_path
                  | '*' rel_segment_star optional_abs_path
                  | '\'' rel_segment_star optional_abs_path
                  | '(' rel_segment_star optional_abs_path
                  | ')' rel_segment_star optional_abs_path
                  | escaped rel_segment_star optional_abs_path
                  | ';' rel_segment_star optional_abs_path
                  | '@' rel_segment_star optional_abs_path
                  | '&' rel_segment_star optional_abs_path
                  | '=' rel_segment_star optional_abs_path
                  | '$' rel_segment_star optional_abs_path
                  | ',' rel_segment_star optional_abs_path


rel_segment: unreserved rel_segment_star
           | escaped rel_segment_star
           | ';' rel_segment_star
           | '@' rel_segment_star
           | '&' rel_segment_star
           | '=' rel_segment_star
           | '+' rel_segment_star
           | '$' rel_segment_star
           | ',' rel_segment_star

rel_segment_star: /*empty*/ | rel_segment

/* GENERAL */

uric: reserved | unreserved | escaped

escaped: '%' hex hex
hex: digit | 'A' | 'B' | 'C' | 'D' | 'E' | 'F'

reserved: ';' | '/' | '?' | ':' | '@' | '&' | '=' | '+' |
                      '$' | ','

unreserved: alphanum
          | mark

mark: '-' | '_' | '.' | '!' | '~' | '*' | '\'' | '(' | ')'

digit: '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9'

alpha: 'A' | 'B' | 'C' | 'D' | 'E' | 'F' | 'G' | 'H' | 'I'
     | 'J' | 'K' | 'L' | 'M' | 'N' | 'O' | 'P' | 'Q' | 'R'
     | 'S' | 'T' | 'U' | 'V' | 'W' | 'X' | 'Y' | 'Z'

alphanum: alpha
        | digit

token: alphanum token2 | '-' token2 | '.' token2 | '*' token2
     | CHAR token2

token2: token
      | /* empty */

NOTCRCL: uric | CHAR | SPACE | '{' | '}' | '[' | ']' | '\\' | '<' | '>' | '"'

NOTCRCL_STAR: NOTCRCL NOTCRCL_STAR | /*empty*/

quoted_string: '"' qstring '"'
qstring: qdtext qstring
       | /*empty */

qdtext:  'Q' | 'W' | 'E' | 'R' | 'T' | 'Y' | 'U' | 'I' | 'O' | 'P' | 'A' | 'S'
       | 'D' | 'F' | 'G' | 'H' | 'J' | 'K' | 'L' | 'Z' | 'X' | 'C' | 'V' | 'B'
       | 'N' | 'M' | '-' | ':' | '.' | '/' | '(' | ')' | '<' | '>' | '@'
       | ',' | ';' | '\\'| '[' | ']' | '?' | '=' | '{' | '}' | digit
       | SPACE | CHAR

dtext:  'Q' | 'W' | 'E' | 'R' | 'T' | 'Y' | 'U' | 'I' | 'O' | 'P' | 'A' | 'S'
       | 'D' | 'F' | 'G' | 'H' | 'J' | 'K' | 'L' | 'Z' | 'X' | 'C' | 'V' | 'B'
       | 'N' | 'M' | '-' | ':' | '.' | '/' | '(' | ')' | '<' | '>' | '@'
       | ',' | ';' | '?' | '=' | '{' | '}' | digit
       | SPACE | CHAR

quoted_pair: '\\' CHAR

qvalue: '0' '.' upTo3digits
      | '0'
      | '1' '.' upTo3zeros
      | '1'

upTo3zeros: /*empty*/ | '0' | '0' '0' | '0' '0' '0'
upTo3digits: /*empty*/ | digit | digit digit | digit digit digit

SPACES: SPACE SPACES
      | /*empty*/

dnl Auxiliary def = innermost loop
define(`Xcountdown', `QUOTE`'$1`'QUOTE X`'decr($2)_$3 copy($1, F`'$2)
ifelse(eval($1 > 1), 1, `| Xcountdown(decr($1),$2,$3)', `| QUOTE`'0`'QUOTE X`'decr($2)_$3 ')')dnl
dnl run_parser.sh:L69→L98
define(`countdownX', `X$1_$2 : Xcountdown(9,$1,$2)
 ifelse(eval($1 > 2), 1, `countdownX(decr($1),$2)', `')')dnl

dnl MAX is the maximum size for the content length field
countdownX(MAX,request)
countdownX(MAX,response)
dnl
dnl Auxiliary def
define(`aux_countdown', `QUOTE`'$1`'QUOTE HTTP_NEWLINE headers_$2_CL copy($1, MCHAR)
ifelse(eval($1 > 1), 1, `| aux_countdown(decr($1),$2)', `| QUOTE`'0`'QUOTE HTTP_NEWLINE headers_$2_CL ')')dnl
dnl run_parser.sh:L100→122
define(`countdownY', `X1_$1 : aux_countdown(9,$1)')dnl
dnl
countdownY(request)
countdownY(response)
/* DEFINING TYPES OF DATA */
MCHAR: CHAR | SPACE | CARRIAGE_RETURN | NEW_LINE |'Q'| 'W' | 'E' | 'R' | 'T' | 'Y'
| 'U' | 'I' | 'O' | 'P' | 'A' | 'S' | 'D' | 'F' | 'G' | 'H' | 'J' | 'K' | 'L' | 'Z'
| 'X' | 'C' | 'V' | 'B' | 'N' | 'M' | '-' | '_' | ':' | '.' | '~' | '!' | '*' | '/'
| '(' | ')' | '\'' | '<' | '>' | '@' | ',' | ';' | '\\' | '"' | '[' | ']' | '?' | '='
| '{' | '}' | '%' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' | '0'
dnl
dnl A first definition from run_parser.sh:L138→L152
define(`countdown', `F$1 : copy(10,F`'decr($1))
 ifelse(eval($1 > 3),1, `countdown(decr($1))', `F2 : copy(10,MCHAR)')')dnl
dnl
countdown(MAX)

define(`allLengths', `X$1_$2 | ifelse(eval($1 > 2),1, `allLengths(decr($1),$2)', `X1_$2')')dnl

length_request: allLengths(MAX,request)
length_response: allLengths(MAX,response)

ifdef(`CHUNKED',
dnl Chunked message
define(`hexadecimal', `ifelse($1,15,`F',$1,14,`E',$1,13,`D',$1,12,`C',$1,11,`B',$1,10,`A',$1)')dnl


dnl Auxiliary def = innermost loop
define(`Xcountdown', `QUOTE`'hexadecimal($1)`'QUOTE X`'decr($2)_$3 copy($1, G`'$2)
ifelse(eval($1 > 1), 1, `| Xcountdown(decr($1),$2,$3)', `| QUOTE`'0`'QUOTE X`'decr($2)_$3 ')')dnl

dnl run_parser.sh:L69→L98
define(`countdownX', `X$1_$2 : Xcountdown(15,$1,$2)
 ifelse(eval($1 > 2), 1, `countdownX(decr($1),$2)', `')')dnl


`countdownX(MAX,chunk)

dnl
dnl Auxiliary def
define(`aux_countdown', `QUOTE`'hexadecimal($1)`'QUOTE CARRIAGE_RETURN NEW_LINE copy($1, MCHAR)
ifelse(eval($1 > 1), 1, `| aux_countdown(decr($1),$2)', `| QUOTE`'0`'QUOTE CARRIAGE_RETURN NEW_LINE')')dnl
dnl run_parser.sh:L100→122
define(`countdownY', `X1_$1 : aux_countdown(15,$1)')dnl
dnl
countdownY(chunk)

define(`allLengths', `X$1_$2 CARRIAGE_RETURN NEW_LINE chunked_msg | ifelse(eval($1 > 3),1, `allLengths(decr($1),$2)', `X2_$2 CARRIAGE_RETURN NEW_LINE chunked_msg')')dnl
chunked_msg: allLengths(MAX, chunk) | X_end

dnl Auxiliary def
define(`aux_countdown', `QUOTE`'hexadecimal($1)`'QUOTE CARRIAGE_RETURN NEW_LINE copy($1, MCHAR) CARRIAGE_RETURN NEW_LINE chunked_msg
ifelse(eval($1 > 1), 1, `| aux_countdown(decr($1),$2)', `| QUOTE`'0`'QUOTE CARRIAGE_RETURN NEW_LINE CARRIAGE_RETURN NEW_LINE')')dnl
dnl run_parser.sh:L100→122
define(`countdownY', `X_end : aux_countdown(15,$1)')dnl
dnl
countdownY(chunk)


define(`countdown', `G$1 : copy(16,G`'decr($1))
 ifelse(eval($1 > 3),1, `countdown(decr($1))', `G2 : copy(16,MCHAR)')')dnl
dnl
countdown(MAX)
')

%%
int yyerror(char *s){
    printf("\n\x1B[31mInvalid HTTP packet: %s\033[0m\n",s);
    exit(0);
}

/************************************************
** Main program
*************************************************/

int main(int argc, char *argv[]){

    /*Comprobamos los argumentos de entrada*/
   if(argc!=2 || argv[1] == NULL){
        printf("Invalid argument: parser input_file\n");
        return -1;
    }

    yyin = fopen(argv[1], "r");
    if (yyin == NULL){
        printf("Invalid input file\n");
        return -1;
    }

    yyparse();

    printf("\n\x1B[32mIt's a valid HTTP packet\033[0m\n");
    printf("-----------------------------------\n\n");
    return 0;
}
