module Capistrano
  module DSL
    module SSLPaths

      # Get the full path of a certificate file
      def certificate_file_for(filename)
        File.expand_path(filename, fetch(:local_certs_folder))
      end

      def existing_certificate_file_for(filename)
        filename = certificate_file_for filename
        unless File.exists? filename
          abort red "Could not find #{filename}"
        end
        filename
      end

      def new_certificate_file_for(filename)
        filename = certificate_file_for filename
        if File.exists? filename
          abort red "File #{filename} already exists"
        end
        execute :mkdir, '-pv', fetch(:local_certs_folder)
        filename
      end

      def chained_certificate
        c1 = File.read(existing_certificate_file_for(fetch(:ssl_cert)))
        c2 = File.read(existing_certificate_file_for(fetch(:ssl_cert_intermediate)))
        StringIO.new(c1.rstrip + "\n" + c2)
      end

      # ssl related files
      def remote_ssl_cert_chained_file
        "#{fetch(:remote_certs_folder)}/certs/#{fetch(:ssl_cert_chain)}"
      end

      def remote_ssl_cert_key_file
        "#{fetch(:remote_certs_folder)}/private/#{fetch(:ssl_cert_key)}"
      end

      def remote_ssl_dhparam_file
        "#{fetch(:remote_certs_folder)}/certs/#{fetch(:ssl_dhparam)}"
      end
    end
  end
end
