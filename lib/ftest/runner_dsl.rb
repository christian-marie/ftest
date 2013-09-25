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

	def scenario *arguments, &block
		if arguments[0].is_a?(String) then
			description = arguments[0]
		else
			description = ''
		end

		if arguments[0].is_a?(Hash) then
			options = arguments[0]
		elsif arguments[1].is_a?(Hash) then
			options = arguments[1]
		else
			options = {}
		end

		unless block_given? then
			raise(::ArgumentError, 'scenario expected block') 
		end

		@scenarios ||= [] 
		@scenarios += Array.new(
				(options[:runs] or 1),
				::FTest::Scenario.new(
					description, &block
				)
		)
	end

	def helpers &block
		unless block_given? then
			raise(::ArgumentError, 'helper expected block') 
		end
		(@helper_blocks ||= []) << block
	end
end

