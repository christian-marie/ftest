module ::FTest::ScenarioDSL::FuzzDSL
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
end
