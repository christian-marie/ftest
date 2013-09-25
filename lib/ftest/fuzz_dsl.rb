require 'base64'
require 'ftest/ring_buffer'
require 'uri'

module ::FTest::ScenarioDSL::FuzzDSL
	# Maybe overflow a 32 bit uint
	DEFAULT_MAXLEN=0xffff+(2<<12)
	# Maximum random values to save (held in a ring buffer)
	MAX_SAVE=10

	def fuzz(*arguments, &block)
		if arguments[0].is_a?(String) then
			description = arguments[0]
		else
			description = ''
		end

		if arguments[0].is_a?(Hash) then
			options = arguments[0]
		elsif arguments[1].is_a?(Hash) then
			options = arguments[1]
		else
			options = {}
		end

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
				begin
					file = write_random_values!
					failure.extra_details << "Last random"\
						" values were written to: "
						"#{file.path}"
				rescue Exception => e
					failure.extra_details << e.message
				end


				# Save our check for nicer errors later.
				failure.extra_details << "whilst fuzzing '"\
					"#{description}'"
				failure.extra_details << "random seed was: "\
					"#{@random.seed}"
				raise failure
			end
		end
	end

	def mutate(string, runs=1)
		save_last_random_value! do
			_mutate(string, runs)
		end
	end

	def random_bytes(length=nil)
		save_last_random_value! do
			length = @random.rand(DEFAULT_MAXLEN) unless length
			@random.bytes(length)
		end
	end

	def random_cstring(length=nil)
		save_last_random_value! do
			length = @random.rand(DEFAULT_MAXLEN) unless length
			@random.bytes(length).gsub("\x00", "\n")
		end
	end

	def random_base64(length=DEFAULT_MAXLEN)
		save_last_random_value! do
			length = @random.rand(DEFAULT_MAXLEN) unless length
			Base64::strict_encode64(@random.bytes(length))
		end
	end

	def random_uri_encoded(length=DEFAULT_MAXLEN)
		save_last_random_value! do
			length = @random.rand(DEFAULT_MAXLEN) unless length
			::URI::encode(@random.bytes(length), /./).gsub(
				"\n", "%0A" # wat
			)
		end
	end

	def rand(*args)
		save_last_random_value! do
			@random.rand(*args)
		end
	end

	protected 
	def save_last_random_value!(&block)
		raise(ArgumentError) unless block_given?

		unless @random
			raise("fuzz DSL may not be outside of 'fuzz' block")
		end

		@last_random_values ||= ::FTest::RingBuffer.new(MAX_SAVE)
		@last_random_values.push(block.call)[0]
	end

	def _mutate(string, runs=1)
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
			new = _mutate(string, runs)
		end

		new
	end

	def write_random_values!
		unless @last_random_values then
			raise ::ArgumentError, 'no fuzz values to report'
		end
		require 'tempfile'
		file = File.open("./ftest_last_values_#{@random.seed}", 'w')

		# Go backwards, seems more readable this way
		file.write(
			"This file has the last #{MAX_SAVE} values that "\
			"ftest was fuzzing with. The oldest value appears"\
			"at the top"
		)

		MAX_SAVE.downto(1) do |i|
			file.write("Random value: #{i}\n")
			file.write(("="*79) + "\n")
			file.write("#{@last_random_values[i-1]}\n")
			file.write("="*79 + "\n")
			file.write("\n")
		end

		file.close
		file
	end
end
