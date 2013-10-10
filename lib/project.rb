require 'yaml'
require 'active_record'

module Migrate
  class Project

    TableNotFound = Class.new StandardError

    DATABASE_CONFIG_PATH = File.join( 'config', 'database.yml' )

    attr_reader :app_path

    def initialize app_path, environment = 'development'
      @app_path    = File.expand_path app_path
      @environment = environment
    end

    def database_configuration
      database_data = YAML.load_file( database_config_file_path )[ @environment ]
      database_data['database'] = File.join( @app_path, database_data['database'] )
      database_data
    end

    def model model_name, options = {}
      class_name = ( options[:as]    || model_name ).to_s.classify
      table      = ( options[:table] || model_name ).to_s.tableize

      klass = build_class class_name, table

      unless klass.connection.table_exists? table
        Object.send :remove_const, class_name
        raise TableNotFound, "table name: #{table}"
      end

      klass
    end

  private

    def build_class class_name, table
      Object.const_set class_name, Class.new( ActiveRecord::Base )
      project_connection = database_configuration

      class_name.constantize.instance_eval do
        establish_connection project_connection
        table_name = table
      end

      class_name.constantize
    end

    def database_config_file_path
      File.expand_path File.join( app_path, DATABASE_CONFIG_PATH )
    end

  end
end
