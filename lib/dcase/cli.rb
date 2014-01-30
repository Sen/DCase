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
        when 'server'
          DCase::Server.new('0.0.0.0', @config.port, @crypto)
        end

      trap("INT") { supervisor.terminate; exit }
      sleep
    end
  end
end
