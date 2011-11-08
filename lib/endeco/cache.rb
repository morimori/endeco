module Endeco
  module Cache
    @@cache  = {}
    @@enable = false

    def self.[]=(key, value)
      @@cache[key] = value
    end

    def self.[](key)
      @@cache[key]
    end

    def self.key?(key)
      @@cache.key? key
    end

    def self.clear
      @@cache.clear
    end

    def self.enable
      @@enable
    end

    def self.enable=(value)
      @@enable = value
    end
  end
end