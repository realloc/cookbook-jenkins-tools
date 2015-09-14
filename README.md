# jenkins-tools cookbook

Collection of useful wrapper around Chef's
[jenkins cookbook](https://supermarket.chef.io/cookbooks/jenkins) resources.


## Requirements

- Chef 11 or higher
- **Ruby 1.9.3 or higher**

## Recipes


### plugins

Wrapper for `jenkins_plugin` resource. Installs plugins form
`node['jenkins']['server']['plugins']` and restarts Jenkins if needed.
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
