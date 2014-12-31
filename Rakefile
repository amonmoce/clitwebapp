require './app'
require_relative 'model/registered.rb'

desc "Create data store"
task :create do
  begin
    Registered.create_table(5, 6)
    puts "New data store created"
  rescue AWS::DynamoDB::Errors::ResourceInUseException => e
    puts 'Data store already exists -- no changes made, no retry attempted'
  end
end
