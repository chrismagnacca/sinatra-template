# encoding: utf-8

# decalre default puma workers & threads
workers Integer(ENV["WORKERS"] || 3)
threads Integer(ENV["MIN_THREADS"]  || 1), Integer(ENV["MAX_THREADS"] || 16)

# greatly reduce the startup time of puma workers & allow for easier management of workers
preload_app!

# setup variables for Sinatra setup
rackup  DefaultRackup
port  ENV["PORT"]  || 3000

# configuration for each worker when it boots up
on_worker_boot do
  # setup application configuration files
  ENVIRONMENT = ENV["RACK_ENV"] || "development"
  DATABASE_CONFIG_FILE = ENV["DATABASE_CONFIG_FILE"] || YAML::load(File.open(File.expand_path(File.dirname(__FILE__) + "/database.yml")))
  APPLICATION_CONFIG_FILE = ENV["DATABASE_CONFIG_FILE"] || YAML::load(File.open(File.expand_path(File.dirname(__FILE__) + "/application.yml")))
  ENV["SESSION_SECRET"] = APPLICATION_CONFIG_FILE["SECRET_KEY"]

  # establish database connection
  ActiveSupport.on_load(:active_record) { ActiveRecord::Base.establish_connection(DATABASE_CONFIG_FILE[ENVIRONMENT]) }
end
