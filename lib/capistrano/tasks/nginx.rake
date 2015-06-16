require 'capistrano/dsl/nginx_paths'
include Capistrano::DSL::NginxPaths

namespace :nginx do

  desc 'Test capistrano config setup'
  task :capistrano_config_test do
    if (fetch(:use_puma) && fetch(:use_unicorn)) || (!fetch(:use_puma) && !fetch(:use_unicorn))
      raise 'Use puma or unicorn'
    end
    raise 'Set server_domain variable to setup nginx' unless fetch(:server_domain)
  end

  desc 'Setup nginx configuration'
  task :setup do
    on roles :web do
      sudo_upload! template('nginx.conf'), nginx_sites_available_file
      sudo :ln, '-fs', nginx_sites_available_file, nginx_sites_enabled_file
    end
  end
  before :setup, :capistrano_config_test

  desc 'Start nginx'
  task :start do
    on roles :web do
      execute nginx_initd_file, 'start'
    end
  end

  desc 'Stop nginx'
  task :stop do
    on roles :web do
      execute nginx_initd_file, 'stop'
      sleep 3
    end
  end

  desc 'Restart nginx'
  task :restart do
    on roles :web do
      sudo nginx_initd_file, 'restart'
    end
  end

  desc 'Reload nginx'
  task :reload do
    on roles :web do
      sudo nginx_initd_file, 'reload'
    end
  end

end

namespace :deploy do
  after :publishing, 'nginx:reload'
end

desc 'Server setup tasks'
task :setup do
  invoke 'nginx:setup'
end
