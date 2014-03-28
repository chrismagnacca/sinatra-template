# encoding: utf-8
require File.expand_path(File.dirname(__FILE__)) +  "/app"

# define application routes
map "/" do  run Routes::AppController end
map "/health" do  run Routes::HealthController end
