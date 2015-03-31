namespace :unicorn do

  desc 'Start unicorn'
  task :start do
    on roles(:app) do
      execute "sudo /etc/init.d/unicorn_#{fetch(:application)}_#{fetch(:stage)} start"
    end
  end

  desc 'Stop unicorn'
  task :stop do
    on roles(:app) do
      execute "sudo /etc/init.d/unicorn_#{fetch(:application)}_#{fetch(:stage)} stop"
      sleep 3
    end
  end

  desc 'Restart unicorn'
  task :restart do
    invoke 'unicorn:stop'
    invoke 'unicorn:start'
  end

end
