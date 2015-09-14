#
# Cookbook Name:: jenkins-tools
# Recipe:: users

node['jenkins']['server']['users'].each do |user|
  if user.is_a?(Hash)
    name = user['username']
    full_name = user['full_name'] if user['full_name']
    email = user['email'] if user['email']
    password = user['password'] if user['password']
    public_keys = user['public_keys'] if user['public_keys']
  else
    name = user
  end

  jenkins_user name do
    full_name full_name if full_name
    email email if email
    password password if password
    public_keys public_keys if public_keys
  end
end
