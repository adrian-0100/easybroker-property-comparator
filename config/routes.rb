Rails.application.routes.draw do
  root 'properties#index'
  get 'compare_properties', to: 'properties#compare'
  get 'export_comparison', to: 'properties#export_comparison', defaults: { format: 'xml' }
end
