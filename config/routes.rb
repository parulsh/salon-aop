Rails.application.routes.draw do

  post '/signup', to: 'users#create'
  post '/login', to: 'authentication#login'
  
  get '/user/show', to: 'users#show'
  put '/user/update', to: 'users#update'
  delete '/user/destroy', to: 'users#destroy'

  resources :salons

  get '/salon/:id/available_slots', to: 'salons#available_time_slots'

  get '/salon/:salon_id/services', to: 'services#index'
  post '/salon/:salon_id/new_service', to: 'services#create'
  put '/salon/:salon_id/update_service/:id', to: 'services#update'
  delete '/salon/:salon_id/destroy_service/:id', to: 'services#destroy'

  resources :bookings
end
