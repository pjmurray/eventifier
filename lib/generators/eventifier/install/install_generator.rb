require 'rails/generators/active_record'

module Eventifier
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      extend ActiveRecord::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      def copy_event_tracking
        copy_file "event_tracking.rb", "app/models/event_tracking.rb"
      end

      def copy_language
        copy_file "events.en.yaml", "config/locales/events.en.yaml"
      end

      def generate_migration
        migration_template "migration.rb", "db/migrate/eventifier_setup.rb" if defined?(ActiveRecord)
      end

    end
  end
end
