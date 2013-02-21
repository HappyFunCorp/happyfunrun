module ActionDispatch::Routing
	class Mapper


		# The only helper exposed to happyfunrun
		def happyfunrun(options={}, &block)
			HappyfunrunMapper.new(self,options,&block)
		end


		# Scope helper methods within HappyfunrunMapper to avoid name collisions
		class HappyfunrunMapper
			
			def initialize(mapper,options={},&block)
				@mapper = mapper

				options.reverse_merge!({})

				self.instance_eval(&block)
			end

			def reports
				@mapper.namespace :happyfunrun do
					@mapper.get 'reports' => 'reports#feed'
					@mapper.get 'metadata' => 'reports#metadata'
				end
			end

			def newsletters
				@mapper.namespace :happyfunrun do
					@mapper.resources :newsletters, :only=>[:new, :create]
				end
			end
		end


	end

end
