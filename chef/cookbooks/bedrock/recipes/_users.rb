# ________________________________________

# This recipe manages user accounts. It assumes accounts are defined
# as node attributes within the following structure (expressed as YAML
# for brevity). "(value)" indicates a default value and a "?"
# indicates optionality:
#
# bedrock:
#   users:
#     <user_name>:
#       action: <action symbol> ? (:create)
#       home: <home directory path> ? (/home/<user name>)
#       directories: ?
#         <directory path>:
#           action: <action symbol> ? (:create)
#           mode: <mode> ? (0755)
#           owner: <user name or ID> ? (<user name>)
#           group: <group name or ID> ? (<user name>)
#         <...> ?
#       files: ?
#         <file path>:
#           action: <action symbol> ? (:create)
#           mode: <mode> ? (0644)
#           owner: <user name or ID> ? (<user name>)
#           group: <group name or ID> ? (<user name>)
#           source: <path to source beneath "files/default">
#         <...>

# Iterate over the list of defined users

node.fetch('bedrock', {}).fetch('users', {})
  .each do |user_name, user_spec|

  # Manage the user account's core characteristics

  user user_name do
    action user_spec.fetch('action', :create)
    home   user_spec.fetch('home', File.join('/home', user_name))
  end

  # Manage additional directories

  user_spec.fetch('directories', {}).each do |dir_path, dir_spec|
    directory dir_path do
      action dir_spec.fetch('action', :create)
      group  dir_spec.fetch('group', user_name)
      mode   dir_spec.fetch('mode', '0755')
      owner  dir_spec.fetch('owner', user_name)
    end
  end

  # Manage additional files

  user_spec.fetch('files', {}).each do |file_path, file_spec|
    cookbook_file file_path do
      action file_spec.fetch('action', :create)
      group  file_spec.fetch('group', user_name)
      mode   file_spec.fetch('mode', '0444')
      owner  file_spec.fetch('owner', user_name)
      source file_spec.fetch('source', file_path.gsub(%r(^/), ''))
    end
  end
end
