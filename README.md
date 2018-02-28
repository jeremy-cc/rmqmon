## rmqmon

#### version 0.0.1

Rmqmon is a lightweight rails 5.1 app that acts as a statistics broker, feeding rabbitmq queue metrics to influxdb via
our statsd backbone.

`rmqmon` attemps to connect to a rabbitMQ cluster or broker running at 

    http://rabbitmq-$ENVNAME.$ENVTYPE.ccycloud.io:$RMQ_PORT
    
to interrogate it for metrics, which it then spools via UDP to the configured statsd endpoint.    

installation:

1.

#### running rmqmon

    ENVTYPE=<envtype> ENVNAME=<envname> RMQ_PASSWORD=<secret> bundle exec rails server -b 0.0.0.0 -p 3000 -e production
    
#### configuration
    
    config.x.rabbitmq.url      = "http://rabbitmq-#{ENV['ENVNAME']}.#{ENV['ENVTYPE']}.ccycloud.io:#{ENV['RMQ_PORT'] || 15672 }"
    config.x.rabbitmq.user     = ENV['RMQ_USER'] || 'monitoring'
    config.x.rabbitmq.password = ENV['RMQ_PASSWORD']
    config.x.rabbitmq.vhost    = ENV['RMQ_VHOST'] || '/platform'

    config.x.statsd.host = ENV['STATSD_HOST'] || "statsdhost"
    config.x.statsd.port = ENV['STATSD_PORT'] || 8125
    
##### Supported environment variables

|Variable | Description | Default |
|---|---|---|    
| ENVTYPE  | Consul ENVTYPE | |
| ENVNAME  | Consul ENVNAME | |
| RMQ_PORT | Port on which the RabbitMQ instance or cluster is accepting API requests | 15672 |
| RMQ_USER | RabbitMQ user with access to the api | monitoring |
| RMQ_PASSWORD | Password for $RMQ_USER | |
| STATSD_HOST | Hostname of the statsd server | statsd.service.consul |
| STATSD_PORT | UDP port for protocol messages | 8125 | 

