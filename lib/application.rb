require 'rubygems'

require 'thor'
require 'active_support/inflector'

require 'project'
require 'console/console'

module Migrate
  class Application < Thor

    desc '<action> <old_project_path> <new_project_path> [options]',
         'Framework to simplify database migrations from old rails applications to new ones'

    option :environment, :aliases => '-e', :type => :string, :default => 'development'

    def console old_path, new_path
      @old_path, @new_path = old_path, new_path

      console = Console.new *projects
      console.run
    end

  private

    def projects
      @_projects ||= [ Project.new( @old_path ), Project.new( @new_path ) ]
    end

  end
end
