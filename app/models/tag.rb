class Tag
  include DataMapper::Resource
  
  # field/column definitions
  property :id,         Serial
  property :name,       String,   :length => 50, :nullable => false, :index => true
  property :created_at, DateTime
  
  # relationships
  has n, :taggings
  has n, :nodes, :through => :taggings

end
