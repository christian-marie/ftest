require 'ftest/runner_dsl'

class ::FTest::Runner
	include ::FTest::RunnerDSL

	Failure = Class.new(RuntimeError)

	def initialize &block
		raise(::ArgumentError) unless block_given?

		# User now sets @scenarios, @before_blocks and @after_blocks
		instance_eval(&block)
	end

	def run!
		(@scenarios||[]).each do |scenario|
			scenario.run!(@before_blocks, @after_blocks)
		end
	end

	def report!
	end

	# This lets us know if, at the time of calling, this instance has had
	# any failures.
	def instance_failure?
		@instance_failure
	end

	protected
	# Run a check, saving any failures.
	def run_check! check
		instance_eval(&check[:block])
	rescue Exception => failure
		# Save our check for nicer errors later.
		failure.instance_variable_set(
			:@check_description,
			check[:description],
		)

		def failure.check_description
			@check_description
		end

		handle_failure!(failure)
	end

	def handle_failure!(failure)
		# Anything that isn't a routine failure is instant death.
		case failure
		when ::FTest::Failure
			@instance_failure = true

			# Save our scenario for better errors.
			failure.instance_variable_set(:@scenario, @scenario)
			def failure.scenario
				@scenario
			end

			@@failures << failure
		else
			raise
		end
	end

	# Class level interface methods.
	public
	def self.test!
		print "Running scenarios: "
		@@scenarios.each do |scenario|
			scenario[:runs].times do |i|
				run = self.new(scenario)
				print(run.instance_failure? ? 'F' : '.')
			end
		end
		puts
		puts "Done."
	end

	# True if all is lost, false if all is well.
	def self.failures?
		!@@failures.empty?
	end

	# Returns an array of Failure exceptions, can be empty.
	def self.failures
		@@failures
	end

	# Display all failures with backtrace, lines within FTest are omitted
	# from the backtrace.
	def self.report!
		puts FTest::Formatting::format_failures(self.failures)
	end

	# Class level DSL
	protected
	def self.scenario description, params={}, &block
		unless block_given? then
			raise ArgumentError, 'scenario requires a block'
		end

		@@scenarios << 	::FTest::Scenario.new(
			description,
			block,
			(params[:runs] or 1)
		)
	end

	# These checks are run at the end of each scenario (just before after!)
	def self.after_check description, &block
		@@after_checks << ::FTest::Check.new(description, block)
	end

	# These checks are run before each scenario run, (just after before!)
	def self.before_check description, &block
		@@before_checks << ::FTest::Check.new(description, block)
	end

	def self.post_mortem description, &block
		@@post_mortems << ::FTest::Check.new(description, block)
	end
end

