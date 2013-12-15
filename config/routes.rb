Pops::Application.routes.draw do
  
  root 'welcome#index'
  
  controller :welcome do
    get 'welcome' => :index
  end
  
  controller :sessions do
    get  'login'  => :new
    post 'login'  => :create
    get  'logout' => :destroy
  end
  
  resources :suppliers, :only => [:index, :new]
  resources :programs,  :only => [:index, :new]
  resources :accounts,  :only => [:index, :new]
  resources :tax_rates, :only => [:index, :new]
  
  resources :users
  resources :orders do
    resources :items, :only => [:new]
  end 
  
  post 'orders/:id/draft'    => 'orders#draft'
  post 'orders/:id/submit'   => 'orders#submit'
  post 'orders/:id/approve'  => 'orders#approve'
  post 'orders/:id/complete' => 'orders#complete'
  
  resources :items, :except => [:index, :new] 
  
  # AJAX routes
  
  post  'orders/:id/items/gst'  => 'items#gst'
  post  'items/:id/gst'         => 'items#gst'
  patch 'items/:id/gst'         => 'items#gst'
  post  'items/gst'             => 'items#gst'
  
  post  'orders/:id/items/tax_rate' => 'items#tax_rate'
  post  'items/:id/tax_rate'        => 'items#tax_rate'
  patch 'items/:id/tax_rate'        => 'items#tax_rate'
  post  'items/tax_rate'            => 'items#tax_rate'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
