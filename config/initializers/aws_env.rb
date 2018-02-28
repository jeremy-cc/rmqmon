# This parses a aws instance /etc/defaults/consul-template into
# statsd tags and permits them to be registered and delivered automatically
# it also provides utility methods leveraging /etc/defaults/consul-template
class AwsEnv
  CONSUL_LOCATION = "/etc/default/consul-template".freeze
  FACTS_LOCATION = "/opt/facts.txt".freeze

  attr_reader :env, :aws_env

  def initialize
    @env ||= AwsEnv._consul_load
    @aws_env = AwsEnv._facts_load
    Rails.logger.info "AWS templates #{env.blank? ? 'not loaded' : 'loaded'}"
  end

  def consul_tags
    env
  end

  def consul_role
    env["rolename"] || env["service"]
  end

  def role_is?(rolename)
    rolename && rolename == consul_role
  end

  def prod?
    "prod" == aws_env["envtype"]
  end

  def nonprod?
    "nonprod" == aws_env["envtype"]
  end

  private

  def self._consul_load
    Rails.logger.info "Looking for consul template #{CONSUL_LOCATION} : exists:#{File.exists?(CONSUL_LOCATION)}, readable: #{File.readable?(CONSUL_LOCATION)}"

    env_lines = File.readlines CONSUL_LOCATION if (File.exists?(CONSUL_LOCATION)  && File.readable?(CONSUL_LOCATION))
    env_lines ||= []

    env = Hash[env_lines.map{ |l| l.downcase.strip.split("=") } ] || {}
    env.merge({ "hostname" => Socket.gethostname })
  end

  def self._facts_load
    Rails.logger.info "Looking for facts template #{FACTS_LOCATION} : exists:#{File.exists?(FACTS_LOCATION)}, readable: #{File.readable?(FACTS_LOCATION)}"

    env_lines = File.readlines FACTS_LOCATION if (File.exists?(FACTS_LOCATION)  && File.readable?(FACTS_LOCATION))
    env_lines ||= []

    Hash[env_lines.map{ |l| l.downcase.strip.split(" ") } ] || {}
  end
end
