Rails.application.routes.draw do
  get 'welcome/index'
  
  resources :ingredients
  resources :utensils

  root 'welcome#index'
end
