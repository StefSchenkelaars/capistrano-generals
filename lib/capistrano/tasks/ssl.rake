require 'capistrano/dsl/ssl_paths'
include Capistrano::DSL::SSLPaths

namespace :ssl do
  # If you intend to secure the URL https://www.yourdomain.com, then your CSR's common name must be www.yourdomain.com. If you plan on getting a wildcard certificate make sure to prefix your domain with an asterisk, example: *.domain.com.
  desc 'Generate Private Key and CSR files'
  task :generate_private_key_and_csr do
    run_locally do
      `openssl req -nodes -newkey rsa:2048 -sha256 -keyout #{new_certificate_file_for(fetch(:ssl_cert_key))} -out #{new_certificate_file_for(fetch(:ssl_csr))}`
    end
  end

  desc 'Generate dhparam file'
  task :generate_dhparam do
    run_locally do
      `openssl dhparam -out #{new_certificate_file_for(fetch(:ssl_dhparam))} 4096`
    end
  end

  desc 'Send certificate and key to server'
  task :upload do
    on roles :web do
      # Upload chained certificate
      sudo_upload! chained_certificate, remote_ssl_cert_chained_file
      sudo :chown, 'root', remote_ssl_cert_chained_file
      sudo :chmod, '644', remote_ssl_cert_chained_file

      # Upload key
      sudo_upload! existing_certificate_file_for(fetch(:ssl_cert_key)), remote_ssl_cert_key_file
      sudo :chown, 'root:ssl-cert', remote_ssl_cert_key_file
      sudo :chmod, '640', remote_ssl_cert_key_file

      # Upload dhparam
      if File.exists? certificate_file_for(fetch(:ssl_dhparam))
        sudo_upload! certificate_file_for(fetch(:ssl_dhparam)), remote_ssl_dhparam_file
        sudo :chown, 'root', remote_ssl_dhparam_file
        sudo :chmod, '644', remote_ssl_dhparam_file
      end
    end
  end
end
