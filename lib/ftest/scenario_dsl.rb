module ::FTest::ScenarioDSL
end

require 'ftest/assertion_dsl'
require 'ftest/fuzz_dsl'
require 'ftest/binary_dsl'

module ::FTest::ScenarioDSL
	include ::FTest::ScenarioDSL::AssertionDSL
	include ::FTest::ScenarioDSL::FuzzDSL
	include ::FTest::ScenarioDSL::BinaryDSL
end
