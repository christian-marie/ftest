require 'spec_helper'

describe ::FTest::ScenarioDSL::FuzzDSL do
	include ::FTest::ScenarioDSL::FuzzDSL

	before :each do
		File.stub('open'){ double('dummy').as_nil_object }
	end

	shared_context 'seeded' do
		before(:each) do
			@random = Random.new(9)
		end
	end

	shared_context 'unseeded' do
		before(:each) do
			@random = Random.new
		end
	end

	describe 'fuzz' do
		it 'throws argument error with nothing' do
			expect{fuzz('desc')}.to raise_exception(
				::ArgumentError, /fuzz expected block/
			)
		end

		it 'runs block n times' do
			n = ::Random.rand(10)
			i = 0

			fuzz(:runs => n) do
				i += 1
			end

			expect(n).to eql(i)
		end
		it 'passes on exceptions' do
			expect {
				fuzz('explosion') do
					raise 'Ohnoes'
				end
			}.to raise_error(
				::RuntimeError, 'Ohnoes'
			)
		end

		it 'munges failures to add extra detail' do
			expect{
				fuzz('explosion') do
					raise ::FTest::Failure, 'x'
				end
			}.to raise_error do |e|
				expect(e.extra_details).to include(
					"whilst fuzzing 'explosion'"
				)
			end
		end
	end

	describe 'mutate' do
		include_context 'unseeded'

		it 'mutates a simple string at least once' do
			1000.times do
				expect(mutate('hi')).to_not eql('hi')
			end
		end
	end

	describe 'bytes' do
		context 'seeded' do
			include_context 'seeded'

			it 'returns a random length, random byte string' do 
				expect(random_bytes.bytesize).to eql(55934)
			end
		end
		context 'unseeded' do
			include_context 'unseeded'
			it 'returns a string of specified length' do
				expect(random_bytes(42).bytesize).to eql(42)
			end
		end
	end

	describe 'random_base64' do
		include_context 'unseeded'

		it 'provides a string' do
			# 3/4 ratio
			expect(random_base64(30).length).to eql(40)
		end
	end

	describe 'random_uri_encoded' do
		include_context 'unseeded'

		it 'provides a string' do
			# 1/3 ratio
			expect(random_uri_encoded(10).length).to eql(30)
			expect(random_uri_encoded).to_not include("\n")
		end
	end

	describe 'random_cstring' do
		include_context 'unseeded'
		
		it 'does not have nulls' do
			expect(random_cstring).to_not include("\00")
		end
	end

	describe 'rand' do
		include_context 'unseeded'

		it 'works' do
			expect(rand).to be_a(Float)
			expect(rand(2)).to be_a(Fixnum)
		end
	end
end
