# jenkins-tools cookbook

Collection of useful wrapper around Chef's
[jenkins cookbook](https://supermarket.chef.io/cookbooks/jenkins) resources.


## Requirements

- Chef 11 or higher
- **Ruby 1.9.3 or higher**

## Recipes


### plugins

Wrapper for `jenkins_plugin` resource. Installs plugins form `node['jenkins']['server']['plugins']` and restarts Jenkins if needed.
Useful when you want to ping specific plugin versions.

#### Example

```json
'jenkins' => {
    'master' => {
      'install_method' => 'package',
      'version' => '1.628-1.1',
    },
    'server' => {
      'plugins' => [
        { 'name' => 'git',
          'version' => '2.4.0'
        },
        { 'name' => 'chucknorris',
          'version' => '0.5'
        },
```

### users

Wrapper for `jenkins_user` resource. Creates users from `node['jenkins']['server']['users']`. If you don't set password, it will not be changed on each chef run.

#### Example

```json
  "jenkins" => {
    "server" => {
      "users" => [
        { 'username' => 'realloc',
          'full_name' => 'Stanislav Bogatyrev',
          'email' => 'realloc@realloc.spb.ru'
        },
```

### credentials

Trivial wrapper for `jenkins_private_key_credentials`. Other types will be supported later.

Make sure you don't expose private keys in clear text in roles! Use chef-vault with att-vault or any other means to encrypt sensitive data.

#### Example

```json
  "jenkins" => {
    "server" => {
    "credentials_key" => [
        { 'name' => 'jenkins_vagrant_unsafe',
          'id' => '666aab48-dead-4eef-b1e2-1d89d86f4458',
          'description' => 'UNSAFE test key',
          'private_key' =>
          "-----BEGIN RSA PRIVATE KEY-----\n...-----END RSA PRIVATE KEY-----"
        }
```

### secure

Adds `admin` user with `ADMINISTER` privileges. It generates key pair for it and uses to further configuration.

### job-dsl

Adds a seed-job that will checkout git-repo, process files filtered by mask and creates jobs described with [job-dsl](https://github.com/jenkinsci/job-dsl-plugin).

# Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `feature/add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

# License & Authors

- Author:: Stanislav Bogatyrev (realloc@realloc.spb.ru)

```text
Copyright:: 2015, Stanislav Bogatyrev

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
