module FTest::InstanceDSL
	def fuzz description, options={}, &block
		(options[:runs] or 1).times do
			begin
				instance_eval(&block)
			rescue FTest::Failure => failure
				# Save our check for nicer errors later.
				failure.instance_variable_set(
					:@fuzz_description,
					description,
				)
				def failure.fuzz_description
					@fuzz_description
				end
				raise failure
			end
		end
	end

	def fatal! description
		raise ::FTest::FatalFailure, description
	end

	def fail! description
		raise ::FTest::Failure, description
	end

	# Check if bool is true, or block evaluates to true.
	def assert(bool_or_description, description='', &block)
		if block_given? then
			unless block.call then
				raise(
					::FTest::Failure.new,
					bool_or_description,
				)
			end
		else
			unless bool.nil?
				unless bool then
					raise(
						::FTest::Failure.new,
						description
					)
				end
			end
		end
	end
end
