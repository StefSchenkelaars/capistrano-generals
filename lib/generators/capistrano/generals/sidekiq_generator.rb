module Capistrano
  module Generals
    module Generators
      class SidekiqGenerator < Rails::Generators::Base
        desc 'Create local sidekiq configuration file for customization'
        source_root File.expand_path('../templates', __FILE__)
        argument :templates_path, type: :string,
          default: 'config/deploy/templates',
          banner: 'path to templates'

        def copy_template
          copy_file 'sidekiq_init.sh.erb', "#{templates_path}/sidekiq_init.sh.erb"
        end
      end
    end
  end
end
