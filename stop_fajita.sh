#!/bin/bash

fajita_pid=`cat /home/fajita/infobot/fajita.pid`
kill -9 $fajita_pid

rm -f /home/fajita/infobot/fajita.pid

