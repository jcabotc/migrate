module Migrate
  module Script
    class Base

      RunMethodNotDefined = Class.new StandardError

      attr_reader :old, :new

      def initialize old_project, new_project
        @old, @new = old_project, new_project
      end

      def self.descendants
        ObjectSpace.each_object( ::Class ).select { |klass| klass < self }
      end

      def run
        raise RunMethodNotDefined, "A 'run' method must be defined in all scripts"
      end

    end
  end
end
