Rails.application.routes.draw do
  root 'properties#index'
  get 'compare_properties', to: 'properties#compare'
end
