#!/bin/bash
#
# Author:	Pedro Valero
#
# Description: Script use to compile the parser used to
# validate HTTP messages and run it.
#
# Date: 02/09/16

SUB_PARSERS_FOLDER="sub_parsers"
REPEATED_FIELDS=$SUB_PARSERS_FOLDER/"duplicate_fields"
CHUNKED=$SUB_PARSERS_FOLDER/"chunked"
OTHERS=$SUB_PARSERS_FOLDER/"others"
COMBINED=$SUB_PARSERS_FOLDER/"combined"

PARSER="parser"
PARSER_CHUNK="parserChunk"

if [ $# -eq 0 ]
	then
	echo "Usage: ./run_parser.sh <input_file>"
	echo "Informs about the correctness of a HTTP message given as argument"
	exit
fi

if [ ! -f $1 ]; then
    echo "File not found!"
    exit
fi

echo "Checking for invalid duplicate fields..."
./$REPEATED_FIELDS $1

if [ $? -ne 0 ]
  then
  echo "Wrong message. Duplicate fields"
  exit
fi

echo "Checking for a variety of possible many errors..."
./$OTHERS $1
if [ $? -ne 0 ]
  then
  echo "Wrong message. Some semantic error occur."
  exit
fi

./$COMBINED $1
if [ $? -ne 0 ]
  then
  echo "Wrong message. Some semantic error occur."
  exit
fi

echo "Checking if the message is chunked..."
./$CHUNKED $1

if [ $? -ne 0 ]
  then
  ./$PARSER_CHUNK $1
  else
  ./$PARSER $1
fi

