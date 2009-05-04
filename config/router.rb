Merb.logger.info("Compiling routes...")
Merb::Router.prepare do


  resources :comments, :collection => {:feed => :get}
  resources :tags, :identify => :name
  resources :nodes, :collection => {:archive => :get, :feed => :get}, :identify => :slug
  
  namespace :admin do |admin|
    admin.resources :nodes, :collection => {:preview => :post}
    admin.resources :comments, :collection => {:spam => :get, :delete_spam => :get}
    admin.resources :bookmarks
    admin.match("").to(:controller => "nodes", :action => "index")
  end
  
  slice(:merb_auth_slice_password, :name_prefix => nil, :path_prefix => "")

  match('/sitemap.xml').to(:controller => 'nodes', :action =>'sitemap', :format => 'xml').name(:sitemap)
  default_routes
  
  match('/').to(:controller => 'nodes', :action =>'index').name(:home)
end