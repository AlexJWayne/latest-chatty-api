xml.instruct!
xml.comments {
  @feed.posts.each do |post|
    xml << render(:partial => 'comment', :locals => { :comment => post, :xml => xml })
  end
}