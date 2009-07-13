xml.authentication do
  xml.success do
    if @success
      xml.true
    else
      xml.false
    end
  end
end