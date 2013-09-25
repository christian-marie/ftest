module FTest::ScenarioDSL::AssertionDSL
	def fail!(description)
		raise(::FTest::Failure, description)
	end

	# Check if bool is true, or block evaluates to true.
	def assert(bool_or_description, description='assertion failed', &block)
		if block_given? then
			unless block.call then
				raise(
					::FTest::Failure,
					bool_or_description
				)
			end
		else
			unless bool_or_description then
				raise(
					::FTest::Failure,
					description
				)
			end
		end
	end

	# Check that a.include? b
	def assert_inclusion(a, b, description='')
		return if a.include?(b) 
		
		begin
			failure = ::FTest::Failure.new(description)
			failure.extra_details << "assert_inclusion failure: "\
				"#{a.inspect}.include? #{b.inspect} == false"
			raise failure
		rescue
			# Just in case
			raise ::FTest::Failure.new(description)
		end
	end
end
