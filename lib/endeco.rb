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
    safe_key = key.sub(/!$/, '')
    return cache(safe_key, options) if Cache.enable and !options[:force] and Cache.key?(safe_key)
    fullpath = expand_path safe_key
    if File.exists? fullpath
      Cache[safe_key] = File.read fullpath
      return cache(safe_key, options)
    end
    return nil if key == safe_key
    raise Errno::ENOENT, "Errno::ENOENT: No such file or directory - #{fullpath}"
  end

  private
  def self.expand_path(name)
    File.expand_path File.join([Config.path, Config.env, name].compact)
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
  end

  def self.cache(key, options = {})
    options[:chomp] ? Cache[key].chomp : Cache[key]
  end
end
