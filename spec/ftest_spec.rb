require 'spec_helper'

describe FTest do
	describe 'basic test' do 
		it 'runs scenario' do
			FTest do
				scenario 'hai' do
					$ftest_scenario_ran = true
				end
			end

			expect($ftest_scenario_ran).to be_true
		end

		it 'does before/after blocks order' do
			FTest do 
				before do
					@before = true
				end

				after do
					@after = true
				end

				scenario 'test before and after' do
					raise unless @before
					raise if @after
				end
			end
		end
	end

	describe 'binary DSL usage' do
		it 'tests support/test script' do
			path = File.join(
				File.dirname(__FILE__),
				'support', 'test',
			)
			FTest do
				before do
					binary "#{path} hai"
				end

				after do
					assert(!exit_success?)
				end

				scenario do
					wait_for_output!

					output = stdout.read(stdout.nread)

					assert_inclusion(output, 'hai')

					# Should block till exit
					assert(return_code == 42)
				end
			end
		end
	end
end
	
