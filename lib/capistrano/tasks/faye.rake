require 'capistrano/dsl/faye_paths'
include Capistrano::DSL::FayePaths

namespace :faye do

  desc 'Test capistrano config setup'
  task :capistrano_config_test do
    raise 'Faye is not on, use_faye is false' unless fetch(:use_faye)
  end

  desc 'Setup faye initializer'
  task :setup_initializer do
    on roles :app do
      sudo_upload! template('faye_init.sh'), faye_initd_file
      execute :chmod, '+x', faye_initd_file
      sudo 'update-rc.d', '-f', faye_service, 'defaults'
    end
  end
  before :setup_initializer, :capistrano_config_test

  desc 'Setup faye app configuration'
  task :setup_app_config do
    on roles :app do
      execute :mkdir, '-pv', File.dirname(fetch(:faye_config).to_s)
      upload! template('faye.ru'), fetch(:faye_config).to_s
    end
  end
  before :setup_app_config, :capistrano_config_test

  desc 'Setup faye'
  task :setup do
    if fetch :use_faye
      invoke 'faye:setup_initializer'
    end
  end

  desc 'Start faye'
  task :start do
    on roles :app do
      sudo faye_initd_file, 'start'
    end
  end
  before :start, :capistrano_config_test

  desc 'Stop faye'
  task :stop do
    on roles :app do
      sudo faye_initd_file, 'stop'
      sleep 8
    end
  end
  before :stop, :capistrano_config_test

  desc 'Restart faye'
  task :restart do
    invoke 'faye:stop'
    invoke 'faye:start'
  end
  before :restart, :capistrano_config_test

  desc 'Restarts faye if faye enabled'
  task :after_publishing do
    if fetch :use_faye
      invoke 'faye:restart'
    end
  end

end

namespace :deploy do
  after :publishing, 'faye:after_publishing'
end

desc 'Server setup tasks'
task :setup do
  invoke 'faye:setup'
end
