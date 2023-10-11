Rails.application.routes.draw do
  
  get 'reposts/create'
  get 'reposts/destroy'
  
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :notifications, only: [:index, :destroy] 

  post 'search', to: 'search#index', as: 'search'
  post 'search/suggestions', to: 'search#suggestions', as: 'search_suggestions'

  resources :events do
    collection do
      get 'calendar_events'
    end
  end

  resources :posts do
    resources :reposts, only: [:create, :destroy]
    resources :comments
  end

  devise_scope :user do
    get '/generate_otp', to: 'users/sessions#generate_otp', as: :generate_otp
    get '/session_id/:id', to: 'users/sessions#session_id', as: :session_id
    post '/verify_otp', to: 'users/sessions#verify_otp', as: :verify_otp
  end

  root 'home#index'
  get '/home', to: 'home#index', as: :home
  get '/home/sort', to: 'home#sort', as: :home_sort
  
  get 'member/:id', to: 'members#show', as: :member  
  get 'member/:id/edit', to: 'members#edit', as: :edit_member
  patch 'member/:id', to: 'members#update', as: :update_member

  get 'members/fetch_country_states', to: 'members#fetch_country_states', as: :fetch_country_states

  get 'edit_description/:id', to: 'members#edit_description', as: 'edit_member_description'
  patch 'update_description', to: 'members#update_description', as: 'update_member_description'

  get 'edit_personal_details', to: 'members#edit_personal_details', as: 'edit_member_personal_details'
  patch 'update_personal_details', to: 'members#update_personal_details', as: 'update_member_personal_details'

  get 'member-connections/:id', to: 'members#connections', as: 'member_connections'

  resources :members do
    collection do
      get :fetch_country_states
    end
  end

  resources :jobs
  resources :job_categories
  resources :work_experiences
  resources :connections
  resources :skills
  resources :shares, only: [:new, :create,:index]

  resources :users do
    resources :posts
    resources :jobs
    resources :my_jobs
    resources :my_events
  end

  resources :members, controllers: 'members' do
    member do
      post :follow
      delete :unfollow
      get :followers_and_following
    end
  end

  resources :likes, only: [:create, :destroy]

  resources :followers, only: [:show] do
    member do
      get :show_followers
    end
  end


end
