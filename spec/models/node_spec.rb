require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Node do

  it "should have a valid factory" do
    Factory.build(:node).should be_valid
  end
  
  it "should not be valid without a title" do
    node = Factory.build(:node, :title => '')
    node.should_not be_valid
  end

  it "should not be valid without content" do
    node = Factory.build(:node, :content => '')
    node.should_not be_valid
  end

  it "should not be valid without a title and content" do
    node = Factory.build(:node, :title => '', :content => '')
    node.should_not be_valid
  end

end

# some example:
# http://railsontherun.com/2008/9/7/db-fixtures-replacement-solution-step-by-step
# http://github.com/thoughtbot/factory_girl/tree/master