require 'spec_helper'
require 'timeout'

describe ::FTest::Scenario::BinaryDSL do
	include ::FTest::Scenario::BinaryDSL

	describe 'binary!' do
		it 'calls popen with exact args' do
			Open3.should_receive('popen3').with('ponies', 1)
			binary('ponies', 1)
		end
	end

	describe 'accessor' do
		before :each do
			@stderr = 'stderr'
			@stdout = 'stdout'
			@stdin = 'stdin'
		end

		it 'is correct for stderr' do
			expect(stderr).to eql('stderr')
		end

		it 'is correct for stdout' do
			expect(stdout).to eql('stdout')
		end

		it 'is correct for stdin' do
			expect(stdin).to eql('stdin')
		end

	end

	describe 'return_code' do
		it 'is retrieved from thread' do
			@thread = double(
				'thread', :value => double(
					'value', :exitstatus => 42
				)
			)

			expect(return_code).to eql(42)
		end
	end

	describe 'exit_success?' do
		it 'comes from thread' do
			@thread = double(
				'thread', :value => double(
					'value', :success? => true
				)
			)

			expect(exit_success?).to be_true
		end
	end

	describe 'pid' do
		it 'comes straight from thread' do
			@thread = double('thread', :pid => 42)

			expect(pid).to eql(42)
		end
	end

	describe 'wait_for_output!' do
		it 'should block with nothing to read' do
			@stdout, _ = IO.pipe
			@stderr, _ = IO.pipe

			expect{
				Timeout::timeout(0.01) do
					wait_for_output!
				end
			}.to raise_error(TimeoutError)
		end

		it 'should not block with something to read on stderr' do
			@stdout, _ = IO.pipe
			@stderr, serr = IO.pipe
			
			serr.write('hai')
			Timeout::timeout(0.01) do
				wait_for_output!
			end
		end

		it 'should not block with something to read on stdout' do
			@stdout, sout = IO.pipe
			@stderr, _ = IO.pipe
			
			sout.write('hai')
			Timeout::timeout(0.01) do
				wait_for_output!
			end
		end

	end

	describe 'kill_child!' do
		before :each do
			@thread = double('thread')
			@thread.should_receive(:pid).and_return(42)
		end

		it 'should kill thread pid with KILL by default' do
			Process.should_receive(:kill).with('KILL', 42)
			kill_child!
		end

		it 'should kill thread pid with whatever you pass' do
			Process.should_receive(:kill).with('crab', 42)
			kill_child!('crab')
		end
	end
end

