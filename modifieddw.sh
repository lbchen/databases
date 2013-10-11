#!/bin/bash
#
#
#
if [ ! -d ./data ]; then
	mkdir data
fi

while true
do
	wget -N --no-cache http://mesowest.utah.edu/data/mesowest_csv.tbl.gz
        if [ -f ./mesowest_csv.tbl.gz ]; then
	gunzip mesowest_csv.tbl.gz
echo "try to get the last modified file in the directory"
	FILE=$(ls -B -c ./data | head -n 1);
	if [ $FILE ]; then
		OUT="$(mktemp)"           

echo "try to get what is different in the new downloaded file and compare it to the one created beforeand Copy it to a new temp one"
		diff mesowest_csv.tbl ./data/$FILE --new-line-format="" --old-line-format="%L" --unchanged-line-format="" > OUT
	
	st="$(cat OUT | head -n 1)" 
	echo $st
	if [ $st=="" ];then
		rm OUT
		rm mesowest_csv.tbl
	else 
		HEADER="$(mktemp)"
		echo 'primary id,secondary id,station name,state,country,latitude,longitude,elevation,mesowest network id,network name,status,primary provider id,primary provider,secondary provider id,secondary provider,tertiary provider id,tertiary provider,wims_id;' > HEADER 
                cat OUT >> HEADER
		rm OUT
                mv HEADER mesowest_csv.tbl
		mv mesowest_csv.tbl ./data/mesowest_csv.tbl.`date "+%Y%m%dT%H%M"`
		mysqlimport -uroot -pmaryamjoon --fields-terminated-by=',' --lines-terminated-by=';' --ignore-lines=1 --local projone ./data/mesowest_csv.tbl.`date "+%Y%m%dT%H%M"`

	fi 
	else
	 mv mesowest_csv.tbl ./data/mesowest_csv.tbl.`date "+%Y%m%dT%H%M"`
	mysqlimport -uroot -pcmpe226 --fields-terminated-by=',' --lines-terminated-by=';' --ignore-lines=1 --local projone ./data/mesowest_csv.tbl.`date "+%Y%m%dT%H%M"`

	fi
	echo "Sleeping for 15 mins to get the next file.......!!!"
	sleep 900;
	echo "Time to download the next file................"
	fi
done
