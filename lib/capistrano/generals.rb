# Require capistrano
require 'capistrano'
require 'capistrano/version'

# Include all helpers
require 'capistrano/generals/helpers'
# include Capistrano::Generals::Helpers


module Capistrano
  module Generals

    def self.load_into(capistrano_configuration)
      capistrano_configuration.load do
        # Load all the rake files
        Dir[File.dirname(__FILE__) + '/tasks/**/*.rake'].each {|file| load file }
      end
    end

  end
end
