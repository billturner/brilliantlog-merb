require 'uri'

class Comment
  include DataMapper::Resource

  # set up pagination
  is_paginated

  # field/column definitions
  property :id,             Serial
  property :node_id,        Integer,  :nullable => false, :index => true
  property :name,           String,   :length => 125, :nullable => false
  property :email,          String,   :length => 125, :nullable => false, :format => :email_address
  property :url,            String,   :length => 250
  property :ip,             String,   :length => 20
  property :referer,        String,   :length => 250
  property :user_agent,     String,   :length => 250
  property :comment,        Text,     :nullable => false
  property :approved,       Boolean,  :default => false, :index => true
  property :spam,           Boolean,  :default => false
  property :created_at,     DateTime
  property :updated_at,     DateTime

  # relationships
  belongs_to :node
  
  # actions
  before :save, :correct_url
  
  def correct_url
    unless url.blank?
      unless url =~ /^http\:\/\//
        self.url = "http://#{url}"
      end
    end
  end
  
  def send_notification
    if self.approved? && !self.spam?
      send_mail(NotifierMailer, :comment_email, {
        :from => self.email,
        :to => "billturner@gmail.com",
        :subject => "New comment on brilliantcorners.org"
      }, { :comment => self, :node => self.node })
    end
  end
  
  def checks_out_okay(request)
    akismet = Akismet.new(ASKIMET_KEY, ASKIMET_KEY)
    self.spam = akismet.comment_check(comment_spam_options(request))
    #Merb.logger.info("Checking Akismet (#{ASKIMET_KEY}) for new comment on Article #{self.node_id}.  #{marked_as_spam? ? 'Blocked' : 'Approved'}")
    #Merb.logger.info "Akismet Response: #{akismet.last_response.inspect}"# unless Akismet.normal_responses.include?(akismet.last_response)
  end
  
  def comment_spam_options(request)
     {:user_ip              => self.ip, 
      :user_agent           => request.user_agent, 
      :referer              => request.referer,
      :comment_author       => self.name,
      :comment_author_email => self.email, 
      :comment_author_url   => self.url, 
      :comment_content      => self.comment}
   end
  
end
