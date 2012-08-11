module Endeco
  module Config
    @@path = nil
    def self.path
      @@path
    end

    def self.path=(new_path)
      @@path = new_path
    end

    @@env  = nil
    def self.env
      @@env
    end

    def self.env=(new_env)
      @@env = new_env
    end

    @@default_chomp = false
    def self.default_chomp=(new_value)
      @@default_chomp = new_value
    end

    def self.default_chomp
      @@default_chomp
    end
  end
end
