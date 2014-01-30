module DCase
  class Crypto
    include DCase::Table

    def initialize(password)
      @encrypt_table, @decrypt_table = get_table(password)
    end

    def encrypt(data)
      translate(@encrypt_table, data)
    end

    def decrypt(data)
      translate(@decrypt_table, data)
    end
  end
end
