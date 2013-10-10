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

  end
end
