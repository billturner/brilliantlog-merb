class Bookmark
  include DataMapper::Resource
  
  # set up pagination
  is_paginated
  
  # field/column definitions
  property :id,           Serial
  property :name,         String,  :length => 250, :nullable => false
  property :url,          String,  :length => 250, :nullable => false
  property :description,  String,  :length => 250
  property :rel,          String,  :length => 250
  property :created_at,   DateTime
  property :updated_at,   DateTime
  

end
