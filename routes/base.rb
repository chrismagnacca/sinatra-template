# encoding: utf-8
module Routes
	class BaseController < Sinatra::Base
		# include any modules for routes
		include Models
		include Sinatra::Param
	end
end
