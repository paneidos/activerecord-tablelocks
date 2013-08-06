config = case ENV["ENGINE"]
when "postgres"
  {
    "adapter" => "postgresql",
    "database" => ENV["DATABASE"],
    "username" => ENV["USERNAME"],
    "password" => ENV["PASSWORD"],
    "pool" => "15"
  }
else
  raise "Only Postgres is supported at this time"
end

ActiveRecord::Migration.verbose = false
ActiveRecord::Base.configurations = { "test" => config }
ActiveRecord::Base.establish_connection("test")
ActiveRecord::Base.default_timezone = :utc


ActiveRecord::Schema.define do
  ActiveRecord::Base.connection.tables.each do |table|
    drop_table table
  end
  create_table :pages do |t|
    t.string :name
    t.text :content
  end
  create_table :comments do |t|
    t.string :title
    t.text :content
  end
  create_table :users do |t|
    t.string :name
  end
  create_table :groups do |t|
    t.string :name
  end
  
end