# Truly some of the most beatiful code ever seen. Deserves it's own module.
module FTest::Formatting
	def self.format_failure(failure)
		out = ''
		if failure.respond_to? :failure_details then
			out += "Extra details:"
			out += failure.failure_details.map do |l|
				"  #{l}"
			end * "\n"
		end
		out += "Failure (#{failure.class}): #{failure.message}\n"
		out += failure.backtrace.reject{|line|
			line.include?(File.dirname(__FILE__))
		}.map{|l| "  #{l}"} * "\n"
	end

	def self.format_failures(scenario)
		"\nFailures whilst runniing scenario '"\
			"#{scenario.description}': \n" +
		scenario.failures.map do |failure|
			FTest::Formatting::format_failure(
				failure
			).lines.map do |l| 
				"  #{l}" 
			end
		end * "\n"
	end
end
