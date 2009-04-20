xml.instruct!
xml.comment! 'Documentation at http://shackchatty.com/readme'
xml.comments :author => params[:author], :parent_author => params[:parent_author], :terms => params[:terms] do
  
  @posts.each do |post|
    xml.comment :id => post.id,
                :author => post.author,
                :date => post.date,
                :preview => post.preview,
                :story_name => post.story_name,
                :story_id => post.story_id    
  end
end