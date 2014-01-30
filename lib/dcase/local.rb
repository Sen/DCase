module DCase
  class Local
    MAX_PACKET_SIZE = 512

    include Celluloid::IO

    attr_accessor :socket, :crypto

    def initialize(addr, port, crypto, config)
      @socket = UDPSocket.new
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
      connector = TCPSocket.new '127.0.0.1', @config.port
      connector.write crypto.encrypt(data)

      async.request(@socket, connector, port, addr)
    end

    def request(socket, connector, port, addr)
      data = connector.readpartial(16384)
      socket.send crypto.decrypt(data), 0, addr, port
      connector.close unless connector.closed?
    end
  end
end
