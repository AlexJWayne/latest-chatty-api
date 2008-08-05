xml.instruct!
xml.comment! 'Documentation at http://latestchatty.beautifulpixel.com/readme'
xml.comments :story_id => @feed.story_id do
  @feed.posts.each do |post|
    render_post(xml, post)
  end
end