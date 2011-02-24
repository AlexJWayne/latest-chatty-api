ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

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
  # 
  # map.push 'push', :controller => 'parse', :action => 'push'
  
  map.root                                    :controller => 'parse', :format => 'json'
  map.root_index        'index.:format',      :controller => 'parse', :format => 'json'
  map.chatty            ':id.:format',        :controller => 'parse', :format => 'json'
  map.paginated_chatty  ':id.:page.:format',  :controller => 'parse', :format => 'json'
  map.thread            'thread/:id.:format', :controller => 'parse', :action => 'thread'
  
  # map.create_root  'create/:story_id.:format',      :controller => 'create', :action => 'index'
  # map.create_reply 'create/:story_id/:id.:format',  :controller => 'create', :action => 'index'
  
end
