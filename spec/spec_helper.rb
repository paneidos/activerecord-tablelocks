$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'activerecord-tablelocks'
require 'rspec'
require 'rspec/autorun'
require 'active_record'

Dir[File.join(File.dirname(__FILE__),"support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
end