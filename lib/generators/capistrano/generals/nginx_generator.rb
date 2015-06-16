module Capistrano
  module Generals
    module Generators
      class NginxGenerator < Rails::Generators::Base
        desc 'Create local nginx configuration file for customization'
        source_root File.expand_path('../templates', __FILE__)
        argument :templates_path, type: :string,
          default: 'config/deploy/templates',
          banner: 'path to templates'

        def copy_template
          copy_file 'nginx.conf.erb', "#{templates_path}/nginx.conf.erb"
        end
      end
    end
  end
end
