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
      sudo 'update-rc.d', '-f', sidekiq_service, 'defaults'
    end
  end
  before :setup_initializer, :capistrano_config_test

  desc 'Setup Sidekiq'
  task :setup do
    if fetch(:use_sidekiq)
      invoke 'sidekiq:setup_initializer'
    end
  end

  desc 'Start sidekiq'
  task :start do
    on roles(:app) do
      sudo sidekiq_initd_file, 'start'
    end
  end
  before :start, :capistrano_config_test

  desc 'Stop sidekiq'
  task :stop do
    on roles(:app) do
      sudo sidekiq_initd_file, 'stop'
      sleep 8
    end
  end
  before :stop, :capistrano_config_test

  desc 'Restart sidekiq'
  task :restart do
    invoke 'sidekiq:stop'
    invoke 'sidekiq:start'
  end
  before :restart, :capistrano_config_test

  desc 'Restarts sidekiq if sidekiq enabled'
  task :after_publishing do
    if fetch :use_sidekiq
      invoke 'sidekiq:restart'
    end
  end

end

namespace :deploy do
  after :publishing, 'sidekiq:after_publishing'
end

desc 'Server setup tasks'
task :setup do
  invoke 'sidekiq:setup'
end
