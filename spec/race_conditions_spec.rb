require 'spec_helper'
require 'models/comment'

describe "Race conditions" do
  it "should prevent race conditions on a single table" do
    comment1 = Comment.new(title: "TITLE")
    comment2 = Comment.new(title: "TITLE")

    mutex1 = Mutex.new
    mutex2 = Mutex.new
    mutex3 = Mutex.new
    mutex4 = Mutex.new

    # This should not run within reasonable time

    # main thread:
    # 1. lock mutex1
    # 2. lock mutex2
    # 3. start threads
    # 4. wait for mutex3 and mutex4 to be locked
    # 4. release mutex1 and mutex2

    # comment1:
    # 0. lock mutex3
    # 1. lock mutex1
    # 2. run validations
    # 3. release mutex1 and mutex3
    # 4. lock mutex4
    # 5. commit
    # 6. release mutex4

    # comment2:
    # 1. lock mutex4
    # 2. lock mutex2
    # 2. run validations
    # 3. release mutex2 and mutex4
    # 4. lock mutex3
    # 5. commit
    # 6. release mutex3

    mutex1.lock
    mutex2.lock

    comment1.validate_mutexes = [mutex1,mutex3]
    comment1.commit_mutexes = [mutex4]
    comment2.validate_mutexes = [mutex2,mutex4]
    comment2.commit_mutexes = [mutex3]

    # Start threads
    thread1 = Thread.new do
      mutex3.lock
      mutex1.lock
      ActiveRecord::Base.connection_pool.with_connection do |conn|
        comment1.save
      end
      mutex4.unlock
    end

    thread2 = Thread.new do
      mutex4.lock
      mutex2.lock
      ActiveRecord::Base.connection_pool.with_connection do |conn|
        comment2.save
      end
      mutex3.unlock
    end

    until mutex3.locked?
      sleep 0.001
    end
    until mutex4.locked?
      sleep 0.001
    end

    mutex1.unlock
    mutex2.unlock
    thread1.join(3).should be_nil
    thread2.join(3).should be_nil

    comment1.persisted?.should == false
    comment2.persisted?.should == false

    # Clean up the threads
    thread1.exit
    thread2.exit

  end
  it "should prevent race conditions on validations spanning multiple tables" do
    user = User.new(name: "root")
    group = Group.new(name: "root")

    mutex1 = Mutex.new
    mutex2 = Mutex.new
    mutex3 = Mutex.new
    mutex4 = Mutex.new

    # This should not run within reasonable time

    # main thread:
    # 1. lock mutex1
    # 2. lock mutex2
    # 3. start threads
    # 4. wait for mutex3 and mutex4 to be locked
    # 4. release mutex1 and mutex2

    # user:
    # 0. lock mutex3
    # 1. lock mutex1
    # 2. run validations
    # 3. release mutex1 and mutex3
    # 4. lock mutex4
    # 5. commit
    # 6. release mutex4

    # group:
    # 1. lock mutex4
    # 2. lock mutex2
    # 2. run validations
    # 3. release mutex2 and mutex4
    # 4. lock mutex3
    # 5. commit
    # 6. release mutex3

    mutex1.lock
    mutex2.lock

    user.validate_mutexes = [mutex1,mutex3]
    user.commit_mutexes = [mutex4]
    group.validate_mutexes = [mutex2,mutex4]
    group.commit_mutexes = [mutex3]

    # Start threads
    thread1 = Thread.new do
      mutex3.lock
      mutex1.lock
      ActiveRecord::Base.connection_pool.with_connection do |conn|
        user.save
      end
      mutex4.unlock
    end

    thread2 = Thread.new do
      mutex4.lock
      mutex2.lock
      ActiveRecord::Base.connection_pool.with_connection do |conn|
        group.save
      end
      mutex3.unlock
    end

    until mutex3.locked?
      sleep 0.001
    end
    until mutex4.locked?
      sleep 0.001
    end

    mutex1.unlock
    mutex2.unlock
    thread1.join(3).should be_nil
    thread2.join(3).should be_nil

    user.persisted?.should == false
    group.persisted?.should == false

    # Clean up the threads
    thread1.exit
    thread2.exit
  end

  it "should pass a test which tries to create a huge amount of comments at roughly the same time with random times between validation and saving to the database" do
    puts "This test will take a long time"
    comments = []
    threads = []
    number_of_comments = 100
    timeouts = AtomicInteger.new
    # The wait times are sorted in reverse order to increase the chance of a race condition
    wait_times = list_of_random_numbers(number_of_comments).sort.reverse
    number_of_comments.times do
      comment = Comment.new title: "RACE"
      comment.wait_time = wait_times.shift
      comments << comment
      threads << Thread.new do
        saved = false
        until saved do
          begin
            ActiveRecord::Base.connection_pool.with_connection do |conn|
              comment.save
              saved = true
            end
          rescue ActiveRecord::ConnectionTimeoutError => e
            # This test most likely triggers a lot of timeout errors
            # We can safely ignore those errors, it's intended behaviour of this test
            # To improve the accuracy of the tests, it's recommended to increase the poolsize
            timeouts.increment
          end
        end
      end
    end
    threads.each do |thread|
      thread.join
    end
    comments.map(&:persisted?).select {|x| x == true}.size.should == 1
    if timeouts.value > 0
      puts "There were #{timeouts.value} timeouts during this test, increase your database connection pool size to improve accuracy"
    end
  end
end