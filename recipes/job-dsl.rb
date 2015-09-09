#
# Cookbook Name:: jenkins-tools
# Recipe:: job-dsl

# Create DSL seed job

seed_job_xml = File.join(
  Chef::Config[:file_cache_path],
  node['jenkins-tools']['job-dsl']['seed_job_file']
)

template seed_job_xml do
  source 'seed-job.xml.erb'
  variables(
    {
      :repo => node['jenkins-tools']['job-dsl']['repo'],
      :branch => node['jenkins-tools']['job-dsl']['branch'],
      :targets => node['jenkins-tools']['job-dsl']['targets']
    }
  )
end

jenkins_job 'Job DSL seed' do
  config seed_job_xml
end
