guard :rspec do
	watch(%r{^spec/.+_spec\.rb$})
	watch(%r{^lib/ftest/(.+)\.rb$}){ |m| 
		"spec/#{m[1]}_spec.rb" 
	}
	watch('spec/spec_helper.rb'){ "spec" }
end

