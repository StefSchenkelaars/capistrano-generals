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

      # ssl related files
      def nginx_ssl_cert_file
        "/etc/ssl/certs/#{fetch(:nginx_ssl_cert)}"
      end

      def nginx_ssl_cert_key_file
        "/etc/ssl/private/#{fetch(:nginx_ssl_cert_key)}"
      end

      def nginx_ssl_dhparam_file
        "/etc/ssl/certs/#{fetch(:nginx_ssl_dhparam)}"
      end

    end
  end
end
