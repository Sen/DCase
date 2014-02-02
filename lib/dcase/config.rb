require 'optparse'
require 'yaml'

require File.expand_path('../version', __FILE__)

module DCase
  class Config
    attr_accessor :args, :side, :server, :port, :password, :dns_list, :config_path

    def initialize(args = [])
      @args = args

      parse_args
      read_config

      check_values
    end

    def check_values
      if side.nil?
        raise 'You need to define side of dcase in'
      end

      if side == 'local' && server.nil?
        raise 'You need to define remote server address'
      end

      if port.nil?
        raise 'You need to define remote server port'
      end

      if password.nil?
        raise 'You need to define a password, should be same in server/local side'
      end
    end

    private

    def read_config
      @config_path = File.expand_path('../..', File.dirname(__FILE__)) + '/config.yml' unless @config_path
      config = YAML.load_file @config_path

      @side      = config["side"]          if @side.nil?
      @server    = config["server"]        if @server.nil?
      @port      = config["port"].to_i     if @port.nil?
      @password  = config["password"]      if @password.nil?
      @dns_list  = config["dns_list"]      if @dns_list.nil?
    end

    def parse_args
      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: dcase [options]"

        opts.separator ""
        opts.separator "Specific options:"

        opts.on("-s", "--side SIDE", "Local or Server side") do |c|
          @side = c
        end

        opts.on("-c", "--config PATH", "Config file path") do |c|
          @config_path = c
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

        opts.on("-l", "--dns-list LIST", "Password, should be same in client and server sides") do |c|
          @dns_list = c.split(',').map(&:strip)
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
