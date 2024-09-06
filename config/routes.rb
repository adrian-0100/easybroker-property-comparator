Rails.application.routes.draw do
  devise_for :users
  root "properties#index"
  get "compare_properties", to: "properties#compare"
  post "save_comparison", to: "properties#save_comparison"
  get "export_comparison", to: "properties#export_comparison", defaults: { format: "xml" }
  resources :comparisons, only: [ :index ]
end
