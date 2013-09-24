require 'ftest/runner'
require 'ftest/formatting'

module ::Kernel
	def FTest(&block)
		::FTest::Runner.new(&block).run!
	end
	module_function :FTest
end

class FTest::Failure < RuntimeError
	attr_accessor :failure_details # array of strings
end

