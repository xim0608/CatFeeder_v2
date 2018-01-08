Rails.application.routes.draw do
  get 'images/:uuid', to: 'images#show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/callback', to: 'line#callback'
  get '/send', to: 'line#send_notice'
  post '/send', to: 'line#send_photo'
end
