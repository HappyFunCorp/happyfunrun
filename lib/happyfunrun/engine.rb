module Happyfunrun

	# If true, raise application exceptions instead of failing silently.
	mattr_accessor :debug_mode
	@@debug_mode = false

	mattr_accessor :subjects
	@@subjects = []

	# A token generated by HappyFunRun that must be passed with all requests
	mattr_accessor :app_id, :api_key
	@@app_id = ''
	@@api_key = ''

	def self.track_value_of(_name, model_scope_or_proc, options={})
		@@subjects << Subject.new(_name, model_scope_or_proc, options)
	end

	def self.setup
	
		# User after_initialize so that model scopes may be accessed. Otherwise I ran into issues
		# where models which accessed config directly (e.g. paperclip + s3.yaml) were not initialized
		# by the time this was executed.
		
		Rails.application.config.after_initialize do
			yield self
		end
	end

	def self.metadata(request)
		_url = "#{request.protocol}#{request.host_with_port}"
		{
			:app_id => @@app_id,
			:app_name => Rails.application.class.parent_name,
			:host => "<a href=\"#{_url}\">#{_url}</a>"
		}.merge( Happyfunrun::Subject.metadata )
	end

	class Engine < Rails::Engine

	end
end
