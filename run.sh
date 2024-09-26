#!/bin/bash

cd $(dirname "${BASH_SOURCE[0]}")

# build and run server in proc 0-3
cd server && go build
nohup GOGC=1000 taskset -c 0-3 ./server &

# build and run client in proc 4-12
cd ../client && go build
nohup GOGC=1000 taskset -c 4-15 ./client -n=10000000 -con=4 &

SERVER_PID=`ps -ef | grep server | grep -v grep | awk '{print $2}'`
pidstat -p $SERVER_PID 1 60