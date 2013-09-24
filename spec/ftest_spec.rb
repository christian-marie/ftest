require 'spec_helper'

describe FTest do
	before do
		# And this is part of the reason for developing this
		# framework
		@original_stdout = $stdout
		$stdout = @stdout = StringIO.new
	end

	after do
		$stdout = @original_stdout
	end

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
				'support', 'test'
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

					output = stdout.read

					assert_inclusion(output, 'hai')

					# Should block till exit
					assert(return_code == 42)
				end
			end
		end
	end

	describe 'fuzz DSL usage' do
		it 'tests a method' do
			widget = double('widget')
			widget.should_receive(:frob).exactly(10).times
			widget.should_receive(:frob).and_raise(
				'wat'
			)

			FTest do
				scenario do
					fuzz(
						'frob',
						:runs => 11,
						:seed => 1234
					) do
						widget.frob(mutate('x'))
					end
				end
			end

			expect(@stdout.string).to include('whilst fuzzing')
			expect(@stdout.string).to include('frob')
			expect(@stdout.string).to include('1234')
		end

	end
end
	
