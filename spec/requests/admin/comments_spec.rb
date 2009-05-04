require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe "/admin/comments" do
  before(:each) do
    @response = request("/admin/comments")
  end
end