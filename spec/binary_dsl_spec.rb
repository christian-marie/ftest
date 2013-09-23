require 'spec_helper'
require 'timeout'

describe FTest::BinaryDSL do
	include FTest::BinaryDSL

	describe 'binary!' do
		it 'calls popen with exact args' do
			Open3.should_receive('popen3').with('ponies', 1)
			binary!('ponies', 1)
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
		it 'is retrieved from thread and cached' do
			@thread = double('thread')
			@thread.should_receive(:value).and_return(42)

			expect(return_code).to eql(42)
			expect(@return_code).to eql(42)

			# Caches correctly
			@return_code = 100
			expect(return_code).to eql(100)
		end
	end

	describe 'exit_success?' do
		it 'thinks that zero is success' do
			@return_code = 0
			expect(exit_success?).to be_true
		end

		it 'thinks that non-zero is not success' do
			@return_code = -1
			expect(exit_success?).to be_false
		end
	end

	describe 'pid' do
		it 'comes straight from thread' do
			@thread = double('thread')
			@thread.should_receive(:pid).and_return(42)

			expect(pid).to eql(42)
		end
	end

	describe 'wait_for_output!' do
		it 'should block with nothing to read' do
			@stdout, sout = IO.pipe
			@stderr, serr = IO.pipe

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

