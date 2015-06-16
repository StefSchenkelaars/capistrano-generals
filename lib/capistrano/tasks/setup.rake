namespace :setup do
#
#   namespace :symlink do
#
#     desc 'Symlink config file for nginx'
#     task :nginx do
#       on roles :app do
#         # Find stage specific config file
#         file_name = File.join current_path, 'config/nginx.conf'
#         file_name = get_config_file(file_name, fetch(:stage).to_s)
#         execute "ln -nfs #{file_name} /etc/nginx/sites-enabled/#{fetch(:application)}_#{fetch(:stage)}"
#       end
#     end
#
#     desc 'Symlink config file for unicorn'
#     task :unicorn do
#       on roles :app do
#         # Find stage specific config file
#         file_name = File.join current_path, 'config/unicorn_init.sh'
#         file_name = get_config_file(file_name, fetch(:stage).to_s)
#         execute "ln -nfs #{file_name} /etc/init.d/unicorn_#{fetch(:application)}_#{fetch(:stage)}"
#         # Start unicorn at startup
#         execute "sudo update-rc.d unicorn_#{fetch(:application)}_#{fetch(:stage)} defaults"
#       end
#     end
#
#     desc 'Symlink config file for sidekiq'
#     task :sidekiq do
#       on roles :app do
#         # Find stage specific config file
#         file_name = File.join current_path, 'config/sidekiq_init.sh'
#         file_name = get_config_file(file_name, fetch(:stage).to_s)
#         execute "ln -nfs #{file_name} /etc/init.d/sidekiq_#{fetch(:application)}_#{fetch(:stage)}"
#         # Start unicorn at startup
#         execute "sudo update-rc.d sidekiq_#{fetch(:application)}_#{fetch(:stage)} defaults"
#       end
#     end
#
#   end
#
end
