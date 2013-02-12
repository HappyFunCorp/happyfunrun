module ActionDispatch::Routing
	class Mapper

		def happyfunstats
			Rails.application.routes.draw do
				get '/stats' => 'happyfunstats/stats#index'
			end
		end
	
	end
end
