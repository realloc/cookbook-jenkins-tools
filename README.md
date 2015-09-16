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

Adds a seed-job that will checkout git-repo and create jobs described with job-dsl.
