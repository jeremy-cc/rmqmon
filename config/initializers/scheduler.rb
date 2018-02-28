#
# config/initializers/scheduler.rb

require 'rufus-scheduler'

# Let's use the rufus-scheduler singleton
#
s = Rufus::Scheduler.singleton

s.every (ENV['PERIOD'] || '10s') do
  client = Api::Client.new
  Rails.logger.debug "Collecting rabbitmq metrics and forwarding to statsd"
  client.snapshot
end