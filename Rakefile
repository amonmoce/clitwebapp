require './app'
require_relative 'model/registered.rb'
require_relative 'model/pdfdata.rb'

desc "Create Registered Class data store"
task :createregistered do
  begin
    Registered.create_table(5, 6)
    puts "New Registered Class data store created"
  rescue AWS::DynamoDB::Errors::ResourceInUseException => e
    puts 'Data store already exists -- no changes made, no retry attempted'
  end
end

desc "Create Pdf texts data store"
task :createpdfdata do
  begin
    Pdfdata.create_table(5, 6)
    puts "New Pdf texts data store created"
  rescue AWS::DynamoDB::Errors::ResourceInUseException => e
    puts 'Data store already exists -- no changes made, no retry attempted'
  end
end
