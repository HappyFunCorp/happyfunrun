module Happyfunrun
	
	class Subject

		attr_accessor :model, :scope, :name, :date_column, :lambda
		
		def initialize(model_scope_or_proc, options={})

			if model_scope_or_proc.is_a? Proc
				@lambda = model_scope_or_proc

			elsif model_scope_or_proc.is_a? Symbol
				@model = model_scope_or_proc.to_s.classify.constantize
				@scope = @model.scoped

			elsif model_scope_or_proc < ActiveRecord::Base
				@model = model_scope_or_proc
				@scope = @model.scoped

			elsif model_scope_or_proc.is_a? ActiveRecord::Relation
				@model = model_scope_or_proc.klass
				@scope = model_scope_or_proc

			end

			options.reverse_merge!({
				:as=>@model.to_s.underscore.pluralize,
				:date_column => 'created_at',
			})

			@name = options[:as]

			@date_column = options[:date_column]
			
		end

	
		def is_lambda?
			!@lambda.nil?
		end


=begin
		def histogram
			Histogram.new(self).evaluate
		end
=end


		def value(options={})
			options.reverse_merge!({:since=>nil})

			if self.is_lambda?

				_result = @lambda.call(options[:since])

			else

				if options[:since].nil?
					_result = @scope.count
				else
					_since = Time.at(options[:since].to_i)
				
					# Sanitize the column name:
					unless @model.column_names.include? @date_column
						raise StandardError.new("CrappyConfigError: Invalid column name '#{@date_column}' for table '#{@model}'.")
					end

					_result = @scope.where("#{@date_column} > ?",_since).count

				end

			end

		end

=begin
		def statistics(options={})
			options.reverse_merge!({:since=>nil})
			_result = {}
			
			if options[:since].nil?
				_result[:count] = @scope.count
			else
				_since = Time.at(options[:since].to_i)
			
				# Sanitize the column name:
				unless @model.column_names.include? @date_column
					raise StandardError.new("CrappyConfigError: Invalid column name '#{@date_column}' for table '#{@model}'.")
				end

				_result[:count] = @scope.where("#{@date_column} > ?",_since).count

			end
			#_result[:histogram] = self.histogram

			{@name => _result}
		end
=end

	end

end

