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
				expect(e.extra_details).to include(
					"whilst fuzzing 'explosion'"
				)
			end
		end
	end

	describe 'mutate' do
		before(:each) do
			@random = Random.new
		end

		it 'mutates a simple string at least once' do
			1000.times do
				expect(mutate('hi')).to_not eql('hi')
			end
		end
	end
end
