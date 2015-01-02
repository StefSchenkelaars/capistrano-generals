namespace :deploy do

  desc 'Restart nginx and unicorn.'
  task :restart do
    on roles(:app) do
      execute "sudo /etc/init.d/unicorn_#{fetch(:application)}_#{fetch(:stage)} upgrade"
      execute "sudo /etc/init.d/nginx restart"
    end
  end

end
