module Migrate
  module Script
    class Base

      RunMethodNotDefined = Class.new StandardError

      attr_reader :old, :new

      def initialize old_project, new_project
        @old, @new = old_project, new_project
      end

      def run
        raise RunMethodNotDefined, "A 'run' method must be defined in all scripts"
      end

      def self.descendants
        ObjectSpace.each_object( ::Class ).select { |klass| klass < self }
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
