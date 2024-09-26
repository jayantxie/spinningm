#!/bin/bash

cd $(dirname "${BASH_SOURCE[0]}")

# build and run server in proc 0-3
cd server && go build
GOGC=1000 taskset -c 0-3 nohup ./server &

# build and run client in proc 4-12
cd ../client && go build
GOGC=1000 taskset -c 4-15 nohup ./client -n=10000000 -con=4 &

SERVER_PID=`ps -ef | grep server | grep -v grep | awk '{print $2}'`
pidstat -p $SERVER_PID 1 60