module Capistrano
  module DSL
    module NginxPaths

      def nginx_initd_file
        '/etc/init.d/nginx'
      end

      def nginx_sites_available_file
        "#{fetch(:nginx_location)}/sites-available/#{fetch(:app_config_name)}"
      end

      def nginx_sites_enabled_file
        "#{fetch(:nginx_location)}/sites-enabled/#{fetch(:app_config_name)}"
      end

    end
  end
end
