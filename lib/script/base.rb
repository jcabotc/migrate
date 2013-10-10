module Migrate
  module Script
    class Base

      RunMethodNotDefined = Class.new StandardError

      attr_reader :old, :new

      @@_models = { :new => Array.new, :old => Array.new }

      def initialize old_project, new_project
        @old, @new = old_project, new_project

        @@_models[ :new ].each { |model_data| new.model *model_data }
        @@_models[ :old ].each { |model_data| old.model *model_data }
      end

      def run
        raise RunMethodNotDefined, "A 'run' method must be defined in all scripts"
      end

      def self.scripts
        ObjectSpace.each_object( ::Class ).select { |klass| klass < self }
      end

      def self.old_model model_name, options = {}
        @@_models[ :old ] << [ model_name, options ]
      end

      def self.new_model model_name, options = {}
        @@_models[ :new ] << [ model_name, options ]
      end

    private

      def log text, options = {}
        puts case options[ :as ]
          when nil      then text
          when :title   then "--- #{text.capitalize} ---"
          when :list    then " * #{text}"
          when :warning then "WARNING: #{text}"
          when :extreme then "<_.·'// #{text} \\\\'·._>"
        end
      end

    end
  end
end
