require 'script/base'

Dir[ File.join( 'scripts', '*.rb' ) ].each do |script|
  require File.expand_path( script )
end

module Migrate
  class ScriptManager

    ScriptNotFound = Class.new StandardError

    LINE_LENGTH = 60

    attr_reader :old, :new

    def initialize old_project, new_project, scripts
      @old, @new = old_project, new_project

      @scripts = script_classes_from scripts
    end

    def run
      @scripts.each do |script|
        log :running, script
        script.run
        log :done, script
      end
    end

  private

    def log action, script
      line = '=' * LINE_LENGTH

      case action
        when :running
          running_text = "Running #{script.class.name}"
          margin = '=' * ( ( ( LINE_LENGTH - running_text.size ) / 2 ) - 1 )

          puts "#{margin} #{running_text} #{margin}"
        when :done
          puts line
          puts ''
      end
    end

    def script_classes_from scripts
      if scripts.any?
        scripts.map do |script_name|
          build_script "#{script_name.classify}Script"
        end
      else
        Script::Base.descendants.map { |script_class| script_class.new @old, @new }
      end
    end

    def build_script class_name
      begin
        class_name.constantize.new @old, @new
      rescue
        raise ScriptNotFound, "#{class_name} not found"
      end
    end

  end
end
