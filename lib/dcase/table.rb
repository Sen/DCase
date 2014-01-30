require "digest"
require 'ffi'

module Ext
  def self.binary_path
    path = ''
    %w( so bundle dll ).each do |ext|
      path = File.expand_path('..', File.dirname(__FILE__)) + "/encrypt.#{ext}"
      break if File.exists? path
    end

    path
  end

  extend FFI::Library
  ffi_lib binary_path
  attach_function "encrypt", [:pointer, :pointer, :int], :pointer
end

module DCase
  module Table
    include Ext

    def get_table key
      table = Array.new(256, 0)
      decrypt_table = Array.new(256, 0)

      a = Digest::MD5.digest(key).unpack('Q<')[0]
      i = 0

      while i < 256
        table[i] = i
        i += 1
      end
      i = 1

      while i < 1024
        table = merge_sort(table, lambda { |x, y|
          a % (x + i) - a % (y + i)
        })
        i += 1
      end
      i = 0
      while i < 256
        decrypt_table[table[i]] = i
        i += 1
      end
      [ table, decrypt_table ]
    end

    def translate(table, buf)
      table_ptr = FFI::MemoryPointer.new(:int, table.length)
      table_ptr.put_array_of_int32(0, table)

      buf_ptr = FFI::MemoryPointer.new(:string, buf.length)
      buf_ptr.put_bytes(0, buf)

      r = Ext.encrypt(table_ptr, buf_ptr, buf.length).get_bytes(0, buf.length)
      table_ptr.free
      buf_ptr.free
      r
    end

    def merge (left, right, comparison)
      result = []
      while (left.length > 0) and (right.length > 0)
        if comparison.call(left[0], right[0]) <= 0
          result.push left.shift()
        else
          result.push right.shift()
        end
      end
      result.push left.shift() while left.length > 0
      result.push right.shift() while right.length > 0
      result
    end

    def merge_sort (array, comparison)
      return array if array.size < 2
      middle = (array.size / 2).ceil
      merge(merge_sort(array.slice(0, middle), comparison), merge_sort(array.slice(middle .. array.size), comparison), comparison)
    end
  end
end
