#
# Cookbook Name:: jenkins-tools
# Recipe:: credentials

node['jenkins']['server']['credentials_key'].each do |cred_key|
  jenkins_private_key_credentials cred_key['name'] do
    cred_key.map { |k, v| send(k, v) }
  end
end
