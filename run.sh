#!/bin/bash

cd $(dirname "${BASH_SOURCE[0]}")

# build and run server in proc 0-3
cd server && go build && mv server spiningm_server
GOGC=1000 taskset -c 0-3 nohup ./spiningm_server &

# build and run client in proc 4-12
cd ../client && go build && mv client spiningm_client
GOGC=1000 taskset -c 4-15 nohup ./spiningm_client -n=10000000 -con=4 &

CLIENT_PID=`ps -ef | grep spiningm_client | grep -v grep | awk '{print $2}'`
SERVER_PID=`ps -ef | grep spiningm_server | grep -v grep | awk '{print $2}'`

sleep 1

# stats server cpu usage
pidstat -p $SERVER_PID 1 30

# kill client/server
kill $CLIENT_PID
kill $SERVER_PID