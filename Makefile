################################################################################
#                                  											   #
#    Author: Pedro Valero Mejia                                                #   
#            					                                               #   
#    Date:   15/09/16                                                          #   
#                                                                              # 
#	 HTTP Validator. Copyright (C) 2016  Pedro Valero                          #
#                                                                              #
#    This program is free software: you can redistribute it and/or modify      #
#    it under the terms of the GNU General Public License as published by      #
#    the Free Software Foundation, either version 3 of the License, or         #
#    (at your option) any later version.                                       #
#                                                                              #
#    This program is distributed in the hope that it will be useful,           #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of            #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             # 
#    GNU General Public License for more details.                              #
#                                                                              #
#    You should have received a copy of the GNU General Public License         #
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.     #
################################################################################

SUB_PARSERS_FOLDER=sub_parsers
MUST_PARSERS=must
COMPARISON_PARSERS=comparison
OUTPUT=bison.y
PARSER=parser
PARSER_RESP_CHUNK=parserRespChunk
PARSER_REQ_CHUNK=parserReqChunk
PARSER_CHUNK=parserChunk

all:
	@echo "Compiling needed subparsers..."
	cd $(SUB_PARSERS_FOLDER); flex -o lex.yy.c chunked.l ; gcc -Werror -o chunked lex.yy.c; flex -o lex.yy.c duplicate_fields.l; gcc -Werror -o duplicate_fields lex.yy.c; flex -o lex.yy.c others.l ; gcc -Werror -o others lex.yy.c; rm lex.yy.c
	cd $(SUB_PARSERS_FOLDER)/$(MUST_PARSERS); flex E1029.l; gcc -Werror -o E1029 lex.yy.c; flex E1054.l; gcc -Werror -o E1054 lex.yy.c; flex E1100.l; gcc -Werror -o E1100 lex.yy.c; flex E1139.l; gcc -Werror -o E1139 lex.yy.c; flex E1194.l; gcc -Werror -o E1194 lex.yy.c; flex E1230.l; gcc -Werror -o E1230 lex.yy.c; flex E1031.l; gcc -Werror -o E1031 lex.yy.c; flex E1058.l; gcc -Werror -o E1058 lex.yy.c; flex E1101.l; gcc -Werror -o E1101 lex.yy.c; flex E1147.l; gcc -Werror -o E1147 lex.yy.c; flex E1195.l; gcc -Werror -o E1195 lex.yy.c; flex E1231.l; gcc -Werror -o E1231 lex.yy.c; flex E1033.l; gcc -Werror -o E1033 lex.yy.c; flex E1062.l; gcc -Werror -o E1062 lex.yy.c; flex E1125.l; gcc -Werror -o E1125 lex.yy.c; flex E1149.l; gcc -Werror -o E1149 lex.yy.c; flex E1206.l; gcc -Werror -o E1206 lex.yy.c; flex E1034.l; gcc -Werror -o E1034 lex.yy.c; flex E1080.l; gcc -Werror -o E1080 lex.yy.c; flex E1128.l; gcc -Werror -o E1128 lex.yy.c; flex E1166.l; gcc -Werror -o E1166 lex.yy.c; flex E1207.l; gcc -Werror -o E1207 lex.yy.c; flex E1048.l; gcc -Werror -o E1048 lex.yy.c; flex E1089.l; gcc -Werror -o E1089 lex.yy.c; flex E1136.l; gcc -Werror -o E1136 lex.yy.c; flex E1174.l; gcc -Werror -o E1174 lex.yy.c; flex E1208.l; gcc -Werror -o E1208 lex.yy.c; flex E1050.l; gcc -Werror -o E1050 lex.yy.c; flex E1090.l; gcc -Werror -o E1090 lex.yy.c; flex E1138.l; gcc -Werror -o E1138 lex.yy.c; flex E1191.l; gcc -Werror -o E1191 lex.yy.c; flex E1217.l; gcc -Werror -o E1217 lex.yy.c
	cd $(SUB_PARSERS_FOLDER)/$(COMPARISON_PARSERS); flex -o lex.yy.c E1105.l; bison -o bison.tab.c E1105_0.y; gcc -w -o E1105_0 bison.tab.c lex.yy.c; bison -o bison.tab.c E1105_1.y; gcc -w -o E1105_1 bison.tab.c lex.yy.c; bison -o bison.tab.c E1105_2.y; gcc -w -o E1105_2 bison.tab.c lex.yy.c;
	@echo "Compiling main parser..."
	flex -w flex.l
	m4 -DCHUNKED="YES" -DCHUNK="YES" parser.y.m4 > $(OUTPUT)
	bison -d --verbose $(OUTPUT)
	gcc -w -o $(PARSER_CHUNK) -I . bison.tab.c lex.yy.c
	rm bison.tab.c; rm bison.tab.h

	@echo "Lets go for the second"

	m4 parser.y.m4 > $(OUTPUT)
	bison -d --verbose $(OUTPUT)
	gcc -w -o $(PARSER) -I . bison.tab.c lex.yy.c
	rm bison.tab.c; rm bison.tab.h

	@echo "Now the third..."

	m4 -DCHUNKED_RESP="YES" -DCHUNK="YES" parser.y.m4 > $(OUTPUT)
	bison -d --verbose $(OUTPUT)
	gcc -w -o $(PARSER_RESP_CHUNK) -I . bison.tab.c lex.yy.c
	rm bison.tab.c; rm bison.tab.h

	@echo "And the last one"

	m4 -DCHUNKED_REQ="YES" -DCHUNK="YES" parser.y.m4 > $(OUTPUT)
	bison -d --verbose $(OUTPUT)
	gcc -w -o $(PARSER_REQ_CHUNK) -I . bison.tab.c lex.yy.c
	rm bison.tab.c; rm bison.tab.h

	@echo "Done"