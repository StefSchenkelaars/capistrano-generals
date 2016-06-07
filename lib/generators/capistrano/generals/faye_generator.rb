module Capistrano
  module Generals
    module Generators
      class FayeGenerator < Rails::Generators::Base
        desc 'Create local faye configuration files for customization'
        source_root File.expand_path('../templates', __FILE__)
        argument :templates_path, type: :string,
          default: 'config/deploy/templates',
          banner: 'path to templates'

        def copy_template
          copy_file 'faye.ru.erb', "#{templates_path}/faye.ru.erb"
          copy_file 'faye_init.sh.erb', "#{templates_path}/faye_init.sh.erb"
        end
      end
    end
  end
end
