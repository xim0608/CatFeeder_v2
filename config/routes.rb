Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/callback', to: 'line#callback'
  get '/send', to: 'line#send_testing'
end
