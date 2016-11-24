Pops::Application.routes.draw do

  root 'orders#index'
  
  controller :welcome do
    get 'welcome' => :index
  end
  
  controller :sessions do
    get  'login'  => :new
    post 'login'  => :create
    get  'logout' => :destroy
  end
  
  get  'tbr'                 => 'tbr#select'
  get  'tbr/select'          => 'tbr#select'
  get  'tbr/reports'         => 'tbr#reports'
  post 'tbr/report'          => 'tbr#report'
  post 'tbr/go'              => 'tbr#go'
  get  'tbr/log/:id'         => 'tbr#log'
  post 'tbr/log/:id'         => 'tbr#log'
  
  resources :accounts,      :except => [:create, :delete, :show]
  resources :payment_terms, :except => [:create, :delete, :show]
  resources :programs,      :except => [:create, :delete, :show]    
  resources :suppliers,     :except => [:create, :delete, :show]
  resources :tax_rates,     :except => [:create, :delete, :show]
  resources :users
  resources :deliveries
  resources :tbr_services
  
  get  'notes'               => 'notes#index'
  
  get  'orders/refresh'      => 'orders#refresh'
  get  'orders/:id/print'    => 'orders#print' 
  get  'orders/:id/search'   => 'orders#search'
  
  resources :orders do
    resources :items,    :only => [:new]
  end 
  
  post  'orders/refresh'       => 'orders#refresh'
  patch 'orders/:id/redraft'   => 'orders#redraft'
  post  'orders/:id/submit'    => 'orders#submit'
  patch 'orders/:id/resubmit'  => 'orders#resubmit'
  post  'orders/:id/approve'   => 'orders#approve'
  patch 'orders/:id/reapprove' => 'orders#reapprove'
  post  'orders/:id/complete'  => 'orders#complete'
  
  resources :items,    :except => [:index, :new] 
  resources :receipts, :only   => [:create, :new]
  
  # AJAX routes
  
  post  'orders/:id/items/gst'  => 'items#gst'
  post  'items/:id/gst'         => 'items#gst'
  patch 'items/:id/gst'         => 'items#gst'
  post  'items/gst'             => 'items#gst'
  
  post  'orders/:id/items/tax_rate' => 'items#tax_rate'
  post  'items/:id/tax_rate'        => 'items#tax_rate'
  patch 'items/:id/tax_rate'        => 'items#tax_rate'
  post  'items/tax_rate'            => 'items#tax_rate'
  
  post  'orders/:id/items/account_select'  => 'items#account_select'
  post  'items/:id/account_select'         => 'items#account_select'
  patch 'items/:id/account_select'         => 'items#account_select'
  post  'items/account_select'             => 'items#account_select'
  
  post  'orders/:id/items/program_select'  => 'items#program_select'
  post  'items/:id/program_select'         => 'items#program_select'
  patch 'items/:id/program_select'         => 'items#program_select'
  post  'items/program_select'             => 'items#program_select'
  
  post  'orders/payment_date'     => 'orders#payment_date'
  patch 'orders/:id/payment_date' => 'orders#payment_date'
  
  post  'orders/delivery'         => 'orders#delivery'
  patch 'orders/:id/delivery'     => 'orders#delivery'
  
  post  'users/ldap'              => 'users#ldap'
  patch 'users/:id/ldap'          => 'users#ldap'
  
  post  'tbr/report_select'       => 'tbr#report_select'
  
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
