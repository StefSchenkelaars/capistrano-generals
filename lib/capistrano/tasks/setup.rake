namespace :setup do

  desc "Symlinks config files for Nginx and Unicorn"
  task :symlink_nginx_and_unicorn do
    on roles :app do
      # Find stage specific config file
      file_name = File.join current_path, 'config/nginx.conf'
      file_name = get_config_file(file_name, fetch(:stage).to_s)
      execute "ln -nfs #{file_name} /etc/nginx/sites-enabled/#{fetch(:application)}_#{fetch(:stage)}"

      # Find stage specific config file
      file_name = File.join current_path, 'config/unicorn_init.sh'
      file_name = get_config_file(file_name, fetch(:stage).to_s)
      execute "ln -nfs #{file_name} /etc/init.d/unicorn_#{fetch(:application)}_#{fetch(:stage)}"
      # Start unicorn at startup
      execute "sudo update-rc.d unicorn_#{fetch(:application)}_#{fetch(:stage)} defaults"
    end
  end

end
