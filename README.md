## gitolite-cookbook
## Description
Install [Gitolite](http://gitolite.com) ( git server ) and manage ssh keys and repository permissions
Gitolite docs: http://gitolite.com/gitolite/gitolite.html
## Supported Platforms

Debian 6.0.10
## Status
This cookbook is experimental, without full test coverage: don't use in production.

## Attributes
Those attributes will be used for the installation and later for the repository management: note that the use of the LWRP on custom install is currently not supported)

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['gitolite']['user']</tt></td>
    <td>string</td>
    <td>this user will install and admin Gitolite</td>
    <td><tt>'git'</tt></td>
  </tr>
  <tr>
    <td><tt>['gitolite']['group']</tt></td>
    <td>string</td>
    <td>group for the gitolite user</td>
    <td><tt>'git'</tt></td>
  </tr>
  <tr>
    <td><tt>['gitolite']['home']</tt></td>
    <td>string</td>
    <td>path where place repositories, install folder, configs and admin repository </td>
    <td><tt>'/home/git'</tt></td>
  </tr>
  </table>

## Usage

### Recipe gitoolite::install

Include `gitolite` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[gitolite::default]"
  ]
}
```
this will execute following steps (description follow default attributes, adjust if you overrides its):

- create user and group git
- install gitolite on /home/git/server
- setup a repository gitolite-admin for the user admin

### LWPR GitoliteRepository 
simple include gitolite_repository on your recipe:
```ruby
gitolite_repository "my_awesome_repo" do
  # key_name is the unique identifier of the key/user on the Gitolite server
  key_name "vagrant_id_rsa"  
  # define the key with key_path or key_string
  key_path "/home/vagrant/.ssh/id_rsa.pub"
  #or 	
  key_string "long_string_of_a_rsa_key"
  # set the permission (see Gitolite docs http://gitolite.com/gitolite/gitolite.html#permsum)
  # set to nil if you want to revoke all permissions
  permission 'RW'  

end
```
## Dependencies 
depends on **sshenv** https://github.com/sekipaolo/sshenv

## License and Authors

Author:: Paolo Sechi (<sekipaolo@gmail.com>)
