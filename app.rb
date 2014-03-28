# encoding: utf-8
require "rubygems"
require "json"
require "yaml"
require "sinatra/base"
require "sinatra/param"
require "active_record"

require_relative "models/init"
require_relative "routes/init"

class App < Sinatra::Base
  set :server,  :puma
  set :content_type, :json
  set :raise_sinatra_param_exceptions,  true
  set :database_file,  File.expand_path(File.dirname(__FILE__) + "/config/database.yml")

  # utilize Rack::Session::Cookie instead of enable :sessions within Sinatra
  use Rack::Session::Cookie, key: "rack.session", domain: "localhost", expire_after: 14400, secret: ENV['SESSION_SECRET']

  # general configuration regardless of environment
  configure do
    ENVIRONMENT = ENV["RACK_ENV"] || "development"
    ActiveRecord::Base.establish_connection(YAML::load(File.open(database_file))[ENVIRONMENT])
  end

  configure :production do
    # production specific environment configuration
  end

  configure :test do
    # test specific environment configuration
  end

  configure :development do
    # development specific environment configuration
  end

  # include rack utils & parameter contracts for sinatra
  helpers do
    include Rack::Utils
  end

end
