require 'ftest/scenario'

# All of the 'top level' DSL calls allowed
module ::FTest::RunnerDSL
	def before &block
		unless block_given? then
			raise(::ArgumentError, 'before expected block') 
		end
		(@before_blocks ||= []) << block
	end

	def after &block
		unless block_given? then
			raise(::ArgumentError, 'after expected block') 
		end
		(@after_blocks ||= []) << block
	end

	def scenario description='', &block
		unless block_given? then
			raise(::ArgumentError, 'scenario expected block') 
		end

		(@scenarios ||= []) << ::FTest::Scenario.new(
			description, &block
		)
	end
end

