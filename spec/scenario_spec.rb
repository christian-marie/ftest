require 'spec_helper'

describe ::FTest::Scenario do
	describe 'run!' do 
		before do
			class ::FTest::Scenario
				attr_reader :scenario_ran
			end
		end

		it 'does before/after and block in order' do
			before = Proc.new do
				@before_ran = true
			end

			after = Proc.new do
				raise unless @scenario_ran
				@after_ran = true
			end

			instance = ::FTest::Scenario.new('desc') do 
				raise unless @before_ran
				@scenario_ran = true
			end

			instance.run!([before], [after])
			expect(instance.scenario_ran).to be_true
		end
	end
end
	
