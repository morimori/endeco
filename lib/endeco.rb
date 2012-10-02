require 'endeco/version'
require 'endeco/config'
require 'endeco/cache'

module Endeco
  def self.method_missing(symbol, *args)
    safe_name = symbol.to_s.sub /!$/, ''
    def_methods safe_name
    __send__ symbol, *args
  end

  def self.[](key, options = {})
    safe_key = key.sub(/[!\?]$/, '')
    value = if Cache.enable and !options[:force] and Cache.key?(safe_key)
      Cache[safe_key]
    else
      fullpath = expand_path safe_key
      if exists? safe_key
        Cache[safe_key] = File.read fullpath
      else
        if key == safe_key
          nil
        else
          raise Errno::ENOENT, "Errno::ENOENT: No such file or directory - #{fullpath}"
        end
      end
    end
    value.chomp! if value && !(options[:chomp] === false) && Config.default_chomp
    value
  end

  private
  def self.expand_path(name)
    File.expand_path File.join([Config.path, Config.env, name].compact)
  end

  def self.exists?(name)
    File.exists? expand_path(name)
  end

  def self.def_methods(name)
    module_eval %[
      def self.#{name}(options = {})
        self[__method__.to_s, options]
      end
    ], __FILE__, __LINE__

    module_eval %[
      def self.#{name}!(options = {})
        self[__method__.to_s, options]
      end
    ], __FILE__, __LINE__

    module_eval %[
      def self.#{name}?
        exists? "#{name}"
      end
    ], __FILE__, __LINE__
  end
end
