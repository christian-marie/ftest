# Truly some of the most beatiful code ever seen
module FTest::Formatting
	def self.format_failure(failure)
		out = "\n"
		if failure.respond_to? :check_description then
			out += "In check '#{failure.check_description}':\n"
		end
		if failure.respond_to? :fuzz_description then
			out += "Whilst fuzzing  '#{failure.fuzz_description}':"
			out += "\n"
		end
		out += "Failure (#{failure.class}): #{failure.message}\n"
		out += failure.backtrace.reject{|line|
			line.include?(File.dirname(__FILE__))
		}.map{|l| "    #{l}"} * "\n"
	end

	def self.format_failures(failures)
		out = "\n"
		failures.group_by{|f|
			f.scenario[:description]
		}.each do |scenario, fails|
			out += "Failures for scenario '#{scenario}':\n"
			out += fails.map do |failure|
				 FTest::Formatting::format_failure(failure)
			end.map do |l|
				"  #{l}"
			end * "\n"
		end
		out
	end
end
