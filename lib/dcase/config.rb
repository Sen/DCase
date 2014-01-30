require 'optparse'

require File.expand_path('../version', __FILE__)

module DCase
  class Config
    attr_accessor :args, :side, :server, :port, :password

    def initialize(args)
      @args = args || []

      parse_args
    end

    private

    def parse_args
      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: dcase [options]"

        opts.separator ""
        opts.separator "Specific options:"

        opts.on("-s", "--side SIDE", "Local or Server side") do |c|
          @side = c
        end

        opts.on("-r", "--remote ADDRESS", "Remote server address") do |c|
          @server = c
        end

        opts.on("-p", "--port PORT", Integer, "Remote server port") do |c|
          @port = c
        end

        opts.on("-k", "--password PASSWORD", "Password, should be same in client and server sides") do |c|
          @password = c
        end

        opts.on_tail("-v", "--version", "Show shadowsocks gem version") do
          puts DCase::VERSION
          exit
        end

        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end
      end

      opt_parser.parse!(args)
    end
  end
end
