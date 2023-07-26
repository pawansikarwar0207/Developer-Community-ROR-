Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  get 'member/:id', to: 'members#show', as: :member  
  get 'member/:id/edit', to: 'members#edit', as: :edit_member
  patch 'member/:id', to: 'members#update', as: :update_member


  resources :members

end
