Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # get '/articles', to: 'articles#index '
  post 'login', to: 'access_token#create'
  resources :articles, only: %i[index show]
end
