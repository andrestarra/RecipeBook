Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # get 'welcome/index'
  # get 'welcome/:id', to: 'welcome#show'

  resources :welcome, only: [:index, :show]
  resources :menus
  resources :plates
  resources :recipes do
    resources :steps
  end
  resources :ingredients
  resources :utensils

  root 'welcome#index'
end
