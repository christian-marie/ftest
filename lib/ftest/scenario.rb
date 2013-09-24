require 'ftest/scenario_dsl'

class ::FTest::Scenario
	include FTest::ScenarioDSL

	def initialize(description, &block)
		raise(::ArgumentError) unless block_given?

		# This namespace should be reserved for the user
		@__block__ = block
	end

	def run! before_blocks, after_blocks
		(before_blocks||[]).each do |block|
			instance_eval(&block)
		end

		instance_eval(&@__block__)

		(after_blocks||[]).each do |block|
			instance_eval(&block)
		end
	end
end
