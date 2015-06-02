require 'serverspec'

describe file("/etc/rc.conf") do
  its(:content) { should match /test_option="test_value"/ }
end
