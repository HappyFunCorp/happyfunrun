module ActionDispatch::Routing
	class Mapper

		def happyfunrun(options)
			options.reverse_merge!( {:at=>'/stats'} )
			get options[:at] => 'happyfunrun/stats#index'
		end
	
	end
end
