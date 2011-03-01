ActionController::Routing::Routes.draw do |map|
  # See how all your routes lay out with "rake routes"
  # map.resources :stories,   :only => [:index, :show]
  # map.resources :users,     :only => [:index, :show]
  # map.resources :messages,  :only
  # map.resources :images,    :only => [:create]
  # map.resource  :devices,   :only => [:create, :destroy]
  # 
  # map.auth 'auth.:format', :controller => 'auth', :action => 'create'
  # 
  # map.search 'search.:format',      :controller => 'search'
  
  map.root                                    :controller => 'parse', :format => 'json'
  map.root_index        'index.:format',      :controller => 'parse', :format => 'json'
  map.chatty            ':id.:format',        :controller => 'parse', :format => 'json'
  map.paginated_chatty  ':id.:page.:format',  :controller => 'parse', :format => 'json'
  map.thread            'thread/:id.:format', :controller => 'parse', :action => 'thread'
  
  map.create_post       'create.:format',     :controller => 'create', :action => 'index'
  map.create_reply      'reply/:id.:format',  :controller => 'create', :action => 'index'
  
  
  
  map.create_root_old  'create/:story_id.:format',      :controller => 'create', :action => 'index'
  map.create_reply_old 'create/:story_id/:id.:format',  :controller => 'create', :action => 'index'  
end
