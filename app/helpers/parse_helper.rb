module ParseHelper
  def render_post(xml, post)
    
    xml.comment :id => post.id, :author => post.author, :date => post.date, :preview => post.preview do
      xml.body post.body
      xml.comments do
        post.children.each do |child|
          render_post(xml, child)
        end
      end
    end
    
  end
end
