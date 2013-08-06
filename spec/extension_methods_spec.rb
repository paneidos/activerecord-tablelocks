require 'spec_helper'
describe "Extension methods" do
  describe "ActiveRecord objects" do
    it "should accept zero arguments for 'enable_locking'" do
      klass = Class.new(ActiveRecord::Base)
      lambda { klass.enable_locking }.should_not raise_error
    end

    it "should accept a hash with options" do
      klass = Class.new(ActiveRecord::Base)
      lambda { klass.enable_locking({}) }.should_not raise_error
    end

    it "should have an empty list at the start" do
      klass = Class.new(ActiveRecord::Base)
      klass.lock_targets[:class_names].should == []
      klass.lock_targets[:table_names].should == []
    end

    it "should save class_names and table_names from options" do
      klass = Class.new(ActiveRecord::Base)
      klass.enable_locking({ class_names: ['User', 'Group'], table_names: ['users_groups'] })
      klass.lock_targets[:class_names].sort.should == ['Group','User']
      klass.lock_targets[:table_names].sort.should == ['users_groups']
    end
  end
end