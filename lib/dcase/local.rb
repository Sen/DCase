module DCase
  class Local
    MAX_PACKET_SIZE = 512

    include Celluloid::IO

    attr_accessor :socket, :crypto

    def initialize(addr, port, crypto, config)
      @socket = UDPSocket.new
      @socket.to_io.setsockopt(:SOCKET, :REUSEADDR, 1)
      @socket.bind(addr, port)
      @crypto = crypto
      @config = config

      async.run
    end

    def run
      loop do
        data, (_, port, addr) = @socket.recvfrom(MAX_PACKET_SIZE)
        handle_data(data, port, addr)
      end
    end

    def handle_data(data, port, addr)
      connector = UDPSocket.new
      connector.send crypto.encrypt(data), 0, @config.server, @config.port

      async.request(connector, port, addr)
    end

    def request(connector, port, addr)
      data, (_, _port, _addr) = connector.recvfrom(16384)
      @socket.send crypto.decrypt(data), 0, addr, port
      connector.close unless connector.closed?
    end
  end
end
