require 'test_helper'
require_relative '../../lib/dcase/config.rb'

class TestConfig < TestCase
  def test_local_params
    config = DCase::Config.new ['-s', 'local']

    assert_equal config.password, 'your password'
    assert_equal config.server, '127.0.0.1'
    assert_equal config.port, 8440
    assert_equal config.dns_list, ['8.8.8.8', '8.8.4.4']
  end

  def test_server_params
    config = DCase::Config.new ['-s', 'server']

    assert_equal config.password, 'your password'
    assert_equal config.server, '127.0.0.1'
    assert_equal config.port, 8440
    assert_equal config.dns_list, ['8.8.8.8', '8.8.4.4']
  end

  def test_local_with_command
    config = DCase::Config.new ['-s', 'local', '-k', 'your password', '-r', '127.0.0.1', '-p', '8440']
    assert_equal config.password, 'your password'
    assert_equal config.server, '127.0.0.1'
    assert_equal config.port, 8440
  end

  def test_server_with_command
    config = DCase::Config.new ['-s', 'server', '-k', 'your password', '-r', '127.0.0.1', '-p', '8440', '-l', '8.8.8.8,8.8.4.4']
    assert_equal config.password, 'your password'
    assert_equal config.server, '127.0.0.1'
    assert_equal config.port, 8440
    assert_equal config.dns_list, ['8.8.8.8', '8.8.4.4']
  end

  def test_blank_side
    e = assert_raises(RuntimeError) { DCase::Config.new }
    assert_equal 'You need to define side of dcase in', e.message
  end
end
