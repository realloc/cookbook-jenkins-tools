#
# Cookbook Name:: jenkins-tools
# Recipe:: job-dsl

# Create DSL seed job

seed_job_xml = File.join(
  Chef::Config[:file_cache_path],
  node['jenkins']['server']['job-dsl']['seed_job_file']
)

template seed_job_xml do
  source 'seed-job.xml.erb'
  variables(
    {
      :repo => node['jenkins']['server']['job-dsl']['repo'],
      :branch => node['jenkins']['server']['job-dsl']['branch'],
      :targets => node['jenkins']['server']['job-dsl']['targets'],
      :credsId => node['jenkins']['server']['job-dsl']['credsId']
    }
  )
end

jenkins_job 'Job DSL seed' do
  config seed_job_xml
end
