Rails.application.routes.draw do
  get 'welcome/index'
  
  resources :recipes
  resources :steps
  resources :ingredients
  resources :utensils

  root 'welcome#index'
end
