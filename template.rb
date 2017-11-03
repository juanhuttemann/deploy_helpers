require './lib/deployer'
include Deployer

host = 'my_ip_address'
username = 'my_username'
password = 'my_password'
db_password = 'my_db_password'
ssh_conexion(host, username, password)
repo_url 'git@gitlab.com:name/repo.git'
