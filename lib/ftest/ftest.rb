require 'ftest/runner'
require 'ftest/formatting'

module ::Kernel
	def FTest(&block)
		::FTest::Runner.new(&block).report!
	end
	module_function :FTest
end

class FTest::Failure < RuntimeError
	def extra_details
		@extra_details ||= []
	end
end

