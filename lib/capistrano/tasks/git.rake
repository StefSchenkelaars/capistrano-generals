namespace :git do

  desc 'Push selected branch to git repo'
  task :push do
    # Check for any local changes that haven't been committed
    # Use 'cap git:push IGNORE_DEPLOY_RB=1' to ignore changes to this file (for testing)
    run_locally do
      status = %x(git status --porcelain).chomp
      if status != ""
        if status !~ %r{^[M ][M ] config/deploy.rb$}
          abort "Local git repository has uncommitted changes"
        elsif !ENV["IGNORE_DEPLOY_RB"]
          # This is used for testing changes to this script without committing them first
          abort "Local git repository has uncommitted changes (set IGNORE_DEPLOY_RB=1 to ignore changes to deploy.rb)"
        end
      end

      # Push selected branch to github
      unless system "git push #{repo_url} #{fetch(:branch)} #{'-f' if ENV['FORCE']}"
        abort red("Failed to push changes to #{fetch(:repo_url)} (set FORCE=true to force push to github)")
      end
    end
  end

end
