Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # get '/articles', to: 'articles#index '
  post 'login', to: 'access_token#create'
  delete 'logout', to: 'access_token#destroy'
  # resources :articles, only: %i[index show create update]
  resources :articles
end
