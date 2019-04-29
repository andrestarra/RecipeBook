Rails.application.routes.draw do
  devise_for :users
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
