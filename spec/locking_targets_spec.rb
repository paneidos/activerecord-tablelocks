require 'spec_helper'
require 'models/page'
require 'models/comment'
require 'models/user'
require 'models/group'

describe "Locking target" do
  it "should be empty by default" do
    Page.tables_to_lock.should == []
  end

  it "should include the class' own table by default" do
    Comment.tables_to_lock.should include(Comment.quoted_table_name)
  end

  it "should include all specified classes" do
    User.tables_to_lock.should include(User.quoted_table_name)
    User.tables_to_lock.should include(Group.quoted_table_name)
  end

  it "should include all specified tables" do
    Group.tables_to_lock.should include(User.quoted_table_name)
    Group.tables_to_lock.should include(Group.quoted_table_name)
  end

  it "should have the tables to lock sorted" do
    User.tables_to_lock.sort.should == User.tables_to_lock
    Comment.tables_to_lock.sort.should == Comment.tables_to_lock
    Page.tables_to_lock.sort.should == Page.tables_to_lock
    Group.tables_to_lock.sort.should == Group.tables_to_lock
  end

  it "should not contain duplicate table names" do
    User.tables_to_lock.uniq.should == User.tables_to_lock
    Comment.tables_to_lock.uniq.should == Comment.tables_to_lock
    Page.tables_to_lock.uniq.should == Page.tables_to_lock
    Group.tables_to_lock.uniq.should == Group.tables_to_lock
  end
end