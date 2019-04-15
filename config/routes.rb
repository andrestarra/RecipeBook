Rails.application.routes.draw do
  get 'welcome/index'
  
  resources :steps
  resources :ingredients
  resources :utensils

  root 'welcome#index'
end
