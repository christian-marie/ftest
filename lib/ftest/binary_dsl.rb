require 'open3'
require 'io/wait'

module FTest::BinaryDSL
	def binary! *cmd
		@stdin, @stdout, @stderr, @thread = Open3.popen3(*cmd)
	end

	def stderr
		@stderr
	end

	def stdout
		@stdout
	end

	def stdin
		@stdin
	end

	def return_code
		@return_code or (@return_code = @thread.value.to_i)
	end

	def exit_success?
		@return_code == 0
	end

	def pid
		@thread.pid
	end

	def alive?
		@thread.alive?
	end

	def kill_child! signal=9
		Process.kill(signal, @thread.pid)
	end

	def wait_for_output!
		while (stdout.nread + stderr.nread == 0)
			sleep 0.001
		end
	end
end
