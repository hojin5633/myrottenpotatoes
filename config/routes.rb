Myrottenpotatoes::Application.routes.draw do
  # in routes.rb, change the line 'resources :movies' to:
  resources :movies do
    resources :reviews
  end
  post '/movies/search_tmdb'
  root :to => redirect('/movies')
  get 'auth/:provider/callback' => 'sessions#create'
  post  'logout' => 'sessions#destroy'
  get 'auth/failure' => 'sessions#failure'
  get 'auth/twitter', :as => 'login'
end
#figure 5.10