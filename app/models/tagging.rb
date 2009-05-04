class Tagging
  include DataMapper::Resource
  
  property :id,         Serial
  property :created_at, DateTime

  belongs_to :tag
  belongs_to :node

end
