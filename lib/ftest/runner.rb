require 'ftest/runner_dsl'

class ::FTest::Runner
	include ::FTest::RunnerDSL

	Failure = Class.new(RuntimeError)

	def initialize &block
		raise(::ArgumentError) unless block_given?

		# User now sets @scenarios, @before_blocks, @after_blocks and
		# @helper_blocks
		instance_eval(&block)
	end

	def run!(&block)
		(@scenarios||[]).each do |scenario|
			scenario.run!(
				@before_blocks,
				@after_blocks,
				@helper_blocks
			)
			yield scenario if block_given?
		end
	end

	def report!
		print "Running scenarios: "

		run! do |scenario|
			print(scenario.success? ? '.' : 'F')
		end

		(@scenarios||[]).each do |scenario|
			if scenario.failure? then
				print(
					::FTest::Formatting::format_failures(
						scenario
					)
				)
			end
		end
	end
end

