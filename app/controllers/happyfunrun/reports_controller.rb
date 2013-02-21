class Happyfunrun::ReportsController < ApplicationController
	
	before_filter :verify_key

	def summary
		begin
			render :json=>Happyfunrun::models.collect{|x| x.reports(:since=>params[:since])}.inject { | a, h | a.merge h }
		rescue StandardError => e
			render :json=>{:error=>e.message}
		end
	end


	private
		
		# Not exactly secure, but it's better than nothing:
		def verify_key
			redirect_to root_path unless (Happyfunrun::app_id==params[:app_id] and Happyfunrun::app_secret==params[:app_secret])
		end
	
end
