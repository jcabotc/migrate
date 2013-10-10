require 'pp'
require 'ripl'

require 'console/api'

module Migrate
  class Console

    PROMPT_SYMBOL = '> '

    def initialize old_project, new_project
      @old_project, @new_project = old_project, new_project
    end

    def run
      api = Api.new @old_project, @new_project

      Ripl.start :binding => api.instance_eval{ binding }
    end

  end
end
