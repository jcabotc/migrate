require 'yaml'

require 'script/script_manager'

module Migrate
  class Api

    attr_reader :old, :new

    def initialize old_project, new_project
      @old, @new = old_project, new_project
    end

    def undefine_model class_name, options = {}
      class_name = class_name.to_s.classify

      Object.send :remove_const, class_name
    end

    def script *names
      script_manager = ScriptManager.new @old, @new, names
      script_manager.run

      nil
    end

    def scripts
      ScriptManager.script_names
    end

    def help
      puts File.readlines File.expand_path( File.join( 'lib', 'console', 'USAGE' ) )
    end

  end
end
