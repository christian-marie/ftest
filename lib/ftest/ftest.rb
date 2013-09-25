require 'ftest/runner'
require 'ftest/formatting'

module ::Kernel
	def FTest(options={}, &block)
		(options[:runs] or 1).times do
			::FTest::Runner.new(&block).report!
		end
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

