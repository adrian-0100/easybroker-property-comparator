Rails.application.routes.draw do
  root 'properties#index'
  resources :properties, only: [:index, :show]
end
