# ________________________________________
# Description: Manage the Chef client configuration
# Notes:
#
#   - We need to migrate what we can from here to the community's
#     "chef-client" cookbook

# Extract the Chef parameters for convenience

chef_attrs = node.fetch('bedrock', {}).fetch('chef', {})

# Take no action if the Chef attributes are empty

return if chef_attrs.empty?

# Create Chef's directories

%w(/etc/chef /var/log/chef).each do |path|
  directory path do
    action :create
  end
end

# Create chef-client's config file

client_name = Socket.gethostname

template '/etc/chef/client.rb' do
  action :create
  source 'etc/chef/client.rb.erb'
  variables(
    'client_key'      => '/etc/chef/client.pem',
    'node_name'       => client_name,
    'server_url'      => chef_attrs.fetch('server_url', 'http://localhost/'),
    'ssl_verify_mode' => ':verify_none'
  )
end

# Install the encrypted data bag secret file

data_secret = chef_attrs.fetch('encrypted_data_secret', {})
cookbook_file data_secret['path'] do
  mode '0600'
  sensitive true
  source data_secret['source']
end unless data_secret.fetch('path', nil).nil?

# Extract the validator parameters for convenience

validator      = chef_attrs.fetch('validator', {})
validator_name = validator.fetch('name', 'chef-validator')
validator_path = validator.fetch('path', '/etc/chef/validator.pem')

# Install the validator key

cookbook_file validator_path do
  mode '0600'
  sensitive true
  source validator['source']
end

# Register the client

bash 'register-chef-client' do
  code <<-SCRIPT
knife client create #{client_name} \
  --config /etc/chef/client.rb \
  --disable-editing \
  --file /etc/chef/client.pem \
  --key #{validator_path} \
  --user #{validator_name}
rm -f  #{validator_path}
  SCRIPT
  not_if { ::File.exists?('/etc/chef/client.pem') }
end

file '/etc/chef/client.pem' do
  mode   '0600'
end
