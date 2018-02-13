#!/bin/bash

# Test if Pipeline is running and stop one of more instances


PROCESSES=$"pipeline"

for PROCESS in $PROCESSES; do
   PIDS=`ps cax | grep $PROCESS | grep -o '^[ ]*[0-9]*'`

   if [ -z "$PIDS" ]; then
     echo
     echo " $PROCESS is not running ... "
     echo
   else
     for PID in $PIDS; do
        echo
        echo "Stopping $PROCESS  "
        kill -9 $PID
        echo
        done
   fi
done
