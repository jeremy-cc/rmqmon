require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_job/railtie"
require "action_controller/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require 'pp'

module Rmqmon
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.api_only = true

    config.x.rabbitmq.url      = "http://rabbitmq-#{ENV['ENVNAME']}.#{ENV['ENVTYPE']}.ccycloud.io:#{ENV['RMQ_PORT'] || 15672 }"
    config.x.rabbitmq.user     = ENV['RMQ_USER'] || 'monitoring'
    config.x.rabbitmq.password = ENV['RMQ_PASSWORD']
    config.x.rabbitmq.vhost    = ENV['RMQ_VHOST'] || '/platform'

    config.x.statsd.host = ENV['STATSD_HOST'] || "statsdhost"
    config.x.statsd.port = ENV['STATSD_PORT'] || 8125
  end
end
