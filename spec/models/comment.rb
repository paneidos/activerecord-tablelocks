class Comment < ActiveRecord::Base
  enable_locking
  validates :title, :uniqueness => true, :presence => true


  attr_accessor :validate_mutexes
  attr_accessor :commit_mutexes
  attr_accessor :wait_time
  after_validation :release_mutexes
  after_validation :wait

  def wait
    if wait_time.present?
      sleep wait_time
    end
  end

  def release_mutexes
    if validate_mutexes.present?
      validate_mutexes.each do |mutex|
        mutex.unlock
      end
    end
    if commit_mutexes.present?
      commit_mutexes.each do |mutex|
        mutex.lock
      end
    end
  end
end