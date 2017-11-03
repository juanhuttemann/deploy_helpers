require 'net/ssh'
module Deployer
  def ssh_conexion(host, username, password)
    @password = password
    @conexion = Net::SSH.start(host, username, password: password)
  end

  def repo_url(repo)
    @repo = repo
    @repo_dir = repo.split('/')[1].split('.')[0]
  end

  def cloned?
    @conexion.exec! 'ls' do |_ch, _stream, data|
      if data.include?(@repo_dir)
        return true
      else
        return false
      end
    end
  end

  def run(cmd, directory = @repo_dir)
    puts "*** Running: #{cmd}"
    puts @conexion.exec! "cd #{directory};#{cmd}"
  end

  def git_clone
    run "git clone #{@repo}", ''
  end

  def git_pull
    run 'git pull'
  end

  def bundle
    run 'bundle install'
  end

  def assets
    run 'rails assets:precompile RAILS_ENV=production'
  end

  def db_password_set(db_password)
    run "sed -i -e '/password:/,+1 d' config/database.yml"
    run "sed -i -e '/\ username/a\\  password: #{db_password}' config/database.yml"
  end

  def secrets(directory = @repo_dir)
    @conexion.exec! "cd #{directory};rails secret" do |_ch, _stream, data|
      @secrets = data
    end
    run "sed -i -e '/secret_key_base:/,+1 d' config/secrets.yml"
    run "sed -i -e '/\production:/a\\  secret_key_base: #{@secrets}' config/secrets.yml"
  end

  def create
    run 'rails db:create RAILS_ENV=production'
  end

  def migrate
    run 'rails db:migrate RAILS_ENV=production'
  end

  def restart_nginx
    run "echo #{@password} | sudo -S service nginx restart"
  end

  def deploy_basics
    bundle
    create
    migrate
    assets
    restart_nginx
  end
end
