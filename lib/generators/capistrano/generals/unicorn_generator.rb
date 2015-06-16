module Capistrano
  module Generals
    module Generators
      class UnicornGenerator < Rails::Generators::Base
        desc 'Create local unicorn configuration file for customization'
        source_root File.expand_path('../templates', __FILE__)
        argument :templates_path, type: :string,
          default: 'config/deploy/templates',
          banner: 'path to templates'

        def copy_template
          copy_file 'unicorn.rb.erb', "#{templates_path}/unicorn.rb.erb"
          copy_file 'unicorn_init.sh.erb', "#{templates_path}/unicorn_init.sh.erb"
        end
      end
    end
  end
end
