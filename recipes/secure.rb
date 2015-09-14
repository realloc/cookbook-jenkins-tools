#
# Cookbook Name:: jenkins-tools
# Recipe:: secure

# Adds user `admin` and adjusts security settings
# Idea taken from:
# http://pghalliday.com/jenkins/groovy/sonar/chef/configuration/management/2014/09/21/some-useful-jenkins-groovy-scripts.html

# Generate private key or take it from vault
# Save it to file. maybe.
# Write it to run_state

ruby_block 'set jenkins private key' do
  block do
    if ( ::File.exists?('/var/lib/jenkins/chef.secret') && ::File.exists?('/var/lib/jenkins/chef.secret.pub') )
      private_key = IO.read('/var/lib/jenkins/chef.secret')
      public_key = IO.read('/var/lib/jenkins/chef.secret.pub')
      node.run_state[:jenkins_private_key] = private_key
      node.run_state[:jenkins_public_key] = public_key
    else
      require 'openssl'
      require 'net/ssh'
      key = OpenSSL::PKey::RSA.new(2048)
      private_key = key.to_pem
      public_key = "#{key.ssh_type} #{[key.to_blob].pack('m0')}"
      File.write('/var/lib/jenkins/chef.secret', private_key)
      File.write('/var/lib/jenkins/chef.secret.pub', public_key)
    end
  end
end

jenkins_user 'admin' do
 public_keys lazy {[ node.run_state[:jenkins_public_key] ]}
 password 'q1w2e3r4'
 full_name 'Jenkins Administrator'
end

# Configure the permissions so that login is required and the admin user is an administrator
# after this point the private key will be required to execute jenkins scripts (including querying
# if users exist) so we notify the `set the security_enabled flag` resource to set this up.
# Also note that since Jenkins 1.556 the private key cannot be used until after the admin user
# has been added to the security realm
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
