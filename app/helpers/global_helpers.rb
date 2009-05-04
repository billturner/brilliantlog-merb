module Merb
  module GlobalHelpers

    def markdown(txt)
      RDiscount.new(txt, :smart).to_html
    end
    
    def rfc822_date(d)
      d.to_time.strftime("%a, %d %b %Y %H:%M:%S %z")
    end
    
    def w3c_date(date)
      date.to_time.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
    end
    
    def tag_list(tags)
      tag_list = Array.new
      tags.each do |t|
        tag_list << link_to(t.name, url(:tag, t), { :rel => 'tag category', :title => "See all posts tagged '#{t.name}'" })
      end
      [tag_list.join(', ')]
    end
    
  end
end
