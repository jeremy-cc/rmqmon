#!/usr/bin/env bash

STATSD_HOST=statsd.service.consul ENVTYPE=prod ENVNAME=prod1 RMQ_PASSWORD=m0nit0r1ng /usr/local/rbenv/versions/2.5.0/bin/bundle exec rails server -b 0.0.0.0 -p 3000