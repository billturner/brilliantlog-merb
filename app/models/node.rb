class Node
  include DataMapper::Resource

  # Set up taglist for editing
  attr_accessor :taglist
  
  # set up pagination
  is_paginated
  
  # field/column definitions
  property :id,             Serial
  property :user_id,        Integer,  :nullable => false, :index => true
  property :title,          String,   :length => 250
  property :slug,           String,   :length => 250, :index => true
  property :content,        Text,     :lazy => false
  property :published,      Boolean,  :default => false, :index => true
  property :allow_comments, Boolean,  :default => false
  property :published_at,   DateTime
  property :created_at,     DateTime
  property :updated_at,     DateTime

  # validations
  validates_present :title
  validates_present :content
  
  # relationships
  has n, :taggings
  has n, :tags, :through => :taggings
  has n, :comments, :spam => false, :approved => true
  belongs_to :user
  
  # callbacks
  after :create,  :generate_slug
  after :create,  :assign_tags
  after :update,  :update_tags
  before :save,    :set_published_at

  class << self
    
    def posts(limit, offset)
      self.all(:published => true, :order => [:published_at.desc], :limit => limit, :offset => offset)
    end
    
  end
  
  private
  
    def generate_slug
      slug = "#{self.id}-#{self.title.gsub(/[^a-z0-9]+/i, '-').gsub(/-$/, '').downcase}"
      self.update_attributes(:slug => slug)
    end
    
    def set_published_at
      self.published_at = Time.now if self.published_at.blank? && self.published?
    end
    
    def assign_tags
      self.taglist.split(',').collect {|t| t.strip}.uniq.each do |tag|
        thistag = Tag.first_or_create(:name => tag.downcase)
        Tagging.create(:node_id => self.id, :tag_id => thistag.id)
      end
    end
  
    def update_tags
      self.taggings.each { |tagging| tagging.destroy }
      self.taggings.reload
      assign_tags
    end
  
end
