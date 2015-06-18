module Capistrano
  module DSL
    module PumaPaths

      def puma_service
        "puma_#{fetch(:app_config_name)}"
      end

      def puma_initd_file
        "/etc/init.d/#{puma_service}"
      end

      def puma_default_config_file
        shared_path.join('config/puma.rb')
      end

      def puma_default_pid_file
        shared_path.join('tmp/pids/puma.pid')
      end
    end
  end
end
