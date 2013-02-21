class Happyfunrun::ReportsController < ApplicationController
	
	before_filter :verify_key

	def feed
		begin
			render :json=>Happyfunrun::models.collect{|x| x.reports(:since=>params[:since])}.inject { | a, h | a.merge h }.merge({:status=>'200'})
		rescue StandardError => e
			render :json=>{:status=>'301', :error=>e.message}
		end
	end

	def metadata
		begin
			render :json=>Happyfunrun.metadata(request).merge({:status=>'200'})
		rescue StandardError => e
			render :json=>{:status=>'301', :error=>e.message}
		end
	end


	private
		
		# Not exactly secure, but it's better than nothing:
		def verify_key
			unless (Happyfunrun::app_id==params[:app_id] and Happyfunrun::app_secret==params[:app_secret])
				render :json=>{:status=>'300', :error=>'Access Denied'}
				return
			end
		end
	
end
