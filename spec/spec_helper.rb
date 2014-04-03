# encoding: utf-8
require "rspec"
require "json"
require "fakeweb"
require "net/http"
require "simplecov"
require "coveralls"
require "rack/test"
require "byebug"
require "rspec/given"
require "factory_girl"
require "database_cleaner"

# set rack environment & secret token
ENVIRONMENT = ENV["RACK_ENV"] || "test"

# coveralls.io, code coverage, & statistics
Coveralls.wear!
SimpleCov.start do
  root = File.expand_path(File.dirname(__FILE__) + "/../")

  # declare application root for SimpleCov
  SimpleCov.root(root)

  # declare groups to be tested
  add_group "Models", "#{root}/models"
  add_group "Routes", "#{root}/routes"

  # filter out tests from coverage
  add_filter "/spec/"
  #add_filter "/config/"
  #add_filter "/lib/"
  #add_filter "/vendor/"
end

# load application after initializing SimpleCov to allow for analysis
require_relative File.join("..", "app")

# set the definition file path & pull in the factories
FactoryGirl.definition_file_paths = %w{./factories ./test/factories ./spec/factories}
FactoryGirl.find_definitions

# rspec configuration settings
RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include FactoryGirl::Syntax::Methods

  def app
    Rack::Builder.new do
      map "/" do  run Routes::AppController end
      map "/health" do  run Routes::HealthController end
    end
  end

  config.before(:suite) do
    begin
      DATABASE_CONFIG_FILE = YAML::load(File.open(File.expand_path(File.dirname(__FILE__) + "/../config/database.yml")))
      APPLICATION_CONFIG_FILE = ENV["DATABASE_CONFIG_FILE"] || YAML::load(File.open(File.expand_path(File.dirname(__FILE__) + "/application.yml")))
      ENV["SESSION_SECRET"] = APPLICATION_CONFIG_FILE["SECRET_KEY"]


      ActiveRecord::Base.establish_connection(DATABASE_CONFIG_FILE[ENVIRONMENT])
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean_with(:truncation)
    end
  end
end
