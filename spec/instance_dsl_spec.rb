require 'spec_helper'

describe FTest::InstanceDSL do
	include FTest::InstanceDSL

	describe 'fuzz' do
		it 'throws argument error with nothing' do
			expect{fuzz('desc')}.to raise_exception(
				ArgumentError, /block not supplied/
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
				RuntimeError, 'Ohnoes'
			)
		end

		it 'munges failures to add extra detail' do
			expect{
				fuzz('explosion') do
					raise FTest::Failure, 'x'
				end
			}.to raise_error do |e|
				expect(e.fuzz_description).
					to include('explosion')
			end
		end
	end

	describe 'fatal!' do
		it 'raises FatalFailure with description passed in' do
			expect{fatal!('desc')}.to raise_error(
				::FTest::FatalFailure, /desc/
			)
		end
	end

	describe 'fail!' do
		it 'raises Failure with description passed in' do
			expect{fail!('desc')}.to raise_error(
				::FTest::Failure, /desc/
			)
		end
	end

	describe 'assert' do
		it 'raises with a false value and no block' do
			expect{assert(false, 'ohno')}.to raise_error(
				::FTest::Failure, /ohno/
			)
		end

		it 'does not raise with true value and no block' do
			assert(true, 'should not raise')
		end

		it 'raises with a block returning false' do
			expect{assert('ohno'){false}}.to raise_error(
				::FTest::Failure, /ohno/
			)
		end

		it 'does not raise with a block returning true' do
			assert('should not raise') { true }
		end
	end
end
