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
          DCase::Local.new('0.0.0.0', 53, @crypto, @config)
          puts "*** Local side is up, port:#{config.port}"
        when 'server'
          DCase::Server.new('0.0.0.0', @config.port, @crypto)
          puts "*** Server side is up, port:#{config.port}"
        end

      puts "*** Hit Ctrl+c to stop"
      trap("INT")  { supervisor.terminate; exit }
      trap("TERM") { supervisor.terminate; exit }
      sleep
    end
  end
end
