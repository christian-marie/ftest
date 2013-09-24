# Truly some of the most beatiful code ever seen. Deserves it's own module.
module FTest::Formatting
	def self.format_failure(failure)
		out = ''
		out += "Failure (#{failure.class}): #{failure.message}\n"
		if failure.respond_to? :extra_details then
			unless failure.extra_details.empty? then
				out += "Extra details:"
				out += failure.extra_details.map do |l|
					"  #{l}"
				end * "\n"
				out += "\n"
			end
		end
		out += failure.backtrace.reject{|line|
			line.include?(File.dirname(__FILE__))
		}.map{|l| "  #{l}"} * "\n"
		out += "\n"
	end

	def self.format_failures(scenario)
		("\nFailures whilst runniing scenario '"\
			"#{scenario.description}': \n" +
		scenario.failures.map do |failure|
			FTest::Formatting::format_failure(
				failure
			).lines.map do |l| 
				"  #{l}" 
			end
		end * "\n") + "\n"
	end
end
