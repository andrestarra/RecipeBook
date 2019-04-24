Rails.application.routes.draw do
  devise_for :users
  get 'welcome/index'
  
  resources :menus
  resources :plates
  resources :recipes do
    resources :steps
  end
  resources :ingredients
  resources :utensils

  root 'welcome#index'
end
