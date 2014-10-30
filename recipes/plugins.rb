#
# Cookbook Name:: jenkins-tools
# Recipe:: plugins

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
