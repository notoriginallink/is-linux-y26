#!/bin/bash

OVERLAY="/root/overlay_"
UPPER_DIR="$OVERLAY/upper"
LOWER_DIR="$OVERLAY/lower"
MERGED_DIR="$OVERLAY/merged"

OUTPUT="04_audit.log"

rm -f "./$OUTPUT"
touch $OUTPUT


# Вывод всех Whiteout файлов в файл
UPPER_COUNT=0
for FILE in $(find $UPPER_DIR -type c); do
	if [[ $UPPER_COUNT -eq 0 ]]; then
		echo "======== Whiteout files ========" >> $OUTPUT 
	fi
	echo $FILE >> $OUTPUT
	UPPER_COUNT=$(($UPPER_COUNT + 1))
done

if [[ $UPPER_COUNT -ne 0 ]]; then
	echo >> $OUTPUT
fi

# Разница между Lower и Merged
echo "======== Lower and Merged diff ========" >> $OUTPUT
diff -y "$LOWER_DIR" "$MERGED_DIR" >> $OUTPUT

exit 1
