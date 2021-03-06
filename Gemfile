source 'https://rubygems.org'

# need jruby alternative for:
# scrypt

gem 'rails', '~> 4.1'
gem 'activerecord-session_store'
gem 'psych'

# webserver
gem "puma",     :platforms => [:mri, :rbx, :jruby], :require => false

# adds foreign key support to activerecord
gem "foreigner"
gem "immigrant"

# uncomment if using in production
# gem "mysql2", :platforms => [:mri, :rbx]
# gem "activerecord-jdbc-adapter", :platforms => :jruby
# gem "activerecord-jdbcmysql-adapter, "~> 1.3.0"", :platforms => :jruby

gem "pg", :platforms => [:mri, :rbx]
gem "activerecord-jdbc-adapter", :platforms => :jruby
gem "activerecord-jdbcpostgresql-adapter", :platforms => :jruby

# misc/production support
gem "secure_headers"
gem "rack-health", :require => "rack/health"
gem "logging"
gem "logging-rails", :require => "logging/rails",
                     :git     => "https://github.com/chetan/logging-rails.git",
                     :branch  => "bixby"
gem "lograge"
gem "exception_notification"

# view related
gem 'haml'


# bixby requirements
gem 'bixby-common'
# gem 'bixby-common', :path => "../common"

gem 'curb', '~> 0.8'
gem 'rubyntlm' # just to silence an annoying warning in httpi

gem "semver2"

# api server for agents
gem "em-hiredis"
gem "faye-websocket"
# gem "em-websocket"
# gem "websocket-eventmachine-server"
# gem "websocket-rack"

gem "multi_json"
gem "oj",           :platforms => [:mri, :rbx]
gem "json",         :platforms => [:mri, :rbx, :jruby]

gem "request_store"
gem "scrypt"
gem "devise"
gem "devise-encryptable"
gem "pretender"
gem "api-auth", :github => "chetan/api_auth", :branch => "bixby"
gem "mixlib-shellout"

# repository module
gem "git", "= 1.2.5"
gem "sshkey"

# rails plugins
gem "acts-as-taggable-on", "~> 3.1.0"
gem "acts_as_tree"      # replace with closure_tree (better perf)?
gem "delete_paranoid", :github => "socialcast/delete_paranoid"

# notifications module
gem "twilio-ruby"
gem "pony"

# scheduler module
gem "redis", "~> 3.0", :require => ["redis/connection/hiredis", "redis"]
# though hiredis is an extension, it should degrade gracefully for jruby
gem "hiredis"

gem "activemodel-globalid", :github => "chetan/activemodel-globalid", :branch => "proper_railtie_namespace"

# uncomment if you are using resque in production
# gem "resque"
# gem "resque-scheduler", :require => ["resque-scheduler"]

gem "sidekiq", "~> 2.9"
gem "slim", "~> 1.3.0"                        # for sidekiq web ui
gem 'sinatra', '>= 1.3.0', :require => nil    # for sidekiq web ui

# metrics module
gem 'continuum', :github => "chetan/continuum"
gem 'bixby-api_pool', :github => 'chetan/bixby-api_pool'

# uncomment if using mongo for metrics storage
# warning: you *really* shouldn't use this in production
# gem 'mongoid', "~> 4.0"


group :assets do
  # asset related gems
  gem 'sprockets-rails'
  gem 'sass'
  gem 'sass-rails', '~> 4.0.2'
  gem 'bootstrap-sass', '~> 3.1.1'
  gem 'sprockets-jst-str'
  gem 'coffee-script'
  gem 'coffee-script-source'
  gem 'haml_assets'
  gem 'uglifier'
  gem 'font-awesome-rails'
  gem 'sprockets-font_compressor', :require => false

  # execjs prefers ruby racer (needed by uglifier and coffee-script)
  # added due to sudden segfaulting with nodejs driver
  gem 'execjs'
  gem 'therubyracer', :platforms => [:mri, :rbx]
  gem 'therubyrhino', :platforms => [:jruby]
end

group :assets, :development do
  # needed for messing with asset tasks
  gem 'rake-hooks', :require => false
end

group :development do

  gem "mysql2", :platforms => [:mri, :rbx]
  gem "activerecord-jdbcmysql-adapter", "~> 1.3.0", :platforms => :jruby

  # debugging
  gem "debugger",     :platforms => [:mri_19, :mri_20, :mri_21]
  gem "debugger-pry", :require => "debugger/pry", :platforms => [:mri_19, :mri_20, :mri_21]
  gem "awesome_print", :github => "michaeldv/awesome_print" # to fix error with mongoid/bson
  gem "coffee-rails-source-maps"
  gem "bullet"

  # rails debugging helpers
  gem "letter_opener"
  gem "better_errors"
  gem "binding_of_caller", :platforms => [:mri_19, :mri_20, :mri_21, :rbx] # used by better_errors for advanced features
  gem "xray", :require => "xray/thread_dump_signal_handler"
  gem "quiet_assets"

  # newrelic - don't require any gems, loaded in initializers/newrelic.rb
  gem 'newrelic_rpm', :require => false
  gem 'newrelic-redis', :require => false
  gem 'newrelic_moped', :require => false
  gem 'newrelic-curb', :github => "red5studios/newrelic-curb", :require => false
  gem 'newrelic-middleware', :require => false

  # docs
  gem "yard"
  gem "redcarpet", :platforms => [:mri, :rbx]
  gem "annotate", ">= 2.5.0"

  # utils
  gem "pry"
  gem "pry-rails"
  gem "marco-polo"
  gem "sextant" # displays routes at http://localhost:3000/rails/routes in dev mode
  gem "highline"
  gem "ruby-termios"
  gem "terminal-table"
  gem "listen", "~> 2.0"

  # deployment
  gem "capistrano",      "~>2.0", :require => false
  gem "rvm-capistrano",           :require => false

end

group :development, :test do
  gem "mongoid", "~> 4.0"
end

group :test do

  # test tools (frameworks, mock, runners, etc)
  gem 'webmock',  :require => false
  gem "minitest", :require => false
  gem 'mocha',    :require => false
  gem "bahia"
  gem "database_cleaner", "=1.0.1"
  gem "factory_girl_rails"
  gem "mock_redis"

  # test utils
  gem "micron", :github => "chetan/micron"
  gem "test_guard", :git => "https://github.com/chetan/test_guard.git"
  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false

  # coverage
  gem "coveralls",            :require => false
  gem "simplecov",            :platforms => [:mri_19, :mri_20, :mri_21], :require => false
  gem "simplecov-html",       :platforms => [:mri_19, :mri_20, :mri_21], :git => "https://github.com/chetan/simplecov-html.git", :require => false
  gem "simplecov-console",    :platforms => [:mri_19, :mri_20, :mri_21], :git => "https://github.com/chetan/simplecov-console.git", :require => false

  # quality
  gem "cane", :platforms => [:mri_19, :mri_20, :mri_21], :require => false
  gem "brakeman", :require => false

  # gems used for dev/test env
  # for using sqlite3 as db backend
  gem "sqlite3", :platforms => [:mri, :rbx]
  gem "activerecord-jdbcsqlite3-adapter", "~> 1.3.0", :platforms => "jruby"

  gem "resque"
  gem "resque-scheduler", :require => ["resque-scheduler"]

end
