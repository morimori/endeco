module Endeco
  module Config
    @@path = nil
    @@env  = nil
    def self.path
      @@path
    end

    def self.path=(new_path)
      @@path = new_path
    end

    def self.env
      @@env
    end

    def self.env=(new_env)
      @@env = new_env
    end
  end
end