#!/usr/bin/env bash

function checkConnectivity() {
case "$(curl -s --max-time 2 -I http://google.com | sed 's/^[^ ]*  *\([0-9]\).*/\1/; 1q')" in
  [23]) return 1;;
  *) return 0;;
esac
}


FAILURES=0
THRESHOLD=5
SLEEP_TIME=1
TESTS=10

while [ $TESTS -gt 0 ]; do
    checkConnectivity
    if [ $? -eq 1 ] ; then
       FAILURES=0
    elif [ $? -eq 0 ] ; then
       FAILURES=$((FAILURES + 1))
    fi
    sleep $SLEEP_TIME
    TESTS=$((TESTS - 1))
    echo "$TESTS) FAILURES=$FAILURES"
done


if [ $FAILURES -gt $THRESHOLD ]; then
  echo "restart"
  systemctl restart
fi
