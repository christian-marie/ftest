$: << File.join(File.dirname(__FILE__), '..', 'lib')
$: << File.join(File.dirname(__FILE__))

require 'rspec'

require 'ftest'

require 'coveralls'
Coveralls.wear!

RSpec.configure do |config|
	config.order = "random"
	config.color_enabled = true
end
