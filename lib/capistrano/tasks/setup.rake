namespace :setup do

  desc "Symlinks config files for Nginx and Unicorn"
  task :symlink_nginx_and_unicorn do
    on roles(:app) do
      execute "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{fetch(:application)}"
      execute "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{fetch(:application)}"
      # Start unicorn at startup
      execute "sudo update-rc.d unicorn_#{fetch(:application)} defaults"
    end
  end

end
