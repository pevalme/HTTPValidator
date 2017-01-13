# HTTP Validator

HTTP Validator is an input validator for HTTP messages that relies on recognizers for context-free and regular languages (implemented using Bison and Flex respectively) to perform the validation.

HTTP Validator is a **proof of concept** implementation developed to back up the theoretical results presented in [this technical report][paper].

### HTTPolice
We consider [HTTPolice][HTTPolice] as a reference tool due to its completeness and the [detailed description][HTTPNotices] of the detected errors provided. In order to facilitate the tool comparison, HTTP Validator has been implemented to receive single messages or request-response pairs within the *streams* and *combined* formats, respectively, defined by HTTPolice. Besides, we have developed a [script][runTests] to validate a series of messages and compare the results with HTTPolice.

Over the set of tests provided in this repository we obtain the following results, which are detailed in [our paper][paper].
<center>
<table>
  <tr>    
  	<td>HTTP Validator \ HTTPolice </td>
    <th>Accept</th>
    <th>Reject</th>
  </tr>
  <tr>
  	<th>Accept</th>
    <td align="center">117</td>
    <td align="center">2</td>    
  </tr>
  <tr>
  	<th>Reject</th>
    <td align="center">0</td>
    <td align="center">121</td>    
  </tr>
</table>
</center>

## Requirements
- bison 3.0.4
- flex 2.6.0
- m4 1.4.17

*Older versions of such programs have not been tested*

## Usage
Before running HTTP Validator it must be compiled by running `make` from the root folder of this repository.

To run the parser:
```shell
	$ ./run_parser.sh input_file
```
To run the parser over a bunch of files and compare with HTTPolice:
```shell
	$ ./run_tests.sh file1 file2 file3 ...
```

## Improvements

At the current stage of development, no effort was invested in making the tool performant.

Nonetheless, the parsing process consists of running multiple parsers one after the other. Since the parsers are independent from each other, they could, in principle, run in parallel. Besides, the parser so called [others][others] consists of many regular expressions, each of which detects a different error. These regular expression are independent and can be split in several files to be run in parallel.

## Errors detected
The following table contains all the errors detected by HTTPolice (as noted [here][HTTPNotices]) classified according to if they are already implemented and detected by HTTP Validator, they can be implemented but are not so yet or they are out of the scope of HTTPolice.

