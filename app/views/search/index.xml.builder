xml.instruct!
xml.comment! 'Documentation at http://shackchatty.com/readme'
xml.comments :author => params[:author], :parent_author => params[:parent_author], :terms => params[:terms] do
  @posts.each do |post|
    render_post(xml, post)
  end
end