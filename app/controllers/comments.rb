class Comments < Application

  #cache_action :feed

  def feed
    only_provides :rss
    @comments = Comment.all(
      :approved => true,
      :spam => false,
      :limit => 15,
      :order => [:created_at.desc]
      )
    display @comments
  end

  def new
    if request.xhr?
      
      @errors = ''
      @node = Node.get(params['node_id'])
      
      if @node

        @comment = @node.comments.build(:name => params['name'], :email => params['email'], :url => params['url'], :comment => params['comment'], :ip => request.remote_ip, :user_agent => request.user_agent, :referer => request.referer)

        if @comment.valid?
          
          # Comment is valid, let's check for spam
          @comment.checks_out_okay request
          @comment.save!

          if @comment.spam?

            # Oops, this seems to be spam
            @comment.update_attributes(:approved => false)
            @errors = "<ul><li>Your comment appears to be spam, sorry. I check occasionally to see if my system marked comments as spam when it shouldn't have. If that's the case, I'll allow it to be displayed.</li></ul>"

          else

            @comment.update_attributes(:approved => true)

            # expire_action(:key => "/comments/feed.rss")
            # expire_action(:key => url(:node, @node))

          end
        
        else
          # The comment fails the validations
          msgs = Array.new

          # Build the error messages
          # Merb.logger.info(@comment.errors.inspect)
          @comment.errors.each do |msg|
            if msg.length > 1
              msg.each do |m|
                msgs << "#{m}"
              end
            else
              msgs << "#{msg}"
            end
          end
          @errors = "<ul><li>#{msgs.join('</li><li>')}</li></ul>"
          
        end
        
      else
        @errors = "There was an unknown problem. Sorry."
      end
      
      if !@errors.blank?
        render :status => 500, :layout => false
      else
        
        #run_later do
          if @comment.approved? && !@comment.spam?
            send_mail(NotifierMailer, :comment_email, {
              :from => @comment.email,
              :to => "XXXX@gmail.com",
              :subject => "New comment on Weblog Name"
            }, { :comment => @comment, :node => @node })
          end
        #end
        render :layout => false
      end
    else
      raise Forbidden
    end
    
  end

end # Comments
