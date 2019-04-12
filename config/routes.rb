Rails.application.routes.draw do
  get 'welcome/index'
  
  resources :ingredients

  root 'welcome#index'
end
