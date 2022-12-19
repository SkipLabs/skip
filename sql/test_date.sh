#!/bin/bash

run_test () {
  cat $1 | ~/skfs/build/skdb --always-allow-joins | sort > /tmp/kk1
  cat $1 | sqlite3 | sort > /tmp/kk2
  diff /tmp/kk1 /tmp/kk2 > /dev/null
  if [ $? -eq 0 ]; then
      echo -e "$2:\tOK"
  else
      echo -e "$2:\tFAILED"
  fi
}


# for y in {1900..2100}; do
#     for m in {1..12}; do
#         if [[ "$m" -lt "10" ]];
#         then
#             mm="0$m"
#         else
#             mm="$m"
#         fi
#         for d in {1..31}; do
#             if [[ "$d" -lt "10" ]];
#             then
#                 dd="0$d"
#             else
#                 dd="$d"
#             fi
#             echo "select strftime('%Y-%m-%d %H:%M:%S', '$y-$mm-$dd');"
#         done
#     done
# done > /tmp/dates.sql

###############################################################################
# testing weekdays #
###############################################################################

# for i in {0..6}; do
#     for y in {1990..2020}; do
#         for m in {1..12}; do
#             if [[ "$m" -lt "10" ]];
#             then
#                 mm="0$m"
#             else
#                 mm="$m"
#             fi
#             for d in {1..31}; do
#                 if [[ "$d" -lt "10" ]];
#                 then
#                     dd="0$d"
#                 else
#                     dd="$d"
#                 fi
#                 echo "select strftime('%Y-%m-%d %H:%M:%S', '$y-$mm-$dd', 'weekday $i');"
#             done
#         done
#     done > /tmp/dates.sql

#     run_test /tmp/dates.sql "weekday $i"
# done


# for y in {1900..2100}; do
#     for m in {1..12}; do
#         if [[ "$m" -lt "10" ]];
#         then
#             mm="0$m"
#         else
#             mm="$m"
#         fi
#         for d in {1..31}; do
#             if [[ "$d" -lt "10" ]];
#             then
#                 dd="0$d"
#             else
#                 dd="$d"
#             fi
#             echo "select strftime('%Y-%m-%d %H:%M:%S', '$y-$mm-$dd', '+1 day');"
#         done
#     done
# done > /tmp/dates.sql

# run_test /tmp/dates.sql "+1 day (at hour 00:00)"


run_hour_test () {

    for i in {"23:00","23:30","00:00","00:30","01:00"}; do
        for y in {1995..2005}; do
            for m in {1..12}; do
                if [[ "$m" -lt "10" ]];
                then
                    mm="0$m"
                else
                    mm="$m"
                fi
                for d in {1..31}; do
                    if [[ "$d" -lt "10" ]];
                    then
                        dd="0$d"
                    else
                        dd="$d"
                    fi
                    echo "select strftime('%Y-%m-%d %H:%M:%S', '$y-$mm-$dd $i', '$1');"
                done
            done
        done > /tmp/dates.sql

        run_test /tmp/dates.sql "$1 (at hour $i)"
    done
}

# for i in {0..32}; do
#     run_hour_test "+$i day"
# done

# run_hour_test "+365 day"
# run_hour_test "+366 day"

# for i in {0..6}; do
#     run_hour_test "weekday $i"
# done

#for i in {0..13}; do
#     run_hour_test "+$i month"
#done

echo "select date('now', '+1 day');" | skdb
