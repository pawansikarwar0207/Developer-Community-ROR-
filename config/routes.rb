Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  get 'search', to: 'search#index'
  get 'posts/index'


  root 'home#index'
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

  resources :work_experiences
  resources :connections
  resources :skills
  
  resources :posts do
    resources :comments
  end

  resources :users do
    resources :posts
  end

  resources :likes, only: [:create, :destroy]

end
