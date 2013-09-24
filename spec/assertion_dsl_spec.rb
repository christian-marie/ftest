require 'spec_helper'

describe ::FTest::ScenarioDSL::AssertionDSL do
	include ::FTest::ScenarioDSL::AssertionDSL
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
