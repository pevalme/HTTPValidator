####################################
#                                  #
# Author: Pedro Valero Mejia       #
#         						   #
# Date:   15/09/16                 #
#                                  #
####################################

SUB_PARSERS_FOLDER=sub_parsers
OUTPUT=bison.y
PARSER=parser
PARSER_CHUNK=parserChunk

all:
	@echo "Compiling needed subparsers..."
	cd $(SUB_PARSERS_FOLDER); flex -o lex.yy.c chunked.l ; gcc -Werror -o chunked lex.yy.c; flex -o lex.yy.c duplicate_fields.l; gcc -Werror -o duplicate_fields lex.yy.c; flex -o lex.yy.c others.l ; gcc -Werror -o others lex.yy.c; rm lex.yy.c

	@echo "Compiling main parser for chunked messages..."
	flex -w flex.l
	m4 -DCHUNKED="YES" parser.y.m4 > $(OUTPUT)
	bison -d -Werror=conflicts-sr,error=conflicts-rr --verbose $(OUTPUT)
	gcc -w -o $(PARSER_CHUNK) -I . bison.tab.c lex.yy.c
	rm bison.tab.c; rm bison.tab.h

	@echo "Compiling main parser for not-chunked messages..."
	m4 parser.y.m4 > $(OUTPUT)
	bison -d -Werror=conflicts-sr,error=conflicts-rr --verbose $(OUTPUT)
	gcc -w -o $(PARSER) -I . bison.tab.c lex.yy.c
	rm bison.tab.c; rm bison.tab.h

	@echo "Done"