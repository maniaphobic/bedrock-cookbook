require 'spec_helper.rb'

describe file('/etc/sudoers') do
  its(:content) { should match /^%wheel.+NOPASSWD/ }
end
