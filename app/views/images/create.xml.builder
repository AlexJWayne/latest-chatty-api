xml.instruct!

if @file_url
  xml.success @file_url
else
  xml.error @error
end