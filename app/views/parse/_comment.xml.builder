xml.comment :id => comment.id, :author => comment.author, :date => comment.date, :preview => comment.preview do
  xml.body comment.body
  xml.comments do
    comment.children.each do |post|
      xml << render(:partial => 'comment', :locals => { :comment => post, :xml => xml })
    end
  end
end