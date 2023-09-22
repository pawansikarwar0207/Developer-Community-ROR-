Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_scope :user do
    get '/otp_verification', to: 'users/sessions#otp_verification', as: :otp_verification
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
  
  resources :posts do
    resources :comments
  end

  resources :users do
    resources :posts
    resources :jobs
    resources :my_jobs
  end

  resources :likes, only: [:create, :destroy]

end
