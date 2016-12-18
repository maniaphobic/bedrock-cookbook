# ________________________________________
# Manage packages for this operating system

# Configure the package system
# Install required packages

Chef::Log.info()

case node['platform_family']
when 'mac_os_x'
  include_recipe('bedrock::_homebrew')
when 'rhel'
  include_recipe('bedrock::_yum')
end

node
  .fetch('bedrock', {})
  .fetch('packages', []).each do |package_name|
  package package_name
end
