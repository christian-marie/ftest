class ::FTest::RingBuffer
	def initialize(size)
		@array = Array.new(size)
	end

	def push(e)
		@array.shift
		@array.push(e)
		self
	end

	def [](n=0)
		@array[-1 + n]
	end
end
