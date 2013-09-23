module FTest::InstanceDSL
	def check description, &block
		instance_eval(&block)
	rescue FTest::Failure => failure
		# Save our check for nicer errors later.
		failure.instance_variable_set(
			:@check_description,
			description
		)
		def failure.check_description
			@check_description
		end

		handle_failure(failure)
	end

	def fatal! description
		raise FTest::FatalFailure, description
	end

	def fail! description
		raise FTest::Failure, description
	end

	# Check if bool is true, or block evaluates to true.
	def assert(bool_or_description, description='', &block)
		if block_given? then
			unless block.call then
				raise(
					::Failure::Failure.new,
					bool_or_description,
				)
			end
		else
			unless bool.nil?
				unless bool then
					raise(
						::Failure::Failure.new,
						description
					)
				end
			end
		end
	end
end
