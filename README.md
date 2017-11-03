# Rails SSH Deployment Helper

# Tired of Capistrano? just copy this shit...

### Basic Settings

``` ruby
require './lib/deployer'
include Deployer

host = 'my_ip_address'
username = 'my_username'
password = 'my_password'
db_password = 'my_db_password'
ssh_conexion(host, username, password)
repo_url 'git@gitlab.com:name/repo.git'
```

Available Tasks :
```ruby
cloned?
```
checks if repo directory exists and returns a boolean

```ruby
git_clone
```
clones repo


```ruby
git_pull
```
pulls repo


```ruby
create
```
run rails db:create


```ruby
migrate
```
run rails db:migrate


```ruby
secrets
```
set db password in secrets.yml


```ruby
assets
```
run rails assets:precompile

```ruby
db_password_set(db_password)
```
set db password in database.yml


### Example
``` ruby
require './lib/deployer'
include Deployer

host = 'my_ip_address'
username = 'my_username'
password = 'my_password'
db_password = 'my_db_password'
ssh_conexion(host, username, password)
repo_url 'git@gitlab.com:name/repo.git'

if cloned?
  git_pull
else
  git_clone
  secrets
  db_password_set(db_password)
end

deploy_basics

```
