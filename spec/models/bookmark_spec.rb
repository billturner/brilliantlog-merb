require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Bookmark do

  it "should have a valid factory" do
    Factory.build(:bookmark).should be_valid
  end
  
  it "should not be valid without a name" do
    bookmark = Factory.build(:bookmark, :name => '')
    bookmark.should_not be_valid
  end

  it "should not be valid without a url" do
    bookmark = Factory.build(:bookmark, :url => '')
    bookmark.should_not be_valid
  end
  
end