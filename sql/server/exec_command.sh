#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SKDB=skdb

cd $SCRIPT_DIR

read LINE
RRD="$LINE"

CMD=`echo "$LINE" | $SKDB --csv-field 0`

(while read LINE; do
    if [ "$LINE" == "END" ]; then
        break;
    fi;
    echo "$LINE"
done) |
(
case "$CMD" in

  "SQL")
    DB=`echo "$LINE" | $SKDB --csv-field 1`
    $SKDB --data "$DB"
    ;;

  "DUMP_TABLE")
    DB=`echo "$LINE" | $SKDB --csv-field 1`
    TABLE_NAME=`echo "$LINE" | $SKDB --csv-field 2`
    TABLE_SUFFIX=`echo "$LINE" | $SKDB --csv-field 3`
    $SKDB --data "$DB" --dump-table "$TABLE_NAME" --table-suffix "$TABLE_SUFFIX"
    ;;

  "WRITE")
    DB=`echo "$LINE" | $SKDB --csv-field 1`
    USER=`echo "$LINE" | $SKDB --csv-field 2`
    PASSWORD=`echo "$LINE" | $SKDB --csv-field 3`
    TABLE_NAME=`echo "$LINE" | $SKDB --csv-field 4`
    $SKDB --data "$DB" --user "$USER" --password "$PASSWORD" --write-csv "$TABLE_NAME"
    ;;

  "TAIL")
    DB=`echo "$LINE" | $SKDB --csv-field 1`
    USER=`echo "$LINE" | $SKDB --csv-field 2`
    PASSWORD=`echo "$LINE" | $SKDB --csv-field 3`
    TABLE_NAME=`echo "$LINE" | $SKDB --csv-field 4`
    $SKDB --data "$DB" --csv --tail `$SKDB --connect "$TABLE_NAME" --user "$USER" --password "$PASSWORD" --data "$DB"`
    ;;

  *)
    eval "${RRD}"
    ;;

esac 2>&1
)
