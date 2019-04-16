Rails.application.routes.draw do
  get 'welcome/index'
  
  resources :menus
  resources :plates
  resources :recipes
  resources :steps
  resources :ingredients
  resources :utensils

  root 'welcome#index'
end
