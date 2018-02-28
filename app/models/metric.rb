class Metric
  def self.gauge(metric, rate)
    $statsd.gauged(metric, rate)
  end

  def self.count(metric, count=1)
    $statsd.counted(metric, count)
  end
end