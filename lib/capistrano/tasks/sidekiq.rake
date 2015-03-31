namespace :sidekiq do

  desc 'Start sidekiq'
  task :start do
    on roles(:app) do
      execute "sudo /etc/init.d/sidekiq_#{fetch(:application)}_#{fetch(:stage)} start"
    end
  end

  desc 'Stop sidekiq'
  task :stop do
    on roles(:app) do
      execute "sudo /etc/init.d/sidekiq_#{fetch(:application)}_#{fetch(:stage)} stop"
      sleep 8
    end
  end

  desc 'Restart sidekiq'
  task :restart do
    invoke 'sidekiq:stop'
    invoke 'sidekiq:start'
  end

end
