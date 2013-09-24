require 'ftest/scenario_dsl'

class ::FTest::Scenario
	include FTest::ScenarioDSL

	def initialize(description, &block)
		raise(::ArgumentError) unless block_given?

		# This namespace should be reserved for the user
		@__block__ = block
		@__description__ = description
	end

	def run!(before_blocks=[], after_blocks=[])
		(before_blocks||[]).each do |block|
			instance_eval(&block)
		end

		instance_eval(&@__block__)

		(after_blocks||[]).each do |block|
			instance_eval(&block)
		end
	rescue Exception => exception
		handle_failure!(exception)
	end

	def failure?
		!success?
	end

	def success?
		failures.empty?
	end

	def failures
		@__failures__ ||= []
	end

	def description
		@__description__
	end

	protected
	def handle_failure!(exception)
		failures << exception
	end
end
