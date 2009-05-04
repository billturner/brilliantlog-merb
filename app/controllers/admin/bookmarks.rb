module Admin
  class Bookmarks < Application
  
    before :ensure_authenticated
    
    before :find_bookmark, :only => %w(edit update delete)

    layout 'admin'
    
    def index
      
      throw_content :title, "All Bookmarks"
      
      @current_page = (params[:page] || 1).to_i
      @page_count, @bookmarks = Bookmark.paginated(
        :page => @current_page,
        :per_page => 25,
        :order => [:name.asc]
      )
      
      display @comments
    end
    
    def new
      throw_content :title, "Add a New Bookmark"
      @bookmark = Bookmark.new
      display @bookmark
    end

    def create
      @bookmark = Bookmark.new(params[:bookmark])
      if @bookmark.save

        # Expire caches
        # expire_action(:key => "bookmarks")

        redirect url(:edit_admin_bookmark, @bookmark), :message => {:notice => "The bookmark has been saved"}
      else
        render :new
      end
    end
    
    def edit
      only_provides :html
      throw_content :title, "Editing Bookmark: '#{@bookmark.name}'"
      display @bookmark
    end
    
    def update
      if @bookmark.update_attributes(params[:bookmark])
        
        # Expire cache
        # expire_action(:key => "bookmarks")
        
        # Set flash & redirect
        redirect url(:edit_admin_bookmark, @bookmark), :message => {:notice => "Changes to the bookmark have been saved"}
        
      else
        render :edit
      end
    end
    
    def delete
      
      if @bookmark.destroy
        
        # expire_action(:key => "bookmarks") 
        
        # Set flash & redirect
        redirect url(:admin_bookmarks), :message => {:notice => "The bookmark has been successfully deleted"}

      else
        raise BadRequest
      end
    end
    
    private
      def find_bookmark
        @bookmark = Bookmark.get(params[:id])
        raise NotFound unless @bookmark
      end
    
  end
end # Admin
