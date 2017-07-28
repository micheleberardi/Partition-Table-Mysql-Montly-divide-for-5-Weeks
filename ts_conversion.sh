#!/bin/bash

FROM=2017-10          # To Be Configured : Starting date        Accepted format : (YY-MM) or (YY-MM-DD)
TO=2017-10-25	      # To be configured : Last partition date  Accepted format : (YY-MM) or (YY-MM-DD)



d=$FROM
oldm=$(echo $d | cut -d\- -f2 )
day=$(echo $d | cut -d\- -f3)
array=(A B C D E F G)
i=0
if [ -z $day ] ; then
	d=$(echo "${FROM}-01")
fi
dayto=$(echo $TO | cut -d\- -f3)
if [ -z $dayto ] ; then
        TO=$(echo "${TO}-01")
fi

echo "d=$d==, TO=$TO="
now="$(date +'%d-%m-%Y')"
echo "${array[0]} == d=($d) to_time=($TO)"

while [[ "$TO" > "$d" ]] ; do 
	echo $d
	d=$(date -I -d "$d + 5 days")
	d_timestamp=$(date -d "$d" +%s)
	y=$(echo $d | cut -d\- -f1)
	m=$(echo $d | cut -d\- -f2 )
	[ $m -gt $oldm ] && i=0
	oldm=$m
	PARTITION=$(echo "P${y}${m}${array[$i]}")
	insertdatetime=$(date -I -d "$d + 5 days" )
	echo "PARTITON ($PARTITION), insertdatetime=($insertdatetime)"
	echo "ALTER TABLE ts_conversion ADD PARTITION (PARTITION  $PARTITION VALUES LESS THAN ('$insertdatetime 00:00:00'));" >> /tmp/ts_conversion_${now}.sql
	i=$(($i +1))

done



