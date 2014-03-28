# encoding: utf-8
module Routes
  class HealthController < BaseController
    get "/" do
      {
        ruby: "#{RUBY_VERSION}",
        rack: "#{Rack::VERSION}",
        sinatra: "#{Sinatra::VERSION}",
      }.to_json
    end
  end
end
