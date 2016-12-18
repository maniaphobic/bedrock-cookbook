# ________________________________________
# Configure YUM repositories on CentOS hosts, ignoring the pre-defined
# repo. named "main"

# Include the "yum::default" recipe
# Iterate over the repository list, creating the well-formed entries

include_recipe('yum')

node.fetch('yum', {'null' => {}}).each do |repo_name, repo_spec|
  action  = repo_spec.fetch('action', 'create').to_sym
  baseurl = repo_spec.fetch('baseurl', nil)
  if action == :create && baseurl.nil?
    Chef::Log.warn(
      ["Ignoring YUM repo. '#{repo_name}' because",
       'action == :create and baseurl == nil'].join(' ')
    )
    next
  end

  yum_repository repo_name do
    action      repo_spec.fetch('action', 'create').to_sym
    baseurl     baseurl
    description repo_spec.fetch('description', 'YUM Repository')
    enabled     repo_spec.fetch('enabled', true)
    gpgcheck    repo_spec.fetch('gpgcheck', false)
  end
end

# Upgrade all packages

bash 'upgrade_all_packages' do
  cwd '/tmp'
  code <<-UPGRADE
    set -x
    yum upgrade --assumeyes
  UPGRADE
end
