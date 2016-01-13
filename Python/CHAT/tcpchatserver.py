#! /usr/bin/env python
#-*- coding:utf-8 -*-

import socket, select

#function to broadcast chat messages to all connected clients
def broadcast_data(sock, message):
    #donot send message to master socket and the client who send to server
    for socket in CONNECTION_LIST:
        if socket != server_socket and socket != sock:
            try:
                socket.send(message)
            except:
                #broken socket connection maybe, chat client pressed
                #ctrl+c for example
                socket.close()
                CONNECTION_LIST.remove(socket)

if __name__ == "__main__":
    #list to keep track of socket descriptors
    CONNECTION_LIST = []
    RECV_BUFFER = 4096    #better to be exponent of 2
    PORT = 5000
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server_socket.bind(("0.0.0.0", PORT))
    server_socket.listen(10)
    CONNECTION_LIST.append(server_socket)
    print "chat server starts on port " + str(PORT)
    while True:
         # Get the list sockets which are ready to be read through select
         read_sockets,write_sockets,error_sockets = select.select(CONNECTION_LIST,[],[])
         for sock in read_sockets:
             #new connection
             if sock == server_socket:
                 sockfd, addr = server_socket.accept()
                 CONNECTION_LIST.append(sockfd)
                 print "client (%s, %s) connected" % addr
                 broadcast_data(sockfd, "[%s:%s] entered room\n" % addr)
             #some incoming message from a client
             else:
                #data received from client, process it
                 try:
                     data = sock.recv(RECV_BUFFER)
                     if data:
                         broadcast_data(sock, "\r<" + str(sock.getpeername()) + ">" + data)
                 except:
                     broadcast_data(sock, "client (%s, %s) is offline" % addr)
                     print "client (%s, %s) is offline" % addr
                     sock.close()
                     CONNECTION_LIST.remove(sock)
                     continue
    server_socket.close()

