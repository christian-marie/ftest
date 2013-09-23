require 'spec_helper'

describe FTest do
	describe 'class DSL' do 
		it 'runs our before_checks' do
			class BeforeCheck < FTest
				before_check('set x'){@x=1}
			end

			scenario = FTest::Scenario.new(
				'test case',
				Proc.new { @x == 1 or fail('thing not set') }
			)

			BeforeCheck.new(scenario)
		end

		it 'runs our after_checks' do
			class AfterCheck < FTest
				after_check('check x'){ fail unless @x == 2 }
			end

			scenario = FTest::Scenario.new(
				'test case',
				Proc.new { @x = 2 },
			)

			AfterCheck.new(scenario)
		end

		it 'runs our post mortem check' do
			class PostMortem < FTest
				def after!
					@x = 3
				end

				post_mortem 'desc' do
					fail unless @x == 3
				end
			end

			scenario = FTest::Scenario.new(
				'test case',
				Proc.new { },
			)

			PostMortem.new(scenario)
		end
	end
end
	