|  Implemented  | Not implemented  | Out of scope  |
|---|---|---|
| E1000: Malformed header | | |
| E1001: Final Transfer-Encoding is not chunked | | |
| E1004: Incomplete message according to Content-Length| | |
| E1005: Malformed Transfer-Encoding: chunked | | |
| E1006: Malformed request heading | | |
| | | E1008: Not enough requests |
| E1009: Malformed response heading | | |
| E1013: Multiple header headers | | |
| E1015: Bad whitespace (BWS) in header | | |
| E1016: Obsolete line folding in headers | | |
| E1018: Transfer-Encoding in a status response | | |
| E1019: Transfer-Encoding in a status response to CONNECT | | |
| E1020: Transfer-Encoding together with Content-Length | | |
| E1023: Content-Length in a status response | | |
| E1024: Content-Length in a status response to CONNECT | |
| E1026: Limit trailer valid values | | |
| | | E1027: Could not decode Transfer-Encoding: coding |
| E1028: TE: chunked | | |
| E1029: TE without “Connection: TE” | | |
| E1031: No Host header | | |
| E1033: status response to a request with a bad Host header | | |
| E1034: Connection: header | | |
| | | E1037: Could not decode Content-Encoding |
| | E1038: Bad JSON body | |
| | E1039: Bad XML body | |
| | | E1040: Bad URL-encoded body |
| E1045: Bad request target | | |
| | | E1046: Proxied response without Via |
| E1048: 101 response with no Upgrade header | | |
| | | E1049: Switching to a protocol that was not requested |
| E1050: Upgrade header without “Connection: upgrade" | | |
| E1051: 101 response to an HTTP/1.0 request | | |
| E1052 header in a status response | | |
| E1054: Trailer header with no chunked body | | |
| E1058: status response to a PUT request with Content-Range | | |
| | E1060: Strange Content-Location in response to DELETE |
| E1062: OPTIONS request with a body but no Content-Type | | |
| E1063: Request with a header header | | |
| E1063: Response with a header header | | |
| E1066: “Expect: 100-continue” with no body | | |
| | | E1068: Referer with ‘https:’ in an unsecured request |
| E1071: status response to an HTTP/1.0 request | | | 
| E1072: 201 response to method | | |
| E1074: 202 response to method | | |
| E1076: 205 response with a body | | |
| E1080: 303 response with no Location header | | |
| E1082: Deprecated status code 305 | | |
| E1083: Reserved status code 306 | | |
| | E1085: Redirection to the same URI | |
| E1086: status response to a server-wide OPTIONS request | | |
| E1088: Reserved status code 402 | | |
| E1089: 405 response with no Allow header | | |
| E1090: Probably wrong use of status code 406 | | |
| E1095: 409 response to a method request | | |
| E1097: 411 response to a request with Content-Length | | |
| E1098: 413 response to a request with no body | | |
| E1099: 415 response to a request with no body | | |
| E1100: 417 response to a request with no Expect | | |
| E1101: 426 response with no Upgrade header | | |
| | E1102: Wrong 426 response | |
| | E1103: Not proceeding with protocol upgrade | |
| E1105: 505 response with the same version as the request | | |
| E1107: Obsolete date-time format in place | | |
| | E1109: Date header is in the future | |
| E1111: Location with a fragment (#) in a 201 response | | |
| E1114: Allow actually includes method | | |
| | E1115: Allow does not include method | |
| E1116: Accept-Encoding: coding with a quality value | | |
| | E1118: Last-Modified later than Date\* | |
| E1120 Weak entity tag in If-Match | | |
| | E1121: If-None-Match was ignored | |
| E1122: If-Modified-Since in a method request | | |
| E1124: 304 response to a method request | | |
| E1125: Probably wrong use of status code status | | |
| E1128: If-Modified-Since was not ignored | | |
| E1129: Wrong 412 response | | |
| E1130: header in a method request | | |
| E1132: Range header in a method request | | |
| | | E1133: Invalid byte range in place\* |
| E1134: If-Range without a Range header | | |
| E1135: Weak entity tag in If-Range | | |
| E1136: 206 response to a request with no Range header | | |
| E1137: 206 response to a method request | | |
| E1138: 206 response without range specifiers | | |
| E1139: Multipart boundary not declared | | |
| | | E1140: Multipart boundary not found\* |
| | E1141: No Content-Range in part #part_num | |
| E1143: Content-Range in a multipart/byteranges response | | |
| E1144: multipart/byteranges response to a request for a single Range | | |
| | | E1145: Wrong 206 response |
| E1147: Content-Range in a status response | | |
| | E1148: Invalid byte range in place\* | |
| E1149: 416 response to a request with no Range | | |
| E1151: Empty list element in place | | |
| E1152: Cache-Control: directive in a request | | |
| E1153: Cache-Control: directive in a response | | |
| E1156: entry: directive without argument | | |
| E1157: entry: directive with argument | | |
| E1158: Malformed place: directive | | |
| E1159: Cache-Control: no-cache with argument | | |
| E1163: Strange warn code code | | |
| | E1164: Warning date does not match the Date header\* | |
| E1165: Warning: code in a request | | |
| E1166: Response from cache without Age | |
| E1167: Bad status code status | |
| E1172: Response from cache to a method request | | |
| E1173: Response from cache to a request with Cache-Control: no-cache | | |
| E1174: Response from cache to a request with Pragma: no-cache | | |
| | E1175: Response from cache with Cache-Control: no-cache | |
| E1176: Response from cache with Cache-Control: no-store | | |
| | E1177: Non-cacheable status response served from cache | |
| E1181: Heuristic freshness when Expires is present | | |
| E1182 Heuristic freshness when max-age is present | | |
| | E1187: Stale response with Cache-Control: must-revalidate | |
| E1191 | | |
| | E1193: Cache-Control: directive1, directive2 | |
| E1194: 401 response without WWW-Authenticate | | |
| E1195: 407 response without Proxy-Authenticate | | |
| E1196: Unquoted ‘realm’ parameter in place | | |
| E1198: “Connection: close” in a status response | | |
| E1199: “Connection: close” in a status response to CONNECT | | |
| E1202: status response from cache | | |
| E1206: header: Basic with no realm | | |
| | E1207: header: Basic with a ‘param’ parameter | |
| E1208: header: Basic with a “charset” charset | | |
| | | E1209: Malformed header: Basic | |
| | | E1210: Malformed header: Basic |
| | | E1211: Malformed header: Basic |
| E1212: Control character char in header: Basic | |
| E1217: Accept-Patch without “Allow: PATCH” | | |
| | E1218: HSTS without max-age | |
| | E1220: Multiple directive directives in HSTS | |
| | | E1221: Strict-Transport-Security without TLS |
| | E1222: Impossible date in place | |
| | E1223: Impossible time in place | |
| E1224: LF without CR in place | | |
| | E1225: Multiple ‘name’ parameters in place | |
| E1228: Upgrade: h2 | | |
| E1230: HTTP2-Settings without “Connection: http2-settings” | | |
| E1231: “Upgrade: h2c” without HTTP2-Settings | | |
| | E1232: Upgrading to HTTP/2 despite bad HTTP2-Settings | |
| | | E1233: “Upgrade: h2c” on an encrypted connection |
| | | E1234: Malformed HTTP2-Settings |
| | E1237: Response to a direct request transformed by proxy | |
| E1239: Body in a response to HEAD | | |
| E1240: 204 response with a body | | |
| | E1241: Date + Age is in the future\* | |
| E1244: header header in an HTTP/2 message | | |
| E1245: Upgrade header in an HTTP/2 message | | |
| E1246: 101 response over HTTP/2 | | |
| | E1247: Content-Disposition: multiple ‘param’ parameters | |
| | E1253: Bad charset ‘charset’ in place | |
| | | E1254: Bad encoded value in place |
| | | E1256: Bad encoding of protocol ID in Alt-Svc |
| E1257: Malformed authority in Alt-Svc | | |
| E1259: Malformed param parameter in place | | |
| E1260: 421 response with Alt-Svc | | |
| E1262: Malformed Authorization: Bearer | |
| E1264: Malformed WWW-Authenticate: Bearer | |
| | | E1265: WWW-Authenticate: Bearer with multiple ‘param’ parameters |
| E1266: Malformed ‘param’ parameter in WWW-Authenticate | | |
| E1273: Malformed header: Basic | | |
| | | E1274: Probably malformed header header. *Not really an error* |
| | E1276: Header: wildcard is as good as value |
| | | E1279: Unprocessable streams |

[RFC]: https://tools.ietf.org/html/rfc7230#page-21
[paper]: https://arxiv.org/abs/1610.07198
[duplicateFields]: ./sub_parsers/duplicate_fields.l
[chunked]: ./sub_parsers/chunked.l
[others]: ./sub_parsers/others.l
[contentLengthSize]: ./sub_parsers/get_content_length_field_size.l
[runParser]: ./run_parser.sh
[runTests]: ./run_tests.sh
[Makefile]: ./Makefile
[mainParser]: ./parser.y.m4
[HTTPolice]: https://github.com/vfaronov/httpolice/
[HTTPNotices]: http://pythonhosted.org/HTTPolice/notices.html

