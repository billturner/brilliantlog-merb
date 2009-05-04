module Admin
  class Nodes < Application
    
    before :ensure_authenticated
    
    before :find_node, :only => %w(edit update delete)
    
    layout 'admin'
  
    def index
      
      throw_content :title, "All Posts"
      
      @current_page = (params[:page] || 1).to_i
      @page_count, @nodes = Node.paginated(
        :page => @current_page,
        :per_page => 25,
        :order => [:created_at.desc]
      )
      
      display @nodes
      
    end
    
    def preview
      @content = params['content']
      render :layout => false
    end
    
    def edit
      only_provides :html
      throw_content :title, "Editing post: '#{@node.title}'"
      display @node
    end

    def update
      if @node.update_attributes(params[:node])

        #eager_cache([Nodes, :feed]) { raise "HELL"}

        # Set flash & redirect
        redirect url(:edit_admin_node, @node), :message => {:notice => "Your changes to this post have been saved"}
      else
        display @node, :edit
      end
    end
    
    def new
      only_provides :html
      throw_content :title, "Add a New Post"
      @node = Node.new
      display @node
    end

    def create
      @node = Node.new(params[:node])
      if @node.save
        
        # Expire caches
        # expire_action(:key => "/nodes/feed.rss")
        # expire_action(:key => "/nodes/archive")
        # expire_action(:key => "/sitemap.xml")
        
        redirect url(:edit_admin_node, @node), :message => {:notice => "This post has been saved successfully"}
      else
        render :new
      end
    end

    def delete
      if @node.destroy
        redirect url(:admin_nodes), :message => {:notice => "Post was successfully deleted."}
      else
        raise InternalServerError
      end
    end
    
    private
    
      def find_node
        @node = Node.get(params[:id])
        raise NotFound unless @node
      end

  end
end # Admin
