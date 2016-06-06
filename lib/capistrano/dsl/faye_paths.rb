module Capistrano
  module DSL
    module FayePaths

      def faye_service
        "faye_#{fetch(:app_config_name)}"
      end

      def faye_initd_file
        "/etc/init.d/#{faye_service}"
      end

      def faye_default_config_file
        shared_path.join('config/faye.ru')
      end

      def faye_default_pid_file
        shared_path.join('tmp/pids/faye.pid')
      end

      def faye_default_require
        current_path.join('config/environment')
      end

      def faye_log_dir
        shared_path.join('log')
      end

      def faye_log_file
        sidekiq_log_dir.join(fetch(:faye_log))
      end
    end
  end
end
