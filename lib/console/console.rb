require 'ripl/multi_line'

require 'console/api'

module Migrate
  class Console

    def initialize old_project, new_project
      @old_project, @new_project = old_project, new_project
    end

    def run
      api = Api.new @old_project, @new_project
      empty_argv

      Ripl.start :binding => api.instance_eval{ binding }
    end

  private

    def empty_argv
      Object.send :remove_const, :ARGV
      Object.send :const_set, :ARGV, []
    end

  end
end
