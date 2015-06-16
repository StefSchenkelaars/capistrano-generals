require 'capistrano/dsl/nginx_paths'
include Capistrano::DSL::NginxPaths

namespace :load do
  task :defaults do
    # Application runner
    set :use_puma, false
    set :use_unicorn, false

    # General Nginx settings
    set :server_domain, -> { fetch(:server_domain) }
    set :nginx_config_name, -> { "#{fetch(:application)}_#{fetch(:stage)}" }
    set :nginx_location, '/etc/nginx'
    set :nginx_redirect_www, true
    set :nginx_fail_timeout, 0

    # SSL Settings
    set :nginx_use_ssl, false
    set :nginx_ssl_stapling, true
    set :nginx_ssl_ciphers, 'AES128+EECDH:AES128+EDH:!aNULL'
    set :nginx_ssl_protocols, 'TLSv1 TLSv1.1 TLSv1.2'
    set :nginx_ssl_session_cache, 'shared:SSL:10m'
    set :nginx_ssl_cert, -> { nginx_default_ssl_cert_file_name }
    set :nginx_ssl_cert_key, -> { nginx_default_ssl_cert_key_file_name }
    set :nginx_ssl_dhparam, -> { nginx_default_ssl_dhparam_file_name }
    set :nginx_server_ciphers, false
    set :nginx_server_ciphers_path, '/etc/ssl/certs/dhparam.pem'
  end
end

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
      execute 'sudo /etc/init.d/nginx start'
    end
  end

  desc 'Stop nginx'
  task :stop do
    on roles :web do
      execute 'sudo /etc/init.d/nginx stop'
      sleep 3
    end
  end

  desc 'Restart nginx'
  task :restart do
    on roles :web do
      execute 'sudo /etc/init.d/nginx restart'
    end
  end

end
