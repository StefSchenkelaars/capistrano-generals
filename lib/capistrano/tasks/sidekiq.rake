require 'capistrano/dsl/sidekiq_paths'
include Capistrano::DSL::SidekiqPaths

namespace :sidekiq do

  desc 'Test capistrano config setup'
  task :capistrano_config_test do
    raise 'Sidekiq is not on, use_sidekiq is false' unless fetch(:use_sidekiq)
  end

  desc 'Setup Sidekiq initializer'
  task :setup_initializer do
    on roles :app do
      sudo_upload! template('sidekiq_init.sh'), sidekiq_initd_file
      execute :chmod, '+x', sidekiq_initd_file
      sudo 'update-rc.d', '-f', unicorn_service, 'defaults'
    end
  end
  before :setup_initializer, :capistrano_config_test

  desc 'Start sidekiq'
  task :start do
    on roles(:app) do
      execute "sudo /etc/init.d/sidekiq_#{fetch(:application)}_#{fetch(:stage)} start"
    end
  end

  desc 'Stop sidekiq'
  task :stop do
    on roles(:app) do
      execute "sudo /etc/init.d/sidekiq_#{fetch(:application)}_#{fetch(:stage)} stop"
      sleep 8
    end
  end

  desc 'Restart sidekiq'
  task :restart do
    invoke 'sidekiq:stop'
    invoke 'sidekiq:start'
  end

end

namespace :deploy do
  if fetch(:use_sidekiq)
    after :publishing, 'sidekiq:restart'
  end
end

desc 'Server setup tasks'
task :setup do
  if fetch(:use_sidekiq)
    invoke 'unicorn:setup_initializer'
  end
end
