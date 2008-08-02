xml.instruct!
xml.comments :story_id => @feed.story_id do
  @feed.posts.each do |post|
    xml << render(:partial => 'comment', :locals => { :comment => post, :xml => xml })
  end
end