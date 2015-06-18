module Capistrano
  module Generals
    module Helpers

      def bundle_unicorn(*args)
        SSHKit::Command.new(:bundle, :exec, :unicorn, args).to_command
      end

      def bundle_sidekiq(*args)
        SSHKit::Command.new(:bundle, :exec, :sidekiq, args).to_command
      end

      def bundle_puma(*args)
        SSHKit::Command.new(:bundle, :exec, :puma, args).to_command
      end

      def red text
        "\033[31m#{text}\033[0m"
      end

      # Try to find stage specific file, otherwice select default
      # If the default does not exists, abort
      def get_config_file(file_name, stage)
        # Default local_file_name is stage specific.
        local_file_name = get_config_file_name(file_name, stage)

        # Check if file exists, else select default file
        # If default file does not exists abort.
        unless file_exists? local_file_name
          unless file_exists? file_name
            abort red "Cannot find file #{local_file_name} or #{file_name} on machine"
          end
          # The default file does exists, selecting that one
          warn "Cannot find stage specific config file #{local_file_name} on machine, taking default #{file_name}"
          local_file_name = file_name
        end
        local_file_name
      end

      # Returns if the file exists
      # The default File.exists? does not work on a remote
      def file_exists?(file_name)
        test("[ -f #{file_name} ]")
      end

      # Get the stage specific name of the file
      def get_config_file_name(config, stage)
        path = File.dirname(config)
        extension = File.extname(config)
        filename = File.basename(config, extension)
        extension.sub!(/^\./, '')
        local_file = [filename, stage].join('.')
        local_file = [local_file, extension].join('.') unless extension.empty?
        local_path = File.join(path, local_file)
      end

      def sudo_upload!(from, to)
        filename = File.basename(to)
        to_dir = File.dirname(to)
        execute :mkdir, '-pv', to_dir
        tmp_file = "#{fetch(:tmp_dir)}/#{filename}"
        upload! from, tmp_file
        sudo :mv, tmp_file, to_dir
      end

      # renders the ERB template specified by template_name to string. Use the locals variable to pass locals to the
      # ERB template
      def template_to_s(template_name, locals = {})
        config_file = "#{fetch(:templates_path)}/#{template_name}.erb"
        # if no customized file, proceed with default
        unless File.exists?(config_file)
          config_file = File.join(File.dirname(__FILE__), "../../generators/capistrano/generals/templates/#{template_name}.erb")
        end

        ERB.new(File.read(config_file)).result(ERBNamespace.new(locals).get_binding)
      end

      # renders the ERB template specified by template_name to a StringIO buffer
      def template(template_name, locals = {})
        StringIO.new(template_to_s(template_name, locals))
      end

      # Helper class to pass local variables to an ERB template
      class ERBNamespace
        def initialize(hash)
          hash.each do |key, value|
            singleton_class.send(:define_method, key) { value }
          end
        end

        def get_binding
          binding
        end
      end

    end
  end
end
