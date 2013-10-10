require 'yaml'
require 'active_record'

require 'active_record_classes'

module Migrate
  class Project

    DATABASE_CONFIG_PATH = File.join( 'config', 'database.yml' )

    ENVIRONMENT = 'development'

    attr_reader :app_path

    def initialize app_path
      @app_path = File.expand_path app_path
    end

    def database_configuration
      database_data = YAML.load_file( database_config_file_path )[ ENVIRONMENT ]
      database_data['database'] = File.join( @app_path, database_data['database'] )
      database_data
    end

  private

    def database_config_file_path
      File.expand_path File.join( app_path, DATABASE_CONFIG_PATH )
    end

  end
end
