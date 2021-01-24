require "socket"

server = TCPServer.new("localhost", 8080)
server.close
