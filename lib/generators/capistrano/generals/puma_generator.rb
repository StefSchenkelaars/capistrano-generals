module Capistrano
  module Generals
    module Generators
      class PumaGenerator < Rails::Generators::Base
        desc 'Create local puma configuration files for customization'
        source_root File.expand_path('../templates', __FILE__)
        argument :templates_path, type: :string,
          default: 'config/deploy/templates',
          banner: 'path to templates'

        def copy_template
          copy_file 'puma.rb.erb', "#{templates_path}/puma.rb.erb"
          copy_file 'puma_init.sh.erb', "#{templates_path}/puma_init.sh.erb"
        end
      end
    end
  end
end
