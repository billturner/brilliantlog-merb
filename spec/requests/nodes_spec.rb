require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a node exists" do
  Node.all.destroy!
  request(resource(:nodes), :method => "POST", 
    :params => { :node => { :id => nil }})
end

describe "resource(:nodes)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:nodes))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of nodes" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a node exists" do
    before(:each) do
      @response = request(resource(:nodes))
    end
    
    it "has a list of nodes" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Node.all.destroy!
      @response = request(resource(:nodes), :method => "POST", 
        :params => { :node => { :id => nil }})
    end
    
    it "redirects to resource(:nodes)" do
      @response.should redirect_to(resource(Node.first), :message => {:notice => "node was successfully created"})
    end
    
  end
end

describe "resource(@node)" do 
  describe "a successful DELETE", :given => "a node exists" do
     before(:each) do
       @response = request(resource(Node.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:nodes))
     end

   end
end

describe "resource(:nodes, :new)" do
  before(:each) do
    @response = request(resource(:nodes, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@node, :edit)", :given => "a node exists" do
  before(:each) do
    @response = request(resource(Node.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@node)", :given => "a node exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Node.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @node = Node.first
      @response = request(resource(@node), :method => "PUT", 
        :params => { :node => {:id => @node.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@node))
    end
  end
  
end

