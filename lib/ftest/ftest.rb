require 'ftest/instance_dsl'
require 'ftest/binary_dsl'
require 'ftest/check'
require 'ftest/scenario'

class FTest
	include InstanceDSL
	include BinaryDSL

	@@failures = []
	@@after_checks = []
	@@before_checks = []
	@@post_mortems = []
	@@scenarios = []

	Failure = Class.new(RuntimeError)
	FatalFailure = Class.new(RuntimeError)

	# Kicks off one scenario run
	def initialize &scenario
		before! if respond_to? :before!

		@@before_checks.each(&method(:run_check!))
		instance_eval(&scenario)
		@@after_checks.each(&method(:run_check!))

	ensure
		after! if respond_to? :after!
		@@post_mortems.each(&method(:run_check!))
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
		when FTest::Failure
			@@failures << failure
		else
			raise
		end
	end

	# Class level interface methods.
	public
	def self.test!
		@@scenarios.each do |scenario|
			self.new(&scenario[:block])
		end
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
		self.failures.each do |failure|
			if failure.respond_to? :check then
				puts "In check: #{failure.check[:description]}"
			end
			puts "Failure (#{failure.class}): #{failure.message}"
			puts failure.backtrace.reject{|line|
				line.include?(File.dirname(__FILE__))
			}
			puts
		end
	end

	# Class level DSL
	protected
	def self.scenario description, params={}, &block
		unless block_given? then
			raise ArgumentError, 'scenario requires a block'
		end

		@@scenarios << 	::FTest::Scenario.new(description, block)
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

