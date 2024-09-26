package main

import (
	"flag"
	"log"
	"net"
	"time"
)

var (
	connections int64
	total       int64
)

func init() {
	flag.Int64Var(&connections, "con", 4, "")
	flag.Int64Var(&total, "n", 10000000, "")
}

func main() {
	flag.Parse()
	conns := make([]net.Conn, connections)
	for i := 0; i < int(connections); i++ {
		conn, err := net.Dial("tcp", ":8080")
		if err != nil {
			log.Fatalf("%v", err)
		}
		conns[i] = conn
	}
	buf := []byte{0, 1, 2, 3, 4, 5, 6, 7}
	for i := 0; i < int(total); i++ {
		idx := i % int(connections)
		conn := conns[idx]
		_, err := conn.Write(buf)
		if err != nil {
			log.Fatalf("%v", err)
		}
		if i%100 == 0 {
			time.Sleep(1 * time.Millisecond)
		}
	}
}
