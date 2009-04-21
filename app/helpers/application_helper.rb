# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def json_callback(object)
    if params[:callback]
      "#{params[:callback]}(#{object.to_json})"
    else
      object.to_json
    end
  end
end
