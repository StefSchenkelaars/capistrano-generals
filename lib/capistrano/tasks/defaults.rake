namespace :load do
  task :defaults do
    # Application runner
    set :use_puma, false
    set :use_unicorn, false
    set :use_sidekiq, false

    # Application settings
    set :app_config_name, -> { "#{fetch(:application)}_#{fetch(:stage)}" }
    set :server_domain, -> { fetch(:server_domain) }

    # General Nginx settings
    set :nginx_location, '/etc/nginx'
    set :nginx_redirect_www, true
    set :nginx_fail_timeout, 0

    # SSL Settings
    set :nginx_use_ssl, false
    set :nginx_ssl_stapling, true
    set :nginx_ssl_ciphers, 'AES128+EECDH:AES128+EDH:!aNULL'
    set :nginx_ssl_protocols, 'TLSv1 TLSv1.1 TLSv1.2'
    set :nginx_ssl_session_cache, 'shared:SSL:10m'
    set :nginx_ssl_cert, -> { "#{fetch(:server_domain)}.crt" }
    set :nginx_ssl_cert_key, -> { "#{fetch(:server_domain)}.key" }
    set :nginx_ssl_dhparam, 'dhparam.pem'
    set :nginx_server_ciphers, false
    set :nginx_server_ciphers_path, '/etc/ssl/certs/dhparam.pem'

    # General Unicorn settings
    set :unicorn_pid, -> { unicorn_default_pid_file } # shared_path/tmp/pids/unicorn.pid
    set :unicorn_config, -> { unicorn_default_config_file } # shared_path/config/unicorn.rb
    set :unicorn_workers, 2
    set :unicorn_worker_timeout, 30
    set :unicorn_log, 'unicorn.stdout.log'
    set :unicorn_error_log, 'unicorn.stderr.log'
    set :unicorn_user, -> { fetch(:deploy_user) }
    set :unicorn_env, ''
    set :unicorn_app_env, -> { fetch(:rails_env) || fetch(:rack_env) || fetch(:stage) }

    # General Sidekiq settings
    set :sidekiq_workers, 3
    set :sidekiq_user, -> { fetch(:deploy_user) }
    set :sidekiq_pid, -> { sidekiq_default_pid_file }
    set :sidekiq_log, 'sidekiq.log'

    # Capistrano settings
    set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids')
    set :templates_path, 'config/deploy/templates'
  end
end
