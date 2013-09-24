require 'spec_helper'

describe ::FTest::Runner do
	describe 'run!' do 
		it 'runs defined scenarios correctly' do
			p1 = Proc.new {1}
			p2 = Proc.new {2}
			p3 = Proc.new {3}

			::FTest::Scenario.should_receive(:new).
				with('', &p3).and_call_original

			instance = ::FTest::Runner.new do 
				before &p1
				after &p2

				scenario &p3
			end

			::FTest::Scenario.any_instance.should_receive(:run!).
				with([p1], [p2])


			instance.run!
		end
	end
end
	
