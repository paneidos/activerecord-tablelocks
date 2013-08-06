class User < ActiveRecord::Base
  enable_locking :class_names => "Group"

  validates :name, :uniqueness => true, :presence => true

  attr_accessor :validate_mutexes
  attr_accessor :commit_mutexes
  after_validation :release_mutexes

  def release_mutexes
    validate_mutexes.each do |mutex|
      mutex.unlock
    end
    commit_mutexes.each do |mutex|
      mutex.lock
    end
  end
end