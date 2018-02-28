module Api
  class Client

    attr_reader :faraday

    def initialize
      url = Rails.configuration.x.rabbitmq.url
      puts "Building client for #{url}"
      @faraday ||= Faraday.new(url: url) do |faraday|
        faraday.basic_auth(Rails.configuration.x.rabbitmq.user, Rails.configuration.x.rabbitmq.password)

        faraday.response :json, :content_type => 'application/json'

        faraday.adapter Faraday.default_adapter
      end
    end

    def get(url, params = {})
      faraday.get(url, params).body
    end

    def snapshot
      snapshot =  get '/api/overview'
      snapshot['object_totals'].each{ |metric,reading| Metric.gauge(metric, reading) }

      vhost = CGI::escape(Rails.configuration.x.rabbitmq.vhost)
      queue_names = get "/api/queues/#{vhost}", columns: :name
      queue_names.map {|e| e['name'] }.reject { |s| s =~ /^retry.*/ }.each do |queue|

        stats = get "/api/queues/#{vhost}/#{CGI::escape(queue)}",
                    columns: ['message_stats.publish_details.rate',
                                      'message_stats.deliver_get_details.rate',
                                      'message_stats.ack_details.rate', :messages,
                                    :messages_ready, :messages_unacknowledged].map(&:to_s).join(',')
        # pp stats
        Metric.gauge("#{queue}.messages_total", stats['messages'])
        Metric.gauge("#{queue}.messages_ready", stats['messages_ready'])
        Metric.gauge("#{queue}.messages_unacknowledged", stats['messages_unacknowledged'])

        if stats['message_stats']
          Metric.gauge("#{queue}.message_rates.ack", stats['message_stats']['ack_details']['rate'])
          Metric.gauge("#{queue}.message_rates.deliver", stats['message_stats']['deliver_get_details']['rate'])
          Metric.gauge("#{queue}.message_rates.incoming", stats['message_stats']['publish_details']['rate'])
        end
      end
    end
  end
end
