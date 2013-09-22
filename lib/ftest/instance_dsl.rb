module FTest::InstanceDSL
	def check description, &block
		instance_eval(&block)
	rescue Failure => failure
		handle_failure(failure)

	end
end
