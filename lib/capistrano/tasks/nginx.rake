namespace :nginx do

  desc 'Start nginx'
  task :start do
    on roles(:app) do
      execute 'sudo /etc/init.d/nginx start'
    end
  end

  desc 'Stop nginx'
  task :stop do
    on roles(:app) do
      execute 'sudo /etc/init.d/nginx stop'
      sleep 3
    end
  end

  desc 'Restart nginx'
  task :restart do
    on roles(:app) do
      execute 'sudo /etc/init.d/nginx restart'
    end
  end

end
