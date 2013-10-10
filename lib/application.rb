require 'thor'
require 'active_support/inflector'

require 'project'
require 'console/console'
require 'script/script_manager'

module Migrate
  class Application < Thor

    def self.environment_options
      method_option :environment,     :aliases => '-e',  :type => :string, :default  => 'development',
        :desc => 'Selects an environment database to me used'

      method_option :old_environment, :aliases => '-oe', :type => :string, :optional => true,
        :desc => 'Selects an environment database for the old project (overriding --environment value)'
      method_option :new_environment, :aliases => '-ne', :type => :string, :optional => true,
        :desc => 'Selects an environment database for the new project (overriding --environment value)'
    end


    desc 'console', 'Runs a ruby console with old an new projects available'
    environment_options

    def console old_path, new_path
      @old_path, @new_path = old_path, new_path

      console = Console.new *projects
      console.run
    end


    desc 'script', 'Runs the given scripts (all by default)'
    environment_options

    def script old_path, new_path, *scripts
      @old_path, @new_path = old_path, new_path

      script_manager = ScriptManager.new *projects, scripts
      script_manager.run
    end


  private

    def projects
      @_projects ||= [ 
        Project.new( @old_path, options[ :old_environment ] || options[ :environment ] ),
        Project.new( @new_path, options[ :new_environment ] || options[ :environment ] )
      ]
    end

  end
end
