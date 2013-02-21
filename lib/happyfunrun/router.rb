module ActionDispatch::Routing
	class Mapper

		class HappyfunrunMapper

			def initialize(mapper)
				@mapper = mapper
				block.call
			end

			def reports(options={})
				options.reverse_merge!( {:at=>'stats'} )
				namespace :happyfunrun do
					get options[:at] => 'stats#index'
				end
			end

			def newsletters
				namespace :happyfunrun do
					resources :newsletters, :only=>[:new, :create]
				end
			end
		end


		def happyfunrun(&block)
			HappyfunrunMapper.new(self)
			block.call
		end

	end

end
