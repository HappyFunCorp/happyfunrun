module Happyfunrun
	
	class Subject

		class << self

			def compile(options={})
				options.reverse_merge!({:since=>nil})
				since = options[:since]
				Happyfunrun::subjects.collect{|subject|
					{
						subject.name => {
							:value => subject.value(:since=>since),
							:since => since
						}
					}
				}.inject { | a, h | a.merge h }
			end

			def metadata(options={})
				options.reverse_merge!({})
				{:fields=> Happyfunrun::subjects.collect{|subject| subject.name}}
			end

		end

		attr_accessor :model, :scope, :name, :date_column, :lambda
		
		def initialize(name, model_scope_or_proc, *options)
			_opts = {}

			@name = name

			if model_scope_or_proc.is_a? Proc
				@lambda = model_scope_or_proc

			elsif model_scope_or_proc.is_a? ActiveRecord::Relation
				@scope = model_scope_or_proc

			elsif model_scope_or_proc < ActiveRecord::Base
				@scope = model_scope_or_proc.scoped

			end

			_opts.reverse_merge!({
				:date_column => 'created_at',
			})

			@date_column = _opts[:date_column]
			
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

				_result = @lambda.call(Time.at(options[:since].to_i))

			else

				if options[:since].nil?
					_result = @scope.count
				else
					_since = Time.at(options[:since].to_i)
				
					# Sanitize the column name:
					unless @scope.klass.column_names.include? @date_column
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

