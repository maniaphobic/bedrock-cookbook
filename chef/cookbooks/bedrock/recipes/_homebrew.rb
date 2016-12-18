# coding: utf-8
# ________________________________________
# Configure Homebrew on Darwin hosts

# Import the Homebrew module

Chef::Recipe.include(Bedrock::Homebrew)

# Extract Homebrew attributes for convenience

homebrew_attrs = node.fetch('bedrock', {}).fetch('homebrew', {})

# Verify the Xcode Command Line Tools package is available

if xcode_clt_installed?
  Chef::Log.info('✓  Xcode Command Line Tools already installed')
else
  Chef::Log.fatal(
    ['Please install Xcode Command Line Tools first.',
     'Run "xcode-select --install" and follow the prompts.'].join(' ')
  )
end

# Install Homebrew

bash 'install_homebrew' do
  cwd '/tmp'
  code <<-INSTALL
    /usr/bin/ruby -e "$(curl -fsSL #{homebrew_attrs['source_url']})"
  INSTALL
  not_if { File.exist?('/usr/local/bin/brew') }
end

# Process Homebrew attributes

homebrew_attrs.each do |key, value|
  case key
  when 'casks'
    # Process casks
    value.each do |cask_name, cask_attrs|
      bash 'process_casks' do
        cwd '/tmp'
        code <<-ACTION
          brew cask #{cask_attrs.fetch('action', 'install')} #{cask_name}
        ACTION
      end
    end
  end
end

# Upgrade all packages

bash 'upgrade_all_packages' do
  cwd '/tmp'
  code <<-UPGRADE
    set -ex
    brew update
    brew upgrade --all
  UPGRADE
end
