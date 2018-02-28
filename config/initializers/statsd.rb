$statsd = Statsd.new Rails.configuration.x.statsd.host, Rails.configuration.x.statsd.port
$statsd.namespace = "rabbitmq"
$statsd.global_tags = AwsEnv.new.consul_tags
$statsd.enabled = true