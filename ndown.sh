#!/bin/bash


declare -a arr=("F" "TSLA")

## now loop through the above array
for i in $@
do
   echo "$i"

	NAME="$i"

	./get-yahoo-quotes.sh $NAME


	FILENAME=$NAME.csv
	FILESIZE=$(stat -f%z "$FILENAME")
	echo "Size of $FILENAME = $FILESIZE bytes."

	
	while [ $FILESIZE -lt 200 ]
	do
		echo "File size = $FILESIZE"
		echo "File size too small... redownloading..."
		./get-yahoo-quotes.sh $NAME
		FILESIZE=$(stat -f%z "$FILENAME")

  	done

done

exit