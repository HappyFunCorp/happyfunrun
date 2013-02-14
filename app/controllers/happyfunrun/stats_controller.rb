class Happyfunrun::StatsController < ApplicationController
	
	before_filter :verify_key

	def index
		begin
			render :json=>Happyfunrun::models.collect{|x| x.statistics(:since=>params[:since])}.inject { | a, h | a.merge h }
		rescue StandardError => e
			render :json=>{:error=>e.message}
		end
	end


	private
		
		# Not exactly secure, but it's better than nothing:
		def verify_key
			redirect_to root_path unless Happyfunrun::key == params[:key]
		end
	
end
