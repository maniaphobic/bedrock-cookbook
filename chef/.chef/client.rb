# Upload artifacts from the current directory
# Disable problematic Ohai plug-ins

chef_repo_path          = '.'
ohai[:disabled_plugins] = [:Passwd, 'passwd']
