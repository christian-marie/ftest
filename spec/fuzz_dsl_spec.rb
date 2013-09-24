require 'spec_helper'

describe ::FTest::ScenarioDSL::FuzzDSL do
	include ::FTest::ScenarioDSL::FuzzDSL

	describe 'fuzz' do
		it 'throws argument error with nothing' do
			expect{fuzz('desc')}.to raise_exception(
				::ArgumentError, /fuzz expected block/
			)
		end

		it 'runs block n times' do
			n = rand(10)
			i = 0

			fuzz('hai', :runs => n) do
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
				expect(e.fuzz_description).
					to include('explosion')
			end
		end
	end
end
