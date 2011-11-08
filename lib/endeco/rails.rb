require 'endeco'

module Endeco
  class Railtie < Rails::Railtie
    config.endeco = ActiveSupport::OrderedOptions.new

    config.before_initialize do
      Endeco::Config.path  = config.endeco.path         || "#{Rails.root}/env"
      Endeco::Config.env   = config.endeco.env          || Rails.env.to_s
      Endeco::Cache.enable = config.endeco.enable_cache || Rails.env.production?
    end
  end
end
