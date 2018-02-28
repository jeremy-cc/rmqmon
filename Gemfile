source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.5'
gem 'puma', '~> 3.7'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'rufus-scheduler', '~> 3.4.2'
gem 'faraday', '0.14.0'
gem 'faraday_middleware', '0.12.2'

gem 'listen'

source "https://gem.fury.io/ccycloud/" do
  gem "tcc_statsd", "2.0.0"
end

