module DCase
  class Server
    include Celluloid::IO
    finalizer :finalize

    attr_accessor :crypto

    def initialize(host, port, crypto)
      @server = UDPSocket.new
      @server.to_io.setsockopt(:SOCKET, :REUSEADDR, 1)
      @server.bind(host, port)

      @crypto = crypto

      async.run
    end

    def finalize
      @server.close unless @server.closed?
    end

    def run
      loop do
        data, (_, port, addr) = @server.recvfrom(16384)
        handle_data(data, port, addr)
      end
    end

    def handle_data(data, port, addr)
      request = UDPSocket.new
      request.send crypto.decrypt(data), 0, '8.8.8.8', 53

      async.start_connect(request, port, addr)
    end

    def start_connect(request, port, addr)
      data, (_, _port, _addr) = request.recvfrom(16384)
      @server.send crypto.encrypt(data), 0, addr, port
      request.close unless request.closed?
    end
  end
end
