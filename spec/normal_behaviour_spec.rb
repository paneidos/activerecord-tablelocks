require 'spec_helper'
require 'models/page'

describe "Normal behaviour" do
  it "is not affected by this gem" do
    page = Page.new(name: "Home", content: "Lorem ipsum dolor, ... you know this.")
    page.save.should == true
  end
end