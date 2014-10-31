#
# Cookbook Name:: jenkins-tools
# Recipe:: plugins

# Flag set to true if plugin is installed or updated and jenkins will be restarted.
# Pattern from https://tickets.opscode.com/browse/CHEF-2452
restart_required = false

node['jenkins']['server']['plugins'].each do |plugin|
  if plugin.is_a?(Hash)
    name = plugin['name']
    version = plugin['version'] if plugin['version']
    url = plugin['url'] if plugin['url']
  else
    name = plugin
  end

  jenkins_plugin name do
    action  :install
    version version if version
    url     url if url
     notifies :create, "ruby_block[jenkins_restart_flag]", :immediately
  end
end

# Is notified only when a 'jenkins_plugin' is installed or updated.
ruby_block "jenkins_restart_flag" do
  block do
    restart_required = true
  end
  action :nothing
end

jenkins_command 'restart' do
  only_if { restart_required }
end
