class Happyfunrun::ReportsController < ApplicationController
	
	before_filter :verify_key

	def feed
		begin
			render :json=> {:statistics=>Happyfunrun::Subject.compile(:begin=>params[:begin], :end=>params[:end])}.merge({:status=>'200'})
		rescue handled_exceptions => e
			render :json=>{:status=>'301', :error=>e.message}
		end
	end

	def metadata
		begin
			render :json=>{:metadata=>Happyfunrun.metadata(request)}.merge({:status=>'200'})
		rescue handled_exceptions => e
			render :json=>{:status=>'301', :error=>e.message}
		end
	end


	private
		
		# Not at all secure, but it's better than nothing:
		def verify_key
			unless (Happyfunrun::app_id==params[:app_id] and Happyfunrun::api_key==params[:api_key])
				render :json=>{:status=>'300', :error=>'Access Denied'}
				return
			end
		end

		def handled_exceptions
			if Happyfunrun.debug_mode
				[StandardError]
			else
				[]
			end
		end
	
end
