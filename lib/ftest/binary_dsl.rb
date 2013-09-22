module FTest::BinaryDSL
	def binary! x
		@binary = x
	end

	def run! x
		reader, writer = IO.pipe

		fork do
			writer.puts `#{@binary} #{x}`
		end

		writer.close
		puts reader.close
	end
end
