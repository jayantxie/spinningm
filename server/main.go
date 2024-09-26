package main

import (
	"log"
	"net"
	"net/http"
	_ "net/http/pprof"
)

func main() {
	go func() {
		log.Println(http.ListenAndServe("localhost:6060", nil))
	}()
	ln, err := net.Listen("tcp", ":8080")
	if err != nil {
		log.Fatalf("%v", err)
	}
	for {
		conn, err := ln.Accept()
		if err != nil {
			log.Fatalf("%v", err)
		}
		go func() {
			// 8 bytes for every message
			buf := make([]byte, 8)
			for {
				_, err := conn.Read(buf)
				if err != nil {
					log.Fatalf("%v", err)
				}
				for i := 0; i < 2; i++ {
					go func() {
						// mock biz logic
						for i := 0; i < 500; i++ {
						}
					}()
				}
			}
		}()
	}
}
