#
# Cookbook Name:: jenkins-tools
# Recipe:: secure

# Adds user `admin` and adjusts security settings
# Idea taken from:
# http://pghalliday.com/jenkins/groovy/sonar/chef/configuration/management/2014/09/21/some-useful-jenkins-groovy-scripts.html

ruby_block 'set jenkins private key' do
  block do
    if ( ::File.exists?("#{node['jenkins']['security']['chef_key_path']}/chef.secret") &&
         ::File.exists?("#{node['jenkins']['security']['chef_key_path']}/chef.secret.pub") )
      private_key = IO.read("#{node['jenkins']['security']['chef_key_path']}/chef.secret")
      public_key = IO.read("#{node['jenkins']['security']['chef_key_path']}/chef.secret.pub")
      node.run_state[:jenkins_private_key] = private_key
      node.run_state[:jenkins_public_key] = public_key
    else
      require 'openssl'
      require 'net/ssh'
      key = OpenSSL::PKey::RSA.new(1024)
      private_key = key.to_pem
      public_key = "#{key.ssh_type} #{[key.to_blob].pack('m0')}"
      File.write("#{node['jenkins']['security']['chef_key_path']}/chef.secret", private_key)
      File.write("#{node['jenkins']['security']['chef_key_path']}/chef.secret.pub", public_key)
      node.run_state[:jenkins_private_key] = private_key
      node.run_state[:jenkins_public_key] = public_key
    end
  end
end

jenkins_user 'admin' do
 public_keys lazy {[ node.run_state[:jenkins_public_key] ]}
 password node['jenkins']['security']['admin_passwd']
 full_name 'Jenkins Administrator'
end

jenkins_script 'configure permissions' do
  command <<-EOH.gsub(/^ {4}/, '')
    import jenkins.model.*
    import hudson.security.*
    def instance = Jenkins.getInstance()
    def hudsonRealm = new HudsonPrivateSecurityRealm(false)
    instance.setSecurityRealm(hudsonRealm)
    def strategy = new GlobalMatrixAuthorizationStrategy()
    strategy.add(Jenkins.ADMINISTER, "admin")
    instance.setAuthorizationStrategy(strategy)
    instance.save()
  EOH
  action :execute
end
