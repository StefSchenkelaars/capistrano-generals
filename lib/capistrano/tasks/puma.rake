require 'capistrano/dsl/puma_paths'
include Capistrano::DSL::PumaPaths

namespace :puma do

  desc 'Test capistrano config setup'
  task :capistrano_config_test do
    raise 'Use puma is not set as the application runner' unless fetch(:use_puma)
    raise 'Unicorn is also set as application runner' if fetch(:use_unicorn)
    raise 'Set the puma_user, which is default the deploy_user' unless fetch(:puma_user)
    raise 'Set server_domain variable to setup nginx' unless fetch(:server_domain)
  end

  desc 'Setup Puma initializer'
  task :setup_initializer do
    on roles :app do
      sudo_upload! template('puma_init.sh'), puma_initd_file
      execute :chmod, '+x', puma_initd_file
      sudo 'update-rc.d', '-f', puma_service, 'defaults 50 50'
    end
  end
  before :setup_initializer, :capistrano_config_test

  desc 'Setup puma app configuration'
  task :setup_app_config do
    on roles :app do
      execute :mkdir, '-pv', File.dirname(fetch(:puma_config).to_s)
      upload! template('puma.rb'), fetch(:puma_config).to_s
    end
  end
  before :setup_app_config, :capistrano_config_test

  desc 'Setup puma'
  task :setup do
    if fetch :use_puma
      invoke 'puma:setup_initializer'
      invoke 'puma:setup_app_config'
    end
  end

  desc 'Start puma'
  task :start do
    on roles :app do
      sudo puma_initd_file, 'start'
    end
  end
  before :start, :capistrano_config_test

  desc 'Stop puma'
  task :stop do
    on roles :app do
      execute puma_initd_file, 'stop'
      sleep 3
    end
  end
  before :stop, :capistrano_config_test

  desc 'Restart puma'
  task :restart do
    invoke 'puma:stop'
    invoke 'puma:start'
  end
  before :restart, :capistrano_config_test

  desc 'Restarts puma if puma enabled'
  task :after_publishing do
    if fetch :use_puma
      invoke 'puma:restart'
    end
  end

end

namespace :deploy do
  after :publishing, 'puma:after_publishing'
end

desc 'Server setup tasks'
task :setup do
  invoke 'puma:setup'
end
