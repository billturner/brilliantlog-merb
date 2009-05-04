class Nodes < Application

  # provides :xml, :yaml, :js
  cache :sitemap
  cache :feed
  cache :archive
  # cache :show
  
  def index
    
    throw_content :title, 'The weblog, writing, whatever of Bill Turner'
    
    @current_page = (params[:page] || 1).to_i
    @page_count, @nodes = Node.paginated(
      :page => @current_page,
      :per_page => 10,
      :published => true,
      :includes => [:comment],
      :order => [:published_at.desc]
    )
    display @nodes
  end

  def show(slug)
    @node = Node.get(slug)
    raise NotFound unless @node
    throw_content :title, @node.title
    display @node
  end
  
  def archive
    throw_content :title, "All previous entries"
    @nodes = Node.all(
      :published => true,
      :order => [:published_at.desc]
    )
    display @nodes
  end
  
  def feed
    
    only_provides :rss
    throw_content :title, 'The weblog, writing, whatever of Bill Turner'
    @nodes = Node.all(
      :published => true,
      :limit => 10,
      :order => [:published_at.desc]
    )
    display @nodes
  end
  
  def sitemap
    only_provides :xml
    @nodes = Node.all(:published => true, :order => [:published_at.desc])
    @tags = Tag.all(:includes => [:nodes])
    display [@nodes, @tags]
  end

end
