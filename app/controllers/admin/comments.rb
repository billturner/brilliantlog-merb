module Admin
  class Comments < Application
  
    before :ensure_authenticated
    
    before :find_comment, :only => %w(edit update delete)

    layout 'admin'

    def index

      throw_content :title, "All Comments"

      @current_page = (params[:page] || 1).to_i
      @page_count, @comments = Comment.paginated(
        :page => @current_page,
        :per_page => 25,
        :order => [:created_at.desc]
      )
      
      display @comments
    end

    def spam
      
      throw_content :title, "All Spam Comments"
      
      @current_page = (params[:page] || 1).to_i
      @page_count, @comments = Comment.paginated(
        :page => @current_page,
        :per_page => 25,
        :spam => true,
        :order => [:created_at.desc]
      )
      
      display @comments
    end

    def edit(id)
      only_provides :html
      
      throw_content :title, "Editing Comment ##{@comment.id}"
      
      display @comment
    end

    def update(id, comment)
      if @comment.update_attributes(comment)
         redirect url(:edit_admin_comment, @comment), :message => {:notice => "Comment was successfully updated"}
      else
        display @comment, :edit
      end
    end

    def delete_spam
      Comment.all(:spam => true).each{ |c| c.destroy }
      redirect url(:spam_admin_comments), :message => {:notice => "All spam comments have been deleted."}
    end
    
    def delete(id)

      if @comment.destroy
        
        # Delete the caches if it's a good comment, as it may be a new one
        if @comment.approved? && !@comment.spam?
          # expire_action(:key => "/comments/feed.rss") 
          # expire_action(:key => url(:node, @comment.node))
        end
        
        redirect url(:admin_comments), :message => {:notice => "Comment was successfully deleted."}

      else
        raise InternalServerError
      end
    end
    
    private
      def find_comment
        @comment = Comment.get(params[:id])
        raise NotFound unless @comment
      end
      
  end
end # Admin
