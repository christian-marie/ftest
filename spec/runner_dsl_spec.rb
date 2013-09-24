require 'spec_helper'

describe ::FTest::RunnerDSL do
	include ::FTest::RunnerDSL

	describe 'before' do
		it 'sticks blocks into @before_blocks' do
			expect(@before_blocks).to be_nil
			before(){}
			expect(@before_blocks).to have(1).things
			before(){}
			expect(@before_blocks).to have(2).things
		end
	end

	describe 'after' do
		it 'sticks blocks into @after_blocks' do
			expect(@after_blocks).to be_nil
			after(){}
			expect(@after_blocks).to have(1).things
			after(){}
			expect(@after_blocks).to have(2).things
		end
	end

	describe 'scenario' do
		it 'sticks new scenarios in @scenarios' do
			expect(@scenarios).to be_nil
			scenario(){}
			expect(@scenarios).to have(1).things
			scenario(){}
			expect(@scenarios).to have(2).things

			expect(@scenarios.first).to be_a(::FTest::Scenario)
		end
	end

	describe 'helpers' do
		it 'sticks helpers in @helper_blocks' do
			expect(@helper_blocks).to be_nil
			helpers(){}
			expect(@helper_blocks).to have(1).things
			helpers(){}
			expect(@helper_blocks).to have(2).things
		end
	end
end
