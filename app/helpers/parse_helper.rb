module ParseHelper
  def render_post(xml, post)
    attributes = {
      :id => post.id,
      :author => post.author,
      :date => post.date,
      :preview => post.preview
    }
    
    attributes[:reply_count] = post.reply_count if post.reply_count
    
    xml.comment attributes do
      xml.body post.body
      xml.comments do
        post.children.each do |child|
          render_post(xml, child)
        end
      end
    end
    
  end
end
