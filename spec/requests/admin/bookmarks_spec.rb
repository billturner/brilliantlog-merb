require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe "/admin/bookmarks" do
  before(:each) do
    @response = request("/admin/bookmarks")
  end
end