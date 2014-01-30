module DCase
  class Server
    include Celluloid::IO
    finalizer :finalize

    attr_accessor :crypto

    def initialize(host, port, crypto)
      @server = TCPServer.new(host, port)
      @server.setsockopt(:SOCKET, :REUSEADDR, true)

      @crypto = crypto

      async.run
    end

    def finalize
      @server.close if @server
    end

    def run
      loop { async.handle_connection @server.accept }
    rescue IOError
      @server.close if @server
    end

    def handle_connection(socket)
      data = crypto.decrypt socket.readpartial(4096)

      request = UDPSocket.new
      request.send data, 0, '8.8.8.8', 53

      async.start_connect(socket, request)
    end

    def start_connect(socket, request)
      data, (_, _port, _addr) = request.recvfrom(16384)
      socket.write crypto.encrypt(data)
      socket.close unless socket.closed?
      request.close unless socket.closed?
    end
  end
end
