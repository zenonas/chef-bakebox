require 'securerandom'

app_directory = File.join(node[:bakebox][:app][:dir], node[:bakebox][:app][:name])

fail 'Please make sure you define a name for your application at default[:bakebox][:app][:name]' if node[:bakebox][:app][:name].empty?
fail 'Please make sure you define a domain for your application at default[:bakebox][:app][:domain]' if node[:bakebox][:app][:domain].empty?
fail 'Please make sure you add at least one deployer under default[:bakebox][:app][:deployers]' if node[:bakebox][:app][:deployers].empty?

directory node[:bakebox][:app][:dir] do
  owner 'root'
  group 'root'
  mode 0755
  recursive true
  action :create
end

user node[:bakebox][:app][:name] do
  supports manage_home: true
  system true
  home app_directory
  password SecureRandom.hex(16)
  shell '/bin/bash'
  action :create
end

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"

%w{shared shared/log shared/tmp shared/config shared/tmp/pids}.each do|dir|
  directory File.join(app_directory, dir) do
    owner node[:bakebox][:app][:name]
    group node[:bakebox][:app][:name]
    recursive true
    mode 0755
    action :create
  end
end

include_recipe "nginx"

rbenv_ruby node[:bakebox][:app][:ruby]

node[:bakebox][:app][:gems].each do |gem|
  rbenv_gem gem do
    ruby_version node[:bakebox][:app][:ruby]
    if node[:bakebox][:app][:upgrade]
      action :upgrade
    else
      action :install
    end
  end
end

directory File.join(app_directory, '.ssh') do
  owner node[:bakebox][:app][:name]
  group node[:bakebox][:app][:name]
  mode 0700
end

template File.join(app_directory, '.ssh', 'authorized_keys') do
  source "authorized_keys.erb"
  owner node[:bakebox][:app][:name]
  group node[:bakebox][:app][:name]
  mode 0600
end

if node[:bakebox][:app][:ssl][:cert].empty?
  template File.join(node[:bakebox][:nginx][:location], "sites-enabled/#{node[:bakebox][:app][:name]}") do
    source "nginx_conf.erb"
    owner 'root'
    group 'root'
    mode 0600
    notifies :reload, 'service[nginx]', :immediately
  end
else
  directory File.join(node[:bakebox][:nginx][:location], 'ssl') do
    owner 'root'
    group 'root'
    mode 0700
  end

  template File.join(node[:bakebox][:nginx][:location], "ssl/#{node[:bakebox][:app][:domain]}.crt") do
    source "cert.erb"
    owner 'root'
    group 'root'
    mode 0600
  end

  fail 'You need to supply the private key to the certificate' if node[:bakebox][:app][:ssl][:key].empty?
  template File.join(node[:bakebox][:nginx][:location], "ssl/#{node[:bakebox][:app][:domain]}.key") do
    source "key.erb"
    owner 'root'
    group 'root'
    mode 0600
  end

  template File.join(node[:bakebox][:nginx][:location], "sites-enabled/#{node[:bakebox][:app][:name]}") do
    source "nginx_conf_ssl.erb"
    owner 'root'
    group 'root'
    mode 0600
    notifies :reload, 'service[nginx]', :immediately
  end
end

template File.join(app_directory, %w{shared config puma.rb}) do
  source "puma.rb.erb"
  owner node[:bakebox][:app][:name]
  group node[:bakebox][:app][:name]
  mode 0644
end

template File.join('/etc/init.d/', node[:bakebox][:app][:name]) do
  source "init.d.erb"
  owner 'root'
  group 'root'
  mode 0755
end

template File.join('/etc/sudoers.d/', node[:bakebox][:app][:name]) do
  source "sudoers.erb"
  owner 'root'
  group 'root'
  mode 0400
end

node[:bakebox][:app][:config_files].each do |config|
  file File.join(app_directory, "shared/config/#{config[:name]}") do
    content config[:content]
    owner node[:bakebox][:app][:name]
    group node[:bakebox][:app][:name]
    mode 0644
  end
end

service node[:bakebox][:app][:name] do
  supports :start => true, :stop => true, :restart => true
  action   :enable
end
