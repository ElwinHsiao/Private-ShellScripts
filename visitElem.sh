#!/bin/bash

function convert_utf8()
{
	value=$1
	echo "${value}"
	fileTy=`file ${value} | cut -d' ' -f2`
	echo "  -- file encode is ${fileTy}."
	
	if [ "$fileTy" != "UTF-8" ]; then
		echo "  -- convert to UTF-8"
		cp ${value} ${value}.bak
		
		iconv -f GBK -t UTF-8 ${value} -o ${value}
		#file ${value}
	fi
	
	echo ""
}

convert_utf8 $1
