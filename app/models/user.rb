class User
  include DataMapper::Resource
  
  # field/column definitions
  property :id,         Serial
  property :login,      String,   :length => 20, :nullable => false
  property :email,      String,   :length => 125, :nullable => false
  property :full_name,  String,   :length => 125
  property :created_at, DateTime
  property :updated_at, DateTime
  
  # validations
  validates_is_unique :login
  
  # relationships
  has n, :nodes
  
end
