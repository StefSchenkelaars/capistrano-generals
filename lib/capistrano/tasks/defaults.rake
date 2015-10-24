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
    set :nginx_x_frame_options, 'DENY'
    set :ngingx_strict_transport_security, false
    set :nginx_respond_to_subdomains, false
    set :nginx_resolver, '8.8.4.4 8.8.8.8 valid=300s'
    set :nginx_resolver_timeout, '10s'
    set :nginx_custom_block, ''

    # Nginx ssl settings
    set :nginx_use_ssl, false
    set :nginx_ssl_stapling, true
    set :nginx_ssl_ciphers, 'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH'
    set :nginx_ssl_protocols, 'TLSv1 TLSv1.1 TLSv1.2'
    set :nginx_ssl_session_cache, 'shared:SSL:10m'

    # Nginx caching settings
    set :cache_static_files, true
    set :cache_custom, ''
    set :cache_custom_expire, 'max'

    # SSL Settings
    set :local_certs_folder, 'config/deploy/certs'
    set :remote_certs_folder, '/etc/ssl'
    set :ssl_csr, -> { "#{fetch(:server_domain)}.csr" }
    set :ssl_cert, -> { "#{fetch(:server_domain)}.crt" }
    set :ssl_cert_intermediate, -> { "#{fetch(:server_domain)}-intermediate.crt" }
    set :ssl_cert_chain, -> { "#{fetch(:server_domain)}-chained.crt" }
    set :ssl_cert_key, -> { "#{fetch(:server_domain)}.key" }
    set :ssl_server_ciphers, false
    set :ssl_dhparam, 'dhparam.pem'

    # General Unicorn settings
    set :unicorn_pid, -> { unicorn_default_pid_file } # shared_path/tmp/pids/unicorn.pid
    set :unicorn_config, -> { unicorn_default_config_file } # shared_path/config/unicorn.rb
    set :unicorn_workers, 2
    set :unicorn_worker_timeout, 30
    set :unicorn_log, 'unicorn.log'
    set :unicorn_error_log, 'unicorn.log'
    set :unicorn_user, -> { fetch(:deploy_user) }
    set :unicorn_env, ''
    set :unicorn_app_env, -> { fetch(:rails_env) || fetch(:rack_env) || fetch(:stage) }

    # General Puma settings
    set :puma_preload_app, true
    set :puma_pid, -> { puma_default_pid_file } # shared_path/tmp/pids/puma.pid
    set :puma_config, -> { puma_default_config_file } # shared_path/config/puma.rb
    set :puma_log, 'puma.log'
    set :puma_error_log, 'puma.log'
    set :puma_workers, 2
    set :puma_worker_timeout, 30
    set :puma_min_threads, 0
    set :puma_max_threads, 16
    set :puma_user, -> { fetch(:deploy_user) }
    set :puma_env, ''
    set :puma_app_env, -> { fetch(:rails_env) || fetch(:rack_env) || fetch(:stage) }

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
