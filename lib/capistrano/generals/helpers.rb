module Capistrano
  module Generals
    module Helpers
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

    end
  end
end
