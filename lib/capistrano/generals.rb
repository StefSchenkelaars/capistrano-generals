# Include all helpers
require 'capistrano/generals/helpers'
include Capistrano::Generals::Helpers

# Load all the rake files
Dir[File.dirname(__FILE__) + '/tasks/**/*.rake'].each {|file| load file }
