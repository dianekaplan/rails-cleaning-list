require 'active_record'
require 'yaml'

class MigrateRunner
  def self.migrate
    config = YAML.load_file('config/database.yml', aliases: true)
    ActiveRecord::Base.establish_connection(config['development'])
    migrations_path = File.join(__dir__, 'migrate')
    ActiveRecord::MigrationContext.new(migrations_path).migrate
    puts 'Migrations applied.'
  rescue => e
    puts "Migration failed: #{e.message}"
    raise
  end
end
