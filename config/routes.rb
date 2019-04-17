Rails.application.routes.draw do
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
