require 'spec_helper'

describe ::FTest::Runner do
	describe 'run!' do 
		it 'runs defined scenarios correctly' do
			p0 = Proc.new {0}
			p1 = Proc.new {1}
			p2 = Proc.new {2}
			p3 = Proc.new {3}

			::FTest::Scenario.should_receive(:new).
				with('', &p3).and_call_original

			instance = ::FTest::Runner.new do 
				helpers(&p0)
				before(&p1)
				after(&p2)

				scenario(&p3)
			end

			::FTest::Scenario.any_instance.should_receive(:run!).
				with([p1], [p2], [p0])


			instance.run!
		end
	end

	describe 'report!' do
		before do
			# And this is part of the reason for developing this
			# framework
			@original_stdout = $stdout
			$stdout = @stdout = StringIO.new
		end

		it 'displays scenarios as they run' do
			instance = ::FTest::Runner.new do 
				scenario { 'success' }
				scenario { 'another victory' }
				scenario('failure'){ fail }
				scenario('assertion'){
					assert(false, "potato")
				}
			end
			
			instance.report!

			expect(@stdout.string.lines.first).to eql(
				"Running scenarios: ..FF\n"
			)

			expect(@stdout.string).to include("failure")
			expect(@stdout.string).to include("assertion")
			expect(@stdout.string).to include("potato")
			expect(@stdout.string).to_not include("Extra details")
		end

		after do
			$stdout = @original_stdout
		end
	end
end
	
