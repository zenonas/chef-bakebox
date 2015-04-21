default[:bakebox][:app] = {
  name: '',
  domain: '',
  ssl: {
    cert: '',
    key: ''
  },
  config_files: [],
  dir: '/opt',
  ruby: '2.2.2',
  gems: ['bundler'],
  upgrade: true,
  deployers: {}
}

default[:bakebox][:nginx] = {
  version: '1.6.3',
  location: '/opt/nginx'
}

## DO NOT TOUCH/OVERWRITE THE FOLLOWING ATTRIBUTES OR SHOUTY THINGS HAPPEN
default[:rbenv][:user]           = node[:bakebox][:app][:name]
default[:rbenv][:group]          = node[:bakebox][:app][:name]
default[:rbenv][:install_prefix] = File.join(node[:bakebox][:app][:dir], node[:bakebox][:app][:name])
default[:rbenv][:user_home]      = File.join(node[:bakebox][:app][:dir], node[:bakebox][:app][:name])
default[:rbenv][:root_path]      = "#{node[:rbenv][:install_prefix]}/.rbenv"
default[:nginx][:dir]            = node[:bakebox][:nginx][:location]
default[:nginx][:log_dir]        = File.join(node[:bakebox][:nginx][:location], 'log')
default[:nginx][:version]        = node[:bakebox][:nginx][:version]
