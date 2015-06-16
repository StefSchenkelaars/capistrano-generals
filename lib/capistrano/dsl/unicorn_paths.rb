module Capistrano
  module DSL
    module UnicornPaths

      def unicorn_service
        "unicorn_#{fetch(:app_config_name)}"
      end

      def unicorn_initd_file
        "/etc/init.d/#{unicorn_service}"
      end

      def unicorn_default_config_file
        shared_path.join('config/unicorn.rb')
      end

      def unicorn_default_pid_file
        shared_path.join('tmp/pids/unicorn.pid')
      end

      def unicorn_log_dir
        shared_path.join('log')
      end

      def unicorn_log_file
        unicorn_log_dir.join(fetch(:unicorn_log))
      end

      def unicorn_error_log_file
        unicorn_log_dir.join(fetch(:unicorn_error_log))
      end

      #
      # def unicorn_default_logrotate_config_file
      #   "/etc/logrotate.d/#{fetch(:unicorn_service)}"
      # end
    end
  end
end
