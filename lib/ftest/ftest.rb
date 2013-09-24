require 'ftest/runner'
require 'ftest/formatting'

module ::Kernel
	def FTest(&block)
		::FTest::Runner.new(&block).report!
	end
	module_function :FTest
end

class ::Exception
	def extra_details
		@extra_details ||= []
	end
end

class FTest::Failure < RuntimeError
end

