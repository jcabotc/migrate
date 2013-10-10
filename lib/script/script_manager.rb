require 'script/base'

Dir[ File.join( 'scripts', '*.rb' ) ].each do |script|
  require File.expand_path( script )
end

module Migrate
  class ScriptManager

    ScriptNotFound = Class.new StandardError

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
      puts case action
        when :running then "====== Running #{script.class.name} ======"
        when :done    then "===== #{script.class.name} succeeded ====="
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
