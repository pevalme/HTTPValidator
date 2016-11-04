#!/bin/bash
#
# Author:	Pedro Valero
#
# Description: Script to run the http parser over several examples.
#
# Date: 1/4/16

TMP="tmp.txt"
AUX="tmp2.txt"
# HHTPolice vs Our Implementation
BB=0
GG=0
BG=0
GB=0

# List of COMMENTS and DEBUG notices in HTTPolice.
DEBUG_COMMENTS="1003,1007,1010,1011,1012,1014,1017,1021,1022,1025,1030,1032,1035,1036,1041,1042,1047,1053,1055,1056,1057,1059,1061,1067,1070,1073,1077,1078,1079,1081,1084,1087,1092,1093,1094,1096,1104,1106,1110,1112,1113,1117,1119,1123,1127,1131,1142,1146,1150,1154,1155,1160,1161,1162,1168,1169,1170,1171,1178,1179,1180,1183,1184,1185,1186,1188,1189,1190,1197,1200,1201,1203,1204,1205,1213,1214,1215,1216,1219,1226,1227,1235,1236,1238,1242,1243,1248,1249,1250,1251,1252,1255,1258,1267,1268,1269,1270,1271,1272,1275,1277,1278"

if [ $# -eq 0 ]
	then
	echo "Usage: ./run_tests.sh file1 file2 file3 ..."
	echo "Informs about the correctness of a serie of HTTP messages given as argument."
	exit
fi

TESTS=$@

echo "Preparing parsers..."
make

for i in $TESTS; do
	# echo -e "Working on test \e[1m"$i"\e[0m"
	firstLine=$(head -n 1 $i)
	if [[ "$firstLine" == "HTTP"* ]]; then
		eval "httpolice -s 1276 -s{$DEBUG_COMMENTS} -i resp-stream $i > $AUX"
	else
		eval "httpolice -s 1276 -s{$DEBUG_COMMENTS} -i req-stream $i > $AUX"
	fi

	./run_parser.sh $i > $TMP
	error=0
	while read line
	do
	  if [[ "$line" == *"Wrong message."* ]]; then
	  	echo -e "HTTP message contained in \e[3m"$i"\e[0m is\e[1m NOT correct.\e[0m"
	  	error=1
	  	if [[ -s $AUX ]]; then
			#echo -e "HTTPolice considers message "$i"\e[1;31m\e[1m contains an error\e[0m"
			BB=$((BB + 1))
		else
			echo -e "HTTPolice considers message \e[3m"$i"\e[0m is\e[1m correct\e[0m"
			echo -e "\e[31m\e[1mUNCONSISTENT RESULTS\e[0m"
			GB=$((GB + 1))
		fi
	  	break
	  fi

	  if [[ "$line" == *"Invalid HTTP packet"* ]]; then
	  	echo -e "HTTP message contained in \e[3m"$i"\e[0m is\e[1m NOT correct.\e[0m"
	  	error=1
	  	if [[ -s $AUX ]]; then
			#echo -e "HTTPolice considers message "$i"\e[1;31m\e[1m contains an error\e[0m"
			BB=$((BB + 1))
		else
			echo -e "HTTPolice considers message \e[3m"$i"\e[0m is\e[1m correct\e[0m"
			echo -e "\e[31m\e[1mUNCONSISTENT RESULTS\e[0m"
			GB=$((GB + 1))
		fi
	  	break
	  fi
	done < $TMP

	if [ $error -eq 0 ]; then
		echo -e "HTTP message contained in \e[3m"$i"\e[0m is\e[1m correct.\e[0m"
		if [[ -s $AUX ]]; then
			echo -e "HTTPolice considers message \e[3m"$i"\e[0m is\e[1m NOT correct\e[0m"
			echo -e "\e[31m\e[1mUNCONSISTENT RESULTS\e[0m"
			cat $AUX
			BG=$((BG + 1))
		else
			#echo -e "HTTPolice considers message "$i"\e[1m is correct\e[0m"
			GG=$((GG + 1))
		fi
	fi
	echo "------------------------------"
done

rm $TMP $AUX
echo ""
echo "Summary [HTTPolice vs Our Implementation]:"
echo "[Good, Good]: "$GG
echo "[Good, Bad]: "$GB
echo "[Bad, Bad]: "$BB
echo "[Bad, Good]: "$BG
