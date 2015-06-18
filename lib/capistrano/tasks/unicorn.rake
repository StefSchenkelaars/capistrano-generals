require 'capistrano/dsl/unicorn_paths'
include Capistrano::DSL::UnicornPaths

namespace :unicorn do

  on :start do
    # Test capistrano config setup
    if fetch(:use_unicorn)
      # raise 'Use unicorn is not set as the application runner' unless fetch(:use_unicorn)
      raise 'Puma is also set as application runner' if fetch(:use_puma)
      raise 'Set the unicorn_user, which is default the deploy_user' unless fetch(:unicorn_user)
      raise 'Set server_domain variable to setup nginx' unless fetch(:server_domain)
    end
  end

  desc 'Setup Unicorn initializer'
  task :setup_initializer do
    on roles :app do
      sudo_upload! template('unicorn_init.sh'), unicorn_initd_file
      execute :chmod, '+x', unicorn_initd_file
      sudo 'update-rc.d', '-f', unicorn_service, 'defaults'
    end
  end

  desc 'Setup unicorn app configuration'
  task :setup_app_config do
    on roles :app do
      execute :mkdir, '-pv', File.dirname(fetch(:unicorn_config).to_s)
      upload! template('unicorn.rb'), fetch(:unicorn_config).to_s
    end
  end

  desc 'Start unicorn'
  task :start do
    on roles :app do
      sudo unicorn_initd_file, 'start'
    end
  end

  desc 'Stop unicorn'
  task :stop do
    on roles :app do
      execute unicorn_initd_file, 'stop'
      sleep 3
    end
  end

  desc 'Restart unicorn'
  task :restart do
    invoke 'unicorn:stop'
    invoke 'unicorn:start'
  end

end

namespace :deploy do
  if fetch(:use_unicorn)
    after :publishing, 'unicorn:restart'
  end
end

desc 'Server setup tasks'
task :setup do
  if fetch(:use_unicorn)
    invoke 'unicorn:setup_app_config'
    invoke 'unicorn:setup_initializer'
  end
end
