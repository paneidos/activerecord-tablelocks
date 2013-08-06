class User < ActiveRecord::Base
  enable_locking :class_names => "Group"
end