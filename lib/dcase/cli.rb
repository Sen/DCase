module DCase
  class Cli
    def initialize(options = {})
      @config = options[:config]
      @crypto = DCase::Crypto.new(@config.password)
    end

    def run
      supervisor = \
        case @config.side
        when 'local'
          puts "*** Local side is up, remote server port:#{@config.port}"
          DCase::Local.supervise('0.0.0.0', 53, @crypto, @config)
        when 'server'
          puts "*** Server side is up, port:#{@config.port}"
          DCase::Server.supervise('0.0.0.0', @config.port, @crypto)
        end

      puts "*** Hit Ctrl+c to stop"
      trap("INT")  { supervisor.terminate; exit }
      trap("TERM") { supervisor.terminate; exit }
      sleep
    end
  end
end
