# Go to http://wiki.merbivore.com/pages/init-rb
 
require 'config/dependencies.rb'
 
use_orm :datamapper
use_test :rspec
use_template_engine :erb
 
Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'cookie'  # can also be 'memory', 'memcache', 'container', 'datamapper
  
  # cookie session store configuration
  c[:session_secret_key]  = 'a20708206da923f2ce6a96d523fdef684ec60a83'  # required for cookie session store
  c[:session_id_key] = '_brilliantlog_session_id' # cookie session id key, defaults to "_session_id"
end
 
Merb::BootLoader.before_app_loads do
  # This will get executed after dependencies have been loaded but before your app's classes have loaded.
end
 
Merb::BootLoader.after_app_loads do
  
  dependency 'tlsmail'
  
  Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)

  Merb::Mailer.config = {
    :host   => 'smtp.gmail.com',
    :port   => '587',
    :user   => 'XXXX@gmail.com',
    :pass   => 'PASSWORD',
    :auth   => :plain
  }

  Merb::Cache.setup do
    register(:action_store, Merb::Cache::ActionStore[Merb::Cache::FileStore], :dir => Merb.root / "public" / "cache")
    register(:default, Merb::Cache::AdhocStore[:action_store])
  end
  
end

begin
  require File.join(File.dirname(__FILE__), '..', 'lib', 'askimet')
rescue LoadError
end

Merb.add_mime_type(:rss, nil, %w[application/rss+xml])