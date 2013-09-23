require 'open3'
require 'io/wait'

module FTest::BinaryDSL
	def binary! *cmd
		@stderr_r, @stderr_w = IO.pipe
		@stdout_r, @stdout_w = IO.pipe
		@stdin_r, @stdin_w = IO.pipe

		@pid = fork do
			# Won't need these
			@stderr_r.close
			@stdout_r.close
			@stdin_w.close

			# Connect the tubes the right way 
			Open3.popen3(*cmd) do |input, stdout, stderr, thread|
				while thread.alive? do
					IO.select([stdout, stderr, @stdin_r])
					if stdout.ready? then
						@stdout_w.write(
							stdout.read(
								stdout.nread
							)
						)
					end
					if stderr.ready? then
						@stderr_w.write(
							stderr.read(
								stderr.nread
							)
						)
					end
					if @stdin_r.ready? then
						input.write(
							@stdin_r.read(
								@stdin_r.nread
							)
						)
					end
				end
			end
		end

		@stderr_w.close
		@stdout_w.close
		@stdin_r.close
	end

	def stderr
		@stderr_r
	end

	def stdout
		@stdout_r
	end

	def stdin
		@stdin_w
	end

	def pid
		Integer(@pid)
	end

	def kill_child! signal=9
		Process.kill(signal, @pid)
	end

	def wait_for_output!
		while (stdout.nread + stderr.nread == 0)
			sleep 0.01
		end
	end
end
