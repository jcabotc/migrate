module Migrate
  class Api

    attr_reader :old, :new

    def initialize old_project, new_project
      @old, @new = old_project, new_project
    end

    def define_model project, model_name, options = {}
      class_name = ( options[:as]    || model_name ).to_s.classify
      table      = ( options[:table] || model_name ).to_s.tableize

      Object.const_set class_name, Class.new( ActiveRecord::Base )

      class_name.constantize.instance_eval do
        establish_connection project.database_configuration
        table_name = table
      end
    end
  end
end
