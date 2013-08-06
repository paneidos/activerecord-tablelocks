class Group < ActiveRecord::Base
  enable_locking :table_names => "users", :class_names => "User"
end