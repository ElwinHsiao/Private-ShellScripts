#!/bin/bash

apks=
outputDir=./extractedJniLibs

red='\e[0;31m'
green='\e[0;32m'
NC='\e[0m' # No Color
bold=`tput bold`
normal=`tput sgr0`

usage() 
{ 
	echo "Usage: "
	echo "  $0 [options] [file...]"
	echo "Options:"
	echo "  -d <directory>: Specify the directory to place the libraries, default value is ${outputDir}."
	echo "  -v: Verbose, print the details."
	echo "  -h: Print this information."
	echo "  [file...]: The APKs from where extract libraries. You may use wildcards(*?) which will be expanded by Shell."
	echo "Examples:"
	echo "  $0 hello.apk"
	echo "  $0 *.apk"
	echo "  $0 -d /tmp/dir1 hello.apk"
	exit 1
}

extractLibs()
{
	libs=(`zipinfo -1 $1 lib/armeabi-v7a/* 2>/dev/null | sed 's,.*/,,g'`)
	unzip -oud ${outputDir} $1 lib/armeabi-v7a/* > /dev/null 2>&1; isSuccess=$?
	
	if [ "${v}" == "1" ]; then
		echo -n "extract Libs: $1"
		if [ ${isSuccess} -eq 0 ]; then
			echo -e "  ${green}[${libs[*]}]${NC}"
		else
			echo -e "  ${red}[NONE]${NC}"
		fi
	fi
	# echo "		unzip returnd: $isSuccess"
}

while getopts "d:vh" o; do
    case "${o}" in
        d)
            d=${OPTARG}
            ;;
        v)
			v=1;
            ;;
        h)
			usage
            ;;
		*)
            usage
            ;;
    esac
done

shift $((OPTIND-1))
if [ ! -z "${d}" ] && [ "${d}" != "" ]; then
	outputDir=${d}
fi


#echo "Libraries will extract to directory (${outputDir})"

if [ "$#" -eq 0 ]; then
	usage
fi

apks=$*
#echo "apks=${apks}"

for apk in ${apks[*]} 
do
	# echo "apk=${apk}"
	extractLibs ${apk}
done

if [ -d ${outputDir}/lib/armeabi-v7a ]; then
	# move to destination
	mv ${outputDir}/lib/armeabi-v7a/* ${outputDir}/
	rm ${outputDir}/lib -rf
	
	echo ""
	echo "${bold}Libraries extracted: ${normal}"
	tree ${outputDir} --noreport
else
	echo "${bold}No library found!${normal}"
fi


