$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'activerecord-tablelocks'
require 'rspec'
require 'rspec/autorun'
require 'active_record'

Dir[File.join(File.dirname(__FILE__),"support/**/*.rb")].each { |f| require f }

# For more progress output during the long test, uncomment the line below
# ActiveRecord::Base.logger = Logger.new(STDOUT)

RSpec.configure do |config|
end