require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Tag do

  it "should have a valid factory" do
    Factory.build(:tag).should be_valid
  end
  
  it "should not be valid without a name" do
    tag = Factory.build(:tag, :name => '')
    tag.should_not be_valid
  end

end