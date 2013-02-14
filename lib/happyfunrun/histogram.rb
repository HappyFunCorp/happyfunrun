module Happyfunrun

	class Histogram

		attr_accessor :subject, :bin_type, :bin_range

		def initialize( subject ) 
			@subject = subject

			# Sanitize the options:
			#@bin_type = %w(daily weekly monthly yearly).include?(bin_type.to_s) ? bin_type.to_sym : :daily
			#@bin_range = Integer(bin_range)
		end

=begin
		def evaluate

			_result = []
			_midnight = Time.now.beginning_of_day

			(0..7).each do |ago|
				_this = {}

				_start_date = _midnight - ago.days
				_end_date = _midnight - (ago-1).days

				_count = @subject.scope
					.where("? > ?", @subject.date_column, _start_date)
					.where("? <= ?", @subject.date_column, _end_date)
					.count

				_this[:start] = _start_date.to_i
				_this[:end] = _end_date.to_i
				_this[:count] = _count

				_result.push(_this)
			end

			_result
		end
=end

	end
	
end
