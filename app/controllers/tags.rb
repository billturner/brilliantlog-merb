class Tags < Application
  # provides :xml, :yaml, :js

  def index
    @tags = Tag.all
    display @tags
  end

  def show(name)
    provides :html, :rss
    
    @tag = Tag.first(:name => Rack::Utils.unescape(name))
    raise NotFound unless @tag
    
    throw_content :title, "Everything tagged with '#{@tag.name}'"
    
    if params[:format] == 'rss'
      display @tag
    else
      @current_page = (params[:page] || 1).to_i
      @page_count, @nodes = @tag.nodes.paginated(
        :page => @current_page,
        :per_page => 10
      )
      display @nodes
    end
    
  end

end
