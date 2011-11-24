Sugebewa::Application.routes.draw do
  #sessions
  get "sessions/logout"
  get "sessions/resend_mail"
  get "sessions/forgot_password"
  post "sessions/forgot_password"
  #//
  get '/signin', :to => 'sessions#login'
  post '/signin', :to => 'sessions#login'
  get '/signout', :to => 'sessions#logout'
  get '/resendmail', :to => 'sessions#resend_mail'
  post '/resendmail', :to => 'sessions#resend_mail'
  get '/forgotpass', :to => 'sessions#forgot_password'
  post '/forgotpass', :to => 'sessions#forgot_password'

  #users
  get 'users/edit'
  get 'users/other_users'
  get 'users/destroy'
  get 'users/show_info'
  get 'users/show_user'
  get 'users/index'
  #//
  get '/signup_u', :to => 'users#new'
  get '/show_u', :to => 'users#show_info'
  resources :users, :only => [:new, :create, :edit, :update, :destroy]

  #relationships
  resources :users do
    member do
      get :following, :followers
    end
  end
  #//
  resources :relationship, :only => [:create, :destroy]


  #groups
  get 'groups/my_groups'

  #microposts
  get 'microposts/destroy'
  get 'microposts/create'
  get 'microposts/my_groups'
  get 'microposts/user_microposts'
  post 'microposts/create'
  resources :microposts, :only => [:index, :create, :destroy]

  #relationship
  get "relationships/create"
  get "relationships/destroy"
  post "relationships/create"
  post "relationships/destroy"

  resources :groups
  root :to => 'microposts#index'
end