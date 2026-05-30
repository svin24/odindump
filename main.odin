package main

import "core:fmt"
import "core:net"
import "core:bytes"
import "core:strings"


main :: proc() {
	SEVER_HOST:= net.IP4_Address{0,0,0,0}
	SEVER_PORT:= 8080
	socket,err := net.listen_tcp({
		address = SEVER_HOST,
		port= SEVER_PORT
	})

	if err !=nil {
		fmt.println("Error creating server", err)
		return
	}
	defer net.close(socket)

	for{

		client_socket,client_endpoint,client_err := net.accept_tcp(socket)
		if err!=nil {
			fmt.println("Error accepting connection", client_err)
			continue
		}
		
		defer net.close(client_socket)

		handle_client(client_socket)

	}
}

handle_client :: proc(client: net.TCP_Socket) {
	buffer: [4096]u8
	bytes_read, read_err := net.recv(client,buffer[:])
	if read_err != nil {
		fmt.println("Error reading from client",read_err)
		return
	}
	request := string(buffer[:bytes_read])
	fmt.printf("recieved request",request)

	response := strings.concatenate([]string{
		"HTTP1.1 200OK\r\n",
		"Content-Type: text/html\r\n",
		"Connection: close\r\n\r\n",
		"<html><body>Web server is running</body></html>"
	})

	net.send(client, transmute([]u8)response)
}