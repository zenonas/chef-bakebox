include_recipe "rbenv::ruby_build"
include_recipe "rbenv::system"

rbenv_gem 'passenger' do
  action :upgrade
end

rbenv_script "passenger-install-nginx-module" do
  rbenv_version node[:rbenv_passenger][:ruby_version]
  code <<-BASH
    passenger-install-nginx-module --auto
  BASH
end
