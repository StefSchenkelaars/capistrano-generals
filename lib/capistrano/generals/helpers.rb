module Capistrano
  module Generals
    module Helpers
      def red text
        "\033[31m#{text}\033[0m"
      end

      def get_config_file config, stage
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
