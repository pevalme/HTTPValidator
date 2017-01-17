#!/bin/bash
#
# Author:	Pedro Valero
#
# Description: Script use to compile the parser used to
# validate HTTP messages and run it.
#
# Date: 02/09/16

# HTTP Validator. Copyright (C) 2016  Pedro Valero
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


SUB_PARSERS_FOLDER="sub_parsers"
REPEATED_FIELDS=$SUB_PARSERS_FOLDER/"duplicate_fields"
CHUNKED=$SUB_PARSERS_FOLDER/"chunked"
OTHERS=$SUB_PARSERS_FOLDER/"others"
MUST=$SUB_PARSERS_FOLDER/"must"
COMPARISON=$SUB_PARSERS_FOLDER/"comparison"

PARSER="parser"
PARSER_CHUNK="parserChunk"
PARSER_RESP_CHUNK="parserRespChunk"
PARSER_REQ_CHUNK="parserReqChunk"

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
  echo "Wrong message."
  exit
fi

echo "Checking for more constraints..."
PARSERS=$(ls --ignore='*.*' $MUST)
for p in $PARSERS; do
  ./$MUST/$p $1
  if [ $? -ne 0 ]
    then
    echo "Wrong message."
    exit
  fi
done

echo "Checking comparison-related constraints..."
# TODO: This should be implemented to be more general.
declare -a PARSERS=("E1105_0" "E1105_1" "E1105_2")
flag=0
for p in "${PARSERS[@]}"
do
  ./$COMPARISON/$p $1
  if [ $? -ne 0 ]
    then
    flag=1
  fi
done

if [ $flag -eq 0 ]
  then
  echo "1105"
  echo "Wrong message."
  exit
fi

echo "Checking if the message is chunked..."
./$CHUNKED $1
ret=$?
echo $ret
if [ $ret -eq 1 ]
  then
  ./$PARSER_REQ_CHUNK $1
elif [ $ret -eq 2 ]
  then
  ./$PARSER_CHUNK $1
elif [ $ret -eq 3 ]
  then
  ./$PARSER_RESP_CHUNK $1
elif [ $ret -eq 4 ]
  then
  ./$PARSER_CHUNK $1
else
  ./$PARSER $1
fi

