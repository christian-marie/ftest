require 'ftest/instance_dsl'
require 'ftest/binary_dsl'

class FTest
	include InstanceDSL
	include BinaryDSL

	@@failures = []
	@@after_checks = []
	@@before_checks = []
	@@scenarios = []

	Failure = Class.new(RuntimeError)

	# Kicks off one scenario run
	def initialize &scenario
		before! if respond_to? :before!

		@@before_checks.each(&method(:run_check))
		instance_eval(&scenario)
		@@after_checks.each(&method(:run_check))

		after! if respond_to? :finish!
	end

	protected
	def run_check check
		instance_eval(&check[:block])
	rescue Failure => failure
		handle_failure(failure)
	end

	def handle_failure(failure)
		@@failures << failure
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
			puts "Failure: #{failure.message}"
			puts failure.backtrace.reject{|line|
				line =~ /#{__FILE__}/
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

	# These checks are run at the end of each scenario, just before after!
	def self.after_check description, &block
		@@after_checks << ::FTest::Check.new(description, block)
	end

	def self.before_check description, &block
		@@before_checks << ::FTest::Check.new(description, block)
	end
end

