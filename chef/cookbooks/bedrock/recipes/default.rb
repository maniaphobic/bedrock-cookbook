#
# Cookbook Name:: bedrock
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Invoke run list constituents:
#
#   - Manage OS packages and repositories
#   - Manage the sudo configuration
#   - Manage the sshd configuration
#   - Manage the Chef client configuration
#   - Manage user accounts

%w(
  bedrock::_packages
  sudo
  sshd
  bedrock::_chef
  bedrock::_users).each do |recipe_name|
  include_recipe(recipe_name)
end
