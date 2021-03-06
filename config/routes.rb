Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  root 'static_pages#home'

  get 'signup' => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  #patch 'users/:id' => 'users#account_password_update'
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :users, :except => [:index, :edit] do
    member do
      get :all
      get :search
      get :account_password
      get :setting
      get :documents
      post :set_vnd
      post :remove_seller
      post :add_seller
      post :remove_manager
      patch :set_note
    end
    resources :orders do
      get :remove
      patch :set_received
      collection do
        get :look_up_order
        get :show_table
      end
    end
    resources :shippings do
      collection do
        get :quick_add
        post :update_quick_add
        get :lookup_range
        get :lookup_shipment
        get :all
      end
    end
    resources :customers
    resources :stores
    resources :data, :only => [:show]

    resources :requests do
      collection do
        patch :perform_request
        get :completed
      end
    end

    resources :messages

    get 'range_orders' => 'orders#look_up_range'
    get 'activities' => 'reports#activity_log'
    get 'report' => 'reports#show_report'
    post 'report' => 'reports#generate_report'
    get 'year' => 'reports#show_year'
    get 'months' => 'reports#monthly_index'

    get 'inbox' => 'inboxes#requests'
  end

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
