module FTest::ScenarioDSL::AssertionDSL
	def fail! description
		raise ::FTest::Failure, description
	end

	# Check if bool is true, or block evaluates to true.
	def assert(bool_or_description, description='', &block)
		if block_given? then
			unless block.call then
				raise(
					::FTest::Failure,
					bool_or_description,
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
		a.include?(b) or raise(
			::FTest::Failure,
			"assertion failure: " +
			"#{a.inspect}.include? #{b.inspect} " +
			"(#{description})"
		)
	end
end
