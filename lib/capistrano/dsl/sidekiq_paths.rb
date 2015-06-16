module Capistrano
  module DSL
    module SidekiqPaths

      def sidekiq_service
        "sidekiq_#{fetch(:app_config_name)}"
      end

      def sidekiq_initd_file
        "/etc/init.d/#{sidekiq_service}"
      end

      def sidekiq_default_pid_file
        shared_path.join('tmp/pids/sidekiq.pid')
      end

      def sidekiq_log_dir
        shared_path.join('log')
      end

      def sidekiq_log_file
        sidekiq_log_dir.join(fetch(:sidekiq_log))
      end
    end
  end
end
