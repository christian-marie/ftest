module ::FTest::ScenarioDSL::FuzzDSL
	def fuzz description, options={}, &block
		unless block_given? then
			raise(::ArgumentError, 'fuzz expected block')
		end
		(options[:runs] or 1).times do
			if options[:seed] then
				@random = Random.new(options[:seed])
			else
				@random = Random.new
			end

			begin
				instance_eval(&block)
			rescue Exception => failure
				# Save our check for nicer errors later.
				failure.extra_details << "whilst fuzzing '"\
					"#{description}'"
				failure.extra_details << "random seed was: "\
					"#{@random.seed}"

				raise failure
			end
		end
	end

	def mutate string, runs=1
		ensure_context!

		original_encoding = string.encoding

		new = string.dup
		new.force_encoding(Encoding::BINARY)

		runs.times do
			new[@random.rand(string.size)] = 
				[@random.rand(255)].pack('c')
		end

		new.force_encoding(original_encoding)

		# Recurse if we didn't actually change anything
		if new == string then
			new = mutate(string, runs)
		end

		new
	end

	protected 
	def ensure_context!
		unless @random
			raise("fuzz DSL may not be outside of 'fuzz' block")
		end
	end
end
