module ParseHelper
  def render_post(xml, post)
    attributes = {
      :id => post.id,
      :author => post.author,
      :date => post.date,
      :preview => post.preview,
      :reply_count => post.reply_count,
      :category => post.category,
    }
    
    attributes[:last_reply_id] = post.last_reply_id if post.last_reply_id
    
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
